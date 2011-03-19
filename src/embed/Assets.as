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
		[Embed(source = "../../data/strings/GameStrings-ES.xml", mimeType = "application/octet-stream")]
		public static var SpanishXML:Class;
		
		// embedded sprites
		
		[Embed(source = "../../data/sprites/en.png")]
		public static var SpriteEN:Class;
		[Embed(source = "../../data/sprites/es.png")]
		public static var SpriteES:Class;
		
		[Embed(source = "../../data/sprites/cityScape.png")]
		public static var SpriteBack:Class;
		[Embed(source = "../../data/sprites/background.png")]
		public static var SpriteMiddle:Class;
		[Embed(source = "../../data/sprites/foreground_building_a.png")]
		public static var SpriteForegroundA:Class;
		[Embed(source = "../../data/sprites/foreground_building_b.png")]
		public static var SpriteForegroundB:Class;
		[Embed(source = "../../data/sprites/foreground_building_c.png")]
		public static var SpriteForegroundC:Class;
		[Embed(source = "../../data/sprites/smoke.png")]
		public static var SpriteSmoke:Class;
		[Embed(source = "../../data/sprites/smokeBig.png")]
		public static var SpriteSmokeBig:Class;
		[Embed(source = "../../data/sprites/smokeBuilding.png")]
		public static var SpriteSmokeBuilding:Class;
		[Embed(source = "../../data/sprites/spark.png")]
		public static var SpriteSpark:Class;
		[Embed(source = "../../data/sprites/cannonBomb.png")]
		public static var SpriteCannonBomb:Class;
		[Embed(source = "../../data/sprites/cannon.png")]
		public static var SpriteCannon:Class;
		
		[Embed(source = "../../data/sprites/torso.png")]
		public static var SpriteBody:Class;
		[Embed(source = "../../data/sprites/head.png")]
		public static var SpriteHead:Class;
		[Embed(source = "../../data/sprites/leftArm.png")]
		public static var SpriteLeftArm:Class;
		[Embed(source = "../../data/sprites/rightArm.png")]
		public static var SpriteRightArm:Class;
		[Embed(source = "../../data/sprites/laser.png")]
		public static var SpriteLaser:Class;
		[Embed(source = "../../data/sprites/fist.png")]
		public static var SpriteFist:Class;
		[Embed(source = "../../data/sprites/fistMini.png")]
		public static var SpriteFistMini:Class;
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
		[Embed(source = "../../data/sprites/mini_explosion.png")]
		public static var SpriteMiniExplosion:Class;
		
		[Embed(source = "../../data/sprites/crosshair.png")]
		public static var SpriteCrosshair:Class;
		[Embed(source = "../../data/sprites/cursor.png")]
		public static var SpriteCursor:Class;
		
		// embedded sprites definition
		
		[Embed(source = "../../data/sprites/head.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteHead:Class;
		[Embed(source = "../../data/sprites/leftArm.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteLeftArm:Class;
		[Embed(source = "../../data/sprites/rightArm.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteRightArm:Class;
		[Embed(source = "../../data/sprites/laser.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteLaser:Class;
		[Embed(source = "../../data/sprites/soldier.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteSoldier:Class;
		[Embed(source = "../../data/sprites/cannon.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteCannon:Class;
		[Embed(source = "../../data/sprites/explosion.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteExplosion:Class;
		[Embed(source = "../../data/sprites/mini_explosion.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteMiniExplosion:Class;
		[Embed(source = "../../data/sprites/rocket.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteRocket:Class;
		[Embed(source = "../../data/sprites/foreground_building_a.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteForegroundA:Class;
		[Embed(source = "../../data/sprites/foreground_building_b.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteForegroundB:Class;
		[Embed(source = "../../data/sprites/foreground_building_c.xml", mimeType = "application/octet-stream")]
		public static var XMLSpriteForegroundC:Class;
		
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
		[Embed(source = "../../data/sfx/depleted_laser.mp3")]
		public static var SfxDepletedLaser:Class;
		
		[Embed(source = "../../data/sfx/explosion.mp3")]
		public static var SfxExplosion:Class;
		
		[Embed(source = "../../data/sfx/theme.mp3")]
		public static var MusicTheme:Class;
		[Embed(source = "../../data/sfx/losmuchachos_8bit.mp3")]
		public static var LosMuchachos8Bit:Class;
	}
}