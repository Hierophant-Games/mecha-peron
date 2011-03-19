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
		
		/**
		 * Override to implement initialization
		 */
		public function init():void
		{
			trace("implement my init!!", this);
		}
		
		/**
		 * This method will be called before the first update,
		 * override it to add objects to the scene AFTER the controlledActor
		 * or to do stuff like that
		 */
		public function preFirstUpdate():void
		{
		}
		
		/**
		 * Override to implement custom behaviour
		 */
		public function update():void
		{
			trace("implement my update!! ", this);
		}
		
		/**
		 * Override to implement some custom behaviour when the actor was hurt
		 * @param	Damage		the amount of health that changed
		 */
		public function onHurt(Damage:Number):Boolean
		{
			trace("implement me!!!");
			return true;
		}
		
		/**
		 * Should be overrided if some custom behavior is wanted when the actor is killed,
		 * like removing dependencies or stuff like that
		 */
		public function onKill():Boolean
		{
			return true;
		}
		
		/**
		 * Override to handle some custom collision response
		 * @param	collideType		If the actor was hit from left, right, top or bottom
		 * @param	contact			The object that collided with our actor
		 */
		public function onCollide(collideType:uint, contact:FlxObject):void
		{
		}
	}
}