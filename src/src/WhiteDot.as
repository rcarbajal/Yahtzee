package 
{
	import Dot;
	
	public class WhiteDot extends Dot {
		public function WhiteDot():void {
			this.init();
			this.drawDot();
		} //end default constructor
		
		protected override function init():void {
			super.init();
			this.bgColor = 0xFFFFFF;
		} //end method init
	} //end class WhiteDot
} //end package