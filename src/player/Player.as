package player 
{
	import org.flixel.*;
	/**
	 * Player class.
	 * Stores info about the current status of the player character.
	 * @author Santiago Vilar
	 */
	public class Player extends FlxSprite
	{
		[Embed(source = "../../data/sprites/peron.png")]
		private var PeronSprite:Class;
		
		public function Player(initialX:Number, initialY:Number)
		{
			loadGraphic(PeronSprite, true, false, 70, 94);
			
			addAnimation("idle", new Array(0, 1, 2, 3, 4, 5), 10, true);
			addAnimation("walk", new Array(0), 10, true);
			addAnimation("attack", new Array(0), 10, false);
			addAnimation("damage", new Array(0), 10, false);
			
			play("idle");
			
			x = initialX;
			y = initialY;
		}
		
		public function move(x:Number, y:Number):void
		{
			if (x != 0)
				play("walk");
			else
				play("idle");
			
			velocity.x = x;
			velocity.y = y;
		}
		
		public function attack():void
		{
			play("attack");
		}
		
		public override function update():void
		{
			if (_curAnim.name != "idle" && !_curAnim.looped && finished)
				play("idle");
			
			super.update();
		}
	}
}