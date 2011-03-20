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
		public function Bullet(actor:Actor) 
		{
			super(actor);
		}
		
		override public function init():void
		{
			new SpriteLoader().loadIntoSprite(_actor, Assets.XMLSpriteRocket, Assets.SpriteRocket);
			_actor.addAnimationCallback(bulletAnimCallback);
			_actor.fixed = true;
			
			_actor.play("thrust");
		}
		
		override public function collide(contact:FlxObject):void
		{
			if (_actor.health == 0) return;
			
			var other:Actor = contact as Actor;
			if (other && other.controller is PlayerController)
			{
				explode();
				_actor.health = 0;
				
				other.hurt(Constants.SOLDIER_BULLET_DAMAGE);
			}
		}
		
		override public function explode():void
		{
			_actor.play("burst");
			_actor.velocity.x = _actor.velocity.y = 0;
		}
		
		private function bulletAnimCallback(name:String, frameNumber:uint, frameIndex:uint):void 
		{
			if (name == "burst" && _actor.finished) 
			{
				_actor.kill();
			}
		}
	}
}