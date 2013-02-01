package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	public class Dot extends Sprite {
		//[Embed(source = '../media/circle.gif')]
		//private var TheDot:Class;
		
		protected var bgColor:uint;
        protected var size:uint;
        protected var offset:uint;
		
		/*
		public function Dot():void {
			this.init();
			/*
			var dispObj:DisplayObject = new TheDot();			
			addChild(dispObj);
			*
		} //end default constructor
		*/
		
		public function destroy():void {
			//this.removeChildAt(0);
			this.filters = new Array();
			this.graphics.clear();
		} //end method destroy
		
		protected function init():void {
			this.bgColor = 0x666666;
			this.size = 8;
			this.offset = 10;
		} //end method init
		
		protected function drawDot():void {
            this.draw();
            var filter:BitmapFilter = this.getBitmapFilter();
            var myFilters:Array = new Array();
            myFilters.push(filter);
            this.filters = myFilters;
		} //end method drawDot

        protected function getBitmapFilter():BitmapFilter {
            //var color:Number = 0xB7FF4C;
            var alpha:Number = 1;
            var blurX:Number = 5;
            var blurY:Number = 5;
            var strength:Number = 10;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;

            return new GlowFilter(this.bgColor, alpha, blurX, blurY, strength, quality, inner, knockout);
        }

        protected function draw():void {
            this.graphics.beginFill(bgColor);
            this.graphics.drawRect(offset, offset, size, size);
            this.graphics.endFill();
        }
	} //end class Dot
} //end package