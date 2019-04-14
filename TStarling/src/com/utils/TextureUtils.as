package com.utils {
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import starling.textures.Texture;
	
	/**
	 * 纹理工具
	 * @author cl 2015/3/6 16:36
	 */
	public class TextureUtils {
		
		public static function getDefaultTexture( width:Number = 32 , height:Number = 32 ):Texture {
			
			var tx:Texture = TextureUtils.createTexture( width , height );
			
			return tx;
		}
		
		/**
		 * 创建一个矩形纹理
		 * @param	width
		 * @param	height
		 * @param	color
		 * @param	alpha
		 * @param	thickness
		 * @param	borderColor
		 * @param	borderAlpha
		 * @return
		 */
		public static function createTexture(width:Number = 400, height:Number = 800, color:uint = 0x00ff00, alpha:Number = 1, thickness:Number = 0, borderColor:uint = 0xff0000, borderAlpha:Number = 0):Texture {
			
			var shape:Shape = new Shape();
			shape.graphics.clear();
			shape.graphics.beginFill(color, alpha);
			shape.graphics.lineStyle(thickness, borderColor, borderAlpha);
			shape.graphics.drawRect(0, 0, width - 2 * thickness, height - 2 * thickness);
			shape.graphics.endFill();
			
			var bmd:BitmapData = new BitmapData(width, height);
			bmd.draw( shape , null , null , null , null , true );
			
			return Texture.fromBitmapData(bmd);
		}
	
	}

}