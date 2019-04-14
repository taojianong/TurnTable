package com.ui.componet {
	
	import com.ui.SpriteAlign;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	
	/**
	 * 横向组件
	 * @author taojianlong 2015/5/7 22:11
	 */
	public class HSprite extends UIComponet {
		
		//对齐方式见 SpriteAlign
		private var _verticalAlign:String 	= "top"; //纵向对齐方式
		private var _horizontalAlign:String = "left"; //横向对齐方式
		
		//容器高宽度,初始设置为0，当对齐方式不为左上时先设置此容器的高宽度，才会看到对齐效果
		private var _contentWidth:Number 	= 0;
		private var _contentHeight:Number 	= 0;
		
		private var _gap:Number = 0; //元件间间隔
		private var _maxHeight:Number = 0;
		
		private var initX:Number = 0; //初始子元件放置X位置
		private var initY:Number = 0; //初始子元件放置Y位置
		
		public function HSprite() {
			
			super();
		}
		
		public function set contentWidth(value:Number):void {
			
			_contentWidth = value;
		}
		
		public function get contentWidth():Number {
			
			return _contentWidth;
		}
		
		public function set contentHeight(value:Number):void {
			
			_contentHeight = value;
		}
		
		public function get contentHeight():Number {
			
			return _contentHeight;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			
			super.addChild(child);
			
			this.requireLayout();
			
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			
			super.addChildAt(child, index);
			
			this.requireLayout();
			
			return child;
		}
		
		override public function removeChild(child:DisplayObject, dispose:Boolean = false):DisplayObject {
			
			super.removeChild(child, dispose);
			
			requireLayout();
			
			return child;
		}
		
		override public function removeChildAt(index:int, dispose:Boolean = false):DisplayObject {
			
			var child:DisplayObject = super.removeChildAt(index, dispose);
			
			this.requireLayout();
			
			return child;
		}
		
		protected function requireLayout():void {
			
			this.update();
		}
		
		//更新组件
		public function update():void {
			
			var i:uint;
			var displayObject:DisplayObject;
			var prevObject:DisplayObject;
			
			initX = 0;
			if (this.nomalWidth > 0) {
				
				switch (_horizontalAlign) {
					
					//左对齐
					case SpriteAlign.LEFT: 
						initX = 0;
						break;
					//右对齐
					case SpriteAlign.RIGHT: 
						initX = this.contentWidth - this.nomalWidth;
						break;
					//居中对齐
					case SpriteAlign.CENTER: 
						initX = (this.contentWidth - this.nomalWidth) / 2;
						break;
				
				}
			}
			for (i = 0; i < this.numChildren; i++) {
				
				displayObject = this.getChildAt(i) as DisplayObject;
				
				switch (_verticalAlign) {
					
					//顶端对齐
					case SpriteAlign.TOP: 
						displayObject.y = 0;
						break;
					//居中对齐	
					case SpriteAlign.MIDDLE: 
						displayObject.y = (_contentHeight - displayObject.height) / 2;
						break;
					//底部对齐
					case SpriteAlign.BOTTOM: 
						displayObject.y = _contentHeight - displayObject.height;
						break;
				}
				
				if (i > 0) {
					
					prevObject = this.getChildAt(i - 1);
					displayObject.x = prevObject.x + prevObject.width + _gap;
					
				} else {
					displayObject.x = initX;
				}
			}
			
			//计算真实高宽度
			this.width = this.nomalWidth;
			this.height = 0;
			for (i = 0; i < this.numChildren; i++) {
				this.height = Math.max(this.height, this.getChildAt(i).height);
			}
		}
		
		/**
		 * 计算子元素的尺寸
		 */
		protected function measure():void {
			
			var startWidth:Number = 0;
			var startHeight:Number = 0;
			var i:int;
			var child:DisplayObject;
			var childPoint:Point;
			for (i = 0; i < this.numChildren; i++) {
				
				child = this.getChildAt(i);
				childPoint = new Point(child.x + child.width, child.height);
				
				startWidth 	= childPoint.x > startWidth ? childPoint.x : startWidth;
				startHeight = childPoint.y > startHeight ? childPoint.y : startHeight;
			}
			_width = Math.max(startWidth, _width);
			_height = startHeight;
		}
		
		/**
		 * 所有子元件加上 _gap 后的宽度
		 */
		public function get nomalWidth():Number {
			
			var displayObject:DisplayObject;
			var i:uint;
			var _nomalWidth:Number = 0;
			for (i = 0; i < this.numChildren; i++) {
				
				displayObject = this.getChildAt(i) as DisplayObject;
				
				_nomalWidth += displayObject.width;
			}
			
			_nomalWidth += (this.numChildren - 1) * _gap;
			
			return _nomalWidth;
		}
		
		public function set gap( value:Number ):void {
			
			_gap = value;
			
			this.requireLayout();
		}
		
		public function get gap():Number {
			
			return _gap;
		}
		
		/**
		 * 布局元素的垂直对齐
		 * 如果该值为 "bottom"、"middle" 或 "top"，则会相对于容器的 contentHeight 属性对齐布局元素。
		 */
		public function set verticalAlign(value:String):void {
			
			_verticalAlign = value;
			
			this.requireLayout();
		}
		
		public function get verticalAlign():String {
			
			return _verticalAlign;
		}
		
		/**
		 * 布局元素的横向对齐方式
		 */
		public function set horizontalAlign(value:String):void {
			
			_horizontalAlign = value;
			
			this.requireLayout();
		}
		
		public function get horizontalAlign():String {
			
			return _horizontalAlign;
		}
	}
}