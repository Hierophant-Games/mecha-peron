package states.levels 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class ParallaxLayer extends FlxGroup
	{
		private var _layerWidth:uint;
		
		public function ParallaxLayer(Graphic:Class, scrollFactor:Number) 
		{
			this.scrollFactor = new FlxPoint(scrollFactor, 0);
			var sprite:FlxSprite = new FlxSprite(0, 0, Graphic);
			_layerWidth = sprite.width;
			add(sprite, true);
			add(new FlxSprite(_layerWidth, 0, Graphic), true);
		}
		
		public override function update():void
		{
			var pos:Number = FlxG.scroll.x * scrollFactor.x;
			for each (var member:FlxObject in members)
			{
				if (member.x + pos < -_layerWidth)
				{
					member.x += _layerWidth * 2;
				}
			}
			super.update();
		}
	}

}