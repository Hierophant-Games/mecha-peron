package player 
{
	import org.flixel.*;
	/**
	 * Player class.
	 * Stores info about the current status of the player character.
	 * @author Santiago Vilar
	 */
	public class Player
	{
		private var _traits:Vector.<Trait> = new Vector.<Trait>();
		
		public function Player()
		{
			_traits.push(new Trait("Intelligence"));
			_traits.push(new Trait("Charisma"));
			_traits.push(new Trait("Willpower"));
			_traits.push(new Trait("Peace of mind"));
			_traits.push(new Trait("Cynicism"));
			_traits.push(new Trait("Sensibility"));
		}
	}
}