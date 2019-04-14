package assets {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	
	/**
	 * 资源管理嵌入资源类
	 * @author taojianlong 2014-5-26 23:23
	 */
	public class Assets {
		
		[Embed(source="../../bin/assets/blue_out.png")]
		public static const blue_out:Class;
		
		[Embed(source="../../bin/assets/blue_over.png")]
		public static const blue_over:Class;		
		
		[Embed(source="../../bin/assets/zp_1/zp_back.png")]
		public static const ZP_BACK:Class; //转盘背景
		
		[Embed(source = "../../bin/assets/zp_1/zp_arrow.png")]
		public static const ZP_ARROW:Class;//转盘箭头
		
		/**
		 * 配置地址
		 */
		public static const CONFIG_PATH:String = "config/";
		
		/**
		 * 配置文件
		 */
		public static const CONFIG_TABLE:String = "table";
		
		//-----------------------------------------------------
		
		private static const sourcePool:Dictionary = new Dictionary();
		
		/**
		 * 获取对应图片资源的纹理
		 * @param	name
		 * @return
		 */
		public static function getTexture( name:String ):Texture {
			
			var bitmap:Bitmap = getBitmap( name );
			
			return bitmap ? Texture.fromBitmap( bitmap ) : null;
		}
		
		public static function getBitmapData( name:String ):BitmapData {
			
			var bmp:Bitmap = getBitmap( name );
			
			return bmp ? bmp.bitmapData.clone() : null;
		}
		
		public static function getBitmap( name:String ):Bitmap {
			
			if ( name in sourcePool ) {
				return sourcePool[ name ] as Bitmap;
			}
			
			var bitmap:Bitmap = null;
			
			if ( Assets[ name ] != undefined ) {
				
				bitmap = new Assets[ name ]();
				
				sourcePool[ name ] = bitmap;
			}
			else {
				throw new Error("Resource not defined.");
			}			
			return bitmap;
		}
	}

}