package actor 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class BuildingController extends ActorController 
	{
		private var _player:Actor;
		private var _layer:FlxGroup;
		
		public function BuildingController(player:Actor, layer:FlxGroup) 
		{
			_player = player;
			_layer = layer;
		}
		
		override public function init():void 
		{
			controlledActor.createGraphic(80, 200, 0xffffffcc);
			controlledActor.fixed = true;
			
			initSoldiers();
		}
		
		override public function update():void
		{
			
		}
		
		private function initSoldiers():void
		{
			for (var i:uint = 0; i < 4; ++i)
			{
				var soldier:Actor = new Actor(new SoldierController(_player, _layer),
						controlledActor.x, controlledActor.y + i * 20);
				
				_layer.add(soldier, true);
			}
		}
	}
}