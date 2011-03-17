package level 
{
	import embed.Assets;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import org.flixel.*;
	import game.Constants;
	/**
	 * ...
	 * @author Fernando
	 */
	public class HUD extends FlxGroup
	{
		private var _lifeBar:FlxSprite;
		
		private const LIFE_BAR_W:Number = 80; // from image
		private const LIFE_BAR_H:Number = 10; // from image
		private const LIFE_BAR_X:Number = FlxG.width - LIFE_BAR_W - 10;
		private const LIFE_BAR_Y:Number = FlxG.height - LIFE_BAR_H - 20;
		private const LIFE_COLOR:Number = 0xff00ff00;
		
		private var _laserBar:FlxSprite;
		private var _overheat:FlxText;
		
		private const LASER_BAR_W:Number = 80; // from image
		private const LASER_BAR_H:Number = 10; // from image
		private const LASER_BAR_X:Number = LIFE_BAR_X;
		private const LASER_BAR_Y:Number = LIFE_BAR_Y + LIFE_BAR_H + 2;
		private const LASER_COLOR:Number = 0xffff0000;
		
		private const BAR_FILL_XOFF:Number = 4;
		private const BAR_FILL_YOFF:Number = 4;
		private const LIFE_FILL_W:Number = LIFE_BAR_W - BAR_FILL_XOFF * 2;
		private const LIFE_FILL_H:Number = LIFE_BAR_H - BAR_FILL_YOFF * 2;
		private const LASER_FILL_W:Number = LASER_BAR_W - BAR_FILL_XOFF * 2;
		private const LASER_FILL_H:Number = LASER_BAR_H - BAR_FILL_YOFF * 2;
		
		private var _distanceText:FlxText;
		
		private var _fist:FlxSprite;
		private var _fistPixels:BitmapData;
		private var _fistScaleDirection:Number = -1;
		
		public function HUD()
		{
			scrollFactor = new FlxPoint(0, 0);
			
			// Life bar background sprite
			var lifeBarBack:FlxSprite = new FlxSprite(LIFE_BAR_X, LIFE_BAR_Y);
			lifeBarBack.loadGraphic(Assets.SpriteHUDGauge, false, false, LIFE_BAR_W, LIFE_BAR_H);
			lifeBarBack.solid = false;
			add(lifeBarBack, true);
			
			// Life bar fill
			_lifeBar = new FlxSprite(LIFE_BAR_X + BAR_FILL_XOFF, LIFE_BAR_Y + BAR_FILL_YOFF);
			_lifeBar.createGraphic(LIFE_FILL_W, LIFE_FILL_H, 0x00ffffff);
			_lifeBar.solid = false;
			add(_lifeBar, true);
			setLifeBarW(1);
			
			// Laser back background sprite
			var laserBarBack:FlxSprite = new FlxSprite(LASER_BAR_X, LASER_BAR_Y);
			laserBarBack.loadGraphic(Assets.SpriteHUDGauge, false, false, LASER_BAR_W, LASER_BAR_H);
			laserBarBack.solid = false;
			add(laserBarBack, true);
			
			// Laser bar fill
			_laserBar = new FlxSprite(LASER_BAR_X + BAR_FILL_XOFF, LASER_BAR_Y + BAR_FILL_YOFF);
			_laserBar.createGraphic(LASER_FILL_W, LASER_FILL_H, 0x00ffffff);
			_laserBar.solid = false;
			add(_laserBar, true);
			setLaserBarW(1);
			
			// Overheat text
			_overheat = new FlxText(_laserBar.x, laserBarBack.y - 2, LASER_FILL_W, Game.Strings.languageXML.Game.Overheat);
			_overheat.setFormat(null, 8, 0xff0000, "center", 0xffffff00);
			add(_overheat, true);
			_overheat.visible = false;
			
			// Distance text
			_distanceText = new FlxText(FlxG.width - 110, 10, 100);
			_distanceText.setFormat(null, 8, 0xffffff, "right", 0xff000000);
			add(_distanceText, true);
			
			// Flying fist
			_fist = new FlxSprite();
			_fist.solid = false;
			_fist.loadGraphic(Assets.SpriteFistMini, false, false, 23, 21);
			_fist.x = LIFE_BAR_X - (_fist.width) - 2;
			_fist.y = LIFE_BAR_Y;
			add(_fist, true);
		
			_fistPixels = new BitmapData(_fist.width, _fist.height);
			_fistPixels.copyPixels(_fist.framePixels, new Rectangle(0, 0, _fist.width, _fist.height), new Point(0, 0));
		}
		
		public function setLifeBarW(widthProp:Number):void
		{
			_lifeBar.fill2(0x00ffffff, LIFE_FILL_W, LIFE_FILL_H);
			_lifeBar.fill2(LIFE_COLOR, widthProp * LIFE_FILL_W, LIFE_FILL_H);
		}
		
		public function setLaserBarW(widthProp:Number):void
		{
			_laserBar.fill2(0x00ffffff, LASER_FILL_W, LASER_FILL_H);
			_laserBar.fill2(LASER_COLOR, widthProp * LASER_FILL_W, LASER_FILL_H);
		}
		
		public function flickerLifeBar(seconds:Number):void
		{
			_lifeBar.flicker(seconds);
		}
		
		public function flickerLaserBar(seconds:Number):void
		{
			_laserBar.flicker(seconds);
		}
		
		public function showOverheat(enable:Boolean):void
		{
			if (enable)
			{
				_overheat.visible = true;
				//_overheat.flicker(0.1);
			}
			else
			{
				_overheat.visible = false;
			}
		}
		
		public function setDistance(distance:String):void
		{
			//trace("Distance " + distance);
			_distanceText.text = distance + " km";
		}
		
		public function setFistW(widthProp:Number):void
		{
			// Restore fist pixels
			_fist.framePixels.copyPixels(_fistPixels, new Rectangle(0, 0, _fist.width, _fist.height), new Point());
			
			if (widthProp >= 1)
			{
				// Animate when full
				_fist.scale.x += _fistScaleDirection * 0.05; 
				_fist.scale.y = _fist.scale.x;
				
				if (_fist.scale.x <= 0.7)
					_fistScaleDirection = 1;
				else if (_fist.scale.x >= 1.0)
					_fistScaleDirection = -1;
			}
			else
			{
				_fist.scale = new FlxPoint(1, 1);	
				
				var backPixels:BitmapData = new BitmapData(_fist.width, _fist.height);
				backPixels.copyPixels(_fistPixels, new Rectangle(0, 0, _fist.width, _fist.height), new Point());
				var ct:ColorTransform = new ColorTransform(0, 0, 0, 0.5);
				backPixels.colorTransform(new Rectangle(0, 0, backPixels.width, backPixels.height), ct);
				
				var startX:Number = backPixels.width * widthProp;
				startX = new Number(startX.toFixed());
				var srcRect:Rectangle = new Rectangle(startX, 0, backPixels.width - startX, backPixels.height);
				var destPoint:Point = new Point(startX, 0);
				
				_fist.framePixels.copyPixels(backPixels, srcRect, destPoint);
			}
		}
	}
}