package com.ui.componet {
	
	import com.utils.ObjectPool;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.display.Stage;
	
	/**
	 * 基类Sprite再封装
	 * @author taojianlong 2014/7/5 1:17
	 */
	public class TSprite extends EventSprite {
		
		public function TSprite() {
			
			super();
		}
		
		/**将元件放到父容器底层**/
		public function toBottom():int {
			
			indexTo( 0 );
			return 0;
		}
		
		/**将元件放到父容器顶层**/
		public function toTop():int {
			
			var ind:int = this.parent != null ? this.parent.numChildren - 1 : 0;
			indexTo( ind );
			return ind;
		}
		
		/**
		 * 设置深度索引
		 * @param	index
		 */
		public function indexTo( index:int ):void {
			
			if ( this.parent != null && index >= 0 && index <= this.parent.numChildren - 1 ) {
				this.parent.setChildIndex( this , index );
			}
		}
		
		/**深度索引**/
		public function get depth():Number {
			
			return this.parent != null ? this.parent.getChildIndex( this ) : 0;
		}
		
		/**
		 * 添加元件
		 *
		 * @param	element  添加元件
		 * @param	parent   容器
		 */
		public function addElement( element:DisplayObject ):DisplayObject {
			
			if (element && !this.contains(element)) {
				
				return this.addChild( element );
			}
			return null;
		}
		
		/**
		 * 移除元件
		 *
		 * @param	element 移除元件
		 * @param	parent  父容器
		 */
		public function removeElement( element:DisplayObject , reback:Boolean = false ):DisplayObject {
			
			if ( element && this.contains( element ) ) {
				
				if ( reback ) {
					ObjectPool.recovery( element );
				}
				return this.removeChild( element );
			}
			return null;
		}
		
		/**
		 * 添加元件到父容器中
		 * @param	element 添加的元件
		 * @param	index   索引
		 * @return
		 */
		public function addElementAt( element:DisplayObject , index:int ):DisplayObject {
			
			if ( element == null ) {
				return null;
			}
			
			if ( !this.contains(element) ) {				
				return this.addChildAt( element , index );
			}
			else if ( index >= 0 && index < this.numChildren ) {				
				this.setChildIndex( element , index );
				return element;
			}
			return null;
		}
		
		/**已处在某处的元件**/
		public function removeElementAt( index:int ):DisplayObject {
			
			return this.removeChildAt( index );
		}
		
		/**
		 * 在舞台上
		 */
		public function get onStage():Boolean {
			
			return this.parent != null && stage != null;
		}
		
		private var _parent:DisplayObjectContainer; //父容器
		
		/**
		 * 检查元件的父节点中包涵有某个元件
		 *
		 * @param  displayObject 元件
		 * @param  parent 元件的父容器
		 * @return
		 */
		public function hasParent( parent:DisplayObjectContainer = null ):Boolean {
			
			_parent = _parent == null ? this.parent : _parent.parent;
			
			if (parent == null || this.parent == null || _parent == null || _parent == this) {
				
				_parent = null;
				return false;
			}
			
			if ( _parent is Stage ) {
				
				var bol:Boolean = _parent == parent;
				_parent = null;
				return bol;
			}
			
			if (parent == _parent) {
				
				_parent = null;
				return true;
			}
			
			return hasParent(parent);
		}
		
		public function getParentOf( cls:Class , _parent:DisplayObjectContainer = null ):DisplayObjectContainer {
			
			_parent = _parent == null ? this.parent : _parent.parent;
			
			if ( _parent is cls ) {
				
				return _parent;
			}
			
			if ( this.parent == null || _parent == null || _parent == this ) {
				
				return _parent is cls ? _parent : null;
			}
			
			if ( _parent is Stage ) {
				
				return _parent is cls ? _parent : null;
			}
			
			/*if ( parent == _parent ) {
				
				return _parent is cls ? _parent : null;
			}*/
			
			return getParentOf( cls , _parent );
		}
		
		/**
		 * 判断是否有某个子元件
		 * 暂时不能判断容器中的子容器是否包含某个子元件，有必要则添加
		 * @param	element
		 * @return
		 */
		public function hasChild( element:DisplayObject , parent:DisplayObjectContainer = null ):Boolean {
			
			/*
			//暂时不需要
			if ( parent == null ) {
				parent = this;
			}			
			var disObj:DisplayObject;
			for (var i:int = 0; i < parent.numChildren;i++ ) {
				disObj = parent.getChildAt(i);
				if ( disObj == element ) {
					return true;
				}
				else {
					return hasChild( element , disObj );
				}
			}
			*/
			
			return element && this.contains( element );
		}
		
		/**
		 * 根据组件ID返回对应组件,获取继承自BSprite的组件
		 *
		 * @param	id  组件ID
		 * @return
		 */
		public function getElementById( id:String , parent:Sprite = null ):* {
			
			if (parent == null) {
				
				parent = this;
			}
			
			var disObj:*;
			var i:uint;
			for (i = 0; i < parent.numChildren; i++) {
				
				disObj = parent.getChildAt(i);
				if (disObj.hasOwnProperty("id") && disObj.id == id) {
					
					return disObj;
				}
			}
			return null;
		}
		
		/**
		 * 获取该容器子节点中对应ID的组件，找到就返回，在该节点下的所有子节点ID不能相同
		 * @param	id 组件ID
		 * @return
		 */
		public function getChildElement(id:String, parent:Sprite = null):* {
			
			if (parent == null) {
				
				parent = this;
			}
			var sonObj:*;
			var disObj:*;
			var i:uint;
			for (i = 0; i < parent.numChildren; i++) {
				
				sonObj = parent.getChildAt(i);
				if (sonObj.hasOwnProperty("id") && sonObj.id == id) {
					
					return sonObj;
				} else if (sonObj is DisplayObjectContainer) {
					
					disObj = getChildElement(id, sonObj);
					if (disObj) {
						return disObj;
					}
				}
			}
			return null;
		}
		
		/******************************************************
		 * 移除所有元件
		 * @param isReback 是否回收
		 */
		public function removeAll(isReback:Boolean = false):void {
			
			var displayObject:DisplayObject;
			while (this.numChildren > 0) {				
				if (!isReback) {
					displayObject = this.removeChildAt(0,true);
					displayObject = null;
				} else {
					displayObject = this.removeChildAt(0);
					recover(displayObject);
				}
			}
		}
		
		/**
		 * 从父容易移除
		 * @param isReback 是否回收
		 */
		public function removeFromParentContainer( isReback:Boolean = false ):void {
			
			if ( this.parent != null && this.parent.contains( this ) ) {
				if ( !isReback ) {					
					this.parent.removeChild( this );					
				}
				else {
					recover( this.parent.removeChild( this ) );
				}
			}
		}
		
		//回收对象
		protected function recover(displayObject:DisplayObject):DisplayObject {
			
			return ObjectPool.recovery( displayObject );
		}
		
		/**获取该对象类**/
		public function get thisClass():Class {
			
			return ObjectPool.getClass( this ) ;
		}
		
		public function get thisClassName():String {
			
			return ObjectPool.getClassName( this );
		}
		
		/**
		 * 移除对应所有可视对象
		 * @param	cls
		 */
		public function removeAllChildOfClass(cls:Class,isReback:Boolean = false):void {
			
			var count:uint = this.getChildCountOfClass(cls);
			var disObj:DisplayObject;
			var i:uint;
			while (count > 0) {
				for (i = 0; i < this.numChildren; i++) {
					disObj = this.getChildAt(i) as DisplayObject;
					if (disObj && disObj is cls) {
						this.removeChild(disObj);
						if ( isReback ) {
							recover( disObj );
						}				
						count--;
					}
				}
			}
		}
		
		/**
		 * 获取容器中对应可视对象数量
		 * @param	cls
		 * @return
		 */
		public function getChildCountOfClass(cls:Class):uint {
			
			var count:uint = 0;
			var i:int;
			var disObj:DisplayObject;
			for (i = 0; i < this.numChildren; i++) {
				disObj = this.getChildAt(i) as DisplayObject;
				if (disObj && disObj is cls) {
					count++;
				}
			}
			return count;
		}
	}
}