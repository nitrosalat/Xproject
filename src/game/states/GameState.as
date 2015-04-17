package game.states
{
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Collision.b2Distance;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	import flash.accessibility.ISearchableText;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import game.gameobjects.Asteroid;
	import game.gameobjects.FuelBar;
	import game.gameobjects.GameStar;
	import game.gameobjects.Planet;
	import game.gameobjects.Rocket;
	import game.levels.Level;
	import game.levels.LevelManager;
	import ru.antkarlov.anthill.AntCamera;
	import ru.antkarlov.anthill.AntG;
	import ru.antkarlov.anthill.Anthill;
	import ru.antkarlov.anthill.AntMath;
	import ru.antkarlov.anthill.AntState;
	import Box2D.Dynamics.b2Body;
	import utils.PixelPerfectCollisionDetection;
	/**
	 * ...
	 * @author mark
	 */
	public class GameState extends AntState
	{
		private var world:b2World = new b2World(new b2Vec2(0, 0), true);
		private var rocket:b2Body;
		private var planetsArray:Vector.<b2Body>;
		private var finishFlat:Finish_mc;
		private var worldScale:Number = 30;
		private var level:Level;
		private var orbitCanvas:Sprite;
		private var camera:AntCamera;
		private var mainCanvas:Sprite;
		private var isRunning:Boolean = true;
		private var gamescreen:GameScreen_mc = new GameScreen_mc();
		private var score:int = 0;
		private var stars:Vector.<GameStar> = new Vector.<GameStar>();
		private var gui:GameGUIPanel_mc = new GameGUIPanel_mc();
		
		private var levelManager:LevelManager;
		public function GameState(level:Level, levelMAnager:LevelManager)
		{
			this.level = level;
			this.levelManager = levelMAnager;
			planetsArray = new Vector.<b2Body>();
			//////////////////////////////////////////////
			addChild(gamescreen);
			mainCanvas = new Sprite();
			addChild(mainCanvas);
		}
		
		override public function create():void
		{
			(gui.getChildByName("reset") as SimpleButton).addEventListener(MouseEvent.CLICK, onResetClickHandler);
			(gui.getChildByName("toMenu") as SimpleButton).addEventListener(MouseEvent.CLICK, onToMenuHandler);
			addChild(gui);
			//(gamescreen.getChildByName("reset") as SimpleButton).addEventListener(MouseEvent.CLICK, onResetClickHandler);
			orbitCanvas = new Sprite();
			orbitCanvas.graphics.lineStyle(1, 0x0000FF);
			for (var count:int = 0; count < level.numChildren; count++)
			{
				var obj:* = level.getChildAt(count);
				if (obj is Rocket)
				{
					addRocket(obj);
					stage.focus = obj;
				}
				else if (obj is Planet)
				{
					addPlanet(obj as Planet);
				}
				else if (obj is Finish_mc)
				{
					finishFlat = obj;
				}
				else if (obj is GameStar)
				{
					stars.push(obj);
				}
				else if (obj is Asteroid)
				{
					addAsteroid(obj);
				}
			}
			mainCanvas.addChild(level);
			mainCanvas.addChild(orbitCanvas);
			
			debugDraw();
			AntG.anthill.start();
		}
		
		private function onToMenuHandler(e:MouseEvent):void 
		{
			AntG.anthill.switchState(new MainMenuState());
		}
		
		private function onResetClickHandler(e:MouseEvent):void 
		{
			resetLevel();
		}
		private function addAsteroid(asteroid:Asteroid):void
		{
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.restitution = 0;
			fixtureDef.density = 1;
			fixtureDef.friction = 0.1;
			var circleShape:b2CircleShape = new b2CircleShape(asteroid.width / 2 / worldScale);
			fixtureDef.shape = circleShape;
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.userData = asteroid;
			bodyDef.position.Set(asteroid.x / worldScale, asteroid.y / worldScale);
			var ast:b2Body = world.CreateBody(bodyDef);
			ast.CreateFixture(fixtureDef);
		}
		private function addRocket(rocket:Rocket):void
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.userData = rocket;
			bodyDef.type = b2Body.b2_dynamicBody;
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.restitution = 0;
			fixtureDef.density = 1;
			var shape:b2PolygonShape = new b2PolygonShape();
			var normalize:Rocket1 = new Rocket1();
			shape.SetAsBox(normalize.width / 4 / worldScale, normalize.height / 2.5 / worldScale);
			fixtureDef.shape = shape;
			bodyDef.position.Set(rocket.x / worldScale, rocket.y / worldScale);
			bodyDef.angle = AntMath.toRadians(rocket.rotation);
			bodyDef.angularDamping = 1;
			bodyDef.linearDamping = 0.5;
			this.rocket = world.CreateBody(bodyDef);
			this.rocket.CreateFixture(fixtureDef);
			(rocket.getChildByName("fuelBar") as FuelBar).reset(100);
		}
		
		private function addPlanet(obj:Planet):void
		{
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.restitution = 0;
			fixtureDef.density = 1;
			fixtureDef.friction = 0.1;
			var circleShape:b2CircleShape = new b2CircleShape(obj.width / 2 / worldScale);
			fixtureDef.shape = circleShape;
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.userData = obj;
			bodyDef.position.Set(obj.x / worldScale, obj.y / worldScale);
			var thePlanet:b2Body = world.CreateBody(bodyDef);
			planetsArray.push(thePlanet);
			thePlanet.CreateFixture(fixtureDef);
			orbitCanvas.graphics.beginFill(0x0099FF,0.05);
			orbitCanvas.graphics.drawCircle(obj.x, obj.y, obj.radiusGravity);
			orbitCanvas.graphics.endFill();
		}
		
		private function debugDraw():void
		{
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			mainCanvas.addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			debugDraw.SetFillAlpha(0.5);
			world.SetDebugDraw(debugDraw);
		}
		private function doWin():void
		{
			isRunning = false;
			AntG.anthill.stop();
			var panel:VictoryPanel_mc = new VictoryPanel_mc();
			(panel.getChildByName("menubtn") as SimpleButton).addEventListener(MouseEvent.CLICK, onToMenuHandler);
			(panel.getChildByName("retrybtn") as SimpleButton).addEventListener(MouseEvent.CLICK, onResetClickHandler);
			(panel.getChildByName("nextbtn") as SimpleButton).addEventListener(MouseEvent.CLICK, onNextButton);
			panel.x = AntG.widthHalf;
			panel.y = AntG.heightHalf;
			addChild(panel);
		}
		
		private function onNextButton(e:MouseEvent):void 
		{
			//AntG.anthill.switchState(new GameState(Level.));
		}
		private function doDefeat():void 
		{
			isRunning = false;
			AntG.anthill.stop();
			var panel:DefeatPanel_mc = new DefeatPanel_mc();
			panel.x = AntG.widthHalf;
			panel.y = AntG.heightHalf;
			addChild(panel);
		}
		
		private var currentVelocity:Number;
		private var differenceVelocity:Number;
		override public function update():void
		{	
			if (!isRunning) return;
			if (PixelPerfectCollisionDetection.isColliding(rocket.GetUserData(),finishFlat,this,true))
			{
				doWin();
			}
			for each(var star:GameStar in stars)
			{
				if (PixelPerfectCollisionDetection.isColliding(rocket.GetUserData(), star, this, true))
				{
					level.removeChild(star);
					addScore(1000);
				}
			}
			world.Step(AntG.elapsed, 10, 10);
			world.ClearForces();
			differenceVelocity = currentVelocity - rocket.GetLinearVelocity().Length();
			if (Math.abs(differenceVelocity) > 2 ) {
				var ex:Explosion_mc = new Explosion_mc();
				ex.x = rocket.GetUserData().x;
				ex.y = rocket.GetUserData().y;
				mainCanvas.addChild(ex);
				rocket.GetUserData().visible = false;
				world.DestroyBody(rocket);
				doDefeat();
			}
			currentVelocity = rocket.GetLinearVelocity().Length();
			if (AntG.keys.isPressed('UP'))
			{
				(rocket.GetUserData() as MovieClip).gotoAndStop(2);
			}
			if (AntG.keys.isReleased('UP'))
			{
				(rocket.GetUserData() as MovieClip).gotoAndStop(1);
			}
			if (AntG.keys.isDown('UP'))
			{
				var fuel:Number = ((rocket.GetUserData() as MovieClip).getChildByName("fuelBar") as FuelBar).currentFuel;
				var angle:Number = rocket.GetAngle();
				angle -= 0.5 * Math.PI;
				var rocketX:Number = Math.cos(angle) * 10;
				var rocketY:Number = Math.sin(angle) * 10;
				if(fuel >= 0)
				rocket.ApplyForce(new b2Vec2(rocketX, rocketY), rocket.GetWorldCenter());
				else
				(rocket.GetUserData() as MovieClip).gotoAndStop(1);
				fuel -= 0.5;
				((rocket.GetUserData() as MovieClip).getChildByName("fuelBar") as FuelBar).update(fuel);
			}
			//rocket.ApplyForce(new b2Vec2(AntMath.randomRangeNumber( -10, 10), AntMath.randomRangeNumber( -10, 10)), rocket.GetWorldCenter());
			if (AntG.keys.isDown('LEFT'))
			{
				rocket.ApplyTorque(-1);
			}
			if (AntG.keys.isDown('RIGHT'))
			{
				rocket.ApplyTorque(1);
			}
			var rocketPos:b2Vec2 = rocket.GetWorldCenter();
			for each (var planet:b2Body in planetsArray)
			{
				var planetRadius:Number = planet.GetUserData().radiusGravity / worldScale;
				var planetPos:b2Vec2 = planet.GetWorldCenter();
				var distance:b2Vec2 = new b2Vec2();
				distance.Add(rocketPos);
				distance.Subtract(planetPos);
				var lengthDist:Number = distance.Length();
				if (lengthDist <= planetRadius)
				{
					distance.NegativeSelf();
					var vecSum:Number = Math.abs(distance.x) + Math.abs(distance.y);
					distance.Multiply((1 / vecSum) * planetRadius / lengthDist);
					rocket.ApplyForce(distance, rocket.GetWorldCenter());
				}
			}
			rocket.GetUserData().x = rocket.GetPosition().x * worldScale;
			rocket.GetUserData().y = rocket.GetPosition().y * worldScale;
			rocket.GetUserData().rotation = AntMath.toDegrees(rocket.GetAngle());
			world.DrawDebugData();
		}
		private function resetLevel():void
		{
			AntG.anthill.switchState(new GameState(levelManager.getLevel(levelManager.currentLevelNum),levelManager));
		}
		private function addScore(value:int):void
		{
			this.score += value;
			(gui.getChildByName("score") as TextField).text = this.score.toString();
		}
	}
}