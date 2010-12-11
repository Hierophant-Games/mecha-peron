package menu 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class MenuEntry extends FlxGroup
	{
		private var _callback:Function;
		private var _text:FlxText;
		
		public function MenuEntry(callback:Function, text:FlxText)
		{
			_callback = callback;
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
	}
}