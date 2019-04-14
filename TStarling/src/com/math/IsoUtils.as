package com.math {
	
	import flash.geom.Point;
	
	/**
	 * 等角投影相关方法
	 * @author taojianlong 2015/3/9 13:49
	 */
	public class IsoUtils {
		
		public static const Y_CORRECT:Number = Math.cos( -Math.PI / 6) * Math.SQRT2 ;
		
		/**
		 * 将全等坐标转换为屏幕坐标
		 * @param	pos	等角投影3D坐标 isometric 
		 * @return	屏幕坐标
		 */
		public static function isoToScreen( pos:Point3D ):Point {
			
			var screenX:Number = pos.x - pos.z ;
			var screenY:Number = pos.y * Y_CORRECT +( pos.x + pos.z ) * .5;
			
			return new Point( screenX, screenY );
		}
		
		/**
		 * 将屏幕坐标转换为等角投影3D坐标
		 * @param	point 屏幕坐标
		 * @return  等角投影坐标
		 */
		public static function screenToIso( point:Point ):Point3D {
			
			var xpos:Number = point.y + point.x * .5;
			var ypos:Number = 0;
			var zpos:Number = point.y - point.x * .5;
			
			return new Point3D( xpos, ypos, zpos );
		}
		
		/**
		 * 等角投影3D坐标中深度(z)获取
		 * @param	pos 等角投影中坐标
		 * @return  深度 z
		 */
		public static function depth( pos:Point3D ):Number {
			
			return ( pos.x +pos.z ) * .866 - pos.y * .707;
		}
	}
}