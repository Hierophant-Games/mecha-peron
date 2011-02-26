package actor 
{
	import embed.Assets;
	import org.flixel.*;
	/**
	 * PlayerController.
	 * Controls an Actor with a player behavior. Handles input and update accordingly.
	 * @author Santiago Vilar
	 */
	public class PlayerController extends ActorController
	{
		public override function init():void
		{
			controlledActor.fixed = true;
			
			controlledActor.loadGraphic(Assets.SpritePeron, true, false, 99, 222);
			
			controlledActor.addAnimation("idle", new Array(0), 1, false);
			controlledActor.addAnimation("walk", new Array(0, 1, 2, 1), 5, true);
			controlledActor.addAnimation("attack", new Array(0), 1, false);
			controlledActor.addAnimation("damage", new Array(1, 2, 3, 4, 3, 2, 1, 2, 3, 2, 1, 0), 12, false);
			controlledActor.addAnimation("laser", new Array(1,3,4), 9, false);
			controlledActor.addAnimationCallback(animationCallback);
			
			controlledActor.play("idle");
		}
		
		public override function update():void
		{
			
			var moveX:Number = 0;
			var moveY:Number = 0;
			if (FlxG.keys.RIGHT) {
				moveX = 30;
			} else if (FlxG.keys.LEFT) {
				moveX = -30;
			}			
			if (FlxG.keys.justPressed("SPACE")) {
				attack();
				moveX = 0; // stop moving while attacking
			}
				
			if(moveX != 0) 
				move(moveX, moveY);
			else
				stopMoving();
		}
		
		private function move(x:Number, y:Number):void
		{
			/* Only play "walk" animation if velocity used to be zero,
			 * otherwise, it would reset itself on each frame */
			
			if (controlledActor.velocity.x == 0) {
				FlxG.log("Started Playing Walk Animation");
				controlledActor.play("walk");
			}
			
			controlledActor.velocity.x = x;
			controlledActor.velocity.y = y;
		}
		
		private function stopMoving():void 
		{
			FlxG.log("Started Playing Idle Animation");
			controlledActor.play("idle");
			controlledActor.velocity.x = 0;
			controlledActor.velocity.y = 0;
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