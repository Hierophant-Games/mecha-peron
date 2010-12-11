package menu 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class BloodTrail extends FlxSprite
	{
		private const BloodColor:uint = 0xff990000;
		
		private var _size:uint;
		private var _randomInitTime:Number;
		private var _trailLength:Number;
		private var _speed:Number;
		private var _completed:Boolean = false;
		
		public function BloodTrail(X:Number, Y:Number, size:uint)
		{
			super(X, Y);
			
			createGraphic(size, size, BloodColor);
			
			_size = size;
			_randomInitTime = FlxU.random() * 50;
			_trailLength = _size;
			_speed = (FlxU.random()*2 + 1) / 3;
		}
		
		override public function update():void
		{
			if (!_completed)
			{
				if (_randomInitTime > 0)
				{
					_randomInitTime -= FlxG.elapsed;
				}
				else if (_trailLength - _size < Game.ScreenHeight)
				{
					_trailLength += _speed;
					createGraphic(_size, _trailLength, BloodColor);
				}
				else
				{
					_completed = true;
				}
			}
			super.update();
		}
		
		public function get completed():Boolean
		{
			return _completed;
		}
		
		public function forceComplete():void
		{
			_completed = true;
			_trailLength = Game.ScreenHeight + _size;
			createGraphic(_size, _trailLength, BloodColor);
		}
	}
}