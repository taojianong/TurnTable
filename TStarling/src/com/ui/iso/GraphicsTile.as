package com.ui.iso {
	
	import starling.display.DisplayObject;
	import starling.text.TextField;
	
	/**
	 * 添加外部等角形状
	 * @author cl 2013/11/15 10:48
	 */
	public class GraphicsTile extends IsoObject {
		
		private var txt:TextField;
		
		public function GraphicsTile( size:Number , classRes:Class , xoffset:Number , yoffset:Number ) {
			
			super( size );
			
			var gfx:DisplayObject = new classRes as DisplayObject;
			gfx.x = -xoffset;
			gfx.y = -yoffset;
			this.addChild( gfx );
			
			txt 		= new TextField();
			txt.width 	= size * 2;
			txt.hAlign 	= "center";
			txt.color 	= 0xff0000;
			txt.x 		= -size ;
			txt.y 		= -size / 2;
			this.addChild( txt );
		}
		
		public function set label( value:String ):void {
			
			txt.text = value;
		}
		
		public function get label():String {
			
			return txt.text;
		}
	}

}