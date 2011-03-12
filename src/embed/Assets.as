package embed 
{
	/**
	 * Embedded assets
	 * @author Santiago Vilar
	 */
	public class Assets 
	{
		// embedded strings
		
		[Embed(source = "../../data/strings/GameStrings-EN.xml", mimeType = "application/octet-stream")]
		public static var EnglishXML:Class;
		
		// embedded sprites
		
		[Embed(source = "../../data/sprites/cityScape.png")]
		public static var SpriteBack:Class;
		[Embed(source = "../../data/sprites/background.png")]
		public static var SpriteMiddle:Class;
		[Embed(source = "../../data/sprites/foreground.png")]
		public static var SpriteFront:Class;
		[Embed(source = "../../data/sprites/smoke.png")]
		public static var SpriteSmoke:Class;
		[Embed(source = "../../data/sprites/smokeBig.png")]
		public static var SpriteSmokeBig:Class;
		[Embed(source = "../../data/sprites/smokeBuilding.png")]
		public static var SpriteSmokeBuilding:Class;
		[Embed(source = "../../data/sprites/spark.png")]
		public static var SpriteSpark:Class;
		[Embed(source = "../../data/sprites/cannon.png")]
		public static var SpriteCannon:Class;
		
		[Embed(source = "../../data/sprites/torso.png")]
		public static var SpriteBody:Class;
		[Embed(source = "../../data/sprites/head.png")]
		public static var SpriteHead:Class;
		[Embed(source = "../../data/sprites/leftArm.png")]
		public static var SpriteLeftArm:Class;
		[Embed(source = "../../data/sprites/laser.png")]
		public static var SpriteLaser:Class;
		[Embed(source = "../../data/sprites/fist.png")]
		public static var SpriteFist:Class;
		[Embed(source = "../../data/sprites/hudGauge.png")]
		public static var SpriteHUDGauge:Class;
		
		
		[Embed(source = "../../data/sprites/rocket.png")]
		public static var SpriteRocket:Class;		
		[Embed(source = "../../data/sprites/enemyBuilding.png")]
		public static var SpriteEnemyBuilding:Class;		
		[Embed(source = "../../data/sprites/soldier.png")]
		public static var SpriteSoldier:Class;
		
		[Embed(source = "../../data/sprites/bomb.png")]
		public static var SpriteBomb:Class;		
		[Embed(source = "../../data/sprites/plane.png")]
		public static var SpritePlane:Class;
		
		[Embed(source = "../../data/sprites/explosion.png")]
		public static var SpriteExplosion:Class;
		
		[Embed(source = "../../data/sprites/crosshair.png")]
		public static var SpriteCrosshair:Class;
		[Embed(source = "../../data/sprites/cursor.png")]
		public static var SpriteCursor:Class;
		
		// embedded sprites definition
		
		[Embed(source = "../../data/sprites/head.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteHead:Class;
		[Embed(source = "../../data/sprites/leftArm.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteLeftArm:Class;
		[Embed(source = "../../data/sprites/laser.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteLaser:Class;
		
		// embedded sounds and music
		
		[Embed(source = "../../data/sfx/console_blip.mp3")]
		public static var SfxConsoleBlip:Class;
		
		[Embed(source = "../../data/sfx/footstep.mp3")]
		public static var SfxFootstep:Class;
		[Embed(source = "../../data/sfx/justicia_social.mp3")]
		public static var SfxJusticiaSocial:Class;
		[Embed(source = "../../data/sfx/tercera_posicion.mp3")]
		public static var SfxTerceraPosicion:Class;
		[Embed(source = "../../data/sfx/laser.mp3")]
		public static var SfxLaser:Class;
		
		[Embed(source = "../../data/sfx/explosion.mp3")]
		public static var SfxExplosion:Class;
		
		[Embed(source = "../../data/sfx/theme.mp3")]
		public static var MusicTheme:Class;
		[Embed(source = "../../data/sfx/losmuchachos_8bit.mp3")]
		public static var LosMuchachos8Bit:Class;
	}
}