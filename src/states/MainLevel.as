package states 
{
	import flash.geom.Rectangle;
	import actor.*;
	import embed.Assets;
	import level.ParallaxLayer;
	import org.flixel.*;
	
	/**
	 * Main Level of the game
	 * @author Santiago Vilar
	 */
	public class MainLevel extends FlxState
	{
		private const RANDOM_VOICEFX_COUNT:uint = 2;
		
		private var _layerBack:ParallaxLayer;
		private var _layerMiddle:ParallaxLayer;
		private var _layerAction:ParallaxLayer;
		private var _layerFront:ParallaxLayer;
		
		private var _player:Actor;
		
		private var _planes:Vector.<Actor> = new Vector.<Actor>();
		
		override public function create():void
		{
			bgColor = 0xffd3a9a9;
			_layerBack = new ParallaxLayer(Assets.SpriteBack,		0.2);
			_layerMiddle = new ParallaxLayer(Assets.SpriteMiddle,	0.5);
			_layerAction = new ParallaxLayer(null,					1.0);
			_layerFront = new ParallaxLayer(Assets.SpriteFront,		1.5);
			
			_layerMiddle.addEmitter(130, 80, setupSmoke, startSmoke);
			_layerMiddle.addEmitter(390, 126, setupSmoke, startSmoke);
			
			initActors();
			
			add(_layerBack);
			add(_layerMiddle);
			add(_layerAction);
			add(_layerFront);
			
			FlxG.playMusic(Assets.MusicTheme, 0.6);
		}
		
		private function initActors():void
		{
			_player = new Actor(new PlayerController(_layerAction));
			_player.x = 0;
			_player.y = FlxG.height - 222;
			
			FlxG.followTarget = _player;
			FlxG.followBounds(0, 0, 100000, FlxG.height);
			
			_layerAction.add(_player);
			
			addActor(new PlaneController(_player, _layerAction), 400, 20);
			addActor(new PlaneController(_player, _layerAction), 600, 40);
			addActor(new PlaneController(_player, _layerAction), 800, 60);
			
			addActor(new BuildingController(_player, _layerAction), 400, 60);
		}
		
		private function addActor(actorController:ActorController, x:Number, y:Number):void
		{
			var theActor:Actor = new Actor(actorController, x, y);
			
			if ((actorController as PlaneController) != null)
			{
				theActor.health = 100;
				_planes.push(theActor);
			}
			
			_layerAction.add(theActor, true);
		}
		
		private var _quakeTimer:Number = 0;
		private var _robotVoiceTimer:Number = 0;
		private var _robotVoiceIndex:uint = 0;
		
		override public function update():void
		{
			// Debug keys!
			if (FlxG.keys.justPressed("ONE")) 	_layerFront.visible = !_layerFront.visible;
			if (FlxG.keys.justPressed("TWO")) 	_layerAction.visible = !_layerAction.visible;
			if (FlxG.keys.justPressed("THREE"))	_layerMiddle.visible = !_layerMiddle.visible;
			if (FlxG.keys.justPressed("FOUR")) 	_layerBack.visible = !_layerBack.visible;
			
			// Voice effect!
			/*_robotVoiceTimer += FlxG.elapsed;
			if (_robotVoiceTimer > 5)
			{
				_robotVoiceTimer -= 5;
				_robotVoices[_robotVoiceIndex].play();
				_robotVoiceIndex = (_robotVoiceIndex + 1) % RANDOM_VOICEFX_COUNT;
			}*/
			
			// Earthquake effect!
			_quakeTimer += FlxG.elapsed;
			if (_quakeTimer > 1.5) // this should depend on Peron's footsteps
			{
				_quakeTimer -= 1.5;
				FlxG.quake.start(0.01, 0.2);
				FlxG.play(Assets.SfxFootstep);
			}
			
			var playerController:PlayerController = (_player.controller as PlayerController);
			//if (playerController == null) assert this?
			
			if (playerController.isLaserActive())
			{
				//playerController.setLaserClip(null);
				for (var i:uint = 0; i < _planes.length; ++i)
				{
					if (_planes[i].x > FlxG.width - FlxG.scroll.x)
						continue;
					
					var enemy:Actor = _planes[i];
					
					if (playerController.checkLaserHit(enemy))
					{
						/*
						var laserRect:Rectangle = playerController.getLaserRect();
						var laserClip:Rectangle = new Rectangle(
													laserRect.x, 
													enemy.y, 
													enemy.x + (enemy.width) - laserRect.x, 
													laserRect.y + laserRect.height - enemy.y);
						playerController.setLaserClip(laserClip);
						*/
						enemy.hurt(2);
						
						if (enemy.health <= 0)
						{
							_layerAction.remove(enemy, true);
							_planes.splice(i, 1);
						}
						
						break;
					}
				}
			}
			
			collide();
			super.update();
		}
		
		private function setupSmoke(emitter:FlxEmitter):void
		{
			emitter.setSize(6, 2);
			emitter.setRotation(0, 0);
			emitter.setXSpeed(-10, 0);
			emitter.setYSpeed(-20, -30);
			emitter.gravity = 0;
			for (var i:uint = 0; i <10; ++i)
			{
				var smoke:FlxSprite = new FlxSprite();
				if (i % 2)
				{
					smoke.loadGraphic(Assets.SpriteSmoke, true, false, 14, 12);
				}
				else
				{
					smoke.loadGraphic(Assets.SpriteSmokeBig, true, false, 28, 24);
				}
				smoke.exists = false;
				smoke.addAnimation("smoke", new Array(1, 2, 3, 4, 3, 2), 4, true);
				smoke.play("smoke");
				smoke.solid = false;
				emitter.add(smoke, true);
			}
		}
		
		private function startSmoke(emitter:FlxEmitter):void
		{
			emitter.start(false, 0.2);
		}
	}
}