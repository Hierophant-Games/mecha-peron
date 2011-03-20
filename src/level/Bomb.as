package level 
{
	import org.flixel.*;
	import level.*;
	import actor.Actor;
	/**
	 * ...
	 * @author Fernando
	 */
	public class Bomb
	{		
		protected var _actor:Actor;
		
		public function Bomb(actor:Actor) 
		{
			_actor = actor;
		}
		
		public function init():void
		{
		}
		
		public function collide(contact:FlxObject):void
		{
		}
		
		public function explode():void // Trigger explosion animation
		{
		}
	}

}