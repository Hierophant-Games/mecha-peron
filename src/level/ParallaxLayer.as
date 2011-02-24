package level 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class ParallaxLayer extends FlxGroup
	{
		private var _layerWidth:uint;
		private var _backgrounds:Vector.<FlxSprite> = new Vector.<FlxSprite>();
		private var _emitters:Vector.<FlxEmitter> = new Vector.<FlxEmitter>();
		private var _emittersStartFunctions:Vector.<Function> = new Vector.<Function>();
		
		public function ParallaxLayer(Graphic:Class, scrollFactor:Number) 
		{
			this.scrollFactor = new FlxPoint(scrollFactor, scrollFactor);
			
			if (Graphic != null)
			{
				_backgrounds.push(new FlxSprite(0, 0, Graphic));
				_layerWidth = _backgrounds[0].width;
				_backgrounds.push(new FlxSprite(_layerWidth, 0, Graphic));
				
				add(_backgrounds[0], true);
				add(_backgrounds[1], true);
				_backgrounds[0].solid = false;
				_backgrounds[1].solid = false;	
			}
		}
		
		public override function update():void
		{
			var pos:Number = FlxG.scroll.x * scrollFactor.x;
			// adjust the background positions
			for each (var background:FlxSprite in _backgrounds)
			{
				if (background.x + pos < -_layerWidth)
				{
					background.x += _layerWidth * 2;
				}
			}
			// update emitters
			for (var i:uint = 0; i < _emitters.length; ++i)
			{
				var emitter:FlxEmitter = _emitters[i];
				var startFunction:Function = _emittersStartFunctions[i];
				
				if (emitter.x + pos < 0)
				{
					emitter.stop(1);
					emitter.x += _layerWidth;
				}
				else if (emitter.x + pos > FlxG.width)
				{
					if (emitter.on)
					{
						emitter.stop(1);
					}
				}
				else
				{
					if (!emitter.on)
					{
						startFunction(emitter);
					}
				}
			}
			
			super.update();
		}
		
		/**
		 * Adds a particle emitter to the layer
		 * @param	x position
		 * @param	y position
		 * @param	setupFunction example(parent:FlxGroup, x:Number, y:Number):void
		 */
		public function addEmitter(x:Number, y:Number, setupFunction:Function, startFunction:Function):void
		{
			var emitter:FlxEmitter = new FlxEmitter(x, y);
			add(emitter, true);
			setupFunction(emitter);
			_emitters.push(emitter);
			_emittersStartFunctions.push(startFunction);
		}
	}
}