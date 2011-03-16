package states 
{
	import embed.Assets;
	import game.Configuration;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class SelectLanguage extends FlxState
	{
		override public function create():void 
		{
			FlxG.mouse.show(Assets.SpriteCursor);
			FlxG.playMusic(Assets.LosMuchachos8Bit, Configuration.musicVolume);
			
			var btnEN:FlxButton = new FlxButton(FlxG.width / 2 + 40, FlxG.height / 2, selectedEN);
			btnEN.loadGraphic(new FlxSprite(0, 0, Assets.SpriteEN));
			btnEN.x -= btnEN.width / 2;
			btnEN.y -= btnEN.height / 2;
			var btnES:FlxButton = new FlxButton(FlxG.width / 2 - 40, FlxG.height / 2, selectedES);
			btnES.loadGraphic(new FlxSprite(0, 0, Assets.SpriteES));
			btnES.x -= btnES.width / 2;
			btnES.y -= btnES.height / 2;
			
			add(btnEN);
			add(btnES);
		}
		
		private function advanceState(lang:String):void
		{
			Game.Strings.setLanguage(lang);
			Game.setState(new Intro());
		}
		
		private function selectedES():void
		{
			advanceState("ES");
		}
		
		private function selectedEN():void
		{
			advanceState("EN");
		}
	}
}