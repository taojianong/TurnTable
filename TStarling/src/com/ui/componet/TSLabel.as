package com.ui.componet {
	import starling.text.TextField;
	
	/**
	 * 基于Starling的文本标签
	 * @author taojianlong 2014/7/5 23:45
	 */
	public class TSLabel extends TextField{
		
		public var id:String = "";
		
		public function TSLabel() {
			super( 100 , 20 , "" );
			this.touchable = false;
		}	
		
		public function set isAutoSize( value:Boolean ):void {
			
			this.autoSize = value ? "left" : "none";
		}
		
		public function set algin( value:String ):void {
			
			this.hAlign = value;
		}
	}
}