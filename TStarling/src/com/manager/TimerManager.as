package com.manager {
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * 时间管理器
	 * @author taojianlong 2015/4/16 22:20
	 */
	public class TimerManager {
		
		private var pool:Object = {};		
		private var timer:Timer;
		/**
		 * 渲染时间,秒
		 */
		public var time:Number = 1;
		
		/**
		 * 时间管理器构造函数
		 * @param	time
		 */
		public function TimerManager( time:Number = 1 ) {
			
			this.time = time;
		}
		
		public function put( key:String , value:ITimer ):void {
			
			if ( pool[ key ] == null ) {
				pool[ key ] = value;
			}			
			
			if ( timer == null ) {	
				timer = new Timer( 1000*time);
			}
			
			if ( !timer.hasEventListener( TimerEvent.TIMER ) ) {
				timer.addEventListener( TimerEvent.TIMER , renderHandler );
				timer.start();
			}
		}
		
		public function remove(key:String):void {
			
			pool[key] = null;
			delete pool[key];
			
			if ( this.count <= 0 ) {
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER , renderHandler );				
			}
		}
		
		private function renderHandler( event:TimerEvent ):void {
			
			for (var key:* in pool) {			
				var iTimer:ITimer = pool[ key ] as ITimer;
				if ( pauseList.indexOf( key ) != -1 ) {
					continue;
				}
				if ( iTimer != null ) {
					iTimer.time = this.time;
					iTimer.update();
				}				
			}
		}
		
		private var pauseList:Array = [];
		
		public function pause( key:String ):void {
			
			if ( key && pauseList.indexOf( key ) == -1 ) {
				pauseList.push( key );
			}
		}
		
		public function pauseAll():void {
			
			pauseList = [];
			for ( var key:* in pauseList ) {
				pauseList.push( key );
			}
		}
		
		public function start( key:String ):void {
			
			if ( pauseList.indexOf( key ) != -1 ) {
				pauseList.indexOf( pauseList.indexOf( key ) , 1  );
			}
		}
		
		public function stop( key:String ):void {
			
			delete pool[ key ];
		}
		
		public function stopAll():void {
			
			while ( this.count > 0 ) {
				for ( var key:* in pool ) {
					delete pool[ key ];
				}
			}	
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER , renderHandler );
		}
		
		public function startAll():void {
			
			while ( pauseList.length > 0 ) {
				pauseList.shift();
			}
		}		
		
		/**
		 * 对应池中数量
		 */
		public function get count():int {			
			var num:int = 0;
			for each( var value:* in pool ) {
				if ( num ) {
					num++;
				}
			}
			return num;
		}
		
		//----------------------------------------------------------------
		
		private static var timerPool:Dictionary = new Dictionary( true );
		
		/**
		 * 开始渲染
		 * @param	key		
		 * @param	iTimer
		 * @param	time
		 */
		public static function startRender( key:String , iTimer:ITimer , time:Number = 1 ):void {
			
			var tmgr:TimerManager = timerPool[ time ];
			
			if ( tmgr == null ) {
				tmgr = new TimerManager( time );
				timerPool[ time ] = tmgr;
			}
			
			tmgr.put( key , iTimer );
		}
		
		/**
		 * 停止渲染
		 * @param	key		对应key的时间管理
		 * @param	time 	0为停止所有渲染,大于0为对应秒时间域管理
		 */
		public static function stopRender( key:String , time:Number = 1 ):void {
			
			if ( time < 0 ) {
				return;
			}
			var tmgr:TimerManager = null;
			if ( time == 0 ) {				
				for each( tmgr in timerPool ) {
					tmgr.stopAll();
				}
			}
			else {
				tmgr = timerPool[ time ];
				if ( tmgr != null ) {
					tmgr.remove( key );
				}
			}			
		}
	}
}