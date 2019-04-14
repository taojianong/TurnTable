package com.ui.componet {
	
	/**
	 * 基于Starling的容器
	 * @author taojianlong 2015/5/6 22:46
	 */
	public class Container extends TSprite {
		
		protected var _contentWidth:Number 	= 0;
		protected var _contentHeight:Number = 0;
		
		public function Container() {
			
			super();
		}
		
		/**容器宽度**/
		public function get contentWidth():Number {
		
			return _contentWidth;
		}
		
		/***容器高度**/
		public function get contentHeight():Number {
		
			return _contentHeight;
		}
	}
}