package states 
{
	import embed.Assets;
	import game.Configuration;
	import menu.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class Credits extends MenuBase
	{
		private var text:FlxText;
		private const TEXT_SPEED:Number = 30;
		
		override public function create():void 
		{
			var creditsStr:String = "";
			creditsStr += Game.Strings.languageXML.Credits.Based;
			creditsStr += "\n\n\n\n" + Game.Strings.languageXML.Credits.Hierophant;
			creditsStr += "\n\n" + getDevTeamInRandomSoNoneIsMoreImportantThanTheOther();
			creditsStr += "\n\n\n\n" + Game.Strings.languageXML.Credits.Voices;
			creditsStr += "\n\n\n\n" + Game.Strings.languageXML.Credits.Marcha8Bit;
			creditsStr += "\n\n" + Game.Strings.languageXML.Credits.MarchaMetal;
			creditsStr += "\n\n\n\n" + Game.Strings.languageXML.Credits.Thanks;
			creditsStr += "\n\n" + Game.Strings.languageXML.Credits.ThanksAdam;
			creditsStr += "\n\n" + Game.Strings.languageXML.Credits.WeLoveJapan;
			creditsStr += "\n\n\n\n" + Game.Strings.languageXML.Credits.CODEAR;
			creditsStr += "\n\n" + Game.Strings.languageXML.Credits.FirstProject;
			
			text = new FlxText(4, FlxG.height, FlxG.width - 60, creditsStr);
			add(text);
			
			addMenuEntry(new MenuEntry(0, FlxG.height - 20, onBack, new FlxText(0, 0, FlxG.width - 10, Game.Strings.languageXML.Menu.Back).setFormat(null, 8, 0xffffff, "right")));
		}
		
		override public function update():void 
		{
			super.update();
			
			text.y -= FlxG.elapsed * TEXT_SPEED;
		}
		
		private function onBack():void
		{
			Game.goToPreviousState();
			FlxG.play(Assets.SfxConsoleBlip, Configuration.soundVolume);
		}
		
		private function getDevTeamInRandomSoNoneIsMoreImportantThanTheOther():String
		{
			var devs:String = "";
			var devsArray:Array = new Array(Game.Strings.languageXML.Credits.SMV, Game.Strings.languageXML.Credits.NVP, Game.Strings.languageXML.Credits.FMH);
			var random:uint = uint(FlxU.random() * devsArray.length);
			devs += devsArray[random] + "\n\n";
			devsArray.splice(random, 1);
			random = uint(FlxU.random() * devsArray.length);
			devs += devsArray[random] + "\n\n";
			devsArray.splice(random, 1);
			devs += devsArray[0];
			return devs;
		}
	}
}