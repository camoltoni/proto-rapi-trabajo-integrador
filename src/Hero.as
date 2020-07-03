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
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author César Alejandro Moltoni
	 */
	public class Hero extends Entity 
	{
		[Embed(source = "assets/hero.png")] private const HERO:Class;
		[Embed(source = "assets/jump.mp3")] private const JUMP:Class;
		
		private const FORCE:b2Vec2 = new b2Vec2(11.33, 0);
		public var sprite:Spritemap;
		public var body:b2Body;
		private var onPlatform:Boolean = false;
		private var onFloor:Boolean = false;
		private var lastVel:b2Vec2;
		private var dead:Boolean = false;
		private var deadTween:ColorTween;
		private var jumpSFX:Sfx;
		
		public function Hero(x:Number=0, y:Number=0) 
		{
			sprite = new Spritemap(HERO, 22, 30);
			sprite.originX = sprite.width / 2;
			sprite.originY = sprite.height / 2;
			sprite.add('idle', [0, 1, 2, 3], 4, true);
			sprite.add('run', [4, 5, 6, 7, 8, 9], 8, true);
			sprite.add('jump', [10], 1, false);
			sprite.add('fall', [11], 1, false);
			
			super(x, y, sprite);
			setHitbox(sprite.width - 6, sprite.height, sprite.originX, sprite.originY);
			type = 'hero';
			MakeBody();
			lastVel = new b2Vec2();
			deadTween = new ColorTween();
			deadTween.tween(3, 0xffffff, 0xdc0404);
			jumpSFX = new Sfx(JUMP);
		}
		
		override public function update():void
		{
			if (!dead && collide('spike', x, y)) {
				dead = true;
				body.SetActive(false);
			}
			
			if (dead) {
				deadTween.update();
				sprite.color = deadTween.color;
				if (deadTween.percent >= 1) {
					FP.world = new MessageWorld('Die to win');
				}
				return;
			}
			if ((Input.pressed(Key.W) || Input.pressed(Key.SPACE)) && (onPlatform || onFloor)) {
				jumpSFX.play();
				body.SetAwake(false);
				body.ApplyImpulse(new b2Vec2(0, -17), body.GetWorldCenter());
			}
			var platform:Platform = Platform(collide('platform', x, y + 1));
			if (platform && y + halfHeight < platform.y - platform.halfHeight) {
				if (!onPlatform) {
					onPlatform = true;
					body.SetAwake(false);
					if (x - platform.x < -halfWidth) {
						body.ApplyImpulse(new b2Vec2(2, -1), body.GetWorldCenter());
					}
					if (x - platform.x  > halfWidth) {
						body.ApplyImpulse(new b2Vec2( -2, -1), body.GetWorldCenter());
					}
					body.SetAwake(true);
				} else {
					sprite.play('idle');
				}
			} else {
				onPlatform = false;
			}
			if (body.GetLinearVelocity().x != 0) lastVel.x = body.GetLinearVelocity().x;
			if (body.GetLinearVelocity().y > 0) lastVel.y = body.GetLinearVelocity().y;
			if (collide('floor', x, y + 1) && !onFloor) {
				onFloor = true;
				var newForce:b2Vec2 = lastVel.x < 0 ? FORCE.GetNegative():FORCE;
				body.SetAwake(false);
				body.ApplyForce(newForce, body.GetWorldCenter());
			}
			if (collide('wall', x + halfWidth, y) && onFloor && body.GetLinearVelocity().x >= 0) {
				body.SetAwake(false);
				body.ApplyForce(FORCE.GetNegative(), body.GetWorldCenter());
			}
			if (collide('wall', x - halfWidth, y) && onFloor && body.GetLinearVelocity().x <= 0) {
				body.SetAwake(false);
				body.ApplyForce(FORCE, body.GetWorldCenter());
			}
			if (!collide('floor', x , y + +1) && onFloor) onFloor = false;
			if (body.GetLinearVelocity().y < 0) sprite.play('jump');
			if (body.GetLinearVelocity().y > 0) sprite.play('fall');
			if (onFloor) sprite.play('run');
			sprite.flipped = lastVel.x < 0;
			x = body.GetPosition().x * GameWorld.SCALE;
			y = body.GetPosition().y * GameWorld.SCALE;
		}
		
		private function MakeBody():void
		{
			// Vars used to create bodies

			var bodyDef:b2BodyDef;
			var boxShape:b2PolygonShape;

			// Add ground body
			bodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.bullet = true;
			bodyDef.linearDamping = 0.5;
			bodyDef.fixedRotation = true;
			bodyDef.position.Set(x / GameWorld.SCALE, y / GameWorld.SCALE);
			boxShape = new b2PolygonShape();
			boxShape.SetAsBox((width) / GameWorld.SCALE / 2, height / GameWorld.SCALE / 2);
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