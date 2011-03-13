package level 
{
	import actor.*;
	import embed.Assets;
	import game.*;
	import org.flixel.*;
	import sprites.SpriteLoader;
	
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
				// create explosion
				var explosion:Actor = new Actor(new ExplosionController(), _layer, x, y);
				_layer.add(explosion);
				
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