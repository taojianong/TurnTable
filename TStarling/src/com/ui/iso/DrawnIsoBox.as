package com.ui.iso {
	
	import com.math.IsoUtils;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * 对角投影，假设光源在右上方，所以左边最暗
	 * @author cl 2013/11/15 10:48
	 */
	public class DrawnIsoBox extends DrawnIsoTile {
		
		/**
		 * 等角阴影盒子
		 * @param	size
		 * @param	color
		 * @param	height 厚度
		 * @param	alpha
		 */
		public function DrawnIsoBox( size:Number = 20 , color:uint = 0xff0000 , height:Number = 0 , alpha:Number = 0.5 ) {
			
			super( size , color , height , alpha );
		}
		
		override public function setInit(size:int, color:uint, height:Number = 0):void {
			
			super.setInit(size, color, height);
		}
		
		override protected function drawIsoTile():void {
			
			var shape:Shape = new Shape();
			
			shape.graphics.clear();
			
			var red:uint = _color >> 16;
			var green:uint = _color >> 8 & 0xff;
			var blue:uint = _color & 0xff;
			
			var leftShadow:uint = (red * .5) << 16 | (green * .5) << 8 | (blue * .5);
			var rightShadow:uint = (red * .75) << 16 | (green * .75) << 8 | (blue * .75);
			var h:Number = _height * IsoUtils.Y_CORRECT;
			
			//draw top
			shape.graphics.beginFill(_color);
			shape.graphics.lineStyle(0, 0, .5);
			shape.graphics.moveTo(-_size, -h);
			shape.graphics.lineTo(0, -_size * .5 - h);
			shape.graphics.lineTo(_size, -h);
			shape.graphics.lineTo(0, _size * .5 - h);
			shape.graphics.lineTo(-_size, -h);
			shape.graphics.endFill();
			
			//draw left
			shape.graphics.beginFill(leftShadow);
			shape.graphics.lineStyle(0, 0, .5);
			shape.graphics.moveTo(-_size, -h);
			shape.graphics.lineTo(0, _size * .5 - h);
			shape.graphics.lineTo(0, _size * .5);
			shape.graphics.lineTo(-_size, 0);
			shape.graphics.lineTo(-_size, -h);
			shape.graphics.endFill();
			
			//draw right
			shape.graphics.beginFill(rightShadow);
			shape.graphics.lineStyle(0, 0, .5);
			shape.graphics.moveTo(_size, -h);
			shape.graphics.lineTo(0, _size * .5 - h);
			shape.graphics.lineTo(0, _size * .5);
			shape.graphics.lineTo(_size, 0);
			shape.graphics.lineTo(_size, -h);
			shape.graphics.endFill();
			
			var matrix:Matrix  = new Matrix();
			matrix.tx = shape.width * 0.5;
			matrix.ty = shape.height * 0.5 + h + 2;
			var bit:BitmapData = new BitmapData( shape.width , shape.height + h + 4 , true , 0 );
			bit.draw( shape , matrix , null , null , null , true );
			
			if ( isoImg == null ) {
				isoImg = new Image( Texture.fromBitmapData( bit ) );
				isoImg.touchable = false;
			}
			else {
				isoImg.texture = Texture.fromBitmapData( bit );
			}
			isoImg.x = -isoImg.width * 0.5;
			isoImg.y = -isoImg.height * 0.5;
			
			this.addElementAtBottom( isoImg );
			//showBorder();
			
			_contentWidth  = isoImg.width;
			_contentHeight = isoImg.height;	
		}	
	}
}