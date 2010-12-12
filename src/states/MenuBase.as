package states 
{
	import org.flixel.*;
	import menu.MenuEntry;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class MenuBase extends FlxState
	{
		private var _menuEntries:Array = new Array();
		private var _selectedMenuEntry:int = 0;
		private var _enabled:Boolean = true;
		
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
				if (i == _selectedMenuEntry) _menuEntries[i].highlight();
				else _menuEntries[i].dehighlight();
			}
		}
		
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
		
		public function get menuEnabled():Boolean
		{
			return _enabled;
		}
	}
}