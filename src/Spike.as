package 
{
	import flash.system.ImageDecodingPolicy;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.Tween;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author César Alejandro Moltoni
	 */
	public class Spike extends Entity 
	{
		[Embed(source = "assets/spike.png")] private const SPIKES:Class;
		[Embed(source = "assets/fall.mp3")] private const FALL:Class;
		
		public var image:Image;
		private var collided:Boolean = false;
		private var posTween:VarTween;
		private var fallSFX:Sfx;
		public function Spike(x:Number=0, y:Number=0) 
		{
			image = new Image(SPIKES);
			super(x, y, image);
			setHitbox(image.width, image.height);
			posTween = new VarTween();
			posTween.tween(this, 'y', 144, 1, Ease.quadIn);
			type = 'spike';
			fallSFX = new Sfx(FALL);
		}
		
		override public function update():void
		{
			if (collide('hero', x, y) && !collided){
				fallSFX.play();
				collided = true;
			}
			if (collided && posTween.percent < 1){
				posTween.update();
			}
		}
	}

}