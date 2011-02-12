package player 
{
	/**
	 * Trait class.
	 * Add them to the player!
	 * @author Santiago Vilar
	 */
	public class Trait 
	{
		private var _name:String;
		private var _value:int;
		
		public function get name():String { return _name; }
		public function get value():int { return _value; }
		
		public function Trait(name:String, initialValue:int = 0) 
		{
			_name = name;
			_value = initialValue;
		}
	}
}