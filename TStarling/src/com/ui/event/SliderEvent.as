package com.ui.event {
	
	import starling.events.Event;
	
	/**
	 * 滑动按钮事件
	 * @author taojianlong
	 */
	public class SliderEvent extends Event {
		
		public static const SHOW:String	 	= "show";
		public static const HIDE:String 	= "hide";
		public static const SLIDER:String 	= "slider";
		
		public var progress:Number 		= 0;//滑动进度		
		public var sliderValue:Number 	= 0;//滑动值
		
		public function SliderEvent(type:String, bubbles:Boolean = false, data:Object = null ) {
			super(type, bubbles, data);
		}
	
	}

}