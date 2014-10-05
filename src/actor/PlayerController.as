package actor 
{
	import collision.RotatedRectangle;
	import embed.Assets;
	import flash.display.Sprite;
	import flash.geom.*;
	import flash.utils.getTimer;
	import game.*;
	import level.HUD;
	import level.SmokeEmitter;
	import org.flixel.*;
	import sprites.SpriteLoader;
	
	/**
	 * PlayerController.
	 * Controls an Actor with a player behavior. Handles input and update accordingly.
	 * @author Santiago Vilar
	 */
	public class PlayerController extends ActorController
	{
		private const SfxPeronFrases:Array = new Array(Assets.SfxPeronCompanieros, Assets.SfxPeronJusticiaSocial, Assets.SfxPeronTerceraPosicion);
		private const SfxPeronHits:Array = new Array(Assets.SfxPeronHit1, Assets.SfxPeronHit2, Assets.SfxPeronHit3);
		
		private var _layer:FlxGroup;
		private var _foregroundLayer:FlxGroup;
		
		private var _laser:CompositeActor;
		private var _laserCharge:Number;
		private var _isLaserRecharging:Boolean;
		private var _laserRechargeTimer:Number = 0;
		
		private var _laserSfx:FlxSound;
		private var _laserShoutSfx:FlxSound;
		
		private var _beforeLevelStart:Boolean = false;
		private var _blockedByBuilding:Boolean = false;
		
		private const ACTION_WALKING:uint = 0;
		private const ACTION_SHOOTING_LASER:uint = 1;
		private const ACTION_ATTACKING_LEFT_ARM:uint = 2;
		private const ACTION_ATTACKING_RIGHT_ARM:uint = 3;
		private const ACTION_BEING_DAMAGED:uint = 4;
		private var _currentAction:uint = ACTION_WALKING;
		
		private var _headSprite:FlxSprite;
		private var _bodySprite:FlxSprite;
		private var _leftArmSprite:FlxSprite;
		private var _rightArmSprite:FlxSprite;
		
		private var _leftHand:Actor;
		private var _fistTimer:Number;
		
		private var _quakeTimer:Number = 0;
		private const QUAKE_TIME:Number = 1.5;
		
		private var _smokeEmitterL:SmokeEmitter; // left eye
		private var _smokeEmitterR:SmokeEmitter; // right eye
		
		// to tell the front building that it can be destroyed
		private var _usingRightArm:Boolean = false;
		
		public function set beforeLevelStart(beforeLevelStart:Boolean):void
		{
			_beforeLevelStart = beforeLevelStart;
		}
		
		public function set blockedByBuilding(blockedByBuilding:Boolean):void
		{
			_blockedByBuilding = blockedByBuilding;
		}
		
		public function get isLaserActive():Boolean
		{
			return _laser.active;
		}
		
		public function get laserAngle():Number
		{
			return _laser.angle;
		}
		
		public function get laserXY():FlxPoint
		{
			return new FlxPoint(_laser.x, _laser.y);
		}
		
		public function set laserClip(clip:Rectangle):void
		{
			_laser.clip = clip;
		}
		
		public function get laserCharge():Number
		{
			return _laserCharge;
		}
		
		public function get usingRightArm():Boolean
		{
			return _usingRightArm;
		}
		
		public function PlayerController(layer:FlxGroup, foregroundLayer:FlxGroup)
		{
			_layer = layer;
			_foregroundLayer = foregroundLayer;
		}
		
		public override function init():void
		{
			controlledActor.fixed = true;
			
			// load the head!
			_headSprite = new SpriteLoader().load(Assets.XMLSpriteHead, Assets.SpriteHead);
			_headSprite.addAnimationCallback(headAnimationCallback);
			_headSprite.fixed = true;
			
			// load the body sprite... no animations
			_bodySprite = new FlxSprite(0, 0, Assets.SpriteBody);
			_bodySprite.fixed = true;
			
			// load the left arm sprite...
			_leftArmSprite = new SpriteLoader().load(Assets.XMLSpriteLeftArm, Assets.SpriteLeftArm);
			_leftArmSprite.addAnimationCallback(leftArmAnimationCallback);
			_leftArmSprite.fixed = true;
			
			// load the right arm sprite...
			_rightArmSprite = new SpriteLoader().load(Assets.XMLSpriteRightArm, Assets.SpriteRightArm);
			_rightArmSprite.addAnimationCallback(rightArmAnimationCallback);
			_rightArmSprite.fixed = true;
			
			// add sprites to the composite actor!
			var compositeActor:CompositeActor = controlledActor as CompositeActor;
			compositeActor.addSprite(_leftArmSprite, new FlxPoint(75, 88));
			compositeActor.addSprite(_bodySprite, new FlxPoint(0, 62));
			compositeActor.addSprite(_headSprite, new FlxPoint(16, 0));
			compositeActor.addSprite(_rightArmSprite, new FlxPoint(0, 60));
			compositeActor.width = _headSprite.width;
			compositeActor.height = 222;
			
			_laser = new CompositeActor(new LaserController(controlledActor), _layer);
			_laser.visible = false;
			_laser.active = false;
			_laserCharge = Constants.LASER_MAX_CHARGE;
			_isLaserRecharging = false;
			_laserRechargeTimer = 0;
			
			_leftHand = new Actor(new LeftHandController(), _layer);
			_leftHand.exists = false;
			_fistTimer = 0;
		}
		
		override public function preFirstUpdate():void
		{
			_layer.add(_laser);
			_layer.add(_leftHand);
			
			_smokeEmitterL = new SmokeEmitter();
			_smokeEmitterL.init();
			_smokeEmitterL.setSize(1, 1);
			_smokeEmitterL.setXSpeed(0, 0);
			_smokeEmitterL.setYSpeed(-40, -60);
			
			_layer.add(_smokeEmitterL);
			
			_smokeEmitterR = new SmokeEmitter();
			_smokeEmitterR.init();
			_smokeEmitterR.setSize(1, 1);
			_smokeEmitterR.setXSpeed(0, 0);
			_smokeEmitterR.setYSpeed(-40, -60);
			
			_layer.add(_smokeEmitterR);
		}
		
		private var _timerRandomQuote:Number = 8;
		private const TIME_RANDOM_QUOTE:Number = 10; // seconds
		
		public override function update():void
		{
			if (controlledActor.dead)
			{
				if (controlledActor.y < FlxG.height * 0.75)
					generateDeadExplosions();
				else
					FlxG.quake.stop();
				
				return;
			}
			
			// should be used to make the character go up and down in each step
			var yVelocity:Number = 0;
			
			_laser.x = controlledActor.x + controlledActor.width + 7;
			_laser.y = controlledActor.y + 37;
				
			updateSmokeEmitters();
			
			// some animations block the movement
			if (_blockedByBuilding || _currentAction != ACTION_WALKING)
				stopMoving();
			else
			{
				// Move forward! Viva Perón!
				setVelocity(Constants.PERON_SPEED_X, yVelocity);
				
				// Earthquake effect!
				_quakeTimer += FlxG.elapsed;
				if (_quakeTimer > QUAKE_TIME) // this should depend on Peron's footsteps
				{
					_quakeTimer -= QUAKE_TIME;
					if (!FlxG.quake.running)
						FlxG.quake.start(0.01, 0.2);
					FlxG.play(Assets.SfxFootstep, Configuration.soundVolume);
				}
				
				// Random quote!
				_timerRandomQuote += FlxG.elapsed;
				if (_timerRandomQuote > TIME_RANDOM_QUOTE)
				{
					if (talk(SfxPeronFrases[uint(FlxU.random() * SfxPeronFrases.length)]))
						_timerRandomQuote -= TIME_RANDOM_QUOTE;
				}
			}
			
			if (!_beforeLevelStart)
				updateAttacks();
		}
		
		private function updateAttacks():void
		{
			var canUseLaser:Boolean = (_currentAction != ACTION_ATTACKING_LEFT_ARM) && (_currentAction != ACTION_ATTACKING_RIGHT_ARM);
			
			if (canUseLaser && FlxG.mouse.pressed())
			{
				startLaser();
				
				_isLaserRecharging = false;
				_laserRechargeTimer = 0;
				_laserCharge -= Constants.LASER_CHARGE_STEP;
				
				if (_laserCharge <= 0)
				{
					_laserCharge = 0;
					stopLaser();
					FlxG.mouse.reset();
					_laserRechargeTimer = Constants.LASER_RECHARGE_DELAY;
					
					FlxG.play(Assets.SfxDepletedLaser, Configuration.soundVolume);
					
					_smokeEmitterL.start(false);
					_smokeEmitterR.start(false);
				}
			}
			else if (_laserRechargeTimer > 0)
			{
				_laserRechargeTimer -= FlxG.elapsed;
				
				if (_laserRechargeTimer <= 0)
				{
					_laserRechargeTimer = 0;
					_isLaserRecharging = true;
					_smokeEmitterL.stop(0);
					_smokeEmitterR.stop(0);
				}
			}
			else if (_isLaserRecharging)
			{
				_laserCharge += Constants.LASER_RECHARGE_STEP;
				
				if (_laserCharge >= Constants.LASER_MAX_CHARGE)
				{
					_laserCharge = Constants.LASER_MAX_CHARGE;
					_isLaserRecharging = false;
				}
			}
			else if (_currentAction == ACTION_SHOOTING_LASER && FlxG.mouse.justReleased())
			{
				stopLaser();
				_isLaserRecharging = true;
			}
			
			// LEFT ARM
			if (_fistTimer > 0)
			{
				_fistTimer -= FlxG.elapsed;
				if (_fistTimer < 0)
					_fistTimer = 0;
			}
			else if (canAttack() && FlxG.keys.justReleased("X"))
			{
				attackLeftArm();
			}
			
			// RIGHT ARM
			if (canAttack() && FlxG.keys.justReleased("Z"))
			{
				attackRightArm();
			}
		}
		
		private function canAttack():Boolean
		{
			return _currentAction == ACTION_BEING_DAMAGED || _currentAction == ACTION_WALKING;
		}
		
		private function startLaser():void
		{
			laser();
			
			_currentAction = ACTION_SHOOTING_LASER;
			
			if (!_laserSfx || !_laserSfx.playing)
				_laserSfx = FlxG.play(Assets.SfxLaser, Configuration.soundVolume);
			if (!_laserShoutSfx || !_laserShoutSfx.playing)
				_laserShoutSfx = talk(Assets.SfxPeronLaserShout);
			
			var angle:Number = Math.atan2(FlxG.mouse.y - (_laser.y + _laser.height), FlxG.mouse.x - _laser.x);
			angle *= 180 / Math.PI;
			
			if (angle > 40) angle = 40;
			else if (angle < -20) angle = -20;
			
			if (!_laser.visible)
			{
				_laser.play("laserOn", true);
				FlxG.flash.start(0x66ffffff, 0.5);
			}
			
			_laser.visible = true;
			_laser.active = true;
			(_laser.controller as LaserController).angle = angle;
		}
		
		private function stopLaser():void
		{
			laserOff();
			
			_laser.play("laserOff", true);

			if (_laserSfx)
				_laserSfx.stop();
		}
		
		override public function onHurt(Damage:Number):Boolean
		{
			if ((controlledActor.health -= Damage) <= 0)
			{
				stopLaser();
				_smokeEmitterL.stop();
				_smokeEmitterR.stop();
				
				FlxG.quake.start(0.01, 100);
				
				setVelocity(0, 6);
				controlledActor.dead = true;
				controlledActor.play("damage");
				return false;
			}
			
			talk(SfxPeronHits[uint(FlxU.random() * SfxPeronHits.length)], true);
			
			if (_currentAction == ACTION_WALKING)
			{
				damage();
				_currentAction = ACTION_BEING_DAMAGED;
			}
			
			return false;
		}
		
		override public function onKill():Boolean
		{
			return true;
		}
		
		private function setVelocity(x:Number, y:Number):void
		{
			/* Only play "walk" animation if velocity used to be zero,
			 * otherwise, it would reset itself on each frame */
			
			if (controlledActor.velocity.x == 0) {
				//trace("Started Playing Walk Animation");
				controlledActor.play("walk");
			}
			
			controlledActor.velocity.x = x;
			controlledActor.velocity.y = y;
		}
		
		private function stopMoving():void 
		{
			controlledActor.velocity.x = 0;
			controlledActor.velocity.y = 0;
		}
		
		private function attackLeftArm():void
		{
			//trace("Started Playing attack Animation");
			_currentAction = ACTION_ATTACKING_LEFT_ARM;
			controlledActor.play("attackLeftArm");
			talk(Assets.SfxPeronRocketPunch, true);
		}
		
		private function attackRightArm():void
		{
			//trace("Started Playing attack Animation");
			_currentAction = ACTION_ATTACKING_RIGHT_ARM;
			controlledActor.play("attackRightArm");
			talk(Assets.SfxPeronHammerFist);
		}
		
		private function laser():void
		{
			//trace("Started Playing laser Animation");
			controlledActor.play("laser");
		}
		
		private function laserOff():void
		{
			//trace("Started Playing laserOff Animation");
			controlledActor.play("laserOff");
		}
		
		private function damage():void
		{
			//trace("Started Playing damage Animation");
			controlledActor.play("damage");
		}
		
		private function headAnimationCallback(name:String, frameNumber:uint, frameIndex:uint):void
		{
			if (_headSprite.finished)
			{
				switch (name) // you can switch with strings in AS 3.0, so why wouldn't I do that?!
				{
					case "laserOff":
					case "damage":
					{
						_currentAction = ACTION_WALKING;
						break;
					}
				}
			}
		}
		
		private function leftArmAnimationCallback(name:String, frameNumber:uint, frameIndex:uint):void
		{
			switch (name)
			{
				case "attackLeftArm":
				{
					if (frameNumber == 4)
						shootLeftHand();
					else if (_leftArmSprite.finished)
						_currentAction = ACTION_WALKING;
					break;
				}
			}
		}
		
		private function rightArmAnimationCallback(name:String, frameNumber:uint, frameIndex:uint):void
		{
			switch (name)
			{
				case "attackRightArm":
				{
					if (_rightArmSprite.finished)
					{
						_currentAction = ACTION_WALKING;
						_foregroundLayer.remove(_rightArmSprite);
						_layer.add(_rightArmSprite);
						_usingRightArm = false;
					}
					else if (frameNumber == 7)
					{						
						_layer.remove(_rightArmSprite);
						_foregroundLayer.add(_rightArmSprite);
						_usingRightArm = true;
					}
					break;
				}
			}
		}
		
		public function checkLaserHit(poorBastard:FlxObject):Boolean
		{
			return (_laser.controller as LaserController).checkLaserHit(poorBastard);
		}
		
		public function updateHUD(hud:HUD):void
		{
			hud.setLifeBarW(controlledActor.health / 100);
			if(controlledActor.health < 100 / 3)
				hud.flickerLifeBar(0.1);
			
			hud.setLaserBarW(_laserCharge / Constants.LASER_MAX_CHARGE);
			if (_isLaserRecharging > 0)
				hud.flickerLaserBar(0.1);
			
			hud.setFistW(1 - (_fistTimer / Constants.FIST_RELOAD_TIME));
		}
		
		private function shootLeftHand():void
		{
			_fistTimer = Constants.FIST_RELOAD_TIME;
			
			_leftHand.reset(_leftArmSprite.x + 56, _leftArmSprite.y);
			_leftHand.velocity = new FlxPoint(Constants.FIST_SPEED_X, 0);
			_leftHand.acceleration = new FlxPoint(0, Constants.GRAVITY * 0.25);
			_leftHand.play("launch");
		}
		
		private function updateSmokeEmitters():void
		{
			_smokeEmitterL.x = controlledActor.x + 50;
			_smokeEmitterL.y = controlledActor.y + 40;
			_smokeEmitterR.x = controlledActor.x + 80;
			_smokeEmitterR.y = controlledActor.y + 40;
		}
		
		private const EXPLOSIONS_DELAY:Number = 0.8;
		private var _explosionsTimer:Number = EXPLOSIONS_DELAY;
		
		private function generateDeadExplosions():void
		{
			if ((_explosionsTimer -= FlxG.elapsed) <= 0)
			{
				_explosionsTimer = EXPLOSIONS_DELAY;
				
				var randomY:Number = controlledActor.y + (FlxU.random() * (controlledActor.height / 2));
				var randomX:Number = controlledActor.x + (FlxU.random() * controlledActor.width);
				
				var explosion:Actor = new Actor(new ExplosionController(), _layer, randomX, randomY);
				_layer.add(explosion);
				
				FlxG.play(Assets.SfxExplosion, Configuration.soundVolume);
			}
		}
		
		private const TALK_TIME:uint = 6;
		private var _lastTalkTime:uint = 0;
		
		private function talk(asset:Class, force:Boolean = false):FlxSound
		{
			var now:uint = getTimer();
			
			if (force || now - _lastTalkTime > TALK_TIME * 1000)
			{
				_lastTalkTime = now;
				return FlxG.play(asset, Configuration.soundVolume);
			}
			
			return null;
		}
	}
}