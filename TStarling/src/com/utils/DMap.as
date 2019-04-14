package com.utils {
	import flash.utils.Dictionary;
	
	public class DMap implements IMap {
		
		public var d:Dictionary;
		
		public function DMap(weakKeys:Boolean = false) {
			
			d = new Dictionary(weakKeys);
		}
		
		/**添加键值对**/
		public function put(key:Object, value:Object):void {
			
			d[key] = value;
		}
		
		/**是否包含键对应的键值对**/
		public function containsKey(key:Object):Boolean {
			
			return d[key] != null;
		}
		
		/**根据键获得值 没有则返回null**/
		public function get(key:Object):* {
			
			if ( !containsKey( key ) ) {
				
				return null;
			}
			
			return d[key];
		}
		
		/**根据键删除键值对**/
		public function remove(key:Object):void {
			
			if (containsKey(key)) {
				
				d[key] = null;
				delete d[key];
			}
		}
		
		/**删除所有键值对**/
		public function clear():void {
			
			var key:Object;
			while (this.keys > 0) {
				
				for ( key in d ) {
					
					remove(key);
				}
			}
		}
		
		/**
		 * map中含有对象个数
		 * @return 数组字典中对象数目
		 *
		 */
		public function get keys():int {
			
			var count:int = 0;
			var key:*;
			for each ( key in d) {
				count++;
			}
			return count;
		}
		
		/**将map中数据转换为数组**/
		public function toArray():Array {
			
			var list:Array = [];
			var data:*;
			for each ( data in d) {
				
				list.push(data);
			}
			return list;
		}
	}
}