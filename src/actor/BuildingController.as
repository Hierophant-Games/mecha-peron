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
		private var _soldierPositions:Vector.<FlxPoint> = new Vector.<FlxPoint>();
		private var _soldiers:Vector.<Actor> = new Vector.<Actor>();
		
		private var _collapsing:Boolean = false;
		
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
			if (_collapsing)
			{
				if (!controlledActor.onScreen())
				{
					controlledActor.kill();
				}
			}
			else if (FlxG.keys.justPressed("Z"))
			{
				collapse();
			}
		}
		
		private function initSoldiers():void
		{
			for (var i:uint = 0; i < _soldierCount; ++i)
			{
				var randomPos:FlxPoint = randomSoldierPosition();
				var soldier:Actor = new Actor(new SoldierController(_player, _layer),
											  randomPos.x, randomPos.y);
				_layer.add(soldier, true);
				_soldiers.push(soldier);
			}
		}
		
		private function randomSoldierPosition():FlxPoint
		{
			var position:FlxPoint = randomWindowPos();
			while (positionTaken(position))
			{
				position = randomWindowPos();
			}
			_soldierPositions.push(position);
			return position;
		}
		
		// returns whether a position is already taken or not
		private function positionTaken(position:FlxPoint):Boolean 
		{
			for each (var soldierPos:FlxPoint in _soldierPositions) 
			{
				if (soldierPos == position)
					return true;
			}
			
			return false;
		}
		
		// returns a random window position to place a soldier in
		private function randomWindowPos():FlxPoint 
		{
			var position:FlxPoint = new FlxPoint;
			position.x = (controlledActor.x - 2) + int((FlxU.random() * 6)) * 13;
			position.y = (controlledActor.y + 21) + int((FlxU.random() * 4)) * 12;
			return position;
		}
		
		private function collapse():void
		{
			_collapsing = true;
			controlledActor.velocity.y = 20;
			killAllSoldiers();
			startSmokeEmitter(0, controlledActor.width / 2);
			startSmokeEmitter(controlledActor.width / 2, controlledActor.width / 2);
		}
		
		private var _smokeEmitters:Vector.<FlxEmitter> = new Vector.<FlxEmitter>();
		
		private function startSmokeEmitter(offsetX:Number, width:Number):void
		{
			var smokeEmitter:FlxEmitter = new FlxEmitter(controlledActor.x + offsetX, FlxG.height);
			smokeEmitter.setSize(width, 2);
			smokeEmitter.setRotation(0, 0);
			smokeEmitter.setXSpeed(-10, 10);
			smokeEmitter.setYSpeed(-20, -30);
			smokeEmitter.gravity = 0;
			for (var i:uint = 0; i <20; ++i)
			{
				var smoke:FlxSprite = new FlxSprite();
				smoke.loadGraphic(Assets.SpriteSmokeBuilding, true, false, 28, 24);
				smoke.exists = false;
				smoke.solid = false;
				smoke.addAnimation("smoke", new Array(1, 2, 3, 4, 3, 2), 4, true);
				smoke.play("smoke");
				smokeEmitter.add(smoke, true);
			}
			smokeEmitter.start(false);
			_layer.add(smokeEmitter, true);
			_smokeEmitters.push(smokeEmitter);
		}
		
		private function killAllSoldiers():void
		{
			for each (var soldier:Actor in _soldiers) 
			{
				soldier.hurt(1);
			}
		}
		
		override public function onKill():void
		{
			for each (var smokeEmitter:FlxEmitter in _smokeEmitters)
			{
				smokeEmitter.stop();
			}
		}
	}
}