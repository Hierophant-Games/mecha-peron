package level 
{
	import actor.*;
	import embed.Assets;
	import game.*;
	import org.flixel.*;
	import sprites.SpriteLoader;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class PlaneBomb extends FlxSprite
	{
		private var _sprExplosion:FlxSprite;
		private var _layer:FlxGroup;
		
		public function PlaneBomb(layer:FlxGroup, X:Number, Y:Number) 
		{
			super(X, Y);
			_layer = layer;
			loadGraphic(Assets.SpriteBomb, false, false, 10, 5, false);
			fixed = true;
		}
		
		public override function hitBottom(Contact:FlxObject, Velocity:Number):void
		{
			var other:Actor = Contact as Actor;
			if (other && other.controller is PlayerController)
			{
				// create explosion
				var explosion:Actor = new Actor(new ExplosionController(), _layer, x, y);
				_layer.add(explosion);
				
				FlxG.play(Assets.SfxExplosion, Configuration.soundVolume);
				
				kill();
				
				other.hurt(Constants.PLANE_BOMB_DAMAGE);
			}
		}
	}
}