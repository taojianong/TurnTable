package com.ui.componet {
	
	import com.utils.BitmapUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import starling.textures.Texture;
	
	/**
	 * 动画数据
	 * @author cl 2015/3/7 15:12
	 */
	public class AnimationData {
		
		public var id:String = "";
		
		public var bitmapData:BitmapData = null;//但个动画序列帧图片
		public var list:int = 1;
		public var row:int = 1;
		public var fps:int = 12; //动画帧频
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		public var loop:int = 0;//是否循环,0为无限循环
		
		/**
		 * 单帧宽度
		 */
		public function get frameWidth():int {
			
			return this.bitmapData != null ? int( this.bitmapData.width / list ) : 0;
		}
		
		/**
		 * 单帧高度
		 */
		public function get frameHeight():int {
			
			return this.bitmapData != null ? this.bitmapData.height : 0;
		}
		
		/**
		 * 获取对应帧的纹理
		 * @param	frameIndex,从1开始
		 * @param	row
		 * @param	list = 1
		 * @return
		 */
		public function getTexture( frameIndex:int , row:int = 1 , list:int = 1 ):Texture {
			
			frameIndex = frameIndex < 1 ? 1 : frameIndex;
			
			if ( _textures && frameIndex <= _textures.length ) {
				
				return _textures[frameIndex-1];
			}
			
			return null;
		}
		
		private var _textures:Vector.<Texture> = null; //帧纹理集
		
		/**
		 * 设置帧纹理集
		 * @param	value
		 */
		public function setTextures( value:Vector.<Texture> ):void {
			
			_textures = value;
		}
		
		/**
		 * 纹理数组
		 */
		public function getTextures( row:int = 1 , list:int = 1 ):Vector.<Texture> {
			
			if ( _textures != null ) {
				return _textures;
			}
			
			_textures = new Vector.<Texture>();
			if ( this.bitmapData != null ) {
				var arr:Array = BitmapUtils.cutBitmapAsList( new Bitmap( this.bitmapData ) , row , list );
				for ( var i:int = 0; i < arr.length;i++ ) {
					var bitmap:Bitmap = arr[i];
					_textures.push( Texture.fromBitmap( bitmap ) );
				}
			}			
			return _textures;
		}
	}
}