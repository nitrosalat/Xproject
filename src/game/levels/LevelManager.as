package game.levels 
{
	import ru.antkarlov.anthill.AntCookie;
	/**
	 * ...
	 * @author mark
	 */
	public class LevelManager 
	{
		public static const TOTAL_LEVELS:int = 12;
		public var currentLevel:Level;
		public var currentLevelNum:int;
		private var levelCompleted:int;
		public function LevelManager() 
		{
			levelCompleted = Main.cookie.read("levelsCleared") as int;
			if (levelCompleted == 0) levelsCompleted = 1;
		}
		public function getNextLevel():Level
		{
			if (currentLevelNum == levelCompleted)
			{
			   levelsCompleted++;
			}
			return getLevel(currentLevelNum + 1);
		}
		public function getLevel(num:int):Level
		{
			if (num < 1 || num > TOTAL_LEVELS)
			{
				trace("level " + num + "не существует");
				return null;
			}
			var lvl:Level;
			switch(num)
			{
				case 1:
					lvl = new Level1();
					break;
			}
			currentLevel = lvl;
			currentLevelNum = num;
			return lvl;
		}
		public function get levelsCompleted():int
		{
			return levelCompleted;
		}
		public function set levelsCompleted(num:int):void
		{
			levelCompleted = num;
			Main.cookie.write("levelsCleared", levelCompleted, 10);
		}
	}

}