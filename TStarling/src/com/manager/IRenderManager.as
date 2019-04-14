package com.manager{
	
	/**
	 * 渲染管理器接口
	 * @author cl 2014/7/15 10:55
	 */
	public interface IRenderManager extends ITimer {
		
		function set id( value:String ):void;
		function get id():String;
		
		//function update():void;		
		function resize():void;//自适应
	}
}