package
{
import net.flashpunk.Engine;
import net.flashpunk.FP;


	public class Main extends Engine
	{
		public function Main()
		{
			super(640, 480, 60, false);
			FP.screen.color = 0xFFE0BD;
			FP.world = new MessageWorld('Die to win');
		}
	}
}