package 
{
	import Dot;
	
	public class PurpleDot extends Dot {
		public function PurpleDot():void {
			this.init();
			this.drawDot();
		} //end default constructor
		
		protected override function init():void {
			super.init();
			this.bgColor = 0xF607FF;
		} //end method init
	} //end class PurpleDot
} //end package