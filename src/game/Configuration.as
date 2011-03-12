package game 
{
	import org.flixel.FlxSave;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class Configuration 
	{
		public static var musicVolume:Number = 0.75;
		public static var soundVolume:Number = 0.75;
		
		public static function save():void
		{
			var save:FlxSave = new FlxSave();
			save.bind("MechaPeronConfig");
			save.write("exists", true);
			save.write("musicVolume", musicVolume);
			save.write("soundVolume", soundVolume);
		}
		
		public static function load():void
		{
			var save:FlxSave = new FlxSave();
			save.bind("MechaPeronConfig");
			if (save.read("exists"))
			{
				musicVolume = save.read("musicVolume") as Number;
				soundVolume = save.read("soundVolume") as Number;
			}
		}
	}
}