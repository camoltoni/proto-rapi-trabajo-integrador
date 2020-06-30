package 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author César Alejandro Moltoni
	 */
	public class GameWorld extends World 
	{
		public static const SCALE:Number = 48;
		
		public static var physicsWorld:b2World;
		public var velocityIterations:int = 30;
		public var positionIterations:int = 30;
		public var timeStep:Number = 1.0 / 30.0;
		public var timer:Timer;
		private var ticks:int = -3;
		public function GameWorld() 
		{
			FP.screen.color = 0xd1dffa;
			super();
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 30.0);
			
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			// Construct a world object
			physicsWorld = new b2World( gravity, doSleep);
			
			add(new Wall(12, FP.screen.height / 2));
			add(new Wall(FP.screen.width - 12, FP.screen.height / 2));
			add(new Wall(FP.screen.width / 2, 12, false, 'ceil'));
			add(new Wall(FP.screen.width / 2, FP.screen.height - 12, false, 'floor'));
			add(new Hero(FP.screen.width / 2, FP.screen.height / 2));
			timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, OnTimer);
			timer.start();
			physicsWorld.SetWarmStarting(true);
		}
		
		override public function update():void
		{
			physicsWorld.Step(timeStep, velocityIterations, positionIterations);
			super.update();
		}
		
		private function OnTimer(event:TimerEvent):void
		{
			if (ticks % 2 == 0) 
				add(new Platform(FP.screen.width + SCALE, FP.screen.height - SCALE * 2.5, -3 ));
			if (ticks % 3 == 0) 
				add(new Platform( -SCALE, FP.screen.height - SCALE * 4.5, 2.5 ));
			if (ticks % 4 == 0)
				add(new Platform( FP.screen.width + SCALE, FP.screen.height - SCALE * 6.5, -2 ));
			if (ticks >= int.MAX_VALUE) ticks = 0;
			ticks++;
		}
		
	}

}