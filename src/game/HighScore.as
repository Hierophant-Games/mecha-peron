package game 
{
	import org.flixel.FlxSave;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class HighScore 
	{
		public static function save(score:Number):void
		{
			var save:FlxSave = new FlxSave();
			save.bind("MechaPeronHighScore");
			save.write("score", score);
		}
		
		public static function load():Number
		{
			var save:FlxSave = new FlxSave();
			save.bind("MechaPeronHighScore");
			return save.read("score") as Number;
		}
	}
}