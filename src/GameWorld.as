package 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author César Alejandro Moltoni
	 */
	public class GameWorld extends World 
	{
		[Embed(source = "assets/background.png")] private const BACK:Class;
		[Embed(source = "assets/foreground.png")] private const FORE:Class;
		[Embed(source = "assets/theme.mp3")] private const THEME:Class;
		public static const SCALE:Number = 24;
		public static const GRID:Number = 16;
		
		public static var physicsWorld:b2World;
		public var velocityIterations:int = 30;
		public var positionIterations:int = 30;
		public var timeStep:Number = 1.0 / 30.0;
		public var timer:Timer;
		private var ticks:int = -3;
		private var emitter:Emitter;
		private var themeSfx:Sfx;
		
		public function GameWorld() 
		{
			FP.screen.color = 0xd1dffa;
			super();
			addGraphic(new Image(BACK), 2);
			addGraphic(new Image(FORE), -1);
			
			emitter = new Emitter(new BitmapData(2,2),2,2);
			emitter.newType("explode",[0]);
			emitter.setAlpha("explode",1,0);
			emitter.setMotion("explode", 180, 30, 4, 180, 4, 1, Ease.quadOut);
			emitter.setColor("explode", 0x4d9595, 0x4fbaba);
			emitter.relative = false;
			addGraphic(emitter);
			themeSfx = new Sfx(THEME);
			themeSfx.loop(0.4);
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 30.0);
			
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			// Construct a world object
			physicsWorld = new b2World( gravity, doSleep);
			// walls
			add(new Wall(GRID, FP.screen.height / 2));
			add(new Wall(FP.screen.width - GRID, FP.screen.height / 2));
			add(new Wall(FP.screen.width / 2, GRID, false, 'ceil'));
			add(new Wall(FP.screen.width / 2, FP.screen.height - GRID, false, 'floor'));
			// separators level 1
			add(new StaticPlatform(GRID * 3, GRID * 10.5));
			add(new StaticPlatform(GRID * 3, GRID * 12.5));
			add(new StaticPlatform(FP.screen.width  - GRID * 3, GRID * 10.5));
			add(new StaticPlatform(FP.screen.width  - GRID * 3, GRID * 12.5));
			// separators level 2
			add(new StaticPlatform(GRID * 3, GRID * 16.5));
			add(new StaticPlatform(GRID * 3, GRID * 18.5));
			add(new StaticPlatform(FP.screen.width  - GRID * 3, GRID * 16.5));
			add(new StaticPlatform(FP.screen.width  - GRID * 3, GRID * 18.5));
			
			// separators level 3
			add(new StaticPlatform(GRID * 3, GRID * 22.5));
			add(new StaticPlatform(GRID * 3, GRID * 24.5));
			add(new StaticPlatform(FP.screen.width  - GRID * 3, GRID * 22.5));
			add(new StaticPlatform(FP.screen.width  - GRID * 3, GRID * 24.5));
			
			// spike
			add(new Spikes(32, 32));
			add(new Spike(32, 32));
			
			add(new Hero(FP.screen.width / 2, FP.screen.height / 2));
			add(new Skeleton(3, 94));
			timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, OnTimer);
			timer.start();
			physicsWorld.SetWarmStarting(true);
		}
		
		override public function update():void
		{
			physicsWorld.Step(timeStep, velocityIterations, positionIterations);
			emitter.emit("explode", 72, 32);
			super.update();
		}
		
		private function OnTimer(event:TimerEvent):void
		{
			if (ticks % 2 == 0) 
				add(new Platform(FP.screen.width + GRID * 3, FP.screen.height - GRID * 6.5, -3 ));
			if (ticks % 3 == 0) 
				add(new Platform( -GRID * 3, FP.screen.height - GRID * 12.5, 2.5 ));
			if (ticks % 4 == 0)
				add(new Platform( FP.screen.width + GRID * 3, FP.screen.height - GRID * 18.5, -2 ));
			if (ticks >= int.MAX_VALUE) ticks = 0;
			ticks++;
		}
		
	}

}