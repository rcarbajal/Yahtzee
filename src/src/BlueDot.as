package 
{
	import Dot;
	
	public class BlueDot extends Dot {
		public function BlueDot():void {
			this.init();
			this.drawDot();
		} //end default constructor
		
		protected override function init():void {
			super.init();
			this.bgColor = 0x00D8FF;
		} //end method init
	} //end class BlueDot
} //end package