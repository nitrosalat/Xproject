package game.states 
{
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import game.levels.Level;
	import ru.antkarlov.anthill.AntCookie;
	import ru.antkarlov.anthill.AntG;
	import ru.antkarlov.anthill.AntState;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import game.levels.*;
	import utils.ClassLoader;
	
	/**
	 * ...
	 * @author mark
	 */
	public class LevelSelectState extends AntState 
	{
		private var view:LevelSelectScreen_mc;
		private var levelManager:LevelManager = new LevelManager;
		public function LevelSelectState() 
		{
			Level.init();
			view = new LevelSelectScreen_mc();
		}
		override public function create():void
		{
			for (var i:int = 1; i <= 12; i++)
			{
				var name:String = "Level" + i.toString();
				trace(i,levelManager.levelsCompleted)
				if (i > levelManager.levelsCompleted)
				{
				  (view.getChildByName(name) as SimpleButton).alpha = 0.5;
				  (view.getChildByName(name) as SimpleButton).enabled = false;
				}
				else
				{
					(view.getChildByName(name) as SimpleButton).addEventListener(MouseEvent.CLICK,onLevelClick);
				}
				
			}
			(view.getChildByName("backButton") as SimpleButton).addEventListener(MouseEvent.CLICK, onBackClick);
			addChild(view);
			
		}
		
		private function onBackClick(e:MouseEvent):void 
		{
			AntG.anthill.switchState(new MainMenuState());
		}
		private function onLevelClick(e:MouseEvent):void 
		{
			var level:Level = levelManager.getLevel(parseInt((e.target as SimpleButton).name.substr(5,(e.target as SimpleButton).name.length - 1)));
			AntG.anthill.switchState(new GameState(level, levelManager));
		}
	}

}