package game.states 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import ru.antkarlov.anthill.AntG;
	import ru.antkarlov.anthill.AntState;
	
	/**
	 * ...
	 * @author mark
	 */
	public class SplashState extends AntState 
	{
		private var view:Splash_mc = new Splash_mc();
		public function SplashState() 
		{
			addChild(view);
			var timer:Timer = new Timer(3000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			timer.start();
		}
		private function onComplete(e:TimerEvent):void 
		{
			AntG.anthill.switchState(new MainMenuState());
		}
		override public function dispose():void
		{
			removeChild(view);
			view = null;
		}
	}

}