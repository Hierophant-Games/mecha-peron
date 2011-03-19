package actor 
{
	import level.*;
	import org.flixel.*;
	/**
	 * ...
	 * @author 
	 */
	public class BombController extends ActorController
	{	
		private var _layer:FlxGroup;
		
		private var _bombClass:Class;
		private var _bomb:Bomb;

		private var _type:Number;
		public static const PLANE_BOMB:Number = 0;
		public static const CANNON_BOMB:Number = 1;
		public static const SOLDIER_BULLET:Number = 2;
		
		private var _lifeBar:LifeBar;
		
		public function get type():Number
		{
			return _type;
		}
		
		public function BombController(bombClass:Class, layer:FlxGroup) 
		{
			_layer = layer;
			
			_bombClass = bombClass;
		}
		
		override public function init():void
		{
			_bomb = new _bombClass(controlledActor);
			_bomb.init();
			
			switch(_bombClass)
			{
				case CannonBomb:
					_type = CANNON_BOMB;
					break;
				case PlaneBomb:
					_type = PLANE_BOMB;
					break;
				case Bullet:
					_type = SOLDIER_BULLET;
					break;
			}
		}
		
		override public function preFirstUpdate():void
		{
			_lifeBar = new LifeBar(10, 1);
			_layer.add(_lifeBar, true);
		}
		
		override public function update():void
		{
			_lifeBar.x = controlledActor.x + controlledActor.width / 2 - _lifeBar.width / 2;
			_lifeBar.y = controlledActor.y - _lifeBar.height;
			_lifeBar.updateLife(controlledActor.health);
		}
		
		override public function onCollide(collideType:uint, contact:FlxObject):void
		{
			_bomb.collide(contact); // Doesn´t matter which type
		}
		
		override public function onHurt(damage:Number):Boolean
		{
			if ((controlledActor.health -= damage) <= 0)
			{
				_bomb.explode();
				if (_type != SOLDIER_BULLET)
					controlledActor.kill();
			}
			
			return false;
		}
		
		override public function onKill():Boolean
		{
			_layer.remove(_lifeBar);
			return true;
		}
	}

}