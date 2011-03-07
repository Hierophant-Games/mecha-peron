package actor 
{
	import org.flixel.*;
	import embed.Assets;
	import org.flixel.data.FlxAnim;

	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class BuildingController extends ActorController 
	{
		private var _player:Actor;
		private var _layer:FlxGroup;
		private var _soldierCount:int;
		private var _soldierPositions:Array = new Array();
		
		
		public function BuildingController(player:Actor, layer:FlxGroup, soldierCount:int = 4) 
		{
			_player = player;
			_layer = layer;
			_soldierCount = soldierCount;
		}
		
		override public function init():void 
		{
			controlledActor.loadGraphic(Assets.SpriteEnemyBuilding, false, false, 79, 225, false);
			controlledActor.fixed = true;
		}
		
		override public function preFirstUpdate():void
		{
			initSoldiers();
		}
		
		override public function update():void
		{
		}
		
		private function initSoldiers():void
		{
			for (var i:uint = 0; i < _soldierCount; ++i)
			{
				var randomPos:FlxPoint = randomSoldierPosition();
				var soldier:Actor = new Actor(new SoldierController(_player, _layer),
				randomPos.x, randomPos.y);
				_layer.add(soldier, true);
			}
		}
		
		private function randomSoldierPosition():FlxPoint
		{
			var position:FlxPoint = randomWindowPos();
			while (positionTaken(position))
			{
				position = randomWindowPos();
			}			
			return position;
		}
		
		// returns whether a position is already taken or not
		private function positionTaken(position:FlxPoint):Boolean 
		{
			var soldierPositionsLength:int = _soldierPositions.length;

			for (var i:uint = 0; i < soldierPositionsLength; i++) 
			{
				if (_soldierPositions[i] == position) 
				{
					return true;
				}
			}
			
			return false;
		}
		
		// returns a random window position to place a soldier in
		private function randomWindowPos():FlxPoint 
		{
			var position:FlxPoint = new FlxPoint;
			position.x = (controlledActor.x -2) + int((FlxU.random() * 6)) * 13;
			position.y = (controlledActor.y + 21) + int((FlxU.random() * 4)) * 12;
			return position;
		}
	}
}