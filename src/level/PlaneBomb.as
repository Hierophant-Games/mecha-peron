package level 
{
	import actor.*;
	import embed.Assets;
	import org.flixel.*;
	import game.Constants;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class PlaneBomb extends FlxSprite
	{
		private var _sprExplosion:FlxSprite;
		private var _layer:FlxGroup;
		
		public function PlaneBomb(layer:FlxGroup, X:Number, Y:Number) 
		{
			super(X, Y);
			_layer = layer;
			createGraphic(6, 6, 0xffcc0000);
			fixed = true;
		}
		
		public override function hitBottom(Contact:FlxObject, Velocity:Number):void
		{
			var other:Actor = Contact as Actor;
			if (other && other.controller is PlayerController)
			{
				// Restrict colission
				if (x > other.x + other.width / 2)
					return;
					
				_sprExplosion = new FlxSprite(x, y);
				_sprExplosion.solid = false;
				_sprExplosion.loadGraphic(Assets.SpriteExplosion, true, false, 64, 64);
				_sprExplosion.addAnimation("explode", new Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25), 20, false);
				_sprExplosion.addAnimationCallback(exploAnimCallback);
				_sprExplosion.play("explode");
				// adjust position
				_sprExplosion.x -= _sprExplosion.frameWidth / 2;
				_sprExplosion.y -= _sprExplosion.frameHeight / 2;
				_layer.add(_sprExplosion);
				FlxG.play(Assets.SfxExplosion);
				
				kill();
				
				other.hurt(Constants.PLANE_BOMB_DAMAGE);
			}
		}
		
		private function exploAnimCallback(name:String, frameNumber:uint, frameIndex:uint):void
		{
			if (frameIndex == 25)
			{
				_sprExplosion.kill();
			}
		}
	}
}