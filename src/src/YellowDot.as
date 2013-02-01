package 
{
	import Dot;
	
	public class YellowDot extends Dot {
		public function YellowDot():void {
			this.init();
			this.drawDot();
		} //end default constructor
		
		protected override function init():void {
			super.init();
			this.bgColor = 0xFFAF05;
		} //end method init
	} //end class YellowDot
} //end package