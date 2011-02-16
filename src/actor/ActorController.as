package actor 
{
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
			trace("implement me!!!");
		}
		
		public function update():void
		{
			trace("implement me!!!");
		}
	}
}