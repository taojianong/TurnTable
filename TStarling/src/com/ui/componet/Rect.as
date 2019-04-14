package com.ui.componet {
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * 矩形
	 * @author cl 2015/3/7 17:41
	 */
	public class Rect extends Sprite {
		
		public var id:String = "";
		
		private var img:Image;
		
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		public function Rect(width:int = 400, height:int = 400, color:uint = 0x00ff00, alpha:Number = 1, borderColor:uint = 0xff0000, borderAlpha:Number = 1, thickness:Number = 1) {
			
			super();
			
			_width = width;
			_height = height;
			
			var texture:Texture = this.getTexture(width, height, color, alpha, borderColor, borderAlpha, thickness);
			img = new Image(texture);
			this.addChild(img);
			
			this.touchable = false;
		}
		
		/**
		 * 绘制矩形
		 * @param	width
		 * @param	height
		 * @param	color
		 * @param	alpha
		 * @param	borderColor
		 * @param	borderAlpha
		 * @param	thickness
		 * @return
		 */
		public function drawRect(width:int = 400, height:int = 400, color:uint = 0x00ff00, alpha:Number = 1, borderColor:uint = 0xff0000, borderAlpha:Number = 1, thickness:Number = 1):void {
			
			_width = width;
			_height = height;
			
			img.texture = this.getTexture(width, height, color, alpha, borderColor, borderAlpha, thickness);
			
			img.width = _width;
			img.height = _height;
		}
		
		private function getTexture(width:int = 400, height:int = 400, color:uint = 0x00ff00, alpha:Number = 1, borderColor:uint = 0xff0000, borderAlpha:Number = 1, thickness:Number = 1):Texture {
			
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(thickness, borderColor, borderAlpha);
			shape.graphics.beginFill(color, alpha);
			shape.graphics.drawRect(0, 0, width, height);
			shape.graphics.endFill();
			
			var bit:BitmapData = new BitmapData(width, height, true, 0);
			bit.draw(shape, null, null, null, null, true);
			
			var texture:Texture = Texture.fromBitmapData(bit);
			
			return texture;
		}
		
		override public function set width(value:Number):void {
			
			super.width = value;
		}
		
		override public function get width():Number {
			
			return _width;
		}
		
		override public function get height():Number {
			
			return _height;
		}
		
		override public function set height(value:Number):void {
			
			super.height = value;
		}
		
		override public function get x():Number {
			
			return super.x;
		}
		
		override public function set x(value:Number):void {
			
			super.x = value;
			
			if ( this.id == "msk" && value == 0 ) {
				trace("xxx");
			}
		}
	}
}