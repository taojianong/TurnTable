package com.utils {
	
	import avmplus.getQualifiedClassName;
	import starling.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import com.utils.DMap;
	
	/**
	 * 对象池管理
	 * @author cl 2013.3.4
	 */
	public class ObjectPool {
		
		public static var classPool:DMap = new DMap( true ); //ObjectPool保存对应类的池
		
		private var objectPool:DMap = new DMap; //保存对应类所实例的对象池 
		private var _cls:Class;
		private var serial:int = 0; //生产序列号
		
		public function ObjectPool( cls:Class ) {
			
			_cls = cls;
			
			if ( !classPool.containsKey( cls ) && cls ) {
				classPool.put(cls, this);
			}			
		}
		
		public static function getObjectPool( value:Class ):ObjectPool {
			
			if (!classPool.get(value)) {
				
				classPool.put(value, new ObjectPool(value));
			}
			return classPool.get(value) as ObjectPool;
		}
		
		/**
		 * 获取对应类实例对象
		 * @param ...args 类构造参数
		 * @return
		 */
		public function getObject(... args):Object {
			
			var obj:Object;
			for each ( obj in objectPool.d ) {			
				if ( obj.parent != null ) {
					continue;
				}
				objectPool.remove( obj );
				return obj;
			}
			
			switch (args.length) {
				case 1: 
					obj = new _cls(args[0]);
					break;
				case 2: 
					obj = new _cls(args[0], args[1]);
					break;
				case 3: 
					obj = new _cls(args[0], args[1], args[2]);
					break;
				case 4: 
					obj = new _cls(args[0], args[1], args[2], args[3]);
					break;
				case 5: 
					obj = new _cls(args[0], args[1], args[2], args[3], args[4]);
					break;
				case 6: 
					obj = new _cls(args[0], args[1], args[2], args[3], args[4], args[5]);
					break;
				case 7: 
					obj = new _cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
					break;
				case 8: 
					obj = new _cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
					break;
				case 9: 
					obj = new _cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
					break;
				default: 
					obj = new _cls();
			}
			obj.name = this.getClassName() + "_" + serial;
			serial++;
			
			return obj;
		}
		
		/**
		 * 创建对象，并保存到池中
		 * @param	...args
		 * @return
		 */
		public function createObject( ...args ):Object {
			
			var obj:Object;
			for each ( obj in objectPool.d ) {			
				if ( obj.parent != null ) {
					continue;
				}
				return obj;
			}
			
			switch (args.length) {
				case 1: 
					obj = new _cls(args[0]);
					break;
				case 2: 
					obj = new _cls(args[0], args[1]);
					break;
				case 3: 
					obj = new _cls(args[0], args[1], args[2]);
					break;
				case 4: 
					obj = new _cls(args[0], args[1], args[2], args[3]);
					break;
				case 5: 
					obj = new _cls(args[0], args[1], args[2], args[3], args[4]);
					break;
				case 6: 
					obj = new _cls(args[0], args[1], args[2], args[3], args[4], args[5]);
					break;
				case 7: 
					obj = new _cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
					break;
				case 8: 
					obj = new _cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
					break;
				case 9: 
					obj = new _cls(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
					break;
				default: 
					obj = new _cls();
			}
			obj.name = this.getClassName() + "_" + serial;
			serial++;
			
			recovery( obj );
			
			return obj;
		}
		
		/**
		 * 外部NEW的对象放入池中
		 * @param	obj
		 * @return
		 */
		public function addObject( obj:Object ):Object {
			
			if ( obj && obj is this.getClass() ) {
				
				obj.name = this.getClassName() + "_" + serial;
				serial++;
			}
			return obj;
		}
		
		/**
		 * 搜索对应键值的对象
		 * @param	...args 格式{ key:key , value:val } , { key:key , value:val }
		 */
		public function searchObject(... args):Object {
			
			var keys:int; //满足条件的所有key
			var sObj:Object;
			var obj:Object;
			for each (sObj in objectPool.d) {
				
				keys = 0;
				for each (obj in args) {
					
					if (sObj.hasOwnProperty(obj.key) && sObj[obj.key] == obj.value) {
						
						keys++;
					}
				}
				
				if (keys == args.length) {
					
					objectPool.remove( sObj );
					return sObj;
				}
			}
			
			return null;
		}
		
		/**使用某个对象**/
		public function useObject( value:Object ):Object {
			
			if ( objectPool.containsKey( value ) ) {
				
				objectPool.remove( value );
			}
			return value;
		}
		
		/**
		 * 回收对象
		 * @param value
		 */
		public function recovery( value:Object ):Object {
			
			if (value && value is _cls && !objectPool.containsKey( value ) ) {//&& value.parent == null 
				
				objectPool.put( value , value);				
			}
			/*else {
				
				throw(new Error("回收对象不是对象池所回收的类"));
			}*/
			return value;
		}
		
		public function clear():void {
			
			objectPool.clear();
			serial = 0;
			_cls = null;
		}
		
		public function getClass():Class {
			
			return _cls;
		}
		
		/**
		 * 获取类的名字
		 * @return
		 */
		public function getClassName():String {
			
			return getQualifiedClassName( _cls );
		}
		
		/**
		 * 返回对象池生产对象的总数，包括外部正在使用的该类对象的个数
		 */
		public function get count():int {
			
			return serial;
		}
		
		/**
		 * 当前池中对象数量
		 */
		public function get poolCount():int {
			
			return objectPool.keys;
		}
		
		/**
		 * 释放所有资源
		 */
		public function dispose():void {
			
			objectPool.clear();
		}
		
		
		//--------------------------------------静态方法----------------------------------
		
		/**
		 * 正在使用某个对象
		 * @param	displayObject
		 * @return
		 */
		public static function useObject( displayObject:DisplayObject ):DisplayObject {
			
			var cls:Class = getDefinitionByName( getQualifiedClassName( displayObject ) ) as Class;
			if ( cls != null ) {						
				ObjectPool.getObjectPool( cls ).useObject( displayObject );
			}
			return displayObject;
		}
		
		/**
		 * 获取某个对象对应的类
		 * @param	displayObject
		 * @return
		 */
		public static function getClass( obj:* ):Class {
			
			return getDefinitionByName( getQualifiedClassName( obj ) ) as Class;
		}
		
		/**
		 * 获取某个对象的类名
		 * @param	obj
		 * @return
		 */
		public static function getClassName( obj:* ):String {
			
			return getQualifiedClassName( obj );
		}
		
		/**
		 * 回收可是对象
		 * @param	displayObject
		 * @return
		 */
		public static function recovery( displayObject:DisplayObject ):DisplayObject {
			
			var cls:Class = getDefinitionByName( getQualifiedClassName( displayObject ) ) as Class;
			if ( cls != null && displayObject != null ) {						
				ObjectPool.getObjectPool( cls ).recovery( displayObject );
			}
			return displayObject;
		}
		
		/**
		 * 释放所有类对象池的数据
		 */
		public static function destroy():void {
			
			var oPool:ObjectPool;
			for each (oPool in classPool.d) {
				
				oPool.clear();
			}
		}
		
		/**释放**/
		public static function dispose():void {
			
			var oPool:ObjectPool;
			for each ( oPool in classPool.d ) {				
				if ( oPool.poolCount == 0 ) {					
					oPool.dispose();					
					classPool.remove( oPool.getClass() );
				}
			}
		}
	}
}
