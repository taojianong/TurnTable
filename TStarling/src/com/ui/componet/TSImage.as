package com.ui.componet {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * 可设置空纹理的图片组件!
	 * 原来Image不支持空纹理图片组件
	 * @author taojianlong 2014/6/30 1:19
	 */
	public class TSImage extends Sprite {
		
		protected var img:Image;
		protected var _isCenter:Boolean = false;
		
		public function TSImage( texture:Texture = null , isCenter:Boolean = false ) {
			
			super();
			
			this._isCenter 	= isCenter;			
			this.texture 	= texture;			
		}
		
		public function set isCenter( value:Boolean ):void {
			
			_isCenter = value;
			
			if ( img ) {
				img.x = _isCenter ? -img.width * 0.5 : 0;
				img.y = _isCenter ? -img.height * 0.5 : 0;
			}
		}
		
		public function get isCenter():Boolean {
			
			return _isCenter;
		}
		
		public function set bitmap( value:Bitmap ):void {
			
			_bitmapData = value ? value.bitmapData : null;
			
			var texture:Texture = Texture.fromBitmap( value );
			
			this.texture = texture;
		}
		
		private var _bitmapData:BitmapData;
		
		public function set bitmapData( value:BitmapData ):void {
			
			_bitmapData = value;
			
			var texture:Texture = Texture.fromBitmapData(value);
			
			this.texture = texture;
		}
		
		public function get bitmapData():BitmapData {
			
			return _bitmapData;
		}
		
		public function set texture( value:Texture ):void {
			
			if ( value == null ) {
				if ( img ) {
					this.removeChild( img , true );	
				}	
			}
			else {				
				if ( img == null ) {
					img = new Image( value );
				}
				else {
					img.texture = value;
				}				
				if ( !this.contains( img ) ) {
					this.addChild( img );
				}
			}
			
			this.isCenter = _isCenter;
		}
		/**
		 * 纹理
		 */
		public function get texture():Texture {
			
			return img ? img.texture : null;
		}
	}

}