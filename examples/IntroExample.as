package
{
	import com.genome2d.Genome2D;
	import com.genome2d.components.physics.nape.GNapeBody;
	import com.genome2d.components.renderables.GSprite;
	import com.genome2d.context.GContextConfig;
	import com.genome2d.context.stats.GStats;
	import com.genome2d.node.GNode;
	import com.genome2d.node.factory.GNodeFactory;
	import com.genome2d.physics.GNapeFactory;
	import com.genome2d.physics.GNapePhysics;
	import com.genome2d.textures.factories.GTextureFactory;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import nape.geom.Vec2;
	import nape.phys.BodyType;

	[SWF(width="800", height="600", backgroundColor="#000000", frameRate="60")]
	public class IntroExample extends Sprite
	{
		[Embed(source = "//../assets/crate.jpg")]
		static private const CrateGFX:Class;

		private var _cGenome2D:Genome2D;

		public function IntroExample()
		{
			// Initialization stuff for more info look into InitializeGenome2D example
			_cGenome2D = Genome2D.getInstance();
			_cGenome2D.onInitialized.addOnce(onGenome2DInitialized);
			
			var config:GContextConfig = new GContextConfig(new Rectangle(0, 0, 640, 960), stage);
			config.enableDepthAndStencil = true;
			config.statsClass = GStats;
			GStats.visible = true;
			GStats.scaleX = GStats.scaleY = 1.5;
			_cGenome2D.init(config);
		}

		protected function onGenome2DInitialized():void
		{
			// Create our crate texture
			GTextureFactory.createFromEmbedded("crate", CrateGFX);

			// Initialize nape physics
			Genome2D.physics = new GNapePhysics(Vec2.get(0, 200));

			// Create a static physics boundary around the stage
			var body:GNapeBody = GNodeFactory.createNodeWithComponent(GNapeBody) as GNapeBody;
			body.napeBody = GNapeFactory.createStaticBoundary(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight), 600);
			_cGenome2D.root.addChild(body.node);
			
			// Manually add body to space
			body.addToSpace();
			
			// Don't move me
			body.type = GNapeBody.STATIC;

			// Create 100 boxes
			for (var i:int = 0; i < 10; ++i)
			{
				createBox(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight);
			}

			// Hook up a mouse click event to create box upon interaction
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}

		protected function onClick(event:MouseEvent):void
		{
			createBox(stage.mouseX, stage.mouseY);
		}

		// Create a dynamic nape box
		protected function createBox(p_x:Number, p_y:Number):void
		{
			// Create a node
			var node:GNode = GNodeFactory.createNode();
			// Create a sprite to render the box
			var sprite:GSprite = node.addComponent(GSprite) as GSprite;
			sprite.textureId = "crate";
			// Create a nape body component for physical representation
			var body:GNapeBody = sprite.node.addComponent(GNapeBody) as GNapeBody;
			// Use nape helper to create a nape body box representation
			body.napeBody = GNapeFactory.createBox(32, 32, BodyType.DYNAMIC);

			// Move the node to a specified position
			node.transform.setPosition(p_x, p_y);
			// Add it to the root
			_cGenome2D.root.addChild(sprite.node);

			// Manually add body to space
			body.addToSpace();
		}
	}
}
