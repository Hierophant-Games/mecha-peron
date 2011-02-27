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
		
		[Embed(source = "../../data/sprites/peron.png")]
		public static var SpritePeron:Class;
		[Embed(source = "../../data/sprites/laser.png")]
		public static var SpriteLaser:Class;
		[Embed(source = "../../data/sprites/chrosshair.png")]
		public static var SpriteChrosshair:Class;
		
		[Embed(source = "../../data/sprites/plane.png")]
		public static var SpritePlane:Class;
		
		[Embed(source = "../../data/sprites/explosion.png")]
		public static var SpriteExplosion:Class;
		
		// embedded sounds and music
		
		[Embed(source = "../../data/sfx/footstep.mp3")]
		public static var SfxFootstep:Class;
		[Embed(source = "../../data/sfx/justicia_social.mp3")]
		public static var SfxJusticiaSocial:Class;
		[Embed(source = "../../data/sfx/tercera_posicion.mp3")]
		public static var SfxTerceraPosicion:Class;
		
		[Embed(source = "../../data/sfx/explosion.mp3")]
		public static var SfxExplosion:Class;
		
		[Embed(source = "../../data/sfx/theme.mp3")]
		public static var MusicTheme:Class;
	}
}