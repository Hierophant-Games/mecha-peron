package states.levels 
{
	import flash.geom.Point;
	import org.flixel.*;
	/**
	 * Main Level of the game
	 * @author Santiago Vilar
	 */
	public class MainLevel extends FlxState
	{
		[Embed(source = "../../../data/sprites/cityScape.png")]
		private var SpriteBack:Class;
		[Embed(source = "../../../data/sprites/background.png")]
		private var SpriteMiddle:Class;
		[Embed(source = "../../../data/sprites/foreground.png")]
		private var SpriteFront:Class;
		[Embed(source = "../../../data/sprites/smoke.png")]
		private var SpriteSmoke:Class;
		
		private var _layerBack:ParallaxLayer;
		private var _layerMiddle:ParallaxLayer;
		private var _layerFront:ParallaxLayer;
		
		override public function create():void 
		{
			FlxG.maxElapsed = 1 / 60; // try to evade v-sync issues
			
			bgColor = 0xffd3a9a9;
			_layerBack = new ParallaxLayer(SpriteBack,   	0.2);
			_layerMiddle = new ParallaxLayer(SpriteMiddle,  0.5);
			_layerFront = new ParallaxLayer(SpriteFront,   	2.0);
			
			createSmoke(85, 104);
			createSmoke(393, 126);
			
			add(_layerBack);
			add(_layerMiddle);
			add(_layerFront);
		}
		
		private var _quakeTimer:Number = 0;
		
		override public function update():void
		{
			FlxG.scroll.x -= 50 * FlxG.elapsed;
			
			
			// Earthquake effect!
			_quakeTimer += FlxG.elapsed;
			if (_quakeTimer > 1) // each 1 second
			{
				_quakeTimer -= 1;
				FlxG.quake.start(0.01, 0.2);
			}
			
			super.update();
		}
		
		private function createSmoke(x:Number, y:Number):void
		{
			var emitter:FlxEmitter = new FlxEmitter(x, y);
			_layerMiddle.add(emitter, true);
			emitter.setSize(6, 2);
			emitter.setRotation(0, 0);
			emitter.setXSpeed(-10, 0);
			emitter.setYSpeed(-20, -30);
			emitter.gravity = 0;
			for (var i:uint = 0; i <10; ++i)
			{
				var smoke:FlxSprite = new FlxSprite();
				smoke.loadGraphic(SpriteSmoke, true, false, 14, 12);
				smoke.addAnimation("smoke", new Array(1, 2, 3, 4, 3, 2), 4, true);
				smoke.play("smoke");
				emitter.add(smoke, true);
			}
			emitter.start(false, 0.2);
		}
	}
}