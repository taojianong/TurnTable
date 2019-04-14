package com.ui.iso {
	
	import com.ui.componet.Ball;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * 绘制投影图像
	 * @author cl 2015/3/9 13:52
	 */
	public class DrawnIsoTile extends IsoObject {
		
		protected var _height:Number;
		protected var _color:uint;
		protected var _alpha:Number = 1;//板砖透明度
		
		protected var _txt:TextField;
		protected var isoImg:Image;
		
		public function DrawnIsoTile(size:Number=20, color:uint=0xff0000, height:Number = 0 , alpha:Number = 0.5 ) {
			
			super(size);
			
			_color  = color;
			_height = height;
			_alpha  = alpha;
			
			drawIsoTile();
			
			//显示文本信息			
			_txt 	= new TextField( size * 2 , 20 , "" );
			_txt.x 	= -_txt.width / 2;
			_txt.y 	= -_txt.height / 2;
			_txt.color = 0x00ff00;
			_txt.touchable = false;
			//_txt.border = true;
			//_txt.borderColor = 0x00ff00;
			this.addChild( _txt );
			
			this.addChild( new Ball( 2 , 0x0000ff ) );
		}
		
		public function setInit( size:int , color:uint , height:Number = 0 ):void {
			
			_size = size;
			_color = color;
			_height = height;
			
			drawIsoTile();
		}
		
		/**
		 * 显示文本
		 * @param text 文本消息
		 */
		public function showTxt( text:String ):void {
			
			if ( !(text == null || text == "") ) {
				_txt.text = text;
			}
		}
		
		/**
		 * 绘制等角阴影
		 */
		protected function drawIsoTile():void {
			
			var shape:Shape = new Shape();
			shape.graphics.clear();
			shape.graphics.beginFill( _color , _alpha );
			shape.graphics.lineStyle( 0 , 0 , 0.5 );
			shape.graphics.moveTo(-size, 0);
			shape.graphics.lineTo(0, -size * .5);
			shape.graphics.lineTo(size, 0);
			shape.graphics.lineTo(0, size * .5);
			shape.graphics.lineTo( -size, 0);
			
			var matrix:Matrix  = new Matrix();
			matrix.tx = shape.width * 0.5;
			matrix.ty = shape.height * 0.5 + 2;
			var bit:BitmapData = new BitmapData( shape.width , shape.height + 2 , true , 0 );
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
		
		override public function get contentWidth():Number {
			
			return _contentWidth;
		}
		
		override public function get contentHeight():Number {
			
			return _contentHeight;
		}
		
		override public function get height():Number {
			
			return _height;
		}
		/**
		 * 厚度
		 */
		override public function set height(value:Number):void {
			
			_height = value;
			
			drawIsoTile();
		}
		
		public function set color(value:uint):void {
			
			_color = value;
			
			drawIsoTile();
		}
		/**设置颜色**/
		public function get color():uint {
			
			return _color;
		}
	}

}