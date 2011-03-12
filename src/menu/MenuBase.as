package menu 
{
	import org.flixel.*;
	import menu.MenuEntry;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class MenuBase extends FlxState
	{
		private var _menuEntries:Vector.<MenuEntry> = new Vector.<MenuEntry>();
		private var _selectedMenuEntry:int = 0;
		private var _enabled:Boolean = true;
		
		public function get menuEnabled():Boolean
		{
			return _enabled;
		}
		
		override public function destroy():void 
		{
			// reset the menu entry stuff
			_menuEntries = new Vector.<MenuEntry>();
			
			super.destroy();
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!_enabled) return;
			
			if (FlxG.keys.justPressed("UP"))
			{
				--_selectedMenuEntry;
				if (_selectedMenuEntry < 0)
				{
					_selectedMenuEntry = _menuEntries.length - 1;
				}
			}
			if (FlxG.keys.justPressed("DOWN"))
			{
				++_selectedMenuEntry;
				if (_selectedMenuEntry >= _menuEntries.length)
				{
					_selectedMenuEntry = 0;
				}
			}
			if (FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("ENTER"))
			{
				(_menuEntries[_selectedMenuEntry] as MenuEntry).select();
			}
			
			for (var i:uint = 0; i < _menuEntries.length; ++i)
			{
				if (_menuEntries[i].mouseOver)
				{
					_selectedMenuEntry = i;
					break;
				}
			}
			
			for (i = 0; i < _menuEntries.length; ++i)
			{
				if (i == _selectedMenuEntry) _menuEntries[i].highlight();
				else _menuEntries[i].dehighlight();
			}
		}
		
		/**
		 * Add a menu entry to the menu, ready to use!
		 * @param	menuEntry
		 */
		protected function addMenuEntry(menuEntry:MenuEntry):void
		{
			_menuEntries.push(menuEntry);
			add(menuEntry);
		}
		
		private function toggleEnabled(flag:Boolean):void
		{
			_enabled = flag;
			for each (var menuEntry:MenuEntry in _menuEntries)
			{
				menuEntry.visible = flag;
			}
		}
		
		public function enableMenu():void 
		{
			toggleEnabled(true);
		}
		
		public function disableMenu():void 
		{
			toggleEnabled(false);
		}
	}
}