package states.levels 
{
	import flash.geom.Point;
	import org.flixel.*;
	import org.flixel.data.FlxAnim;
	import actor.*;
	import player.Player;
	/**
	 * Main Level of the game
	 * @author Santiago Vilar
	 */
	public class MainLevel extends FlxState
	{
		[Embed(source = "../../../data/sprites/cityScape.png")]
		private var SpriteBack:Class;
		[Embed(source = "../../../data/sprites/background.png")]
		private var SpriteMiddle:Class;
		[Embed(source = "../../../data/sprites/foreground.png")]
		private var SpriteFront:Class;
		[Embed(source = "../../../data/sprites/smoke.png")]
		private var SpriteSmoke:Class;
		[Embed(source = "../../../data/sprites/smokeBig.png")]
		private var SpriteSmokeBig:Class;
		
		[Embed(source = "../../../data/sfx/footstep.mp3")]
		private var SfxFootstep:Class;
		[Embed(source = "../../../data/sfx/justicia_social.mp3")]
		private var SfxJusticiaSocial:Class;
		[Embed(source = "../../../data/sfx/tercera_posicion.mp3")]
		private var SfxTerceraPosicion:Class;
		
		[Embed(source = "../../../data/sfx/theme.mp3")]
		private var MusicTheme:Class;
		
		private const RANDOM_VOICEFX_COUNT:uint = 2;
		
		private var _soundFootstep:FlxSound;
		private var _robotVoices:Vector.<FlxSound> = new Vector.<FlxSound>();
		
		private var _layerBack:ParallaxLayer;
		private var _layerMiddle:ParallaxLayer;
		private var _layerAction:ParallaxLayer;
		private var _layerFront:ParallaxLayer;
		
		private var _player:Player;
		
		override public function create():void
		{
			FlxG.maxElapsed = 1 / 60; // try to evade v-sync issues
			
			// sounds
			_soundFootstep = new FlxSound();
			_soundFootstep.loadEmbedded(SfxFootstep);
			for (var i:uint = 0; i < RANDOM_VOICEFX_COUNT; ++i)
			{
				_robotVoices.push(new FlxSound());
			}
			_robotVoices[0].loadEmbedded(SfxJusticiaSocial);
			_robotVoices[1].loadEmbedded(SfxTerceraPosicion);
			
			bgColor = 0xffd3a9a9;
			_layerBack = new ParallaxLayer(SpriteBack,   	0.2);
			_layerMiddle = new ParallaxLayer(SpriteMiddle,  0.5);
			_layerAction = new ParallaxLayer(null,			1.0);
			_layerFront = new ParallaxLayer(SpriteFront,   	1.5);
			
			_layerMiddle.addEmitter(130, 80, setupSmoke, startSmoke);
			_layerMiddle.addEmitter(390, 126, setupSmoke, startSmoke);
			
			initActors();
			
			add(_layerBack);
			add(_layerMiddle);
			add(_layerAction);
			add(_layerFront);
			
			FlxG.music = new FlxSound();
			FlxG.music.loadEmbedded(MusicTheme, true).play();
			FlxG.music.volume = 0.2;
			
			_player = new Player(0, Game.ScreenHeight - 100);
			add(_player);
			
			FlxG.followTarget = _player;
			FlxG.followBounds(0, 0, 100000, Game.ScreenHeight);
		}
		
		private var _quakeTimer:Number = 0;
		private var _robotVoiceTimer:Number = 0;
		private var _robotVoiceIndex:uint = 0;
		
		override public function update():void
		{			
			//Player input
			var moveX:Number = 0;
			var moveY:Number = 0;
			if (FlxG.keys.RIGHT)
				moveX = 30;
			if (FlxG.keys.LEFT)
				moveX = -30;
			_player.move(moveX, moveY);
			
			if (FlxG.keys.justPressed("SPACE"))
				_player.attack();
				
			_player.update();
			
			// Voice effect!
			/*_robotVoiceTimer += FlxG.elapsed;
			if (_robotVoiceTimer > 5)
			{
				_robotVoiceTimer -= 5;
				_robotVoices[_robotVoiceIndex].play();
				_robotVoiceIndex = (_robotVoiceIndex + 1) % RANDOM_VOICEFX_COUNT;
			}*/
			
			// Earthquake effect!
			_quakeTimer += FlxG.elapsed;
			if (_quakeTimer > 1.5) // this should depend on Peron's footsteps
			{
				_quakeTimer -= 1.5;
				FlxG.quake.start(0.01, 0.2);
				_soundFootstep.play();
			}
			
			super.collide();
			super.update();
		}
		
		private function setupSmoke(emitter:FlxEmitter):void
		{
			emitter.setSize(6, 2);
			emitter.setRotation(0, 0);
			emitter.setXSpeed(-10, 0);
			emitter.setYSpeed(-20, -30);
			emitter.gravity = 0;
			for (var i:uint = 0; i <10; ++i)
			{
				var smoke:FlxSprite = new FlxSprite();
				if (i % 2)
				{
					smoke.loadGraphic(SpriteSmoke, true, false, 14, 12);
				}
				else
				{
					smoke.loadGraphic(SpriteSmokeBig, true, false, 28, 24);
				}
				smoke.exists = false;
				smoke.addAnimation("smoke", new Array(1, 2, 3, 4, 3, 2), 4, true);
				smoke.play("smoke");
				smoke.solid = false;
				emitter.add(smoke, true);
			}
		}
		
		private function startSmoke(emitter:FlxEmitter):void
		{
			emitter.start(false, 0.2);
		}
		
		private var _actors:Vector.<Actor> = new Vector.<Actor>();
		
		private function initActors():void
		{
			addActor(new PlaneController(), 500, 20);
			addActor(new PlaneController(), 520, 40);
			addActor(new PlaneController(), 540, 60);
		}
		
		private function addActor(actorController:ActorController, x:Number, y:Number):void
		{
			var theActor:Actor = new Actor(actorController);
			theActor.x = x;
			theActor.y = y;
			_layerAction.add(theActor, true);
			_actors.push(theActor);
		}
	}
}