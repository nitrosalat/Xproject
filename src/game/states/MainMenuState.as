package game.states 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import game.gameobjects.Rocket;
	import ru.antkarlov.anthill.AntButton;
	import ru.antkarlov.anthill.AntG;
	import ru.antkarlov.anthill.AntState;
	
	/**
	 * ...
	 * @author mark
	 */
	public class MainMenuState extends AntState
	{
		private var view:MainMenuScreen_mc;
		public function MainMenuState() 
		{
			
			view = new MainMenuScreen_mc();
			addChild(view);
		}
		override public function create():void 
		{
			(view.getChildByName("playButton") as SimpleButton).addEventListener(MouseEvent.CLICK, onPlayClick);
			super.create();
		}
		private function onPlayClick(e:MouseEvent):void 
		{
			AntG.anthill.switchState(new LevelSelectState());
		}
	    override public function update():void
		{
			super.update();
		}
	
		
	}

}