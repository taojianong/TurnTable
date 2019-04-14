package com.utils {
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * 图片处理工具 
	 * @author taojianlong 2013-3-29 22:50
	 */
	public class BitmapUtils {
		
		/**
		 * 将图片切片保存为列表
		 * @param	bitmap 原始图片
		 * @param	row    行
		 * @param	list   列
		 * @return
		 */
		public static function cutBitmapAsList( bitmap:Bitmap , row:int = 1 , list:int = 1 ):Array {
			
			var singleWidth:Number;
			var singleHeight:Number;
			
			if ( bitmap != null && bitmap.bitmapData != null ) {
				
				var arr:Array = [];
				var i:int;
				var j:int;
				singleWidth  = bitmap.width / list;
				singleHeight = bitmap.height / row;
				
				var bmd:BitmapData;
				
				var len:int = row * list;
				for ( i = 0; i < len;i++ ) {					
					var x:Number = int(i % list) * singleWidth;
					var y:Number = int(i / list) * singleHeight;
					bmd = cutBitmap( bitmap , new Rectangle( x , y , singleWidth, singleHeight) );					
					arr.push( new Bitmap( bmd ) );
				}
				
				return arr;
			}
			
			return null;
		}
		
		/**
		 * 裁剪图像 2013-3-10 23:21
		 * @param	bitmap
		 * @param	rect
		 * @return
		 */
		public static function cutBitmap( bitmap:* , rect:Rectangle ):BitmapData {
			
			var bit:BitmapData;
			
			if (bitmap is Bitmap) {
				
				bit = Bitmap(bitmap).bitmapData;
			} else if (bitmap is BitmapData) {
				
				bit = bitmap;
			} else {
				
				return null;
			}
			
			if (rect.width > bit.width || rect.height > bit.height) {
				
				throw new Error("超过图像尺寸，裁剪失败");
				return null;
			}
			
			var bmd:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			bmd.copyPixels(bit, rect, new Point(0, 0), null, null, true);
			
			return bmd;
		}
		
		/**
		 * 将图片数据保存为二进制数据
		 * @param	bitmap 将图片转换为二进制格式
		 * @param	format 图片格式
		 * @return
		 */
		public static function bitmapToByteArray( bitmap:BitmapData , format:String = "jpg" ):ByteArray {
			
			var byteArray:ByteArray;
			
			if (format == "jpg") {
				
				var jpgEnc:JPGEncoder = new JPGEncoder;
				//encode the bitmapdata object and keep the encoded ByteArray
				byteArray = jpgEnc.encode(bitmap);
			} else if (format == "png") {
				
				//var pngEnc:PNGEncoder = new PNGEncoder();			
				//encode the bitmapdata object and keep the encoded ByteArray
				byteArray = PNGEncoder.encode(bitmap);
			}
			
			return byteArray;
		}
		
		/**
		 * 转变图形数据
		 * @param	bit 源图片数据
		 * @param	horizontaltrun 转变为横向的图形数据
		 * @param	leftturn 左右翻转
		 * @param	downturn 上下翻转
		 * @return
		 */
		public static function switchBitmapData( bitdata:BitmapData , horizontaltrun:Boolean = false , leftturn:Boolean = false , downturn:Boolean = false ):BitmapData {
			
			var bmd:BitmapData = new BitmapData(bitdata.width, bitdata.height);
			//var bitdata:BitmapData = bit;
			var colorArr:Array = new Array(bitdata.width);
			for (var i:uint = 0; i < bitdata.width; i++) {
				colorArr[i] = new Array(bitdata.height);
				for (var j:uint = 0; j < bitdata.height; j++)
					colorArr[i][j] = bitdata.getPixel32(i, j);
				
			}
			
			if (horizontaltrun){ //竖向变横向
			
				for (var k:int = 0; k < colorArr.length; k++) {
					for (var m:int = k + 1; m < colorArr[k].length; m++) {
						var tempValue:Object = colorArr[k][m];
						colorArr[k][m] = colorArr[m][k];
						colorArr[m][k] = tempValue;
					}
				}
			}
			
			if ( leftturn )
				colorArr.reverse(); //左右翻转
				
			for (var l:int = 0; l < colorArr.length; l++) {
				if (downturn)
					colorArr[l].reverse(); //上下翻转
				for (var n:int = 0; n < colorArr[l].length; n++)
					bmd.setPixel32(l, n, colorArr[l][n]);
			}
			return bmd;
		}
		
		/**
		 * 缩放图片到某个尺寸
		 *
		 * @param	bitmap
		 * @param	width
		 * @param	height
		 * @return
		 */
		public static function scaleBitmapTo( bitmap:BitmapData , width:Number = 40 , height:Number = 40 ):BitmapData {
			
			if (bitmap == null)
				return null;
			
			if (bitmap.width == width && bitmap.height == height) {
				return bitmap;
			}
			
			var scaleX:Number = width / bitmap.width;
			var scaleY:Number = height / bitmap.height;
			
			return scaleBitmapData(bitmap, scaleX, scaleY);
		}
		
		/**
		 * 缩放图片
		 * @param	bitmap 原始BitmapData
		 * @param	scaleX
		 * @param	scaleY
		 * @return
		 */
		public static function scaleBitmapData( bitmap:BitmapData , scaleX:Number = 1 , scaleY:Number = 1 ):BitmapData {
			
			if (bitmap == null) {
				
				return null;
			}
			
			var bitWidth:Number = bitmap.width * scaleX;
			var bitHeight:Number = bitmap.height * scaleY;
			var matrix:Matrix = new Matrix;
			matrix.scale(scaleX, scaleY);
			var bmd:BitmapData = new BitmapData(bitWidth, bitHeight, true, 0);
			bmd.draw(bitmap, matrix, null, null, null, true);
			
			return bmd;
		}
		
		/**
		 * 图像锐化图片处理
		 * @param	bitmap 
		 * @param	amount 0~100
		 * @return
		 */
		/*public static function sharpenImage( bitmap:BitmapData , amount:Number = 1 ):BitmapData {
			
			var sf:SharpenFilter = new SharpenFilter( amount );
			var sharpenedData:BitmapData = bitmap.clone();
			sharpenedData.applyFilter( bitmap , bitmap.rect , new Point() , sf );
			return sharpenedData;
		}*/
	}

}