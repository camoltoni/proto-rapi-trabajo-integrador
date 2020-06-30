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
	public class Wall extends Entity 
	{
		[Embed(source = "assets/wall_v.png")] private const WALL_V:Class;
		[Embed(source = "assets/wall_h.png")] private const WALL_H:Class;
		
		public var image:Image;
		public var body:b2Body;
		
		public function Wall(x:Number=0, y:Number=0, vertical:Boolean = true, type:String = 'wall') 
		{
			if (vertical) {
				image = new Image(WALL_V);
			} else  {
				image = new Image(WALL_H);
			}
			this.type = type;
			image.originX = image.width / 2;
			image.originY = image.height / 2;
			super(x, y, image);
			setHitbox(image.width, image.height, image.originX, image.originY);
			MakeBody();
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