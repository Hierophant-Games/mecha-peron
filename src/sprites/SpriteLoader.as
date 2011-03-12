package sprites 
{
	import org.flixel.*;
	
	/**
	 * Handles the loading of animated sprites from a definition file
	 * @author Santiago Vilar
	 */
	public class SpriteLoader 
	{
		public function load(DefAsset:Class, GraphicAsset:Class):FlxSprite
		{
			var sprite:FlxSprite = new FlxSprite();
			var xml:XML = XML(new DefAsset() as Object); // weird cast stuff to make it work
			
			var animated:Boolean = readBoolean(xml.graphic.@animated);
			var reverse:Boolean = readBoolean(xml.graphic.@reverse);
			var width:uint = new uint(xml.graphic.@width);
			var height:uint = new uint(xml.graphic.@height);
			
			sprite.loadGraphic(GraphicAsset, animated, reverse, width, height);
			
			var xmlAnims:XMLList = xml.animations.elements("animation");
			for (var i:uint = 0; i < xmlAnims.length(); ++i)
			{
				var name:String = xmlAnims[i].@name;
				var frames:Array = readCSVArray(xmlAnims[i].@frames);
				var frameRate:Number = xmlAnims[i].@frameRate;
				var loop:Boolean = readBoolean(xmlAnims[i].@loop);
				
				sprite.addAnimation(name, frames, frameRate, loop);
			}
			
			return sprite;
		}
		
		private function readBoolean(string:String):Boolean
		{
			return string != "false";
		}
		
		private function readCSVArray(string:String):Array
		{
			var array:Array = new Array();
			var splitArray:Array = string.split(',');
			for each (var str:String in splitArray)
			{
				array.push(new uint(str));
			}
			return array;
		}
	}
}