package level 
{
	import org.flixel.*;
	import level.*;
	/**
	 * ...
	 * @author Fernando
	 */
	public class Bomb extends FlxSprite
	{
		protected var _layer:FlxGroup;
		
		private var _lifeBar:LifeBar;
		
		public function get layer():FlxGroup
		{
			return _layer;
		}
		
		public function Bomb(layer:FlxGroup, X:Number, Y:Number) 
		{
			super(X, Y);
			
			_layer = layer;
			
			health = 100;
			
			_lifeBar = new LifeBar(10, 1);
			_layer.add(_lifeBar, true);
		}
		
		override public function update():void
		{
			_lifeBar.x = x + width / 2 - _lifeBar.width / 2;
			_lifeBar.y = y - _lifeBar.height;
			_lifeBar.updateLife(health);
			
			super.update();
		}
		
		override public function kill():void
		{
			_layer.remove(_lifeBar);
			
			super.kill();
		}
	}

}