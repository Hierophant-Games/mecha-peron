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
			createGraphic(6, 6, 0xffcc0000);
			fixed = true;
		}
		
		public override function hitBottom(Contact:FlxObject, Velocity:Number):void
		{
			var other:Actor = Contact as Actor;
			if (other && other.controller is PlayerController)
			{
				other.flicker();
				
				kill();
			}
		}
	}
}