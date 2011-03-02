package actor 
{
	import flash.geom.Point;
	import game.Constants;
	import level.Bullet;
	import org.flixel.*;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class SoldierController extends ActorController 
	{
		private var _player:Actor;
		private var _layer:FlxGroup;
		
		public function SoldierController(player:Actor, layer:FlxGroup) 
		{
			_player = player;
			_layer = layer;
		}
		
		override public function init():void 
		{
			controlledActor.createGraphic(10, 10, 0xff00ffff);
			controlledActor.fixed = true;
		}
		
		override public function update():void
		{
			// only shoot if the actor is on the screen
			if (controlledActor.onScreen())
			{
				shoot();
			}
		}
		
		private const SHOOT_TIME:Number = 2;
		private var _shootTimer:Number = 0;
		
		private function shoot():void
		{
			_shootTimer += FlxG.elapsed;
			if (_shootTimer > SHOOT_TIME)
			{
				_shootTimer -= SHOOT_TIME;
				
				var originPos:Point = new Point(controlledActor.x, controlledActor.y);
				//var targetPos:Point = new Point(_player.x + _player.width / 2, _player.y);
				//var velocity:Point = targetPos.subtract(originPos);
				//velocity.normalize(30);
				var velocity:Point = new Point(Constants.SOLDIER_BULLET_SPEED_X, 0);
				
				var bullet:Bullet = new Bullet(_layer, originPos.x, originPos.y);
				bullet.velocity = new FlxPoint(velocity.x, velocity.y);
				_layer.add(bullet);
			}
		}
	}
}