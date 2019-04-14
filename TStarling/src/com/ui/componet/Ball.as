package com.ui.componet {
	
	import com.utils.MathUtils;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * 圆球
	 * @author cl 2015/3/7 18:01
	 */
	public class Ball extends Sprite {
		
		private var img:Image;
		
		public function Ball( radius:int = 10 , color:uint = 0x00ff00 , alpha:Number = 1 , borderColor:uint = 0xff0000 , borderAlpha:Number = 1 ) {
			
			super();
			
			var texture:Texture = this.getTexture( radius , color , alpha , borderColor , borderAlpha );
			img = new Image( texture );
			img.x = img.y = -img.width * 0.5;
			this.addChild( img );
		}
		
		public function drawBall( radius:int = 5 , color:uint = 0x00ff00 , alpha:Number = 1 , borderColor:uint = 0xff0000 , borderAlpha:Number = 1 ):void {
			
			img.texture = this.getTexture( radius , color , alpha , borderColor , borderAlpha );
			img.x = img.y = -img.width * 0.5;
		}
		
		public function getTexture( radius:int = 5 , color:uint = 0x00ff00 , alpha:Number = 1 , borderColor:uint = 0xff0000 , borderAlpha:Number = 1 , thickness:Number = 1 ):Texture {
			
			var shape:Shape = new Shape();
			shape.graphics.lineStyle( thickness , borderColor , borderAlpha );
			shape.graphics.beginFill( color , alpha );
			shape.graphics.drawCircle( radius , radius , radius );
			shape.graphics.endFill();
			
			var w:Number = radius * 2 + 4;
			var h:Number = radius * 2 + 4;
			w = MathUtils.getLast2Pow( w );
			h = MathUtils.getLast2Pow( h );
			var matrix:Matrix  = new Matrix();
			matrix.tx = ( w - (radius * 2 + 4) ) / 2;
			matrix.ty = ( h - (radius * 2 + 4) ) / 2;
			var bit:BitmapData = new BitmapData( w , h , true , 0 );			
			bit.draw( shape , matrix , null , null , null , true );
			
			return Texture.fromBitmapData( bit );
		}
	}

}