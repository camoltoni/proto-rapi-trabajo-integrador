package 
{
	import flash.display.BlendMode;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author César Alejandro Moltoni
	 */
	public class Skeleton extends Entity 
	{
		[Embed(source = "assets/skeleton.png")] private const SKELETON:Class;
		private static const ANIMS:Array = ['stay', 'idle', 'attack'];
		private var current:String = 'idle';
		private var timer:Timer;
		private var dead:Boolean = false;
		public var sprite:Spritemap;
		public function Skeleton(x:Number=0, y:Number=0) 
		{
			sprite = new Spritemap(SKELETON, 150, 150);
			sprite.add('stay', [8], 0, false);
			sprite.add('idle', [8, 9, 10, 11], 8, false);
			sprite.add('attack', [0, 1, 2, 3, 4, 5, 6, 7, 8], 8, false);
			sprite.add('death', [12, 13, 14, 15], 8, false);
			sprite.scale = 0.65;
			setHitbox(48, 48, -38, -32);
			super(x, y, sprite);
			type = 'skeleton';
			sprite.play('stay');
			timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, OnTimerComplete);
			timer.start();
			
		}
		
		//private function OnEndAnimation():void
		//{
			//complete = true;
		//}
		
		override public function update():void
		{
			
			if (collide('spike', x, y) && !dead)
				dead = true;
			if (dead)
				sprite.play('death');
			else
				sprite.play(current);
			super.update();
		}
		
		private function OnTimerComplete(event:TimerEvent):void
		{
			current = ANIMS[FP.rand(ANIMS.length)];
			timer.start();
		}
	}
}