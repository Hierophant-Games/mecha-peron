package states.levels 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class BeggarLevel extends FlxState
	{
		[Embed(source = "../../../data/sprites/beggar_stage_bg.png")]
		private var Background:Class;
		
		override public function create():void 
		{
			add(new FlxSprite(0, 0, Background));
		}
	}
}