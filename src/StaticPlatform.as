package 
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2FixtureDef;
	import flash.system.ImageDecodingPolicy;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author César Alejandro Moltoni
	 */
	public class StaticPlatform extends Entity 
	{
		[Embed(source = "assets/separator.png")] private const SEPA:Class;
		public var image:Image;
		public var body:b2Body;
		
		public function StaticPlatform(x:Number=0, y:Number=0) 
		{
			image = new Image(SEPA);
			image.originX = image.width / 2;
			image.originY = image.height / 2;
			image.alpha = 0.0;
			super(x, y, image);
			setHitbox(image.width, 0, image.originX, image.originY);
			MakeBody();
			type = 'floor';
		}
		
		private function MakeBody():void
		{
			// Vars used to create bodies

			var bodyDef:b2BodyDef;
			var boxShape:b2PolygonShape;

			// Add ground body
			bodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_staticBody;
			bodyDef.position.Set(x / GameWorld.SCALE, y / GameWorld.SCALE);
			boxShape = new b2PolygonShape();
			boxShape.SetAsBox(width / GameWorld.SCALE / 2, height / GameWorld.SCALE / 2);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = boxShape;
			fixtureDef.friction = 0.3;
			fixtureDef.density = 1; // static bodies require zero density
			fixtureDef.restitution = 0;
			
			body = GameWorld.physicsWorld.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
		}
		
	}

}