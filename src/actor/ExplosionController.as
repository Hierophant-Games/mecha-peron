package actor 
{
	import embed.Assets;
	import sprites.SpriteLoader;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class ExplosionController extends ActorController
	{
		override public function init():void
		{
			new SpriteLoader().loadIntoSprite(controlledActor, Assets.XMLSpriteExplosion, Assets.SpriteExplosion);
			controlledActor.addAnimationCallback(animationCallback);
			controlledActor.solid = false;
			controlledActor.play("explode");
		}
		
		override public function preFirstUpdate():void 
		{
			// adjust position
			controlledActor.x -= controlledActor.frameWidth / 2;
			controlledActor.y -= controlledActor.frameHeight / 2;
		}
		
		override public function update():void 
		{
			
		}
		
		private function animationCallback(name:String, frameNumber:uint, frameIndex:uint):void
		{
			if (controlledActor.finished)
			{
				controlledActor.kill();
			}
		}
	}
}