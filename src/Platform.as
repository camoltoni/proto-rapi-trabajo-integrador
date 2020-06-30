package 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author César Alejandro Moltoni
	 */
	public class Platform extends Entity 
	{
		[Embed(source = "assets/platform.png")] private const PLATFORM:Class;
		public var image:Image;
		public var body:b2Body;
		
		public function Platform(x:Number=0, y:Number=0, vel:Number = 0) 
		{
			image = new Image(PLATFORM);
			image.originX = image.width / 2;
			image.originY = image.height / 2;
			type = 'platform';
			super(x, y, image);
			setHitbox(image.width, 0, image.originX, image.originY);
			MakeBody();
			body.SetLinearVelocity(new b2Vec2(vel, 0));
		}
		
		override public function update():void
		{
			x = body.GetPosition().x * GameWorld.SCALE;
			y = body.GetPosition().y * GameWorld.SCALE;
		
			if (x > FP.screen.width + width || x < -width) FP.world.remove(this);
		}
		
		override public function removed():void
		{
			GameWorld.physicsWorld.DestroyBody(body);
		}
		
		private function MakeBody():void
		{
			// Vars used to create bodies

			var bodyDef:b2BodyDef;
			var boxShape:b2PolygonShape;

			// Add ground body
			bodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_kinematicBody;
			bodyDef.bullet = true;
			bodyDef.position.Set(x / GameWorld.SCALE, y / GameWorld.SCALE);
			boxShape = new b2PolygonShape();
			boxShape.SetAsBox(image.width / GameWorld.SCALE / 2, image.height / GameWorld.SCALE / 2);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = boxShape;
			fixtureDef.friction = 0.6;
			fixtureDef.density = 1;
			fixtureDef.restitution = 0;
 
			body = GameWorld.physicsWorld.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
		}
		
	}

}