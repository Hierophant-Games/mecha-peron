package actor 
{
	import level.CannonBomb;
	import org.flixel.*;
	import embed.Assets;
	import flash.geom.Point;
	import game.Constants;
	/**
	 * ...
	 * @author 
	 */
	public class CannonController extends ActorController 
	{
		private var _player:Actor;
		private var _layer:FlxGroup;
		
		private var _visibleTimer:Number;
		
		public function CannonController(player:Actor, layer:FlxGroup) 
		{
			_player = player;
			_layer = layer;
		}
		
		override public function init():void
		{
			controlledActor.loadGraphic(Assets.SpriteCannon, true, false, 19, 23);
			
			controlledActor.addAnimation("leftIdle", new Array(0, 0));
			controlledActor.addAnimation("leftShoot", new Array(1, 1));
			controlledActor.addAnimation("topIdle", new Array(2, 2));
			controlledActor.addAnimation("topShoot", new Array(3, 3));
			
			controlledActor.fixed = true;
		}
		
		override public function update():void
		{
			var posXInScreen:Number = controlledActor.getScreenXY().x;
			
			// camera culling
			controlledActor.visible = (posXInScreen < FlxG.width);
			// mark as dead when it goes out of camera
			if (posXInScreen < -controlledActor.frameWidth)
			{
				controlledActor.kill();
				return;
			}
			
			if (controlledActor.visible)
				_visibleTimer += FlxG.elapsed;
			else
				_visibleTimer = 0;

			if (controlledActor.getScreenXY().x > _player.getScreenXY().x + (_player.width * 1.5))
			{
				if (_visibleTimer > Constants.CANNON_ATTACK_DELAY - 1.0)
					controlledActor.play("leftShoot");
				else
					controlledActor.play("leftIdle");
			}
			else
			{
				if (_visibleTimer > Constants.CANNON_ATTACK_DELAY - 1.0)
					controlledActor.play("topShoot");
				else
					controlledActor.play("topIdle");
			}
			
			if (_visibleTimer >= Constants.CANNON_ATTACK_DELAY)
			{
				_visibleTimer = 0;
				
				// Randomize target y
				var randomY:Number = FlxU.random() * (_player.height / 4);
				var targetPos:Point = new Point(_player.getScreenXY().x + _player.width / 2, _player.getScreenXY().y + randomY);
				
				var actorScreenPos:FlxPoint = controlledActor.getScreenXY();
				var bomb:CannonBomb = new CannonBomb(_layer, actorScreenPos.x, actorScreenPos.y);
				bomb.x -= FlxG.scroll.x * _layer.scrollFactor.x;
				
				var speed:Point = new Point(targetPos.x - actorScreenPos.x, targetPos.y - actorScreenPos.y);
				speed.normalize(1);
				
				bomb.velocity.x = speed.x * Constants.CANNON_BOMB_SPEED;
				bomb.velocity.y = speed.y * Constants.CANNON_BOMB_SPEED;
				
				_layer.add(bomb, true);
			}
		}
		
		override public function hurt(Damage:Number):void
		{
			
		}
		
		override public function onKill():void
		{
			
		}
	}

}