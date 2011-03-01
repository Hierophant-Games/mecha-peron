package actor 
{
	import org.flixel.*;
	
	/**
	 * Actor class. Its behaviour is changed by the controller.
	 * @author Santiago Vilar
	 */
	public class Actor extends FlxSprite
	{
		private var _controller:ActorController;
		
		public static const COLLIDE_LEFT:uint = 0;
		public static const COLLIDE_RIGHT:uint = 1;
		public static const COLLIDE_TOP:uint = 2;
		public static const COLLIDE_BOTTOM:uint = 3;
		
		public function set controller(actorController:ActorController):void
		{
			_controller = actorController;
			_controller.controlledActor = this;
			_controller.init();
		}
		
		public function get controller():ActorController
		{
			return _controller;
		}
		
		public function Actor(actorController:ActorController, X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			controller = actorController;
			
			FlxG.log("Added actor (" + X + "," + Y + ") with controller: " + actorController);
		}
		
		private var _firstUpdate:Boolean = true;
		
		override public function update():void
		{
			if (_firstUpdate)
			{
				_controller.preFirstUpdate();
				_firstUpdate = false;
			}
			_controller.update();
			super.update();
		}
		
		override public function kill():void
		{
			_controller.onKill();
			super.kill();
		}
		
		public override function hurt(Damage:Number):void
		{
			_controller.hurt(Damage);
			super.hurt(Damage);
		}
		
		override public function hitLeft(Contact:FlxObject,Velocity:Number):void
		{
			_controller.onCollide(COLLIDE_LEFT, Contact);
			super.hitLeft(Contact, Velocity);
		}
		
		override public function hitRight(Contact:FlxObject,Velocity:Number):void
		{
			_controller.onCollide(COLLIDE_RIGHT, Contact);
			super.hitRight(Contact, Velocity);
		}
		
		override public function hitTop(Contact:FlxObject,Velocity:Number):void
		{
			_controller.onCollide(COLLIDE_TOP, Contact);
			super.hitTop(Contact, Velocity);
		}
		
		override public function hitBottom(Contact:FlxObject,Velocity:Number):void
		{
			_controller.onCollide(COLLIDE_BOTTOM, Contact);
			super.hitBottom(Contact, Velocity);
		}
	}
}