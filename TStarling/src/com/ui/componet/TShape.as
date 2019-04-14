package com.ui.componet {
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * 基于Starling的Shape
	 * @author taojianlong 2015/5/6 23:29
	 */
	public class TShape extends Image {
		
		protected var shape:Shape = new Shape();
		
		public function TShape() {
			
			var tx:Texture = Texture.fromColor( 100 , 100 , 0xff0000 );
			super( tx );
			this.touchable = false;
		}
		
		public function get graphics():Graphics {
			
			return shape.graphics;
		}
		
		public function clear():void {
			
			shape.graphics.clear();
			
			this.texture = Texture.fromColor( 100 , 100 , 0xff0000 );
		}		
		
		/**
		 * 绘制矩形
		 *
		 * @param	width     高度
		 * @param	height    宽度
		 * @param	fillColor 颜色
		 * @param	fillAlpha 透明度
		 * @param   lineStyle 线条粗细
		 * @param   lineColor 线条颜色
		 * @param   lineAlpha 线条透明度
		 */
		public function drawRectBackground(width:Number, height:Number, fillColor:uint = 0x000000, fillAlpha:Number = 1, lineStyle:Number = 1, lineColor:uint = 0x000000, lineAlpha:Number = 0, isClear:Boolean = true):void {
			
			if (isClear) {
				shape.graphics.clear();
			}
			
			shape.graphics.lineStyle(lineStyle, lineColor, lineAlpha);
			shape.graphics.beginFill(fillColor, fillAlpha);
			shape.graphics.drawRect(0, 0, width, height);
			shape.graphics.endFill();
			
			endFill();
		}
		
		public function endFill():void {
			
			shape.graphics.endFill();
			
			var bit:BitmapData = new BitmapData( shape.width , shape.height , true , 0 );
			bit.draw( shape );
			
			this.texture = Texture.fromBitmapData( bit );
		}
	}
}