package actor 
{
	import flash.geom.Point;
	import game.Constants;
	import level.Bullet;
	import org.flixel.*;
	import embed.Assets;
	
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
			controlledActor.loadGraphic(Assets.SpriteSoldier, true, false, 18, 9, false);
			controlledActor.addAnimation("Shoot", new Array(3, 4, 5, 2), 8, false);
			controlledActor.addAnimation("Reload", new  Array(2, 1, 0), 6, false);
			controlledActor.addAnimation("Aim", new Array(1, 2), 4, false);
			controlledActor.addAnimation("Die", new Array(6), 1, false);
			controlledActor.addAnimationCallback(soldierAnimCallback);
			controlledActor.fixed = true;
		}
		
		override public function update():void
		{
			// only shoot if the actor is on the screen
			if (controlledActor.onScreen())
			{
				aim();
			}
		}
		
			override public function hurt(Damage:Number):void
		{
			// explosion
			controlledActor.play("Die");
		}
		
		private const SHOOT_TIME:Number = 3;
		/* by setting initial value of timer as a random number
		 * between 0 and SHOOT_TIME, the soldiers will now shoot
		 * in different moments instead of always at the same time
		 */
		private var _shootTimer:Number = FlxU.random() * SHOOT_TIME;
		
		private function aim():void
		{
			_shootTimer += FlxG.elapsed;
			if (_shootTimer > SHOOT_TIME)
			{
				// reset timer
				_shootTimer -= SHOOT_TIME;
				controlledActor.play("Aim");
			}
		}
		
		private function shoot():void {
			controlledActor.play("Shoot");
			var originPos:Point = new Point(controlledActor.x, controlledActor.y);
			
			// Bullets will have a random "Y" component in their velocity between 5 and -5 pixels height
			var velocity:Point = new Point(Constants.SOLDIER_BULLET_SPEED_X, ((FlxU.random()*10) - 5));
			
			var bullet:Bullet = new Bullet(_layer, originPos.x, originPos.y);
			bullet.velocity = new FlxPoint(velocity.x, velocity.y);
			_layer.add(bullet);			
		}
		
		private function reload():void 
		{
			controlledActor.play("Reload");
		}
			
		private function soldierAnimCallback(name:String, frameNumber:uint, frameIndex:uint):void 
		{
			if(name == "Aim" && frameIndex == 2) 
			{
				shoot();
			}
			else if (name == "Shoot" && frameIndex == 2)
			{
				reload();
			}
		}
	}
}