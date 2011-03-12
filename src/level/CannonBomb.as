package level 
{
	import actor.*;
	import embed.Assets;
	import game.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author
	 */
	public class CannonBomb extends FlxSprite
	{
		private var _sprExplosion:FlxSprite;
		private var _layer:FlxGroup;
		
		public function CannonBomb(layer:FlxGroup, X:Number, Y:Number) 
		{
			super(X, Y);
			_layer = layer;
			createGraphic(5, 5, 0xffffff00);
			fixed = true;
		}		
		
		public override function hitLeft(Contact:FlxObject, Velocity:Number):void
		{
			var other:Actor = Contact as Actor;
			if (other && other.controller is PlayerController)
			{
				_sprExplosion = new FlxSprite(x, y);
				_sprExplosion.solid = false;
				_sprExplosion.loadGraphic(Assets.SpriteExplosion, true, false, 50, 50);
				_sprExplosion.addAnimation("explode", new Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), 24, false);
				_sprExplosion.addAnimationCallback(exploAnimCallback);
				_sprExplosion.play("explode");
				// adjust position
				_sprExplosion.x -= _sprExplosion.frameWidth / 2;
				_sprExplosion.y -= _sprExplosion.frameHeight / 2;
				_layer.add(_sprExplosion);
				FlxG.play(Assets.SfxExplosion, Configuration.soundVolume);
				
				kill();
				
				other.hurt(Constants.CANNON_BOMB_DAMAGE);
			}
		}
		
		private function exploAnimCallback(name:String, frameNumber:uint, frameIndex:uint):void
		{
			if (frameIndex == 12)
			{
				_sprExplosion.kill();
			}
		}
	}
}