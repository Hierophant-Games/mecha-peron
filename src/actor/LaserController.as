package actor 
{
	import flash.geom.*;
	import collision.RotatedRectangle;
	import embed.Assets;
	import sprites.SpriteLoader;
	import org.flixel.*;
	/**
	 * ...
	 * @author
	 */
	public class LaserController extends ActorController 
	{
		private var _player:Actor;
		
		private var _laserR:FlxSprite;
		private var _laserL:FlxSprite;
		
		private var _laserRBox:RotatedRectangle;
		private var _laserLBox:RotatedRectangle;
		
		private var _angle:Number;
		
		public function get angle():Number
		{
			return _angle;
		}
		
		public function set angle(angle:Number):void
		{
			_laserR.angle = angle;
			_laserL.angle = angle;
			_angle = angle;
		}
		
		public function LaserController(player:Actor) 
		{
			_player = player;
		}
		
		override public function init():void
		{			
			_laserR = new SpriteLoader().load(Assets.XMLSpriteLaser, Assets.SpriteLaser);
			_laserR.loadGraphic(Assets.SpriteLaser, true, false, 320, 8);
			_laserR.origin = new FlxPoint(0, _laserR.height / 2);
			_laserRBox = new RotatedRectangle(new Rectangle(), 0);
			
			(controlledActor as CompositeActor).addSprite(_laserR, new FlxPoint(0, 0));
			
			_laserL = new SpriteLoader().load(Assets.XMLSpriteLaser, Assets.SpriteLaser);
			_laserL.loadGraphic(Assets.SpriteLaser, true, false, 320, 8);
			_laserL.origin = new FlxPoint(0, _laserL.height / 2);
			_laserLBox = new RotatedRectangle(new Rectangle(), 0);
			
			(controlledActor as CompositeActor).addSprite(_laserL, new FlxPoint(-22, 0));
			
			(controlledActor as CompositeActor).height = _laserR.height;
			(controlledActor as CompositeActor).width = _laserR.width;
		}
		
		override public function update():void
		{
		}
		
		public function checkLaserHit(object:FlxObject):Boolean
		{
			_laserRBox.rect = new Rectangle(_laserR.x, _laserR.y, _laserR.width, _laserR.height);
			_laserRBox.angle = _laserR.angle;
			_laserRBox.origin = new Point(_laserR.origin.x, _laserR.origin.y);
			var hit:Boolean = _laserRBox.collides2(object);
			
			if (!hit)
			{
				_laserLBox.rect = new Rectangle(_laserL.x, _laserL.y, _laserL.width, _laserL.height);
				_laserLBox.angle = _laserL.angle;
				_laserLBox.origin = new Point(_laserL.origin.x, _laserL.origin.y);
				hit = _laserLBox.collides2(object);
			}
			
			return hit;
		}
	}
}