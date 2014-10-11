package actor 
{
	import embed.Assets;
	import game.*;
	import org.flixel.*;
	import sprites.SpriteLoader;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class FrontBuildingController extends ActorController
	{
		private const NUM_BUILDINGS:uint = 3;
		private const Graphics:Array = [Assets.SpriteForegroundA, Assets.SpriteForegroundB, Assets.SpriteForegroundC];
		private const Defs:Array = [Assets.XMLSpriteForegroundA, Assets.XMLSpriteForegroundB, Assets.XMLSpriteForegroundC];
		
		private static var _lastRandom:uint;
		
		private var _playerController:PlayerController;
		
		private var _cannon:Actor;
		
		public function set cannon(cannon:Actor):void
		{
			_cannon = cannon;
		}
		
		public function FrontBuildingController(playerController:PlayerController):void
		{
			_playerController = playerController;
		}
		
		override public function init():void 
		{
			var random:uint;
			do {
				random = uint(FlxU.random() * NUM_BUILDINGS);
			} while (random == _lastRandom);
			_lastRandom = random;
			
			//trace("random building: ", random);
			new SpriteLoader().loadIntoSprite(controlledActor, Defs[random], Graphics[random]);
			
			controlledActor.solid = false;
		}
		
		override public function preFirstUpdate():void 
		{
			controlledActor.y = FlxG.height - controlledActor.height;
		}
		
		override public function update():void 
		{
			if (!controlledActor.dead && _playerController.usingRightArm)
			{
				var player:Actor = _playerController.controlledActor;
				var playerX:Number = player.getScreenXY().x;
				var thisX:Number = controlledActor.getScreenXY().x;
				if (playerX + player.width > thisX)
				{
					controlledActor.dead = true;
					controlledActor.play("damage");
					FlxG.quake.start(0.01);
					FlxG.play(Assets.SfxExplosion, Configuration.soundVolume);
					if (_cannon && _cannon.exists)
						_cannon.kill();
						
					// track it!
					ScoreTracker.killed(ScoreTracker.BUILDING);
				}
			}
		}
	}
}