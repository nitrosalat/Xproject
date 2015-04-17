package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import ru.antkarlov.anthill.AntPreloader;
	
	/**
	 * ...
	 * @author mark
	 */
	public class Preloader extends AntPreloader
	{
		private var preloader_mc:Preloader_mc;
		public function Preloader() 
		{
			super();
			entryClass = "Main";
			preloader_mc = new Preloader_mc();
			addChild(preloader_mc);
		}
		override public function update(aPercent:Number):void
		{
			super.update(aPercent);
			(preloader_mc.getChildByName("percent") as TextField).text = int(aPercent * 100).toString();
			trace("Loading:", aPercent * 100);
		}
		override public function completed():void
		{
			super.completed();
			removeChild(preloader_mc);
			trace("Loading is completed!");
		}	
		
	}
	
}