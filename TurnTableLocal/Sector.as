package com.ui.componet.flash {
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/***
	 * 画扇形
	 * @author taojianlong 2010.4.1
	 */
	public class Sector extends Sprite {
		
		public var radius:Number;
		public var color:uint;
		public var ball:Sprite;
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var cx:Number; //小球初始位置
		public var cy:Number;
		public var ay:Number; //加速度
		public var mass:Number; //质量 2010.12.3
		public var degree:Number; //度数
		
		public function Sector( radius:Number = 40, degree:Number = 180, color:uint = 0xff0000, mass:Number = 1) {
			this.radius = radius;
			this.color = color;
			this.mass = mass;
			this.degree = degree;
			init();
		}
		
		private function init():void {
			graphics.lineStyle(1, 0x00ff00, 0);
			graphics.beginFill(color, 0.5);
			graphics.moveTo(0, 0);
			graphics.lineTo(radius, 0);
			for (var deg:Number = 0; deg < degree; deg+=0.1) {
				var x1:Number = Math.cos(deg * Math.PI / 180) * radius;
				var y1:Number = Math.sin(deg * Math.PI / 180) * radius;
				graphics.lineTo(x1, y1);
			}
			graphics.lineTo(0, 0);
		}
		
		public function get bitmapData():BitmapData {
		
			var tx:Matrix = new Matrix();
			tx.tx = this.radius;
			tx.ty = this.radius;
			var bmd:BitmapData = new BitmapData( this.radius * 2 , this.radius * 2 , true , 0 );			
			bmd.draw( this , tx , null , null , null , true );
			return bmd;
		}
	}
}