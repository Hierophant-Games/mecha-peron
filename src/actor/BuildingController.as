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
		private var _inittedSoldiers:Boolean = false;
		
		public function BuildingController(player:Actor, layer:FlxGroup) 
		{
			_player = player;
			_layer = layer;
		}
		
		override public function init():void 
		{
			controlledActor.createGraphic(80, 200, 0xffffffcc);
			controlledActor.fixed = true;
		}
		
		override public function update():void
		{
			// if I add the soldiers in the init function, the building
			// gets added after them, so I do it here... it's an ugly workaround but stfu
			if (!_inittedSoldiers) initSoldiers();
		}
		
		private function initSoldiers():void
		{
			_inittedSoldiers = true;
			for (var i:uint = 0; i < 4; ++i)
			{
				var soldier:Actor = new Actor(new SoldierController(_player, _layer),
						controlledActor.x, controlledActor.y + i * 20);
				
				_layer.add(soldier, true);
			}
		}
	}
}