package actor 
{
	import org.flixel.FlxObject;
	/**
	 * IActorController is the base interface for every
	 * controller attacheable to the actor
	 * @author Santiago Vilar
	 */
	public class ActorController 
	{
		private var _controlledActor:Actor;
		
		public function get controlledActor():Actor
		{
			return _controlledActor;
		}
		
		public function set controlledActor(actor:Actor):void
		{
			_controlledActor = actor;
		}
		
		public function init():void
		{
			trace("implement my init!!", this);
		}
		
		public function update():void
		{
			trace("implement my update!! ", this);
		}
		
		public function hurt(Damage:Number):void
		{
			trace("implement me!!!");
		}
		
		public function onKill():void
		{
			// should be overrided if some custom behavior is wanted here
		}
		
		public function onCollide(collideType:uint, contact:FlxObject):void
		{
			// collision handling
		}
	}
}