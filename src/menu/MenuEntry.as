package menu 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class MenuEntry extends FlxButton
	{
		private var _text:FlxText;
		
		public function MenuEntry(x:Number, y:Number, callback:Function, text:FlxText)
		{
			super(x, y, callback);
			
			loadGraphic(new FlxSprite().createGraphic(1,1,0), new FlxSprite().createGraphic(1,1,0));
			
			width = text.width;
			height = text.height;
			
			_text = text;
			add(_text);
			
			dehighlight();
		}
		
		public function select():void
		{
			_callback();
		}
		
		public function dehighlight():void
		{
			_text.setFormat(null, 8, 0xcccccc);
		}
		
		public function highlight():void
		{
			_text.setFormat(null, 8, 0xffffff);
		}
		
		public function get mouseOver():Boolean
		{
			return _on.visible;
		}
	}
}