package com.ui.componet {
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.TouchEvent;
	
	//import flash.events.Event;
	//import flash.events.MouseEvent;
	//import flash.text.TextFieldAutoSize;
	//import flash.text.TextFormatAlign;
	
	/**
	 * 复选框 2012-12-23 23:26
	 * @author taojianlong
	 */
	public class ComboBox extends UIComponet {
		
		public static const RECT:String = "rect";
		public static const CIRCLE:String = "circle";
		
		public static const SELECT_TYPE_DEFAULT:int = 0;//默认为点击自动设置选择状态
		public static const SELECT_TYPE_HAND:int = 1;//手动设置选择状态
		
		private var _color:uint;
		private var _selected:Boolean = true;
		private var _selectType:int = 0;//选择模式
		private var _labelOffsetX:Number = 0;
		
		private var lab:TSLabel;
		private var msk:Rect;
		
		private var bakImg:TSImage;
		private var seleImg:TSImage;
		
		/**
		 * 复选框
		 * @param	width
		 * @param	height
		 * @param	boderColor 边框颜色
		 */
		public function ComboBox(width:Number = 16, height:Number = 16, boderColor:uint = 0x000000) {
			
			super(width, height );
			
			//this.mouseChildren = false;
			//this.mouseEnabled = true;
			_width = width;
			_height = height;
			_color = boderColor;
			
			init();
		}
		
		private function init():void {
			
			bakImg = new TSImage();
			seleImg = new TSImage();
			
			this.addChild(bakImg);
			this.addChild(seleImg);
			
			drawCombo();
			
			lab = new TSLabel;
			//lab.width = 50;
			lab.height = 15;
			//lab.algin = TextFormatAlign.LEFT;
			//lab.autoSize = TextFieldAutoSize.LEFT;
			lab.isAutoSize = true;
			lab.x = _width + 1;
			this.addChild(lab);
			
			msk = new Rect(this.width, this.height);
			msk.alpha = 0;
			//msk.buttonMode = false;
			this.addChild(msk);
		}
		
		override protected function addToStageHandler(event:Event):void {
			
			super.addToStageHandler(event);
			
			if ( !this.hasEventListener( TouchEvent.TOUCH ) ) {
				this.addEventListener( TouchEvent.TOUCH , clickHandler );
			}			
		}
		
		override protected function removeFromStageHandler(event:Event):void {
			
			super.removeFromStageHandler(event);
			
			this.removeEventListener( TouchEvent.TOUCH , clickHandler);
		}
		
		private function clickHandler(event:TouchEvent):void {
			
			if ( _selectType == SELECT_TYPE_DEFAULT ) {
				this.selected = !this.selected;
			}
			else if ( _selectType == SELECT_TYPE_HAND ) {
				this.dispatchEvent(new Event(Event.SELECT));
			}
		}
		
		public function set selectType( value:int ):void {
			
			_selectType = value;
		}
		/**
		 * 设置选中类型 0为默认方式，1为触发选择事件方式
		 */
		public function get selectType():int {
			
			return _selectType;
		}
		
		/**背景资源类**/
		public function set backSourceClass(value:String):void {
			
		}
		
		/**选择资源类**/
		public function set selectSourceClass(value:String):void {
			
		}
		
		/**
		 * 设置标签参数
		 * @param	color     标签颜色
		 * @param	fontSize  标签字体
		 * @param	ox        标签偏移坐标
		 * @param	oy
		 */
		public function setLab(color:uint = 0xffffff, fontSize:Number = 20, ox:Number = 0, oy:Number = 0):void {
			
			lab.color = color;
			lab.fontSize = fontSize;
			lab.x = _width + ox;
			lab.y = oy;
			//lab.updateStyle();
		}
		
		public function set labelColor( value:uint ):void {
			
			lab.color = value;
		}
		
		public function set labelFontSize( value:int ):void {
			
			lab.fontSize = value;
		}
		
		public function set labelOffsetX( value:Number ):void {
			
			_labelOffsetX = value;
			
			lab.x = bakImg.width + value;
		}
		
		public function set labelOffsetY( value:Number ):void {
			
			lab.y = value;
		}
		
		public function set color(value:uint):void {
			
			_color = value;
			
			drawCombo();
		}
		
		/**复选边框颜色**/
		public function get color():uint {
			
			return _color;
		}
		
		override public function get width():Number {
			
			return _width;
		}
		
		override public function set width(value:Number):void {
			
			_width = value;
			
			drawCombo();
			
			lab.x = _width;
		}
		
		override public function get height():Number {
			
			return _height;
		}
		
		override public function set height(value:Number):void {
			
			_height = value;
			
			drawCombo();
		}
		
		public function set selected(value:Boolean):void {
			
			_selected = value;
			
			drawCombo();
			
			this.dispatchEvent( new Event( Event.SELECT ) );			
		}		
		/**
		 * 是否选中,触发选中事件
		 */
		public function get selected():Boolean {
			
			return _selected;
		}
		
		/**
		 * 是否选中
		 */
		public function set isSelected( value:Boolean ):void {
			
			_selected = value;
			
			drawCombo();
		}
		
		public function get enabled():Boolean {
			
			return !_selected;
		}
		
		private function drawCombo():void {
			
			if (seleImg.texture != null) {
				//this.graphics.clear();
				_selected ? this.addElement(seleImg) : this.removeElement(seleImg);
				return;
			}
			
			/*if (this.type == RECT) {
				this.drawRectBackground(_width, _height, _backColor, this.selectAlpha, 2, color, 1);
			} else if (this.type == CIRCLE) {
				this.drawCircle(_width / 2, 0x000000, this.selectAlpha, 0xff0000, 1, true);
			}*/
		}
		
		public function set label(value:String):void {
			
			lab.text = value;
		}
		
		public function get label():String {
			
			return lab.text;
		}
		
		private function get selectAlpha():Number {
			
			return _selected ? 1 : 0;
		}
	}

}