package states.levels 
{
	import flash.geom.Point;
	import org.flixel.*;
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class MainLevel extends FlxState
	{
		//[Embed(source = "../../../data/sprites/beggar_stage_bg.png")]
		//private var Background:Class;
		
		[Embed(source = "../../../data/sprites/cityScape.png")]
		private var SpriteBack:Class;
		[Embed(source = "../../../data/sprites/background.png")]
		private var SpriteMiddle:Class;
		[Embed(source = "../../../data/sprites/foreground.png")]
		private var SpriteFront:Class;
		
		override public function create():void 
		{
			FlxG.maxElapsed = 1 / 60; // try to evade v-sync issues
			
			bgColor = 0xffd3a9a9;
			add(new ParallaxLayer(SpriteBack,   0.2));
			add(new ParallaxLayer(SpriteMiddle, 0.5));
			add(new ParallaxLayer(SpriteFront,  1.0));
		}
		
		override public function update():void
		{
			FlxG.scroll.x -= 50 * FlxG.elapsed;
			super.update();
		}
	}
}