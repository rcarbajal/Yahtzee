package 
{
	import Dot;
	
	public class OrangeDot extends Dot {
		public function OrangeDot():void {
			this.init();
			this.drawDot();
		} //end default constructor
		
		protected override function init():void {
			super.init();
			this.bgColor = 0xFF6702;
		} //end method init
	} //end class OrangeDot
} //end package