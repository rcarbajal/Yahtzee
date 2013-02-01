package 
{
	import Dot;
	
	public class GreenDot extends Dot {
		public function GreenDot():void {
			this.init();
			this.drawDot();
		} //end default constructor
		
		protected override function init():void {
			super.init();
			this.bgColor = 0xB7FF4C;
		} //end method init
	} //end class GreenDot
} //end package