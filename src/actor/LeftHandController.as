package actor 
{
	import embed.Assets;
	import org.flixel.*;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class LeftHandController extends ActorController 
	{
		
		public function LeftHandController() 
		{
			
		}
		
		override public function init():void
		{
			controlledActor.fixed = true;
			
			controlledActor.loadGraphic(Assets.SpriteFist, true, false, 44, 30);
			
			controlledActor.addAnimation("launch", new Array(0, 1, 2), 16, false);
			controlledActor.addAnimation("fly", new Array(3, 4), 16, true);
			controlledActor.addAnimationCallback(animationCallback);
		}
		
		override public function update():void
		{
			
		}
		
		override public function onHurt(Damage:Number):Boolean
		{
			return false;
		}
		
		private function animationCallback(name:String, frameNumber:uint, frameIndex:uint):void
		{
			if (name == "launch" && controlledActor.finished)
			{
				controlledActor.play("fly");
			}
		}
	}
}