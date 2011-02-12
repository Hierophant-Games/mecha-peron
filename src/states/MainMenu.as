package states 
{
	import menu.*;
	import org.flixel.*;
	import player.Player;
	import states.levels.BeggarLevel;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class MainMenu extends MenuBase
	{
		private var _bloodGroup:FlxGroup;
		private var _bloodTrailAmout:uint;
		private var _completedRatio:Number = 0;
		private var _gameNameText:FlxText;
		private var _skipBlood:Boolean = false;
		
		override public function create():void
		{
			initBloodEffect();
			
			_gameNameText = new FlxText(2, 2, Game.ScreenWidth / 2, Game.Strings.languageXML.GameName);
			_gameNameText.setFormat(null, 16, 0);
			add(_gameNameText);
			
			if (_skipBlood)
			{
				skipBloodEffect();
				updateBloodEffect();
			}
			
			initMenuEntries();
		}
		
		override public function destroy():void 
		{
			_bloodTrailAmout = 0;
			super.destroy();
		}
		
		override public function update():void
		{
			if (_completedRatio < 1)
			{
				if (FlxG.mouse.justPressed() || FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("ENTER"))
				{
					skipBloodEffect();
				}
				updateBloodEffect();
			}
			else if (!menuEnabled)
			{
				enableMenu();
			}
			
			super.update();
		}
		
		private function initBloodEffect():void
		{
			_bloodGroup = new FlxGroup();
			var x:uint = 0;
			while (x < Game.ScreenWidth)
			{
				// generate a block of 1-6 pixels
				var size:uint = uint(FlxU.random() * 5 + 1);
				if (size + x >= Game.ScreenWidth)
				{
					size = Game.ScreenWidth - x;
				}
				
				var bloodTrail:BloodTrail = new BloodTrail(x, -size, size);
				_bloodGroup.add(bloodTrail);
				++_bloodTrailAmout;
				
				x += size;
			}
			add(_bloodGroup);
		}
		
		private function updateBloodEffect():void
		{
			var numCompleted:uint;
			for each (var bloodTrail:BloodTrail in _bloodGroup.members)
			{
				if (bloodTrail.completed)
				{
					++numCompleted;
				}
			}
			_completedRatio = numCompleted / _bloodTrailAmout;
			
			var colorValue:uint = 0xff * _completedRatio;
			var color:uint = (0xff << 24) | (colorValue << 16) | (colorValue << 8) | colorValue;
			
			bgColor = color;
			_gameNameText.color = color;
		}
		
		private function skipBloodEffect():void
		{
			_skipBlood = true;
			for each (var bloodTrail:BloodTrail in _bloodGroup.members)
			{
				bloodTrail.forceComplete();
			}
		}
		
		private function initMenuEntries():void
		{
			addMenuEntry(new MenuEntry(onPlay, new FlxText(0, Game.ScreenHeight - 48, Game.ScreenWidth - 2, Game.Strings.languageXML.Menu.Play).setFormat(null, 8, 0xffffff, "right")));
			addMenuEntry(new MenuEntry(onOptions, new FlxText(0, Game.ScreenHeight - 34, Game.ScreenWidth - 2, Game.Strings.languageXML.Menu.Options).setFormat(null, 8, 0xffffff, "right")));
			addMenuEntry(new MenuEntry(onHelp, new FlxText(0, Game.ScreenHeight - 20, Game.ScreenWidth - 2, Game.Strings.languageXML.Menu.Help).setFormat(null, 8, 0xffffff, "right")));
			disableMenu();
		}
		
		private function onPlay():void
		{
			//Game.setState(new PlayerStats(new Player()));
			Game.setState(new BeggarLevel());
		}
		
		private function onOptions():void
		{
			trace("options");
		}
		
		private function onHelp():void
		{
			Game.setState(new Help());
		}
	}
}