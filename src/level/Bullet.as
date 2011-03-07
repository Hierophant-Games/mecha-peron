package level 
{
	import actor.*;
	import embed.Assets;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class Bullet extends FlxSprite 
	{
		private var _layer:FlxGroup;
		
		public function Bullet(layer:FlxGroup, X:Number, Y:Number) 
		{
			super(X, Y);
			_layer = layer;
			loadGraphic(Assets.SpriteRocket, true, false, 9, 9, false);
			addAnimation("Thrust", new Array(0, 1), 6, true);
			addAnimation("Burst", new Array(2, 3, 4, 5, 6, 7, 8), 12, true);
			addAnimationCallback(bulletAnimCallback);
			fixed = true;
			
			play("Thrust");
		}
		
		public override function hitLeft(Contact:FlxObject, Velocity:Number):void
		{
			var other:Actor = Contact as Actor;
			if (other && other.controller is PlayerController)
			{
				play("Burst");
				other.flicker();
				other.controller.hurt(1);
				velocity.x = velocity.y = 0;
			}
		}
		
		private function bulletAnimCallback(name:String, frameNumber:uint, frameIndex:uint):void 
		{
			if(name == "Burst" && frameIndex == 8) 
			{
				kill();
			}
		}
	}
}