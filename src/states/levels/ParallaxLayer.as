package states.levels 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class ParallaxLayer extends FlxGroup
	{
		public function ParallaxLayer(Graphic:Class, scrollFactor:Number) 
		{
			this.scrollFactor = new FlxPoint(scrollFactor, 0);
			add(new FlxSprite(0, 0, Graphic), true);
			add(new FlxSprite(FlxG.width, 0, Graphic), true);
		}
		
		public override function update():void
		{
			var pos:Number = FlxG.scroll.x * scrollFactor.x;
			for each (var member:FlxObject in members)
			{
				if (member.x + pos < -FlxG.width)
				{
					member.x += FlxG.width * 2;
				}
			}
			super.update();
		}
	}

}