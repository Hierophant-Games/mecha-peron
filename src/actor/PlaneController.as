package actor 
{
	import embed.Assets;
	import flash.geom.Point;
	import game.Constants;
	import level.LifeBar;
	import level.PlaneBomb;
	import org.flixel.*;
	import sprites.SpriteLoader;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class PlaneController extends ActorController 
	{
		/**
		 * Constants
		 */
		private const SIN_FACTOR:Number = 0.03;
		private const SIN_HEIGHT:Number = 5;
		
		private var _initialY:Number;
		private var _accum:Number = 0;
		
		private var _player:Actor;
		private var _layer:FlxGroup;
		private var _smokeEmitter:FlxEmitter;
		private var _sparkEmitter:FlxEmitter;
		
		private var _emitSparks:Boolean = false;
		private var _bombDropped:Boolean = false;
		
		private var _falling:Boolean = false;
		
		private var _warningSign:FlxText;
		
		private var _lifeBar:LifeBar;
		
		public function PlaneController(player:Actor, layer:FlxGroup) 
		{
			_player = player;
			_layer = layer;
		}
		
		override public function init():void
		{
			//controlledActor.createGraphic(24, 16, 0xffcccccc);
			controlledActor.loadGraphic(Assets.SpritePlane, true, false, 72, 29);
			
			controlledActor.addAnimation("default", new Array(0, 1, 2), 9);
			controlledActor.play("default");
			
			controlledActor.fixed = true;
			controlledActor.velocity.x = Constants.PLANE_SPEED_X;
		}
		
		override public function preFirstUpdate():void
		{
			// the actor position is set after the call to init...
			// so we grab the value here
			_initialY = controlledActor.y;
			
			// Deffered particles initialization so they are added to the layer
			// AFTER the plane so they are rendered in front
			initSmokeEmitter();
			initSparkEmitter();
			
			_warningSign = new FlxText(0, 0, FlxG.width, "WARNING ->");
			_warningSign.setFormat(null, 8, 0xffff00, "right", 0xff0000);
			controlledActor.layer.add(_warningSign, false);
			
			_lifeBar = new LifeBar(20, 2);
			controlledActor.layer.add(_lifeBar, true);
		}
		
		override public function update():void
		{
			var posXInScreen:Number = controlledActor.getScreenXY().x;
			// camera culling
			controlledActor.visible = (posXInScreen < FlxG.width);
			// mark as dead when it goes out of camera
			if (posXInScreen < -controlledActor.frameWidth)
			{
				controlledActor.kill();
				return;
			}
			
			if (_falling)
			{
				_smokeEmitter.x = controlledActor.x;			
				_smokeEmitter.y = controlledActor.y;
			}
			else
			{
				_accum += SIN_FACTOR;
				if (_accum > 2 * Math.PI)
					_accum -= 2 * Math.PI;
			
				controlledActor.y = _initialY - SIN_HEIGHT * Math.sin(_accum);
				
				dropBombs();
				
				//controlledActor.color = 0x00ffffff - ((1 - (controlledActor.health / 100)) * 0x0000ffff);
			}
			
			_lifeBar.x = controlledActor.x + controlledActor.width / 2 - _lifeBar.width / 2;
			_lifeBar.y = controlledActor.y - _lifeBar.height;
			_lifeBar.updateLife(controlledActor.health);
			
			if (_emitSparks)
			{
				_sparkEmitter.x = controlledActor.x + controlledActor.width / 4;
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
			
			// Warning signs
			if (controlledActor.x > FlxG.width - FlxG.scroll.x
				&& controlledActor.x < FlxG.width - FlxG.scroll.x + Constants.PLANE_WARNING_X_THRESHOLD)
			{
				_warningSign.visible = true;
				_warningSign.x = -FlxG.scroll.x;
				_warningSign.y = controlledActor.y;
			}
			else
			{
				_warningSign.visible = false;
			}
		}
		
		override public function onHurt(Damage:Number):Boolean
		{
			_emitSparks = true;
			
			if ((controlledActor.health -= Damage) <= 0)
			{
				controlledActor.dead = true;
				
				controlledActor.angularAcceleration = -120;
				controlledActor.acceleration.y = 140;
				_falling = true;
				
				_smokeEmitter.start(false);
				
				// create explosion
				_layer.add(new Actor(new ExplosionController(), _layer,
					controlledActor.x,
					controlledActor.y + controlledActor.height / 2));
			}
			
			return false;
		}
		
		private function dropBombs():void
		{
			if (_bombDropped || _player.dead) return;
			
			var actorScreenPos:FlxPoint = controlledActor.getScreenXY();
			var originPos:Point = new Point(actorScreenPos.x + controlledActor.width / 2, actorScreenPos.y + controlledActor.height / 2);
			
			// Randomize target y
			var randomY:Number = FlxU.random() * (_player.height / 4) + (_player.height / 4);
			var targetPos:Point = new Point(_player.getScreenXY().x + _player.width / 2, _player.getScreenXY().y + randomY);
			
			// dy = 1/2*g*t^2
			// t = v(dy/(1/2*g))
			var timeToHitTarget:Number = Math.sqrt((targetPos.y - originPos.y) / (0.5 * Constants.GRAVITY));
			var posXToHit:Number = originPos.x + (controlledActor.velocity.x - _player.velocity.x) * timeToHitTarget;
			if (posXToHit < targetPos.x)
			{
				_bombDropped = true;
				
				var bomb:PlaneBomb = new PlaneBomb(_layer, originPos.x, originPos.y);
				bomb.x -= FlxG.scroll.x * _layer.scrollFactor.x;
				
				bomb.acceleration.y = Constants.GRAVITY;
				bomb.velocity.x =  controlledActor.velocity.x;
				
				_layer.add(bomb, true);
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
				
				var randomGrey:Number = FlxU.random() * 3;	
				randomGrey = Number(randomGrey.toFixed()) * 0x333333;
				smoke.color = randomGrey;
				
				smoke.exists = false;
				smoke.solid = false;
				smoke.addAnimation("smoke", new Array(1, 2, 3, 4, 3, 2), 4, true);
				smoke.play("smoke");
				_smokeEmitter.add(smoke, true);
			}
			
			_layer.add(_smokeEmitter, true);
		}
		
		private function initSparkEmitter():void
		{
			_sparkEmitter = new FlxEmitter();
			
			_sparkEmitter.setSize(5, 5);
			_sparkEmitter.setRotation(0, 0);
			_sparkEmitter.setXSpeed(0, 0);
			_sparkEmitter.setYSpeed(0, 0);
			_sparkEmitter.gravity = Constants.GRAVITY;
			
			for (var i:uint = 0; i < 5; ++i)
			{
				var spark:FlxSprite = new FlxSprite();
				spark.loadGraphic(Assets.SpriteSpark, false, false, 5, 5);
				spark.exists = false;
				spark.solid = false;
				_sparkEmitter.add(spark, true);
			}
			
			_layer.add(_sparkEmitter, true);
		}
		
		public function setSparksDirection(xTarget:Number, yTarget:Number):void
		{
			var direction:Point = new Point(controlledActor.x - xTarget, controlledActor.y - yTarget);
			direction.normalize(1);
			
			_sparkEmitter.setXSpeed(10 * direction.x, 20 * direction.x);
			_sparkEmitter.setYSpeed(50 * direction.y, 80 * direction.y);
		}
		
		override public function onKill():Boolean
		{
			if (_smokeEmitter)
				_smokeEmitter.stop();
				
			if (_sparkEmitter)
				_sparkEmitter.stop();
				
			controlledActor.layer.remove(_warningSign);
			controlledActor.layer.remove(_lifeBar);
				
			return true;
		}
	}
}