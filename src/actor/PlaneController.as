package actor 
{
	import flash.geom.Point;
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
		
		public function PlaneController(player:Actor) 
		{
			_player = player;
		}
		
		public override function init():void
		{
			controlledActor.createGraphic(24, 16, 0xffcccccc);
			controlledActor.fixed = true;
			controlledActor.velocity.x = SPEED_X;
			
			// randomize the start of the sinusoidal movement
			//_accum = Math.random() * 2 * Math.PI;
			_accum = 0;
		}
		
		public override function update():void
		{
			if (isNaN(_initialY))
			{
				_initialY = controlledActor.y;
			}
			
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
			var posXToHit:Number = originPos.x + controlledActor.velocity.x * timeToHitTarget;
			if (posXToHit < targetPos.x)
			{
				_bombDropped = true;
				
				var bomb:PlaneBomb = new PlaneBomb(originPos.x, originPos.y);
				bomb.acceleration.y = BOMB_GRAVITY;
				bomb.velocity.x =  controlledActor.velocity.x;
				
				FlxG.state.add(bomb);
			}
		}
	}
}