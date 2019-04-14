package com.utils {
	import starling.textures.Texture;
	
	/**
	 * 资源管理
	 * @author cl 2015/3/6 17:26
	 */
	public class SourceManager {
		
		/**
		 * 获取加载资源图像纹理
		 * @param	name	对应的资源名字
		 * @return
		 */
		public function getLoadedTexture( name:String ):Texture {
			
			return Game.assets.getTexture( name );
		}
		
		/**
		 * 获取绑定图片纹理资源
		 * @param	cls			绑定资源类
		 * @param	scaleFactor 缩放参数，适应对应频幕
		 * @return
		 */
		public function getEmbeddedTexture( cls:Class , scaleFactor:Number = 1 ):Texture {
			
			return Texture.fromEmbeddedAsset( cls , false , false , scaleFactor );
		}
		
		private static var instance:SourceManager;
		public static function get Instance():SourceManager {
			return instance = instance || new SourceManager();
		}
	}
}