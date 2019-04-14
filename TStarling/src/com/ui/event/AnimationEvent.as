package com.ui.event {
	
	import starling.events.Event;	
	
	/**
	 * 动画事件
	 * @author cl 2014/11/25 15:44
	 */
	public class AnimationEvent extends Event {
		
		public static const PLAY_ONCE:String = "playOnce"; //每播放一次触发
		
		public static const PLAY_COMPLETE:String = "playComplete"; //动画播放完成
		
		public function AnimationEvent( type:String , data:Object=null , bubbles:Boolean=false ) {
			
			super( type , bubbles ,  data );
		}
		
	}
}