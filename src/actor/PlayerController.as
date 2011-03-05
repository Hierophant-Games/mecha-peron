package actor 
{
	import collision.RotatedRectangle;
	import embed.Assets;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import level.HUD;
	import game.Constants;
	import org.flixel.*;
	
	/**
	 * PlayerController.
	 * Controls an Actor with a player behavior. Handles input and update accordingly.
	 * @author Santiago Vilar
	 */
	public class PlayerController extends ActorController
	{
		private const MAX_HEALTH:Number = 100;
		
		private var _layer:FlxGroup;
		
		private var _laserSprite:FlxSprite;
		private var _laserColissionBox:RotatedRectangle;
		
		private var _laserCharge:Number;
		private var _isLaserRecharging:Boolean;
		private var _laserRechargeTimer:Number;
		private const LASER_MAX_CHARGE:Number = 5000;
		private const LASER_CHARGE_STEP:Number = 10;
		private const LASER_RECHARGE_DELAY:Number = 1.5; // seconds
		
		private var _laserSfx:FlxSound;
		
		private var _shootingLaser:Boolean = false;
		private var _blockedByBuilding:Boolean = false;
		private var _beingDamaged:Boolean = false;
		
		private var _headSprite:FlxSprite;
		private var _bodySprite:FlxSprite;
		private var _leftArmSprite:FlxSprite;
		
		public function PlayerController(layer:FlxGroup)
		{
			_layer = layer;
		}
		
		public override function init():void
		{
			controlledActor.health = MAX_HEALTH;
			
			controlledActor.fixed = true;
			
			// load the head!
			_headSprite = new FlxSprite();
			_headSprite.loadGraphic(Assets.SpriteHead, true, false, 68, 100);
			_headSprite.addAnimation("idle", new Array(0), 1, false);
			_headSprite.addAnimation("walk", new Array(0, 1, 2, 1), 5, true);
			_headSprite.addAnimation("attack", new Array(0), 1, false);
			_headSprite.addAnimation("damage", new Array(1, 2, 3, 4, 3, 2, 1, 2, 3, 2, 1, 2, 3, 2, 1, 0), 16, false);
			_headSprite.addAnimation("laser", new Array(1, 3, 4), 9, false);
			_headSprite.addAnimation("laserOff", new Array(4, 3, 1), 9, false);
			_headSprite.addAnimationCallback(headAnimationCallback);
			
			// load the body sprite... no animations
			_bodySprite = new FlxSprite(0, 0, Assets.SpriteBody);
			
			// load the left arm sprite...
			_leftArmSprite = new FlxSprite();
			_leftArmSprite.loadGraphic(Assets.SpriteLeftArm, true, false, 88, 69);
			_leftArmSprite.addAnimation("idle", new Array(0), 1, false);
			_leftArmSprite.addAnimation("walk", new Array(0, 1, 2, 1), 5, true);
			_leftArmSprite.addAnimation("attack", new Array(0), 1, false);
			_leftArmSprite.addAnimation("damage", new Array(0), 1, false);
			_leftArmSprite.addAnimation("laser", new Array(0), 1, false);
			_leftArmSprite.addAnimation("laserOff", new Array(0), 1, false);
			
			// add sprites to the composite actor!
			var compositeActor:CompositeActor = controlledActor as CompositeActor;
			compositeActor.addSprite(_leftArmSprite, new FlxPoint(79, 88));
			compositeActor.addSprite(_bodySprite, new FlxPoint(0, 62));
			compositeActor.addSprite(_headSprite, new FlxPoint(16, 0));
			
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
			
			_laserCharge = LASER_MAX_CHARGE;
			_isLaserRecharging = false;
			_laserRechargeTimer = 0;
			
			_laserSfx = new FlxSound();
			_laserSfx.loadEmbedded(Assets.SfxLaser);
			_laserSfx.volume = 0.7;
		}
		
		override public function preFirstUpdate():void
		{
			// Do this to add other objects right after this one in the layer group members array
			var index:int = _layer.members.indexOf(controlledActor);
			_layer.members.splice(index, 0, _laserSprite);
			
			//_layer.add(_laserSprite);
		}
		
		public override function update():void
		{
			// should be used to make the character go up and down in each step
			var yVelocity:Number = 0;
			
			/*
			if (FlxG.keys.justPressed("SPACE"))
			{
				stopMoving(); // stop moving while attacking
				attack();
			}
			else if (FlxG.keys.justPressed("A")) // for debugging purposes
			{
				stopMoving(); // stop moving while attacking
				laser();
			} else if (FlxG.keys.justPressed("S")) // for debugging purposes
			{
				stopMoving(); // stop moving while being damaged
				damage();
			}
			else stopMoving(); 
			*/
			
			if (FlxG.mouse.pressed())
			{
				_beingDamaged = false;
				_shootingLaser = true;
				laser();
				
				_laserSfx.play();
				
				_laserSprite.x = controlledActor.x + controlledActor.width / 2;
				_laserSprite.y = controlledActor.y + 40;
				
				var angle:Number = Math.atan2(FlxG.mouse.y - (_laserSprite.y + _laserSprite.height), FlxG.mouse.x - _laserSprite.x);
				angle *= 180 / Math.PI;
				
				if (angle > 50) angle = 50;
				else if (angle < -30) angle = -30;
				
				if(FlxG.mouse.justPressed())
					_laserSprite.play("default");
				
				_laserSprite.visible = true;
				_laserSprite.active = true;
				_laserSprite.angle = angle;
				
				_isLaserRecharging = false;
				_laserRechargeTimer = 0;
				_laserCharge -= LASER_CHARGE_STEP;
				
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
				_laserCharge += LASER_CHARGE_STEP;
				
				if (_laserCharge >= LASER_MAX_CHARGE)
				{
					_laserCharge = LASER_MAX_CHARGE;
					_isLaserRecharging = false;
				}
			}
			else if(FlxG.mouse.justReleased())
			{
				stopLaser();
			}
			
			// some animations block the movement
			if (_blockedByBuilding || _shootingLaser || _beingDamaged)
				stopMoving();
			else // Move forward! Viva Perón!
				setVelocity(Constants.PERON_SPEED_X, yVelocity);
		}
		
		private function stopLaser():void
		{
			laserOff();
			_laserSprite.visible = false;
			_laserSprite.active = false;
			_laserRechargeTimer = LASER_RECHARGE_DELAY;

			_laserSfx.stop();
			_laserSprite.frame = 0;
		}
		
		override public function hurt(Damage:Number):void
		{
			if (!_shootingLaser)
			{
				damage();
				_beingDamaged = true;
			}
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
		
		private function attack():void
		{
			//trace("Started Playing attack Animation");
			controlledActor.play("attack");
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
		
		public function isLaserActive():Boolean
		{
			return _laserSprite.active;
		}
		
		public function getLaserAngle():Number
		{
			return _laserSprite.angle;
		}
		
		public function getLaserRect():Rectangle
		{
			return new Rectangle(_laserSprite.x, _laserSprite.y, _laserSprite.width, _laserSprite.height);
		}
		
		public function setLaserClip(clip:Rectangle):void
		{
			_laserSprite.clip = clip;
		}
		
		override public function onCollide(collideType:uint, contact:FlxObject):void
		{
			var other:Actor = contact as Actor;
			if (other && other.controller is BuildingController)
			{
				_blockedByBuilding = true;
			}
		}
		
		public function updateHUD(hud:HUD):void
		{
			hud.setLifeBarW(controlledActor.health / MAX_HEALTH);
			if(controlledActor.health < MAX_HEALTH / 3)
				hud.flickerLifeBar(0.1);
			
			hud.setLaserBarW(_laserCharge / LASER_MAX_CHARGE);
			if (_isLaserRecharging > 0)
				hud.flickerLaserBar(0.1);
		}
	}
}