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
		
		public function PlaneController(player:Actor, layer:FlxGroup) 
		{
			_player = player;
			_layer = layer;
		}
		
		override public function init():void
		{
			controlledActor.createGraphic(24, 16, 0xffcccccc);
			controlledActor.fixed = true;
			controlledActor.velocity.x = SPEED_X;
			
			// randomize the start of the sinusoidal movement
			//_accum = Math.random() * 2 * Math.PI;
			_accum = 0;
			
			// add a particle emitter
			initParticleEmitter();
		}
		
		override public function update():void
		{
			if (isNaN(_initialY)) _initialY = controlledActor.y;
			
			var posXInScreen:Number = controlledActor.getScreenXY().x;
			// camera culling
			controlledActor.visible = (posXInScreen < FlxG.width);
			// mark as dead when it goes out of camera
			if (posXInScreen < 0)
				controlledActor.kill();
			
			_accum += SIN_FACTOR;
			if (_accum > 2 * Math.PI)
				_accum -= 2 * Math.PI;
			
			controlledActor.y = _initialY - SIN_HEIGHT * Math.sin(_accum);
			
			_smokeEmitter.x = controlledActor.x;
			_smokeEmitter.y = controlledActor.y;
			
			dropBombs();
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
				_bombDropped = true;
				
				var bomb:PlaneBomb = new PlaneBomb(_layer, originPos.x, originPos.y);
				bomb.acceleration.y = BOMB_GRAVITY;
				bomb.velocity.x =  controlledActor.velocity.x;
				
				_layer.add(bomb);
			}
		}
		
		private function initParticleEmitter():void
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
			_smokeEmitter.start(false);
			
			_layer.add(_smokeEmitter, true);
		}
	}
}