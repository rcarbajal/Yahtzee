package 
{
	import Dot;
	
	public class RedDot extends Dot {
		public function RedDot():void {
			this.init();
			this.drawDot();
		} //end default constructor
		
		protected override function init():void {
			super.init();
			this.bgColor = 0xFF0000;
		} //end method init
	} //end class RedDot
} //end package