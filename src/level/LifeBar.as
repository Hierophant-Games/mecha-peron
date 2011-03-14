package level 
{
	import org.flixel.*;
	import utils.ColorUtils;
	/**
	 * ...
	 * @author 
	 */
	public class LifeBar extends FlxSprite
	{
		private var _width:Number;
		private var _height:Number;
		
		private var _life:Number;
		
		public function LifeBar(width:Number, height:Number) 
		{
			_width = width;
			_height = height;
			
			solid = false;
			createGraphic(width, height);
		}
		
		public function updateLife(life:Number):void
		{
			if (life == _life) // life is the same
			{
				visible = false;
				return;
			}
			visible = true;
			_life = life;
			
			if (life <= 0)
			{
				fill(0);
				return;
			}
			var ratio:Number = life / 100;
			
			var first:Number = (1 - ratio) * 0xff;
			var second:Number = ratio * 0xff;
			
			var diff:Number = Math.abs(first - second);
			var influence:Number = (0xff - diff) / 2;
			first += influence;
			first = Number(first.toFixed());
			second += influence;
			second = Number(second.toFixed());
			
			var lifeColor:Number = ColorUtils.getHex(first, second, 0);
			lifeColor += 0xff000000;
			
			fill2(0xff000000, _width, _height);
			fill2(lifeColor, ratio * _width, _height);
		}
	}

}