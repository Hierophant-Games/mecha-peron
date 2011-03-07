package actor 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class CompositeActor extends Actor 
	{
		private var _sprites:Vector.<FlxSprite> = new Vector.<FlxSprite>();
		private var _offsets:Vector.<FlxPoint> = new Vector.<FlxPoint>();
		
		public function CompositeActor(actorController:ActorController, X:Number = 0, Y:Number = 0) 
		{
			super(actorController, X, Y);
		}
		
		public function addSprite(sprite:FlxSprite, offset:FlxPoint):void
		{
			_sprites.push(sprite);
			_offsets.push(offset);
			
			// update width and height accordingly (?)
			/*
			 * disabled to avoid having the arms collide with enemy bullets, as the body is the only area that takes damage. (properly set on PlayerController.as)
			 */
			/*if (sprite.frameWidth + offset.x > width)
				width = sprite.frameWidth + offset.x;
			if (sprite.frameHeight + offset.y > height)
				height = sprite.frameHeight + offset.y;*/
		}
		
		override public function update():void
		{
			// update the actor
			super.update();
			// update each sprite
			for (var i:int = 0; i < _sprites.length; i++) 
			{
				var sprite:FlxSprite = _sprites[i];
				sprite.x = this.x + _offsets[i].x;
				sprite.y = this.y + _offsets[i].y;
				sprite.update();
			}
		}
		
		override public function render():void
		{
			// render each sprite
			for each (var sprite:FlxSprite in _sprites) 
			{
				sprite.render();
			}
		}
		
		override public function play(AnimName:String,Force:Boolean=false):void
		{
			// try to play the animation in each sprite
			for each (var sprite:FlxSprite in _sprites)
			{
				sprite.play(AnimName, Force);
			}
		}
		
		/* apparently it doesn't get called
		override public function collide(object:FlxObject = null):Boolean
		{
			for each (var sprite:FlxSprite in _sprites)
			{
				if (FlxU.collide(sprite, ((object == null)?sprite:object)))
					return true;
			}
			return false;
		}*/
	}
}