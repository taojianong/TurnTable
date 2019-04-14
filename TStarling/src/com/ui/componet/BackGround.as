package com.ui.componet {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * 背景,默认为纯色背景
	 * @author taojianlong 2014/6/28 23:45
	 */
	public class BackGround extends ItemBase {
		
		private var backImage:Image;
		private var image:Image;
		
		private var shape:Shape;
		
		private var _color:uint = 0x00ff00;
		private var _alpha:Number = 1;
		private var _borderColor:uint = 0xff0000;
		private var _borderAlpha:Number = 1;
		private var _thickness:Number = 1;
		
		public function BackGround(width:Number = 400, height:Number = 800, color:uint = 0x00ff00, alpha:Number = 1, thickness:Number = 1, borderColor:uint = 0xff0000, borderAlpha:Number = 0) {
			
			super( width , height );			
			
			_thickness 	 = thickness;
			_width 		 = width;
			_height 	 = height;
			_alpha 		 = alpha;
			_borderColor = borderColor;
			_borderAlpha = borderAlpha;
			
			var texture:Texture = createTexture(width, height, color, alpha, thickness, borderColor, borderAlpha);
			
			backImage = new Image(texture);
			backImage.touchable = true;
			
			this.addChild(backImage);
		}
		
		private function createTexture(width:Number = 400, height:Number = 800, color:uint = 0x00ff00, alpha:Number = 1, thickness:Number = 0, borderColor:uint = 0xff0000, borderAlpha:Number = 0):Texture {
			
			shape = shape || new Shape();
			shape.graphics.clear();
			shape.graphics.beginFill(color, alpha);
			shape.graphics.lineStyle(thickness, borderColor, borderAlpha);
			shape.graphics.drawRect(0, 0, width - thickness, height - thickness);
			shape.graphics.endFill();
			
			var bmd:BitmapData = new BitmapData( width , height );
			bmd.draw(shape, null, null, null, null, true);
			
			return Texture.fromBitmapData(bmd);
		}
		
		public function set bitmapData(value:BitmapData):void {
			
			var texture:Texture = Texture.fromBitmapData(value);
			
			this.texture = texture;
		}
		
		override public function set width(value:Number):void {
			
			super.width = value;
			
			updateTexture();
		}
		
		override public function set height(value:Number):void {
			
			super.height = value;
			
			updateTexture();
		}
		
		public function set color(value:uint):void {
			
			_color = value;
			
			updateTexture();
		}
		
		public function get color():uint {
			
			return _color;
		}
		
		override public function get alpha():Number {
			
			return _alpha;
		}
		
		override public function set alpha(value:Number):void {
			
			_alpha = value;
			
			updateTexture();
		}
		
		public function set borderColor(value:uint):void {
			
			_borderColor = value;
			
			updateTexture();
		}
		
		public function get borderColor():uint {
			
			return _borderColor;
		}
		
		public function set borderAlpha(value:Number):void {
			
			_borderAlpha = value;
			
			updateTexture();
		}
		
		public function get borderAlpha():Number {
			
			return _borderAlpha;
		}
		
		public function set thickness( value:Number ):void {
			
			_thickness = value;
		}
		
		public function get thickness():Number {
			
			return _thickness;
		}	
		
		public function set texture(value:Texture):void {
			
			/*if (image == null) {
				image = new Image( value );
			} else {
				image.texture = value;
			}
			
			image.x = (this.width - image.width) / 2;
			image.y = (this.height - image.height) / 2;
			
			this.addChild(image);*/
			
			backImage.texture = value;
		}
		
		private function updateTexture():void {
			
			var texture:Texture = createTexture( this.width , this.height , this.color , this.alpha , this.thickness , this.borderColor , this.borderAlpha );
			
			this.texture = texture;
		}
	}
}