package com.ui {
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import starling.textures.Texture;
	
	/**
	 * UI纹理
	 * @author cl 2015/3/16 17:48
	 */
	public class UITexture {
		
		public static function getTexture(width:int = 400, height:int = 400, color:uint = 0x00ff00, alpha:Number = 1, borderColor:uint = 0xff0000, borderAlpha:Number = 1, thickness:Number = 1,ellipse:Number=0):Texture {
			
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(thickness, borderColor, borderAlpha);
			shape.graphics.beginFill(color, alpha);
			shape.graphics.drawRoundRect(0, 0, width, height,ellipse,ellipse);
			shape.graphics.endFill();
			
			var bit:BitmapData = new BitmapData(width, height, true, 0);
			bit.draw(shape, null, null, null, null, true);
			
			var texture:Texture = Texture.fromBitmapData(bit);			
			return texture;
		}
	}

}