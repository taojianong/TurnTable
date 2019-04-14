package com.ui.componet {
	
	/**
	 * 条目基类
	 * @author taojianlong 2014/7/4 0:48
	 */
	public class ItemBase extends UIComponet {
		
		public function ItemBase( width:Number = 100 , height:Number = 20 ) {
			
			super( width , height );
		}
		
		override public function get width():Number {
			
			return _width;
		}
		
		override public function set width(value:Number):void {
			
			_width = value;
		}
		
		override public function get height():Number {
			
			return _height;
		}
		
		override public function set height(value:Number):void {
			
			_height = value;
		}
	}
}