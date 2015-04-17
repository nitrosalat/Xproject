package game.gameobjects 
{
	import flash.display.MovieClip;
	import ru.antkarlov.anthill.AntMath;
	
	/**
	 * ...
	 * @author mark
	 */
	public class FuelBar extends MovieClip 
	{
		public var fulFuel:Number;
		public var currentFuel:Number;
		public function FuelBar() 
		{
			stop();
		}
		public function update(fuel:Number):void
		{
			currentFuel = fuel;
			var percent:Number = AntMath.toPercent(fuel, fulFuel);
			this.gotoAndStop(Math.round(AntMath.fromPercent(percent, this.totalFrames)));
		}
		public function reset(fullFuel:Number):void
		{
			this.fulFuel = fullFuel;
			this.currentFuel = fullFuel;
			this.gotoAndStop(this.totalFrames);
		}
	}

}