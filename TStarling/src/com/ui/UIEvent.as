package com.ui {
	
	import starling.events.Event;	
	
	/**
	 * UI相关事件
	 * @author taojianlong 2014/7/2 20:43
	 */
	public class UIEvent extends Event {
		
		public static const CREATE_COMPLETE:String = "create_complete";
		
		public function UIEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}	
	}
}