package actor 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class PlaneBomb extends FlxSprite
	{
		
		[Embed(source = "../../data/sprites/explosion.png")]
		private var SpriteExplosion:Class;
		
		[Embed(source = "../../data/sfx/explosion.mp3")]
		private var SfxExplosion:Class;
		
		private var _sprExplosion:FlxSprite;
		
		public function PlaneBomb(X:Number, Y:Number) 
		{
			super(X, Y);
			createGraphic(6, 6, 0xffcc0000);
			fixed = true;
		}
		
		public override function hitBottom(Contact:FlxObject, Velocity:Number):void
		{
			var other:Actor = Contact as Actor;
			if (other && other.controller is PlayerController)
			{
				_sprExplosion = new FlxSprite(other.x, other.y);
				_sprExplosion.solid = false;
				_sprExplosion.loadGraphic(SpriteExplosion, true, false, 64, 64);
				_sprExplosion.addAnimation("explode", new Array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25), 20, false);
				_sprExplosion.addAnimationCallback(exploAnimCallback);
				_sprExplosion.play("explode");
				FlxG.state.add(_sprExplosion);
				FlxG.play(SfxExplosion);
				
				kill();
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