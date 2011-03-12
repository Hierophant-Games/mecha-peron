package actor 
{
	import collision.RotatedRectangle;
	import embed.Assets;
	import flash.geom.*;
	import game.*;
	import level.HUD;
	import org.flixel.*;
	
	/**
	 * PlayerController.
	 * Controls an Actor with a player behavior. Handles input and update accordingly.
	 * @author Santiago Vilar
	 */
	public class PlayerController extends ActorController
	{
		private var _layer:FlxGroup;
		
		private var _laserSprite:FlxSprite;
		private var _laserColissionBox:RotatedRectangle;
		
		private var _laserCharge:Number;
		private var _isLaserRecharging:Boolean;
		private var _laserRechargeTimer:Number;
		
		private var _laserSfx:FlxSound;
		
		private var _beforeLevelStart:Boolean = false;
		private var _shootingLaser:Boolean = false;
		private var _blockedByBuilding:Boolean = false;
		private var _beingDamaged:Boolean = false;
		private var _attackingLeftArm:Boolean = false;
		
		private var _headSprite:FlxSprite;
		private var _bodySprite:FlxSprite;
		private var _leftArmSprite:FlxSprite;
		
		private var _leftHand:Actor;
		
		private var _quakeTimer:Number = 0;
		private const QUAKE_TIME:Number = 1.5;
		
		public function set beforeLevelStart(beforeLevelStart:Boolean):void
		{
			_beforeLevelStart = beforeLevelStart;
		}
		
		public function get isLaserActive():Boolean
		{
			return _laserSprite.active;
		}
		
		public function get laserAngle():Number
		{
			return _laserSprite.angle;
		}
		
		public function get laserRect():Rectangle
		{
			return new Rectangle(_laserSprite.x, _laserSprite.y, _laserSprite.width, _laserSprite.height);
		}
		
		public function set laserClip(clip:Rectangle):void
		{
			_laserSprite.clip = clip;
		}
		
		public function PlayerController(layer:FlxGroup)
		{
			_layer = layer;
		}
		
		public override function init():void
		{
			controlledActor.fixed = true;
			
			// load the head!
			_headSprite = new FlxSprite();
			_headSprite.loadGraphic(Assets.SpriteHead, true, false, 68, 100);
			_headSprite.addAnimation("idle", new Array(0, 0), 1, false);
			_headSprite.addAnimation("walk", new Array(0, 1, 2, 1), 5, true);
			_headSprite.addAnimation("attackLeftArm", new Array(1, 2, 3, 2, 1, 2), 4, false);
			_headSprite.addAnimation("damage", new Array(1, 2, 3, 4, 3, 2, 1, 2, 3, 2, 1, 2, 3, 2, 1, 0), 16, false);
			_headSprite.addAnimation("laser", new Array(1, 3, 4), 9, false);
			_headSprite.addAnimation("laserOff", new Array(4, 3, 1), 9, false);
			_headSprite.addAnimationCallback(headAnimationCallback);
			
			// load the body sprite... no animations
			_bodySprite = new FlxSprite(0, 0, Assets.SpriteBody);
			
			// load the left arm sprite...
			_leftArmSprite = new FlxSprite();
			_leftArmSprite.loadGraphic(Assets.SpriteLeftArm, true, false, 88, 69);
			_leftArmSprite.addAnimation("idle", new Array(1, 1), 1, false);
			_leftArmSprite.addAnimation("walk", new Array(0, 1, 2, 1), 5, true);
			_leftArmSprite.addAnimation("attackLeftArm", new Array(4, 5, 5), 2, false);
			_leftArmSprite.addAnimation("damage", new Array(3, 3), 1, false);
			_leftArmSprite.addAnimation("laser", new Array(0, 0), 1, false);
			_leftArmSprite.addAnimation("laserOff", new Array(1, 1), 1, false);
			_leftArmSprite.addAnimationCallback(leftArmAnimationCallback);
			
			// add sprites to the composite actor!
			var compositeActor:CompositeActor = controlledActor as CompositeActor;
			compositeActor.addSprite(_leftArmSprite, new FlxPoint(75, 88));
			compositeActor.addSprite(_bodySprite, new FlxPoint(0, 62));
			compositeActor.addSprite(_headSprite, new FlxPoint(16, 0));
			compositeActor.width = _headSprite.width;
			compositeActor.height = 222;
			
			_laserSprite = new FlxSprite();
			_laserSprite.loadGraphic(Assets.SpriteLaser, true, false, 320, 8);
			_laserSprite.origin = new FlxPoint(0, _laserSprite.height);
			_laserSprite.visible = false;
			_laserSprite.active = false;
			
			_laserSprite.addAnimation("default", new Array(0, 1, 2, 3, 4), 30, false);
			
			_laserColissionBox = new RotatedRectangle(
									new Rectangle(_laserSprite.x, _laserSprite.y, _laserSprite.width, _laserSprite.height), 
									_laserSprite.angle, 
									new Point(_laserSprite.origin.x, _laserSprite.origin.y));
			
			_laserCharge = Constants.LASER_MAX_CHARGE;
			_isLaserRecharging = false;
			_laserRechargeTimer = 0;
			
			_laserSfx = new FlxSound();
			_laserSfx.loadEmbedded(Assets.SfxLaser);
			_laserSfx.volume = Configuration.soundVolume;
			
			_leftHand = new Actor(new LeftHandController(), _layer);
			_leftHand.exists = false;
		}
		
		override public function preFirstUpdate():void
		{
			// Do this to add other objects right after this one in the layer group members array
			var index:int = _layer.members.indexOf(controlledActor);
			_layer.members.splice(index + 1, 0, _laserSprite);
			
			//_layer.add(_laserSprite);
			_layer.add(_leftHand);
		}
		
		public override function update():void
		{
			// should be used to make the character go up and down in each step
			var yVelocity:Number = 0;
			
			if (!_beforeLevelStart)
				updateAttacks();
			
			// some animations block the movement
			var blockMovement:Boolean = _blockedByBuilding || _shootingLaser || _beingDamaged || _attackingLeftArm;
			if (blockMovement)
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
					stopLaser();
					FlxG.mouse.reset();
				}
			}
			else if (_laserRechargeTimer > 0)
			{
				_laserRechargeTimer -= FlxG.elapsed;
				
				if (_laserRechargeTimer <= 0)
					_isLaserRecharging = true;
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
			}
			
			// LEFT ARM
			if (FlxG.keys.justReleased("Z"))
			{
				_attackingLeftArm = true;
				attackLeftArm();
			}
		}
		
		private function startLaser():void
		{
			laser();
			
			_beingDamaged = false;
			_shootingLaser = true;
			
			_laserSfx.play();
			
			_laserSprite.x = controlledActor.x + controlledActor.width;
			_laserSprite.y = controlledActor.y + 40;
			
			var angle:Number = Math.atan2(FlxG.mouse.y - (_laserSprite.y + _laserSprite.height), FlxG.mouse.x - _laserSprite.x);
			angle *= 180 / Math.PI;
			
			if (angle > 30) angle = 30;
			else if (angle < -10) angle = -10;
			
			if(FlxG.mouse.justPressed())
				_laserSprite.play("default");
			
			_laserSprite.visible = true;
			_laserSprite.active = true;
			_laserSprite.angle = angle;
		}
		
		private function stopLaser():void
		{
			laserOff();
			_laserSprite.visible = false;
			_laserSprite.active = false;
			_laserRechargeTimer = Constants.LASER_RECHARGE_DELAY;

			_laserSfx.stop();
			_laserSprite.frame = 0;
		}
		
		override public function onHurt(Damage:Number):Boolean
		{
			var attacking:Boolean = _shootingLaser || _attackingLeftArm;
			if (!attacking)
			{
				damage();
				_beingDamaged = true;
			}
			
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
		/*
		 * At the moment going back to idle animation when no input 
		 * is made is disabled, as it is required to check wether or
		 * not the previous animation has finished before doing so.
		 */
			//trace("Started Playing Idle Animation");
			// controlledActor.play("idle");
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
					{
						_shootingLaser = false;
						break;
					}
					case "damage":
					{
						_beingDamaged = false;
						break;
					}
					case "attackLeftArm":
					{
						_attackingLeftArm = false;
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
					if (frameNumber == 1)
					{
						shootLeftHand();
					}
					break;
				}
			}
		}
		
		public function checkLaserHit(poorBastard:FlxObject):Boolean
		{
			_laserColissionBox.rect = new Rectangle(_laserSprite.x, _laserSprite.y, _laserSprite.width, _laserSprite.height);
			_laserColissionBox.angle = _laserSprite.angle;
			_laserColissionBox.origin = new Point(_laserSprite.origin.x, _laserSprite.origin.y);
			return _laserColissionBox.collides2(poorBastard);
		}
		
		override public function onCollide(collideType:uint, contact:FlxObject):void
		{
			var other:Actor = contact as Actor;
			if (other && other.controller is BuildingController)
			{
				_blockedByBuilding = !other.dead;
			}
		}
		
		public function updateHUD(hud:HUD):void
		{
			hud.setLifeBarW(controlledActor.health / 100);
			if(controlledActor.health < 100 / 3)
				hud.flickerLifeBar(0.1);
			
			hud.setLaserBarW(_laserCharge / Constants.LASER_MAX_CHARGE);
			if (_isLaserRecharging > 0)
				hud.flickerLaserBar(0.1);
		}
		
		private function shootLeftHand():void
		{
			_leftHand.exists = true;
			_leftHand.x = _leftArmSprite.x + 56;
			_leftHand.y = _leftArmSprite.y + 34;
			_leftHand.velocity = new FlxPoint(Constants.FIST_SPEED_X, 0);
			_leftHand.acceleration = new FlxPoint(0, Constants.GRAVITY / 4);
			_leftHand.play("launch");
		}
	}
}