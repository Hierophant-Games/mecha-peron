package level 
{
	import actor.*;
	import embed.Assets;
	import game.Constants;
	import org.flixel.*;
	import sprites.SpriteLoader;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class Bullet extends Bomb 
	{		
		public function Bullet(layer:FlxGroup, X:Number, Y:Number) 
		{
			super(layer, X, Y);
			new SpriteLoader().loadIntoSprite(this, Assets.XMLSpriteRocket, Assets.SpriteRocket);
			addAnimationCallback(bulletAnimCallback);
			fixed = true;
			
			play("thrust");
		}
		
		public override function hitLeft(Contact:FlxObject, Velocity:Number):void
		{
			var other:Actor = Contact as Actor;
			if (other && other.controller is PlayerController)
			{
				play("burst");
				other.hurt(Constants.SOLDIER_BULLET_DAMAGE);
				velocity.x = velocity.y = 0;
			}
		}
		
		private function bulletAnimCallback(name:String, frameNumber:uint, frameIndex:uint):void 
		{
			if (name == "burst" && finished) 
			{
				kill();
			}
		}
	}
}