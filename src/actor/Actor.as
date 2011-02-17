package actor 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class Actor extends FlxSprite
	{
		private var _actorController:ActorController;
		
		public function Actor(actorController:ActorController) 
		{
			_actorController = actorController;
			_actorController.controlledActor = this;
			_actorController.init();
		}
		
		public override function update():void
		{
			_actorController.update();
			super.update();
		}
	}
}