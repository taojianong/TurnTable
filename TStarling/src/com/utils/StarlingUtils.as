package com.utils {
	
	import flash.system.Capabilities;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.utils.deg2rad;
	
	/**
	 * Starling 管理器
	 * @author taojianlong 2014-5-17 11:54
	 */
	public class StarlingUtils {
		
		/**
		 * 转换为弧度
		 * @param	displyObject
		 * @param	angle 0 ~ 360
		 */
		public static function switchAngle( displyObject:DisplayObject , angle:Number = 0 ):void {
			
			displyObject.rotation = deg2rad( angle ); //转换为弧度
		}
		
		/**
		 * 判断是否使用硬件渲染
		 */
		public function get isHW():Boolean {
			
			return Starling.context.driverInfo.toLowerCase().indexOf("software") == -1; 
		}		
		
		public static function get isIOS():Boolean {
			return Capabilities.manufacturer.indexOf("iOS") != -1;
		}
		
		public static function get isAndroid():Boolean {
			return Capabilities.manufacturer.indexOf("Android") != -1;
		}
	}
}