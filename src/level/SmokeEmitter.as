package level 
{
	import org.flixel.*;
	import embed.Assets;
	/**
	 * ...
	 * @author Fernando
	 */
	public class SmokeEmitter extends FlxEmitter
	{
		public function init():void
		{
			setRotation(0, 0);
			gravity = 0;
			for (var i:uint = 0; i <10; ++i)
			{
				var smoke:FlxSprite = new FlxSprite();
				if (i % 2)
				{
					smoke.loadGraphic(Assets.SpriteSmoke, true, false, 14, 12);					
				}
				else
				{
					smoke.loadGraphic(Assets.SpriteSmokeBig, true, false, 28, 24);
				}
				
				var randomGrey:Number = FlxU.random() * 3;	
				randomGrey = Number(randomGrey.toFixed()) * 0x333333;
				smoke.color = randomGrey;
				//smoke.alpha = 0.5;
				
				smoke.exists = false;
				smoke.solid = false;
				smoke.addAnimation("smoke", new Array(1, 2, 3, 4, 3, 2), 4, true);
				smoke.play("smoke");
				add(smoke, true);
			}
		}
	}

}