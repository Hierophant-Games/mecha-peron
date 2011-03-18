package actor 
{
	import collision.RotatedRectangle;
	import embed.Assets;
	import flash.display.Sprite;
	import flash.geom.*;
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
		private var _layer:FlxGroup;
		
		private var _laser:CompositeActor;
		private var _laserCharge:Number;
		private var _isLaserRecharging:Boolean;
		private var _laserRechargeTimer:Number = 0;
		
		private var _laserSfx:FlxSound;
		
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
		
		public function PlayerController(layer:FlxGroup)
		{
			_layer = layer;
		}
		
		public override function init():void
		{
			controlledActor.fixed = true;
			
			// load the head!
			_headSprite = new SpriteLoader().load(Assets.XMLSpriteHead, Assets.SpriteHead);
			_headSprite.addAnimationCallback(headAnimationCallback);
			
			// load the body sprite... no animations
			_bodySprite = new FlxSprite(0, 0, Assets.SpriteBody);
			
			// load the left arm sprite...
			_leftArmSprite = new SpriteLoader().load(Assets.XMLSpriteLeftArm, Assets.SpriteLeftArm);
			_leftArmSprite.addAnimationCallback(leftArmAnimationCallback);
			
			// load the right arm sprite...
			_rightArmSprite = new SpriteLoader().load(Assets.XMLSpriteRightArm, Assets.SpriteRightArm);
			
			// add sprites to the composite actor!
			var compositeActor:CompositeActor = controlledActor as CompositeActor;
			compositeActor.addSprite(_leftArmSprite, new FlxPoint(75, 88));
			compositeActor.addSprite(_bodySprite, new FlxPoint(0, 62));
			compositeActor.addSprite(_headSprite, new FlxPoint(16, 0));
			compositeActor.addSprite(_rightArmSprite, new FlxPoint(11, 54));
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
			_smokeEmitterL.setYSpeed(-30, -50);
			
			_layer.add(_smokeEmitterL);
			
			_smokeEmitterR = new SmokeEmitter();
			_smokeEmitterR.init();
			_smokeEmitterR.setSize(1, 1);
			_smokeEmitterR.setXSpeed(0, 0);
			_smokeEmitterR.setYSpeed(-30, -50);
			
			_layer.add(_smokeEmitterR);
		}
		
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
			
			if (!_beforeLevelStart)
				updateAttacks();
				
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
			}
		}
		
		private function updateAttacks():void
		{
			// LASER
			if (FlxG.mouse.pressed())
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
				_laserCharge += Constants.LASER_CHARGE_STEP;
				
				if (_laserCharge >= Constants.LASER_MAX_CHARGE)
				{
					_laserCharge = Constants.LASER_MAX_CHARGE;
					_isLaserRecharging = false;
				}
			}
			else if(FlxG.mouse.justReleased())
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
			else if (FlxG.keys.justReleased("Z"))
			{
				_currentAction = ACTION_ATTACKING_LEFT_ARM;
				attackLeftArm();
			}
		}
		
		private function startLaser():void
		{
			laser();
			
			_currentAction = ACTION_SHOOTING_LASER;
			
			if (!_laserSfx || !_laserSfx.playing)
				_laserSfx = FlxG.play(Assets.SfxLaser, Configuration.soundVolume);
			
			_laser.x = controlledActor.x + controlledActor.width + 7;
			_laser.y = controlledActor.y + 37;
			
			var angle:Number = Math.atan2(FlxG.mouse.y - (_laser.y + _laser.height), FlxG.mouse.x - _laser.x);
			angle *= 180 / Math.PI;
			
			if (angle > 30) angle = 30;
			else if (angle < -10) angle = -10;
			
			if(FlxG.mouse.justPressed())
				_laser.play("default", true);
			
			_laser.visible = true;
			_laser.active = true;
			(_laser.controller as LaserController).angle = angle;
		}
		
		private function stopLaser():void
		{
			laserOff();
			_laser.visible = false;
			_laser.active = false;

			if (_laserSfx)
				_laserSfx.stop();
		}
		
		override public function onHurt(Damage:Number):Boolean
		{
			if ((controlledActor.health -= Damage) <= 0)
			{
				stopLaser();
				FlxG.quake.start(0.01, 100);
				setVelocity(0, 6);
				controlledActor.dead = true;
				controlledActor.play("damage");
				return false;
			}
			
			if (_currentAction == ACTION_WALKING)
			{
				damage();
				_currentAction = ACTION_BEING_DAMAGED;
			}
			
			return false;
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
			controlledActor.play("attackLeftArm");
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
					case "attackLeftArm":
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
					{
						shootLeftHand();
					}
					break;
				}
			}
		}
		
		public function checkLaserHit(poorBastard:FlxObject):Boolean
		{
			return (_laser.controller as LaserController).checkLaserHit(poorBastard);
		}
		
		override public function onCollide(collideType:uint, contact:FlxObject):void
		{/*not here anymore, check MainLevel update
			var other:Actor = contact as Actor;
			if (other && other.controller is BuildingController)
			{
				_blockedByBuilding = !other.dead;
			}*/
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
		
		override public function onKill():Boolean
		{
			return true;
		}
	}
}