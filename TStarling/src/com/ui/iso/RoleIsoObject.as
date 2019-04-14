package com.ui.iso {
	
	/**
	 * 角色等角投影
	 * @author taojianlong 2015/3/9 13:53
	 */
	public class RoleIsoObject extends DrawnIsoTile{
		
		protected var _direct:int ;//设置英雄方向
		protected var _isWalk:Boolean = false;//是否在行走
		
		public function RoleIsoObject( size:Number=20, color:uint=0xff0000, height:Number = 0 ) {
			
			super( size , color , height );
		}
		
		public function set direct( value:int ):void {
			
			_direct = value;
		}
		/**
		 * 设置英雄方向,MainConst中方向静态参数
		 */
		public function get direct():int {
			
			return _direct;
		}
		
		public function set isWalk( value:Boolean ):void {
			
			_isWalk = value;
		}
		/**
		 * 是否在行走
		 */
		public function get isWalk():Boolean {
			
			return _isWalk;
		}
	}

}