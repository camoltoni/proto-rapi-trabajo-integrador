package 
{
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.Tween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author César Alejandro Moltoni
	 */
	public class MessageWorld extends World 
	{
		public var message:String;
		protected var titleText:Text;
		protected var pressText:Text;
		private var titleTweenIn:VarTween;
		private var titleTweenOut:VarTween;
		private var pressTween:VarTween;
		private var waiting:Boolean = false;
		
		public function MessageWorld(message:String) 
		{
			super();
			this.message = message;
			
			this.titleText = new Text(message);
			this.pressText = new Text("Press SPACE BAR or W to start");
			
			this.titleText.color = 0x282828;
			this.titleText.scale = 2;
			this.pressText.color = 0x282828;
			this.pressText.alpha = 0;
			
			this.titleText.originX = titleText.width / 2;
			this.titleText.x = FP.screen.width / 2;
			this.pressText.x = (FP.screen.width - this.pressText.width) / 2;
			
			this.titleText.y = -100;
			this.pressText.y = FP.screen.height * 0.75;
			
			titleTweenIn = new VarTween(function():void {addTween(pressTween); });
			titleTweenOut = new VarTween(function():void {FP.world = new GameWorld(); });
			pressTween = new VarTween(function():void {waiting = true; }, LOOPING);
			titleTweenIn.tween(titleText, "y", FP.screen.height * 0.25, 2, Ease.backOut);
			titleTweenOut.tween(titleText, "scale", 0, 2, Ease.backIn);
			pressTween.tween(pressText, "alpha", 1, 0.7, Ease.expoInOut);

			addTween(titleTweenIn);
			addGraphic(titleText); 
			addGraphic(pressText);
		}
		
		override public function update():void
		{
			if ((Input.pressed(Key.SPACE) || Input.pressed(Key.W)) && waiting){
				removeTween(titleTweenIn);
				removeTween(pressTween);
				pressText.visible = false;
				addTween(titleTweenOut);
			}
			super.update();
		}
		
	}

}