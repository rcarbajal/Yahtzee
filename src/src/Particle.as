package
{
	import flash.display.*;
	import mx.core.UIComponent;
 
	public class Particle
	{
		public var clip:DisplayObject;
		public var xVelocity:Number = 0;
		public var yVelocity:Number = 0;
		public var drag:Number = 1;
		public var gravity:Number = 0;
		public var shrink:Number = 1;
		public var fade:Number = 0;
	 
		// Constructor to create particle object
		public function Particle(particleImage:Sprite, target:DisplayObjectContainer, xpos:Number, ypos:Number)
		{
			// create particle clip
			clip = particleImage;
			var uic:UIComponent = new UIComponent();
			uic.addChild(clip);
			target.addChild(uic);
			
			//position particle
			clip.x = xpos;
			clip.y = ypos;
		} //end constructor
		
		public function update():void
		{
			clip.x += xVelocity;
			clip.y += yVelocity;
		 
			xVelocity *= drag;
			yVelocity *= drag;
			 
			yVelocity += gravity;
			clip.scaleX *= shrink;
			clip.scaleY *= shrink;
			 
			clip.alpha -= fade;
		} //end method update
		
		public function destroy():void
		{
			var dot:Dot = Dot(clip);
			dot.destroy();
			dot = null;
			
			var uic:UIComponent = UIComponent(clip.parent);
			uic.removeChild(clip);
			clip = null;
			
			uic.parent.removeChild(uic);
			uic = null;
		} //end method destroy
	} //end class Particle
} //end package