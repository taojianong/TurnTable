package com.ui.componet {
	import starling.events.Event;
	
	/**
	 * 复杂组件基类
	 * @author taojianlong 2015/4/23 23:26
	 */
	public class UIComponet extends ToolTipSprite {
		
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		
		//对齐相对父容器
		protected var _top:Number; //顶部对齐像素
		protected var _bottom:Number; //底部对齐像素
		protected var _left:Number; //左对齐像素
		protected var _right:Number; //右对齐像素		
		protected var _horizontalCenter:Number; //相对父元件中心便宜横向对齐
		protected var _verticalCenter:Number; //相对父元件中心便宜纵向对齐
		
		public function UIComponet( width:Number = 0 , height:Number = 0 ) {
			
			_width 	= width;
			_height = height;
			
			this.addEventListener( Event.ADDED_TO_STAGE , addToStageHandler );
			this.addEventListener( Event.ADDED_TO_STAGE , removeFromStageHandler );
		}
		
		protected function addToStageHandler( event:Event ):void {
			
			updateAlign();
		}
		
		protected function removeFromStageHandler( event:Event ):void { 
			
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
		
		/*************************对齐方式*************************/
		public function set top(value:Number):void {
			
			_top = value;
			if (this.parent && Math.abs(_top) >= 0) {
				this.y = _top;
			}
		}
		
		public function get top():Number {
			
			return _top;
		}
		
		public function set bottom(value:Number):void {
			
			_bottom = value;
			if (this.parent && Math.abs(_bottom) >= 0) {
				this.y = this.parent.height - this.height - _bottom;
			}
		}
		
		public function get bottom():Number {
			
			return _bottom;
		}
		
		public function set left(value:Number):void {
			
			_left = value;
			if (this.parent && Math.abs(_left) >= 0) {
				this.x = _left;
			}
		}
		
		public function get left():Number {
			
			return _left;
		}
		
		public function set right(value:Number):void {
			
			_right = value;
			if (this.parent && Math.abs(_right) >= 0) {
				this.x = this.parent.width - this.width - _right;
			}
		}
		
		public function get right():Number {
			
			return _right;
		}
		
		public function set verticalCenter(value:Number):void {
			
			_verticalCenter = value;
			
			if (this.parent && Math.abs(_verticalCenter) >= 0) {
				
				this.y = (this.parent.height - this.height) / 2 + value;
			}
		}		
		/**相对父元件中心便宜纵向对齐**/
		public function get verticalCenter():Number {
			
			return _verticalCenter;
		}
		
		public function set horizontalCenter(value:Number):void {
			
			_horizontalCenter = value;
			
			if (this.parent && Math.abs(_horizontalCenter) >= 0) {
				
				this.x = (this.parent.width - this.width) / 2 + value;
			}
		}		
		/**相对父元件中心便宜横向对齐**/
		public function get horizontalCenter():Number {
			
			return _horizontalCenter;
		}
		
		protected function updateAlign():void {
			
			this.top 				= _top;
			this.bottom 			= _bottom;
			this.left 				= _left;
			this.right 				= _right;
			this.verticalCenter 	= _verticalCenter;
			this.horizontalCenter 	= _horizontalCenter;
		}
	}

}