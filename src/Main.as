package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import game.states.MainMenuState;
	import game.states.SplashState;
	import ru.antkarlov.anthill.AntCookie;
	import ru.antkarlov.anthill.Anthill;
	import ru.antkarlov.anthill.AntG;

	/**
	 * ...
	 * @author mark
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		public static var cookie:AntCookie = new AntCookie();
		private var engine:Anthill;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			engine = new Anthill(MainMenuState, 60);
			addChild(engine);
			
			//cookie.open("GALAXYROCKET");
			//trace(cookie.read("levelsCleared"));
			
		}	
	}
	
}