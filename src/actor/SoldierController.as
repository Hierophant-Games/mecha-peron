package actor 
{
	import flash.geom.Point;
	import game.Constants;
	import level.Bullet;
	import level.LifeBar;
	import org.flixel.*;
	import embed.Assets;
	import sprites.SpriteLoader;
	
	/**
	 * ...
	 * @author Santiago Vilar
	 */
	public class SoldierController extends ActorController 
	{
		private var _player:Actor;
		private var _layer:FlxGroup;
		
		private var _lifeBar:LifeBar;
		
		private var _spawnBombCallback:Function;
		
		public function SoldierController(player:Actor, layer:FlxGroup, spawnBombCB:Function) 
		{
			_player = player;
			_layer = layer;
			_spawnBombCallback = spawnBombCB;
		}
		
		override public function init():void 
		{
			new SpriteLoader().loadIntoSprite(controlledActor, Assets.XMLSpriteSoldier, Assets.SpriteSoldier);
			controlledActor.addAnimationCallback(soldierAnimCallback);
			controlledActor.fixed = true;
		}
		
		override public function preFirstUpdate():void
		{
			_lifeBar = new LifeBar(10, 2);
			controlledActor.layer.add(_lifeBar, true);
		}
		
		override public function update():void
		{
			// only shoot if the actor is on the screen
			if (controlledActor.onScreen() && !controlledActor.dead)
			{
				aim();
			}
			
			_lifeBar.x = controlledActor.x;
			_lifeBar.y = controlledActor.y - _lifeBar.height;
			_lifeBar.updateLife(controlledActor.health);
		}
		
		override public function onHurt(Damage:Number):Boolean
		{
			if (!controlledActor.dead && (controlledActor.health -= Damage) <= 0)
			{
				// explosion
				var explo:Actor = new Actor(new ExplosionController(ExplosionController.TYPE_MINI),
					_layer, controlledActor.x + controlledActor.width / 2, controlledActor.y + controlledActor.height / 2);
				_layer.add(explo, true);
				
				controlledActor.play("Die");
				controlledActor.dead = true;
			}
			
			return false;
			// Avoid calling super.hurt() on purpose so it doesn´t stops rendering
			// when killed so we can render the broken window frame in soldier sprite
		}
		
		private const SHOOT_TIME:Number = 6;
		/* by setting initial value of timer as a random number
		 * between 0 and SHOOT_TIME, the soldiers will now shoot
		 * in different moments instead of always at the same time
		 */
		private var _shootTimer:Number = FlxU.random() * SHOOT_TIME;
		
		private function aim():void
		{
			_shootTimer += FlxG.elapsed;
			if (_shootTimer > SHOOT_TIME)
			{
				// reset timer
				_shootTimer -= SHOOT_TIME;
				controlledActor.play("Aim");
			}
		}
		
		private function shoot():void
		{
			if (_player.dead)
				return;
			
			controlledActor.play("Shoot");
			
			var originScreenPos:Point = new Point(controlledActor.getScreenXY().x, controlledActor.getScreenXY().y);
			
			var velocity:Point = new Point(Constants.SOLDIER_BULLET_SPEED_X, ((FlxU.random()*10) - 5));
				
			var bullet:Bullet = new Bullet(_layer, originScreenPos.x, originScreenPos.y);
			bullet.x -= FlxG.scroll.x * _layer.scrollFactor.x;
				
			bullet.velocity = new FlxPoint(velocity.x, velocity.y);
			_layer.add(bullet, true);
			
			if (_spawnBombCallback != null)
				_spawnBombCallback(bullet);
		}
		
		private function reload():void 
		{
			controlledActor.play("Reload");
		}
			
		private function soldierAnimCallback(name:String, frameNumber:uint, frameIndex:uint):void 
		{
			switch (name)
			{
				case "Aim":
				{
					if (frameIndex == 2)
						shoot();
					break;
				}
				case "Shoot":
				{
					if (frameIndex == 4)
						reload();
					break;
				}
			}
		}
		
		override public function onKill():Boolean
		{
			controlledActor.layer.remove(_lifeBar);
			return true;
		}
	}
}