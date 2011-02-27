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
			controlledActor.addAnimation("damage", new Array(1, 2, 3, 4, 3, 2, 1, 2, 3, 2, 1, 2, 3, 2, 1, 0), 16, false);
			controlledActor.addAnimation("laser", new Array(1,3,4), 9, false);
			//controlledActor.addAnimationCallback(animationCallback);
			
			controlledActor.play("idle");
		}
		
		public override function update():void
		{
			// should be used to make the character go up and down in each step
			var yVelocity:Number = 0;
			
			if (FlxG.keys.RIGHT)
				SetVelocity(30,yVelocity);
			else if (FlxG.keys.LEFT) 
				SetVelocity(-30,yVelocity);			
			else if (FlxG.keys.justPressed("SPACE"))
			{
				stopMoving(); // stop moving while attacking
				attack();
			}
			else if (FlxG.keys.justPressed("A")) // for debugging purposes
			{
				stopMoving(); // stop moving while attacking
				laser();
			} else if (FlxG.keys.justPressed("S")) // for debugging purposes
			{
				stopMoving(); // stop moving while being damaged
				damage();
			}
			else stopMoving(); 
		
		}
		
		private function SetVelocity(x:Number, y:Number):void
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
		/*
		 * At the moment going back to idle animation when no input 
		 * is made is disabled, as it is required to check wether or
		 * not the previous animation has finished before doing so.
		 */
			// FlxG.log("Started Playing Idle Animation");
			// controlledActor.play("idle");
			controlledActor.velocity.x = 0;
			controlledActor.velocity.y = 0;
		}
		
		private function attack():void
		{
			 FlxG.log("Started Playing attack Animation");
			controlledActor.play("attack");
		}
		
		private function laser():void
		{
			FlxG.log("Started Playing laser Animation");
			controlledActor.play("laser");
		}
		
		private function damage():void
		{
			FlxG.log("Started Playing damage Animation");
			controlledActor.play("damage");
		}
		
		/*private function animationCallback(name:String, frameNumber:uint, frameIndex:uint):void
		{
			controlledActor.play("idle");
		}*/
	}
}