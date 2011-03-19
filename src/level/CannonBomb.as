package level 
{
	import actor.*;
	import embed.Assets;
	import game.*;
	import org.flixel.*;
	import sprites.SpriteLoader;
	
	/**
	 * ...
	 * @author
	 */
	public class CannonBomb extends Bomb
	{
		public function CannonBomb(actor:Actor) 
		{
			super(actor);
		}
		
		override public function init():void
		{
			_actor.loadGraphic(Assets.SpriteCannonBomb, false, false, 5, 5, false);
			_actor.fixed = true;
		}
		
		override public function collide(contact:FlxObject):void
		{
			var other:Actor = contact as Actor;
			if (other && other.controller is PlayerController)
			{
				explode();
				_actor.kill();
				
				other.hurt(Constants.CANNON_BOMB_DAMAGE);
			}
		}
		
		override public function explode():void
		{
			// create explosion
			var explosion:Actor = new Actor(new ExplosionController(), _actor.layer, _actor.x, _actor.y);
			_actor.layer.add(explosion);
			
			FlxG.play(Assets.SfxExplosion, Configuration.soundVolume);
		}
	}
}