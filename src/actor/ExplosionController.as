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
		public static const TYPE_NORMAL:uint = 0;
		public static const TYPE_MINI:uint = 1;
		private var _type:uint;
		
		public function ExplosionController(type:uint = TYPE_NORMAL)
		{
			_type = type;
		}
		
		override public function init():void
		{
			switch (_type)
			{
				case TYPE_NORMAL:
				{
					new SpriteLoader().loadIntoSprite(controlledActor, Assets.XMLSpriteExplosion, Assets.SpriteExplosion);
					break;
				}
				case TYPE_MINI:
				{
					new SpriteLoader().loadIntoSprite(controlledActor, Assets.XMLSpriteMiniExplosion, Assets.SpriteMiniExplosion);
					break;
				}
			}
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
		
		override public function onKill():Boolean 
		{
			return true;
		}
	}
}