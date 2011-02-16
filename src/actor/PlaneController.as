package actor 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class PlaneController extends ActorController 
	{
		private var _initialY:Number;
		private var _accum:Number = 0;
		
		public function PlaneController() 
		{
		}
		
		public override function init():void
		{
			controlledActor.createGraphic(24, 16, 0xffcccccc);
		}
		
		public override function update():void
		{
			if (isNaN(_initialY))
			{
				_initialY = controlledActor.y;
			}
			
			controlledActor.x -= 50 * FlxG.elapsed;
			
			_accum += 0.17;
			if (_accum > 2 * Math.PI)
			{
				_accum -= 2 * Math.PI;
			}
			
			controlledActor.y = _initialY - 20*Math.sin(_accum);
		}
	}
}