package com.math {
	
	import flash.geom.Point;
	
	public class Vector2D {
		
		private static const _RadsToDeg:Number = 180 / Math.PI;        
		
		private var _x:Number = 0 ;
        private var _y:Number = 0 ;
		
		public function get x():Number { return _x; }
        public function get y():Number { return _y; }
		public function set x( value:Number ):void {
			
			_x = value;
		}
		
		public function set y( value:Number ):void {
			
			_y = value;
		}
		
		/**
		 * 斜度,y = kx + c 中的k值
		 * @return
		 */
		public function get taper():Number {
			
			return _y / _x;
		}
		
		/**
		 * 斜率
		 */
		public function get slope():Number {
			
			return Math.atan( _y / _x );
		}
		
		public function get angle():Number {
			
			return Math.atan2( _y, _x );
		}
		
		public function set angle( value:Number ):void {
			
			var len:Number = length;
			
			_x = Math.cos( value ) * len;
			_y = Math.sin( value ) * len;
		}
		
		
		public function set radian(value:Number):void {
			
			var len:Number = this.length;
			
			_x = Math.cos( value ) * len;
			_y = Math.sin( value ) * len;
		}		
		/**
		 * 弧度
		 */
		public function get radian():Number {
			
			return Math.atan2( _y , _x );
		}
		
		
		public function set length( value:Number ):void {
			
			var a:Number = angle;
			
			_x = Math.cos( a ) * value;
			_y = Math.sin( a ) * value;
		}
		
        public function get length():Number { 
			
			return Math.sqrt(_x * _x + _y * _y); 
		}
		
		public function get lengthSqr():Number { 
			
			return _x * _x + _y * _y;
		}
		
		public function get perp():Vector2D {
			
			return new Vector2D( -y, x );
		}
		
		public function Vector2D( x:Number=0,y:Number=0 ) 	{
			
			_x = x ;
			_y = y ;
		}
		
		public function clone():Vector2D { 
			
			return new Vector2D(_x, _y); 
		}
		
		public function toPoint():Point {
			
			return new Point( _x , _y );
		}
		
		public function zero():Vector2D {
			
			_x = 0;
			_y = 0;
			
			return this;
		}
        public function add( vec:Vector2D ):Vector2D { 
			
			return new Vector2D(_x + vec.x, _y + vec.y ); 			
		}
		
		public function subtract( vec:Vector2D ):Vector2D {
			
			return new Vector2D( _x - vec.x, _y - vec.y );
		}
        public function sub( vec:Vector2D):Vector2D { 
			
			return new Vector2D(_x - vec.x, _y - vec.y); 
		}		
 
        public function mul(value:Number):Vector2D { 
			
			return new Vector2D( _x * value, _y * value ); 
		}
        
        public function div( value:Number ):Vector2D { 
			
			return new Vector2D( _x / value, _y / value );			
		}
		
		
        public function scale(s:Number):Vector2D { 
			
			return new Vector2D(_x * s, _y * s);
		}
 
        public function normalize():Vector2D {
			
			if ( length == 0 ) {
				
				_x = 1;
				return this;
			}
			
			_x /= length;
			_y /= length;
			
			return this;
        }
		
		public function reverse():Vector2D {
			
			_x = -_x;
			_y = -_y;
			
			return this;
		}
		
		public function truncate( max:Number ):Vector2D {
			
			length = Math.min( max, length );
			return this;
		}
		
        public function dist(vec:Vector2D):Number {
			
			return Math.sqrt( distSQ( vec ) );
        }
		
        public function distSQ(vec:Vector2D):Number {
			
            var xd:Number = _x - vec.x;
            var yd:Number = _y - vec.y;
			
            return xd * xd + yd * yd;
        }
		
        public function equals(vec:Vector2D):Boolean { 
			
			return _x == vec.x && _y == vec.y; 
		}
		
        public function isNormalized():Boolean { 
			
			return length == 1.0;
		}
		
        public function isZero():Boolean { 
			
			return IOBitMath.isZero( _x ) && IOBitMath.isZero( _y ); 
		}
		
		public function dotProd( v2:Vector2D ):Number {
			
			return _x * v2.x + _y * v2.y;
		}
		
		public function angleBetween( v1:Vector2D, v2:Vector2D ):Number {
			
			if ( !v1.isNormalized() ) v1 = v1.clone().normalize();
			if ( !v2.isNormalized() ) v2 = v2.clone().normalize();
			
			return Math.cos( v1.dotProd( v2 ) );
		}
		
		public function sign( v2:Vector2D ):Number {
			
			return perp.dotProd( v2 ) < 0? -1:1;
		}
		
	}

}