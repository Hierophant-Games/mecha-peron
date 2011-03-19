package states 
{
	import actor.*;
	import embed.Assets;
	import game.Configuration;
	import game.Constants;
	import level.*;
	import level.GameOverScreen;
	import org.flixel.*;
	
	/**
	 * Main Level of the game
	 * @author Santiago Vilar
	 */
	public class MainLevel extends FlxState
	{
		private const RANDOM_VOICEFX_COUNT:uint = 2;
		private const DISTANCE_SCALE_FACTOR:Number = 300;
		
		// Layers
		private var _layerBack:ParallaxLayer;
		private var _layerMiddle:ParallaxLayer;
		private var _layerActionBack:ParallaxLayer;
		private var _layerActionMiddle:ParallaxLayer;
		private var _layerActionFront:ParallaxLayer;
		private var _layerFront:ParallaxLayer;
		
		// Actors
		private var _player:CompositeActor;	
		private var _planes:Vector.<Actor> = new Vector.<Actor>();		
		private var _cannons:Vector.<Actor> = new Vector.<Actor>();
		private var _soldierBuildings:Vector.<Actor> = new Vector.<Actor>();
		private var _bombs:Vector.<Actor> = new Vector.<Actor>();
		
		private var _hud:HUD = new HUD();
		
		private var _distanceTraveled:uint = 0;
		private var _previousDistance:uint;
		
		private var _followBeacon:FlxObject;
		private const FOLLOW_OFFSET:int = 160;
		
		private var _levelStarted:Boolean = false;
		private var _playingTutorial:Boolean = false;
		private var _gameOver:Boolean = false;
		
		private var _gameOverScreen:GameOverScreen;		
		
		private var _aiDirector:AIDirector;
		
		// to access without casting every time
		private var _playerController:PlayerController;
		
		override public function create():void
		{
			bgColor = 0xffd3a9a9;
			_layerBack = new ParallaxLayer(Assets.SpriteBack,		0.2);
			_layerMiddle = new ParallaxLayer(Assets.SpriteMiddle,	0.5);
			_layerActionBack = new ParallaxLayer(null,				1.0);
			_layerActionMiddle = new ParallaxLayer(null,			1.0);
			_layerActionFront = new ParallaxLayer(null,				1.0);
			_layerFront = new ParallaxLayer(Assets.SpriteFront,		1.5);
			
			_layerFront.OnSpriteOffset = spawnCannons;
			
			_layerMiddle.addEmitter(130, 80, setupSmoke, startSmoke);
			_layerMiddle.addEmitter(390, 126, setupSmoke, startSmoke);
			
			initPlayer();
			
			_layerFront.add(_hud);
			_hud.visible = false;
			
			add(_layerBack);
			add(_layerMiddle);
			add(_layerActionBack);
			add(_layerActionMiddle);
			add(_layerActionFront);
			add(_layerFront);
			
			_aiDirector = new AIDirector(this, spawnPlane, spawnBuilding);
			
			// load cursor
			FlxG.mouse.show(Assets.SpriteCrosshair, 5, 5);
			
			// stop music from the menu
			//FlxG.music.stop();
		}
		
		private function initPlayer():void
		{
			_playerController = new PlayerController(_layerActionMiddle);
			_player = new CompositeActor(_playerController, _layerActionMiddle);
			_player.x = -160;
			_player.y = FlxG.height - 222;
			_player.health = 100;
			
			_followBeacon = new FlxObject(_player.x + FOLLOW_OFFSET, _player.y);
			FlxG.followBounds(0, 0, 1000000, FlxG.height);
			FlxG.follow(_followBeacon, 3);
			
			_layerActionMiddle.add(_player);
			_playerController.beforeLevelStart = true;
		}
		
		private function initLevel():void
		{
			FlxG.playMusic(Assets.MusicTheme, Configuration.musicVolume);
			
			_levelStarted = true;
			_playerController.beforeLevelStart = false;
			_hud.visible = true;
			_previousDistance = _player.x; // Start traveled distance count here
		}
		
		private function addActor(actorController:ActorController, x:Number, y:Number, layer:FlxGroup):void
		{
			var theActor:Actor = new Actor(actorController, layer, x, y);
			theActor.health = 100;
			
			if ((actorController as PlaneController) != null)
			{
				_planes.push(theActor);
			}
			else if ((actorController as CannonController) != null)
			{
				_cannons.push(theActor);
			}
			else if ((actorController as BuildingController) != null)
			{
				_soldierBuildings.push(theActor);
			}
			
			layer.add(theActor, true);
		}
		
		private var _robotVoiceTimer:Number = 0;
		private var _robotVoiceIndex:uint = 0;
		
		override public function update():void
		{
			if (FlxG.debug)
			{
				// Debug keys!
				if (FlxG.keys.justPressed("ONE"))
					_layerFront.visible = !_layerFront.visible;
				if (FlxG.keys.justPressed("TWO"))
				{
					_layerActionBack.visible = !_layerActionBack.visible;
					_layerActionMiddle.visible = !_layerActionMiddle.visible;
					_layerActionFront.visible = !_layerActionFront.visible;
				}
				if (FlxG.keys.justPressed("THREE"))
					_layerMiddle.visible = !_layerMiddle.visible;
				if (FlxG.keys.justPressed("FOUR"))
					_layerBack.visible = !_layerBack.visible;
			}
			
			if (FlxG.keys.justPressed("ESCAPE"))
			{
				FlxG.music.stop();
				Game.setState(new MainMenu());
			}
			
			if (!_levelStarted)
			{
				if (_playingTutorial)
				{
					playTutorial();
					return;
				}
				else if (_player.x > 0)
				{
					_playingTutorial = true;
					FlxG.timeScale = 1;
				}
				else if (_player.x > -10)
				{
					// stop it a little bit before the text
					FlxG.timeScale = 1;
				}
				else
				{
					// if the player is impatient she can speed up
					// the mecha entrance in the intro
					if (FlxG.mouse.justReleased())
					{
						FlxG.timeScale = 4;
					}
				}
			}
			
			if (_gameOver)
			{
				_gameOverScreen.update();
				super.update();
				
				return;
			}
			
			if (_player.dead)
			{
				var score:Number = _distanceTraveled / DISTANCE_SCALE_FACTOR;
				_gameOverScreen = new GameOverScreen(score.toFixed(1) + " km");				
				_gameOver = true;
				_gameOverScreen.start();
				add(_gameOverScreen);
				
				FlxG.followLerp = 0; // Avoid involuntary camera movement
				_playerController.updateHUD(_hud);
				return;
			}
			
			// Voice effect!
			/*_robotVoiceTimer += FlxG.elapsed;
			if (_robotVoiceTimer > 5)
			{
				_robotVoiceTimer -= 5;
				_robotVoices[_robotVoiceIndex].play();
				_robotVoiceIndex = (_robotVoiceIndex + 1) % RANDOM_VOICEFX_COUNT;
			}*/
			
			// check building collision
			for each (var building:Actor in _soldierBuildings)
			{
				_playerController.blockedByBuilding = false;
				if (_player.x + _player.composedWidth > building.x && !building.dead)
				{
					_playerController.blockedByBuilding = true;
				}
			}
			
			if (_levelStarted)
				_aiDirector.update(_player.x);
			
			updateLaserCombat();
			
			updateCrushingArm();
			
			removeDeadActors();
			
			// HUD
			_playerController.updateHUD(_hud);

			_distanceTraveled += _player.x - _previousDistance;
			_previousDistance = _player.x;
			
			var scaledDistance:Number = _distanceTraveled / DISTANCE_SCALE_FACTOR;
			_hud.setDistance(scaledDistance.toFixed(1));
			
			if (_playerController.laserCharge <= 0)
				_hud.showOverheat(true);
			else
				_hud.showOverheat(false);
			
			collide();
			super.update();
			
			// update beacon (?)
			_followBeacon.x = _player.x + FOLLOW_OFFSET;
			_followBeacon.y = _player.y;
		}
		
		private function spawnBuilding():void
		{
			addActor(new BuildingController(_player, _layerActionMiddle, spawnBomb), _player.x + FlxG.width, 40, _layerActionBack);
		}
		
		private function spawnPlane():void // callback
		{
			var y:Number = 20 + FlxU.random() * 40;
			addActor(new PlaneController(_player, _layerActionFront), _player.x + FlxG.width * 2, y, _layerActionFront);
		}
		
		private function spawnCannons(x:Number):void // Callback
		{
			//Front buildings cannon positions
			//48, 135
			//146, 147
			//236, 120
			return; // disabling them until we have the proper attack to kill them
			if(FlxU.random() * 100 > 70)
				addActor(new CannonController(_player, _layerActionMiddle, spawnBomb), x + 48, 135 - 15, _layerFront);
			if(FlxU.random() * 100 > 70)
				addActor(new CannonController(_player, _layerActionMiddle, spawnBomb), x + 146, 147 - 15, _layerFront);
			if(FlxU.random() * 100 > 70)
				addActor(new CannonController(_player, _layerActionMiddle, spawnBomb), x + 236, 120 - 15, _layerFront);
		}
		
		private function spawnBomb(bomb:Actor):void
		{
			bomb.health = 100;
			_bombs.push(bomb);
		}
		
		private function updateLaserCombat():void
		{
			if (_playerController.isLaserActive)
			{
				var i:uint;
				// soldier buildings
				for (i = 0; i < _soldierBuildings.length; ++i)
				{
					if (_soldierBuildings[i].getScreenXY().x > FlxG.width)
						continue;
					
					var soldiers:Vector.<Actor> = (_soldierBuildings[i].controller as BuildingController).soldiers;
					
					for (var j:uint = 0; j < soldiers.length; ++j)
					{
						if (soldiers[j].dead || !soldiers[j].onScreen())
							continue;
						
						if (_playerController.checkLaserHit(soldiers[j]))
						{
							soldiers[j].hurt(Constants.LASER_SOLDIER_DAMAGE);
						}
					}
				}
				
				// planes
				//playerController.setLaserClip(null);
				for (i = 0; i < _planes.length; ++i)
				{
					if (_planes[i].getScreenXY().x > FlxG.width || _planes[i].dead)
						continue;
					
					var plane:Actor = _planes[i];
					
					if (_playerController.checkLaserHit(plane))
					{
						/*
						var laserRect:Rectangle = playerController.getLaserRect();
						var laserClip:Rectangle = new Rectangle(
													laserRect.x, 
													plane.y, 
													plane.x + (plane.width) - laserRect.x, 
													laserRect.y + laserRect.height - plane.y);
						playerController.setLaserClip(laserClip);
						*/
						var laserXY:FlxPoint = _playerController.laserXY;
						var laserX:Number = laserXY.x;
						var laserY:Number = laserXY.y;
						
						(plane.controller as PlaneController).setSparksDirection(
								laserX, 
								laserY);
						
						plane.hurt(Constants.LASER_PLANE_DAMAGE);
					}
				}
				
				//Bombs
				for (i = 0; i < _bombs.length; ++i)
				{
					var bomb:Actor = _bombs[i];
					
					if (bomb.dead)
						continue;
					
					if (_playerController.checkLaserHit(bomb))
					{
						var bombController:BombController = bomb.controller as BombController;
						if (bombController.type == BombController.SOLDIER_BULLET)
						{
							bomb.hurt(Constants.LASER_SOLDIER_BOMB_DAMAGE);
						}						
						else if (bombController.type == BombController.CANNON_BOMB)
						{
							bomb.hurt(Constants.LASER_CANNON_BOMB_DAMAGE);
						}
						/*else if (bombController.type == BombController.PLANE_BOMB) // Can´t hurt plane bombs for now
						{
							bomb.hurt(Constants.LASER_PLANE_BOMB_DAMAGE);
						}*/
					}
				}
			}
		}
		
		private function updateCrushingArm():void
		{
			if (FlxG.keys.justPressed("SPACE"))
			{
				for (var i:uint = 0; i < _cannons.length; ++i)
				{
					if (_cannons[i].getScreenXY().x > FlxG.width)
						continue;
					
					var cannon:Actor = _cannons[i];
					
					var rightArmX1:Number = _player.getScreenXY().x + _player.width / 2;
					var rightArmX2:Number = rightArmX1 + _player.width;
					if (cannon.getScreenXY().x < rightArmX2 && cannon.getScreenXY().x + cannon.width > rightArmX1)
					{
						cannon.hurt(cannon.health);
					}
				}
			}
		}
		
		private function removeDeadActors():void
		{
			var actorIdx:int;
			for (actorIdx = 0; actorIdx < _soldierBuildings.length; ++actorIdx)
			{
				var building:Actor = _soldierBuildings[actorIdx];
				if (!building.exists)
				{
					_soldierBuildings.splice(actorIdx, 1);
					building.layer.remove(building);
					--actorIdx;
					FlxG.log("Removed actor with controller: " + building.controller);
				}
			}
			for (actorIdx = 0; actorIdx < _planes.length; ++actorIdx)
			{
				var plane:Actor = _planes[actorIdx];
				if (!plane.exists)
				{
					_planes.splice(actorIdx, 1);
					plane.layer.remove(plane);
					--actorIdx;
					FlxG.log("Removed actor with controller: " + plane.controller);
				}
			}
			for (actorIdx = 0; actorIdx < _cannons.length; ++actorIdx)
			{
				var cannon:Actor = _cannons[actorIdx];
				if (!cannon.exists)
				{
					_cannons.splice(actorIdx, 1);
					cannon.layer.remove(cannon);
					--actorIdx;
					FlxG.log("Removed actor with controller: " + cannon.controller);
				}
			}
			for (actorIdx = 0; actorIdx < _bombs.length; ++actorIdx)
			{
				var bomb:Actor = _bombs[actorIdx];
				if (!bomb.exists)
				{
					_bombs.splice(actorIdx, 1);
					bomb.layer.remove(bomb);
					--actorIdx;
					FlxG.log("Removed actor with controller: " + bomb.controller);
				}
			}
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
		
		private var _tutorialText:TutorialText = null;
		
		private function playTutorial():void
		{
			if (!_tutorialText)
			{
				_tutorialText = new TutorialText();
				add(_tutorialText);
			}
			_tutorialText.update();
			if (_tutorialText.tutorialComplete)
			{
				_tutorialText.kill();
				_playingTutorial = false;
				initLevel();
			}
		}
	}
}