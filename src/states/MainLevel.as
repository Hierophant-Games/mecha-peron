package states 
{
	import actor.*;
	import embed.Assets;
	import game.*;
	import level.*;
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
		private var _frontBuildings:Vector.<Actor> = new Vector.<Actor>();
		
		private var _hud:HUD = new HUD();
		
		private var _distanceTraveled:uint = 0;
		private var _previousDistance:uint;
		
		private var _followBeacon:FlxObject;
		private const FOLLOW_OFFSET:int = 160;
		
		private var _tutorialText:TutorialText;
		
		private var _levelStarted:Boolean = false;
		private var _playingTutorial:Boolean = false;
		private var _fistTutorial:Boolean = true;
		private var _gameOver:Boolean = false;
		
		private var _fistTutorialText:FlxText;
		private var _armTutorialText:FlxText;
		
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
			_layerFront = new ParallaxLayer(null,					1.5);
			
			_layerMiddle.addEmitter(130, 80, setupSmoke, startSmoke);
			_layerMiddle.addEmitter(390, 126, setupSmoke, startSmoke);
			
			initPlayer();
			
			add(_layerBack);
			add(_layerMiddle);
			add(_layerActionBack);
			add(_layerActionMiddle);
			add(_layerActionFront);
			add(_layerFront);
			// after everything, add the HUD
			add(_hud);
			_hud.visible = false;
			
			_aiDirector = new AIDirector(this, spawnPlane, spawnBuilding, spawnCannon);
			
			// load cursor
			FlxG.mouse.show(Assets.SpriteCrosshair, 5, 5);
			
			// do some updates for the front buildings
			updateFrontBuildings();
			updateFrontBuildings();
			updateFrontBuildings();
			// VIVA LA CABEZEADA!
			
			ScoreTracker.reset();
			
			// fade in
			FlxG.flash.start(0xff000000, 0.5);
		}
		
		private function initPlayer():void
		{
			_playerController = new PlayerController(_layerActionMiddle, _layerFront);
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
		
		private function addActor(actorController:ActorController, x:Number, y:Number, layer:FlxGroup):Actor
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
			return theActor;
		}
		
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
				if (updateTutorial())
					return;
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
				_gameOverScreen = new GameOverScreen(score.toFixed(2) + " km");
				_gameOver = true;
				_gameOverScreen.start();
				add(_gameOverScreen);
				
				FlxG.followLerp = 0; // Avoid involuntary camera movement
				_playerController.updateHUD(_hud);
				
				// Submit score to the Kong API
				if (FlxG.kong)
				{
					// all kong stats must be positive integers,
					// so let's convert the float with 2 decimals to a simple integer
					// i.e.: if score was '1.23', we'll submit '123'. cool
					var kongScore:uint = uint(score * 100);
					FlxG.kong.API.stats.submit("score", kongScore);
				}
				ScoreTracker.publish();
				
				// Save locally the High Score too
				HighScore.save(score);
				
				return;
			}
			
			// check building collision
			for each (var building:Actor in _soldierBuildings)
			{
				_playerController.blockedByBuilding = false;
				if (_player.x + _player.composedWidth > building.x && !building.dead)
				{
					_playerController.blockedByBuilding = true;
				}
			}
			
			updateFrontBuildings();
			
			if (_levelStarted)
				_aiDirector.update(_player.x);
				
			updateLaserCombat();
			
			removeDeadActors();
			
			// HUD
			_playerController.updateHUD(_hud);

			_distanceTraveled += _player.x - _previousDistance;
			_previousDistance = _player.x;
			
			var scaledDistance:Number = _distanceTraveled / DISTANCE_SCALE_FACTOR;
			_hud.setDistance(scaledDistance.toFixed(2));
			
			if (_playerController.laserCharge <= 0)
				_hud.showOverheat(true);
			else
				_hud.showOverheat(false);
				
			_hud.setPoints(FlxG.score);
			
			// update beacon (?)
			_followBeacon.x = _player.x + FOLLOW_OFFSET;
			_followBeacon.y = _player.y;
			
			collide();
			super.update();
		}
		
		private function spawnBuilding():void
		{
			var buildingX:Number = _player.x + FlxG.width;
			addActor(new BuildingController(_player, _layerActionMiddle, spawnBomb), buildingX, 40, _layerActionBack);
			
			// Prepare fist tutorial
			if (_fistTutorialText == null)
			{
				var textScrollFactor:Number = 1.9; // A ojo
				var fistTutorialX:Number =  (buildingX + FlxG.scroll.x) - (FlxG.scroll.x * textScrollFactor);
				
				_fistTutorialText = new FlxText(fistTutorialX, 25, FlxG.width - 100, Game.Strings.languageXML.Game.FistTutorial);
				_fistTutorialText.setFormat(null, 12, 0xffffff, "center", 1);
				_layerActionFront.add(_fistTutorialText);
				_fistTutorialText.scrollFactor.x = textScrollFactor;	
			}
		}
		
		private function spawnPlane():void // callback
		{
			var y:Number = 10 + FlxU.random() * 50;
			addActor(new PlaneController(_player, _layerActionFront), _player.x + FlxG.width * 2, y, _layerActionFront);
		}
		
		private function spawnCannon():void
		{
			// get last building
			var building:Actor = _frontBuildings[_frontBuildings.length - 1];
			var x:Number = building.x + building.width / 2;
			var y:Number = building.y - 15;
			var cannon:Actor = addActor(new CannonController(_player, _layerActionMiddle, spawnBomb), x, y, _layerFront);
			(building.controller as FrontBuildingController).cannon = cannon;
			var random:Number = (FlxU.random() * cannon.width * 2) - cannon.width;
			cannon.x -= cannon.width / 2; // centered
			cannon.x += random;
			
			// Prepare arm tutorial
			if (_armTutorialText == null)
			{
				var width:Number = FlxG.width - 100;
				_armTutorialText = new FlxText(x - (width / 4), 40, width, Game.Strings.languageXML.Game.ArmTutorial);
				_armTutorialText.setFormat(null, 12, 0xffffff, "center", 1);
				_layerFront.add(_armTutorialText, true);
			}
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
		
		private function updateFrontBuildings():void
		{
			const kScreenLeft:Number = -FlxG.scroll.x * _layerFront.scrollFactor.x;
			const kScreenRight:Number = kScreenLeft + FlxG.width * _layerFront.scrollFactor.x;
			//trace("kScreenRight", kScreenRight);
			
			var maxXOfBuilding:Number = kScreenLeft;
			
			for each (var building:Actor in _frontBuildings)
			{
				var maxX:Number = building.x + building.width;
				if (maxX < kScreenLeft)
				{
					building.kill();
				}
				else if (maxX > maxXOfBuilding)
				{
					maxXOfBuilding = maxX;
				}
			}
			//trace("maxXOfBuilding", maxXOfBuilding);
			var randomOffset:Number = 20 + (FlxU.random() * 10) * 2;
			maxXOfBuilding += randomOffset;
			if (maxXOfBuilding < kScreenRight)
			{
				var newBuilding:Actor = new Actor(new FrontBuildingController(_playerController), _layerFront, maxXOfBuilding);
				_layerFront.add(newBuilding, true);
				_frontBuildings.push(newBuilding);
			}
			
			// clean vector
			for (var i:int = 0; i < _frontBuildings.length; i++) 
			{
				var item:Actor = _frontBuildings[i];
				if (!item.exists)
				{
					_frontBuildings.splice(i, 1);
					_layerFront.remove(item);
					--i;
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
		
		private function updateTutorial():Boolean
		{
			if (_playingTutorial)
			{
				playTutorial();
				return true;
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
			return false;
		}
		
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