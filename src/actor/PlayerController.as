package actor 
{
	import org.flixel.*;
	/**
	 * Player class.
	 * Stores info about the current status of the player character.
	 * @author Santiago Vilar
	 */
	public class PlayerController extends ActorController
	{
		[Embed(source = "../../data/sprites/peron.png")]
		private var PeronSprite:Class;
		
		public override function init():void
		{
			controlledActor.loadGraphic(PeronSprite, true, false, 70, 94);
			
			controlledActor.addAnimation("idle", new Array(0, 1, 2, 3, 4, 5), 10, true);
			controlledActor.addAnimation("walk", new Array(0), 10, true);
			controlledActor.addAnimation("attack", new Array(0), 10, false);
			controlledActor.addAnimation("damage", new Array(0), 10, false);
			controlledActor.addAnimationCallback(animationCallback);
			
			controlledActor.play("idle");
		}
		
		public override function update():void
		{
			var moveX:Number = 0;
			var moveY:Number = 0;
			if (FlxG.keys.RIGHT)
				moveX = 30;
			if (FlxG.keys.LEFT)
				moveX = -30;
			move(moveX, moveY);
			
			if (FlxG.keys.justPressed("SPACE"))
				attack();
		}
		
		private function move(x:Number, y:Number):void
		{
			if (x != 0)
				controlledActor.play("walk");
			else
				controlledActor.play("idle");
			
			controlledActor.velocity.x = x;
			controlledActor.velocity.y = y;
		}
		
		private function attack():void
		{
			controlledActor.play("attack");
		}
		
		private function animationCallback(name:String, frameNumber:uint, frameIndex:uint):void
		{
			controlledActor.play("idle");
		}
	}
}