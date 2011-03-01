package actor 
{
	import collision.RotatedRectangle;
	import embed.Assets;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
		
		private var _blockedByBuilding:Boolean = false;
		
		public function PlayerController(layer:FlxGroup)
		{
			_layer = layer;
		}
		
		public override function init():void
		{
			controlledActor.fixed = true;
			
			controlledActor.loadGraphic(Assets.SpritePeron, true, false, 99, 222);
			
			controlledActor.addAnimation("idle", new Array(0), 1, false);
			controlledActor.addAnimation("walk", new Array(0, 1, 2, 1), 5, true);
			controlledActor.addAnimation("attack", new Array(0), 1, false);
			controlledActor.addAnimation("damage", new Array(1, 2, 3, 4, 3, 2, 1, 2, 3, 2, 1, 2, 3, 2, 1, 0), 16, false);
			controlledActor.addAnimation("laser", new Array(1, 3, 4), 9, false);
			controlledActor.addAnimation("laserOff", new Array(4, 3, 1), 9, false);
			//controlledActor.addAnimationCallback(animationCallback);
			
			controlledActor.play("idle");
			
			_laserSprite = new FlxSprite();
			_laserSprite.loadGraphic(Assets.SpriteLaser, false, false, 320, 10);
			_laserSprite.origin = new FlxPoint(0, _laserSprite.height);
			_laserSprite.visible = false;
			_laserSprite.active = false;
			
			_laserColissionBox = new RotatedRectangle(
									new Rectangle(_laserSprite.x, _laserSprite.y, _laserSprite.width, _laserSprite.height), 
									_laserSprite.angle, 
									new Point(_laserSprite.origin.x, _laserSprite.origin.y));
									
			_layer.add(_laserSprite);

			FlxG.mouse.load(Assets.SpriteChrosshair, 15, 15);
			FlxG.mouse.show();
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
			
			// Go forward! Viva Perón!
			if (!_blockedByBuilding)
				setVelocity(30, yVelocity);
			else
				stopMoving();
			
			if (FlxG.mouse.pressed())
			{
				laser();
				
				_laserSprite.x = controlledActor.x + controlledActor.width / 2;
				_laserSprite.y = controlledActor.y + 40;
		
				var angle:Number = Math.atan2(FlxG.mouse.y - (_laserSprite.y + _laserSprite.height), FlxG.mouse.x - _laserSprite.x);
				angle *= 180 / Math.PI;
				
				if (angle > 50) angle = 50;
				else if (angle < -30) angle = -30;
				
				_laserSprite.visible = true;
				_laserSprite.active = true;
				_laserSprite.angle = angle;
			}
			else if(FlxG.mouse.justReleased())
			{
				laserOff();
				_laserSprite.visible = false;
				_laserSprite.active = false;
			}
		}
		
		override public function hurt(Damage:Number):void
		{
			damage();
		}
		
		private function setVelocity(x:Number, y:Number):void
		{
			/* Only play "walk" animation if velocity used to be zero,
			 * otherwise, it would reset itself on each frame */
			
			if (controlledActor.velocity.x == 0) {
				FlxG.log("Started Playing Walk Animation");
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
			// FlxG.log("Started Playing Idle Animation");
			// controlledActor.play("idle");
			controlledActor.velocity.x = 0;
			controlledActor.velocity.y = 0;
		}
		
		private function attack():void
		{
			 FlxG.log("Started Playing attack Animation");
			controlledActor.play("attack");
		}
		
		private function laser():void
		{
			FlxG.log("Started Playing laser Animation");
			controlledActor.play("laser");
		}
		
		private function laserOff():void
		{
			FlxG.log("Started Playing laserOff Animation");
			controlledActor.play("laserOff");
		}
		
		private function damage():void
		{
			FlxG.log("Started Playing damage Animation");
			controlledActor.play("damage");
		}
		
		/*private function animationCallback(name:String, frameNumber:uint, frameIndex:uint):void
		{
			controlledActor.play("idle");
		}*/
		
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
	}
}