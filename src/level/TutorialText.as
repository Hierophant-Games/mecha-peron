package level 
{
	import embed.Assets;
	import game.Configuration;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class TutorialText extends FlxGroup
	{
		private const UPDATE_TIME:Number = 0.06;
		private const CURSOR_TIME:Number = 0.5;
		private const LAST_TUTORIAL_STEP:uint = 6;
		
		private var _text:FlxText;
		private var _background:FlxSprite;
		
		private var _tutorialStep:uint = 0;
		private var _currentString:String = null;
		private var _tutorialComplete:Boolean = false;
		private var _accum:Number = 0;
		private var _updateTime:Number = UPDATE_TIME;
		
		private var _cursorToggle:Boolean = false;
		
		private var _skip:Boolean = false;
		
		public function get tutorialComplete():Boolean
		{
			return _tutorialComplete;
		}
		
		public function TutorialText() 
		{
			_background = new FlxSprite(0, 0);
			_background.createGraphic(FlxG.width, FlxG.height, 0x66000000);
			_text = new FlxText(2, 0, FlxG.width);
			_text.text = "> ";
			
			add(_background);
			add(_text);
			
			_currentString = Game.Strings.languageXML.Game.MechaPeron;
		}
		
		override public function update():void
		{
			_accum += FlxG.elapsed;
			if (_accum > _updateTime)
			{
				_accum -= _updateTime;
				updateStep();
			}
				
			if (FlxG.mouse.justReleased())
			{
				_skip = true;
				if (_tutorialStep >= LAST_TUTORIAL_STEP)
					_tutorialComplete = true;
			}
			
			super.update();
		}
		
		private function updateStep():void
		{
			if (_currentString.length > 0)
			{
				FlxG.play(Assets.SfxConsoleBlip, Configuration.soundVolume);
				if (_skip)
				{
					_text.text += _currentString;
					_currentString = "";
				}
				else
				{
					_text.text += _currentString.charAt();
					_currentString = _currentString.slice(1);
				}
			}
			else if (_tutorialStep < LAST_TUTORIAL_STEP)
				advanceStep();
			else
			{
				_updateTime = CURSOR_TIME;
				
				if (_cursorToggle)
					_text.text = _text.text.slice(0, _text.text.length - 1);
				else
				{
					FlxG.play(Assets.SfxConsoleBlip, Configuration.soundVolume);
					_text.text += "_";
				}
				_cursorToggle = !_cursorToggle;
			}
		}
		
		private function advanceStep():void
		{
			++_tutorialStep;
			_currentString = null;
			_text.text += "\n> ";
			
			switch (_tutorialStep)
			{
				case 1:
				{
					_currentString = Game.Strings.languageXML.Game.LineBreak;
					break;
				}
				case 2:
				{
					_currentString = Game.Strings.languageXML.Game.Preparing;
					break;
				}
				case 3:
				{
					_currentString = Game.Strings.languageXML.Game.AimReady;
					break;
				}
				case 4:
				{
					_currentString = Game.Strings.languageXML.Game.FlyingArm;
					break;
				}
				case 5:
				{
					_currentString = Game.Strings.languageXML.Game.CrushArm;
					break;
				}
				case 6:
				{
					_currentString = "\n> " + Game.Strings.languageXML.Game.ClickToContinue;
					break;
				}
			}
		}
	}
}