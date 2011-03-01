package actor 
{
	import embed.Assets;
	import flash.geom.Point;
	import level.PlaneBomb;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class PlaneController extends ActorController 
	{
		/**
		 * Constants
		 */
		private const SPEED_X:Number = -80;
		private const SIN_FACTOR:Number = 0.03;
		private const SIN_HEIGHT:Number = 16;
		
		private var _initialY:Number;
		private var _accum:Number;
		
		private var _player:Actor;
		private var _layer:FlxGroup;
		private var _smokeEmitter:FlxEmitter;
		private var _sparkEmitter:FlxEmitter;
		
		private var _sparksInitialized:Boolean;
		private var _emitSparks:Boolean;
		
		public function PlaneController(player:Actor, layer:FlxGroup) 
		{
			_player = player;
			_layer = layer;
		}
		
		override public function init():void
		{
			//controlledActor.createGraphic(24, 16, 0xffcccccc);
			controlledActor.loadGraphic(Assets.SpritePlane, true, false, 109, 35);
			
			controlledActor.addAnimation("default", new Array(0, 1, 2), 9);
			controlledActor.play("default");
			
			controlledActor.fixed = true;
			controlledActor.velocity.x = SPEED_X;
			
			// randomize the start of the sinusoidal movement
			//_accum = Math.random() * 2 * Math.PI;
			_accum = 0;
			
			// add smoke emitter
			initSmokeEmitter();
			
			// init spark emitter
			//initSparkEmitter();
			_sparksInitialized = false; 
			// Deffered sparks initialization so they are added to the layer AFTER the plane so they are rendererd in front
			_emitSparks = false;
		}
		
		override public function update():void
		{
			if (isNaN(_initialY)) _initialY = controlledActor.y;
			
			var posXInScreen:Number = controlledActor.getScreenXY().x;
			// camera culling
			controlledActor.visible = (posXInScreen < FlxG.width);
			// mark as dead when it goes out of camera
			if (posXInScreen < -controlledActor.frameWidth)
			{
				controlledActor.kill();
				return;
			}
			
			_accum += SIN_FACTOR;
			if (_accum > 2 * Math.PI)
				_accum -= 2 * Math.PI;
			
			controlledActor.y = _initialY - SIN_HEIGHT * Math.sin(_accum);
			
			_smokeEmitter.x = controlledActor.x;			
			_smokeEmitter.y = controlledActor.y;
			
			dropBombs();
			
			controlledActor.color = 0x00ffffff - ((1 - (controlledActor.health / 100)) * 0x0000ffff);
			
			if (!_sparksInitialized)
				initSparkEmitter();
			
			if (_emitSparks)
			{
				_sparkEmitter.x = controlledActor.x + controlledActor.width / 2;			
				_sparkEmitter.y = controlledActor.y + controlledActor.height / 2;
				
				if (!_sparkEmitter.on)
				{
					_sparkEmitter.start(false);
				}
				
				_emitSparks = false;
			}
			else
			{
				if (_sparkEmitter.on)
				{
					_sparkEmitter.stop(0);
				}
			}
		}
		
		override public function hurt(Damage:Number):void
		{
			_emitSparks = true;
		}
		
		private const BOMB_GRAVITY:Number = 50;
		private var _bombDropped:Boolean = false;
		
		private function dropBombs():void
		{
			if (_bombDropped) return;
			
			var originPos:Point = new Point(controlledActor.x, controlledActor.y);
			var targetPos:Point = new Point(_player.x + _player.width / 2, _player.y);
			
			// dy = 1/2*g*t^2
			// t = v(dy/(1/2*g))
			var timeToHitTarget:Number = Math.sqrt((targetPos.y - originPos.y) / (0.5 * BOMB_GRAVITY));
			var posXToHit:Number = originPos.x + (controlledActor.velocity.x - _player.velocity.x) * timeToHitTarget;
			if (posXToHit < targetPos.x)
			{
				trace("dropping bomb");
				_bombDropped = true;
				
				var bomb:PlaneBomb = new PlaneBomb(_layer, originPos.x, originPos.y);
				bomb.acceleration.y = BOMB_GRAVITY;
				bomb.velocity.x =  controlledActor.velocity.x;
				
				_layer.add(bomb);
			}
		}
		
		private function initSmokeEmitter():void
		{
			_smokeEmitter = new FlxEmitter(controlledActor.x, controlledActor.y);
			_smokeEmitter.setSize(6, 2);
			_smokeEmitter.setRotation(0, 0);
			_smokeEmitter.setXSpeed(-10, 10);
			_smokeEmitter.setYSpeed(-20, -30);
			_smokeEmitter.gravity = 0;
			for (var i:uint = 0; i <10; ++i)
			{
				var smoke:FlxSprite = new FlxSprite();
				if (i % 2)
				{
					smoke.loadGraphic(Assets.SpriteSmoke, true, false, 14, 12);
				}
				else
				{
					smoke.loadGraphic(Assets.SpriteSmokeBig, true, false, 28, 24);
				}
				smoke.exists = false;
				smoke.addAnimation("smoke", new Array(1, 2, 3, 4, 3, 2), 4, true);
				smoke.play("smoke");
				smoke.solid = false;
				_smokeEmitter.add(smoke, true);
			}
			//_smokeEmitter.start(false);
			
			_layer.add(_smokeEmitter, true);
		}
		
		private function initSparkEmitter():void
		{
			_sparkEmitter = new FlxEmitter();
			
			_sparkEmitter.setSize(1, 1);
			_sparkEmitter.setRotation(0, 0);
			_sparkEmitter.setXSpeed(0, 0);
			_sparkEmitter.setYSpeed(0, 0);
			_sparkEmitter.gravity = 0;
			
			for (var i:uint = 0; i < 5; ++i)
			{
				var spark:FlxSprite = new FlxSprite();
				spark.loadGraphic(Assets.SpriteSpark, false, false, 5, 5);
				spark.exists = false;
				spark.solid = false;
				_sparkEmitter.add(spark, true);
			}
			
			_layer.add(_sparkEmitter, true);
			
			_sparksInitialized = true;
		}
		
		public function setSparksDirection(xTarget:Number, yTarget:Number):void
		{
			var direction:Point = new Point(controlledActor.x - xTarget, controlledActor.y - yTarget);
			direction.normalize(1);
			
			_sparkEmitter.setXSpeed(10 * direction.x, 20 * direction.x);
			_sparkEmitter.setYSpeed(50 * direction.y, 80 * direction.y);
		}
		
		override public function onKill():void
		{
			if (_smokeEmitter)
				_smokeEmitter.kill();
				
			if (_sparkEmitter)
				_sparkEmitter.kill();
		}

	}
}