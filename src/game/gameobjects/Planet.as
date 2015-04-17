package game.gameobjects 
{
	import flash.display.MovieClip;
	import ru.antkarlov.anthill.AntActor;
	import ru.antkarlov.anthill.AntBasic;
	
	/**
	 * ...
	 * @author mark
	 */
	public class Planet extends MovieClip
	{
		[Inspectable(type = "Number", defaultValue = "1")]
		public var radiusGravity:Number;
		public function Planet() 
		{
			
		}
		
	}

}