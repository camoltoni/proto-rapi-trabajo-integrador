package 
{
	import flash.system.ImageDecodingPolicy;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author César Alejandro Moltoni
	 */
	public class Spikes extends Entity 
	{
		[Embed(source = "assets/spikes_hollow.png")] private const SPIKES:Class;
		
		public var image:Image;
		public function Spikes(x:Number=0, y:Number=0) 
		{
			image = new Image(SPIKES);
			super(x, y, image);
		}
		
		
	}

}