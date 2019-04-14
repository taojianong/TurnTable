package com.manager {
	
	/**
	 * 时间接口
	 * @author taojianlong 2015/4/16 22:22
	 */
	public interface ITimer {
		
		function update():void;
		
		function set time( value:Number):void; //对应的时间，秒
		function get time():Number;
	}

}