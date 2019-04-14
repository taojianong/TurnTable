package com.ui.componet {
	
	import starling.display.Sprite;
	
	/**
	 * 处理基本事件的元件
	 * @author cl 2015/1/8 17:02
	 */
	public class EventSprite extends Sprite {
		
		//元件ID
		protected var _id:String = "";
		public function set id( value:String ):void {
			_id = value;
		}
		public function get id():String {
			return _id;
		}
		
		protected var _listenerList:Array = []; //监听事件列表
		
		public function EventSprite() {
			super();
		}
		
		/******************************************移除所有监听*********************************************
		 * 重载的 addEventListener方法，在添加事件侦听时将其存在一个数组中，以便记录所有已添加的事件侦听
		 */
		override public function addEventListener(type:String, listener:Function ):void {
			
			var obj:Object = new Object();
			obj.type = type;
			obj.listener = listener;
			_listenerList.push(obj);
			super.addEventListener(type, listener );
		}
		
		override public function removeEventListener(type:String, listener:Function ):void {
			
			var obj:Object;
			for each ( obj in _listenerList ) {				
				if ( obj.type == type && obj.listener == listener ) {					
					_listenerList.splice(_listenerList.indexOf(obj), 1);
					break;
				}
			}
			super.removeEventListener(type, listener);
		}
		
		/**
		 * 自我毁灭，删除所有事件侦听器以及从父显示对象中移除，等待垃圾回收
		 */
		public function removeAllListeners():void {
			
			var obj:Object;
			while (_listenerList && _listenerList.length > 0) {
				obj = _listenerList.shift();
				if (obj) {
					removeEventListener(obj.type, obj.listener);
				}
			}
		}
		
		/**
		 * 监听事件列表
		 *
		 **/
		public function get listenerList():Array {
			
			return _listenerList;
		}
		
		/**
		 * 是否有对应事件的监听事件
		 * @param	type      事件类型
		 * @param	listener  事件方法
		 * @return
		 */
		public function hasListenerOf( type:String , listener:Function = null ):Boolean {
			
			var obj:Object;
			for each (obj in _listenerList) {				
				if (obj.type == type && ( obj.listener == listener || listener == null ) ) {					
					return true;
				}
			}			
			return false;
		}	
	}
}