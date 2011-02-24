package actor 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class SoldierController extends ActorController 
	{
		private var _player:Actor;
		private var _layer:FlxGroup;
		
		public function SoldierController(player:Actor, layer:FlxGroup) 
		{
			_player = player;
			_layer = layer;
		}
		
		override public function init():void 
		{
			controlledActor.createGraphic(10, 10, 0xff00ffff);
			controlledActor.fixed = true;
		}
		
		override public function update():void
		{
			
		}
	}
}