package com.ui.componet {
	
	import flash.display.BitmapData;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 方块图片
	 * @author taojianlong 2014/6/29 21:42
	 */
	public class TImage extends Sprite {
		
		public var id:String = "";
		
		private var img:Image;
		private var _bitmapData:BitmapData;
		
		private var _isCenter:Boolean = false;//是否居中
		
		/**
		 * 基于Starling的图片组件
		 * @param	bitmap		图片资源数据
		 * @param	isCenter	是否居中
		 */
		public function TImage( bitmap:BitmapData = null , isCenter:Boolean = false ) {
			
			_isCenter = isCenter;
			this.bitmapData = bitmap;			
		}
		
		/*private function touchHandler( event:TouchEvent ):void {
			
			var touchs:Vector.<Touch> = event.getTouches( this );
			if ( this.hasEventListener( TouchEvent.TOUCH ) ) {
				this.dispatchEvent( new TouchEvent( TouchEvent.TOUCH , touchs ) );
			}
		}*/
		
		public function set texture( value:Texture ):void {
			
			if ( img == null ) {
				img = new Image( value );
				this.addChild( img );
				//img.addEventListener( TouchEvent.TOUCH , touchHandler );
			}
			else {
				img.texture = value;
			}
			
			img.width 	= value ? value.width : 0;
			img.height 	= value ? value.height : 0;
			
			this.updateImgXY();
		}
		/**
		 * 设置纹理
		 */
		public function get texture():Texture {
			
			return img != null ? img.texture : null;
		}
		
		public function set bitmapData( value:BitmapData ):void {
			
			_bitmapData = value;
			
			var tx:Texture = value != null ? Texture.fromBitmapData( value ) : null;
			
			if ( tx != null ) {
				if ( img == null ) {
					img = new Image( tx );
					this.addChild( img );
				}
				else {
					img.texture = tx;
				}				
			}
			else if ( img != null ) {
				img.dispose();
			}
			
			this.updateImgXY();
		}
		/**
		 * 图片资源
		 */
		public function get bitmapData():BitmapData {
			
			return _bitmapData;
		}
		
		public function set isCenter( value:Boolean ):void {
			
			_isCenter = value;
			
			this.updateImgXY();
		}
		/**
		 * 是否居中
		 */
		public function get isCenter():Boolean {
			
			return _isCenter;
		}
		
		/**
		 * 刷新图片对应坐标
		 */
		private function updateImgXY():void {
			
			if ( img != null ) {
				img.x = _isCenter ? -img.width * 0.5 : 0;
				img.y = _isCenter ? -img.height * 0.5: 0;
				
				//trace( "img.x: " + img.x + " img.y: " + img.y );
			}
		}
		
		private var rect:Rect = null;
		
		public function showBorder( color:uint = 0xff0000 ):void {
			
			rect = rect || new Rect( this.width , this.height );
			rect.drawRect( this.width , this.height , 0 , 0 , color , 1 , 2 );
			rect.x = -rect.width * 0.5;
			rect.y = -rect.height * 0.5;
			if ( !this.contains(rect) ) {
				this.addChild( rect );
			}
		}
		
		public function hideBorder():void {
			
			if ( rect && this.contains( rect ) ) {
				this.removeChild( rect );
			}
		}
	}
}