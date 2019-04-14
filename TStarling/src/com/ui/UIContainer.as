package com.ui {
	
	import com.ui.componet.TSprite;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.utils.Dictionary;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	/**
	 * 界面容器
	 * @author taojianlong 2014-2-22 16:49
	 */
	public class UIContainer extends TSprite {
		
		private var pool:Dictionary = new Dictionary;
		private var displayList:Array;
		
		public var isComplete:Boolean = false;
		
		/**
		 * 界面容器
		 * @param	file 配置文件地址或者UI XML数据
		 */
		public function UIContainer(xml:XML = null) {
			
			super();
			
			displayList = new UIXMLAnalyze(xml).displayList;
			
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			this.addEventListener(UIEvent.CREATE_COMPLETE, createComplete);
			
			init();
		}
		
		protected function init():void {
			
			if ( displayList == null || displayList.length <= 0 ) {
				this.dispatchEvent( new UIEvent( UIEvent.CREATE_COMPLETE ) );
			}
			else {
				addDiaplayObject();	
			}
		}
		
		protected function createComplete(event:UIEvent):void {
			
			this.removeEventListener(UIEvent.CREATE_COMPLETE, createComplete);
			
			this.isComplete = true;
		}
		
		protected function addToStageHandler(event:Event):void {
		}
		
		protected function removeFromStageHandler(event:Event):void {
		}
		
		private function addDiaplayObject():void {
			
			if (displayList == null || displayList.length <= 0) {
				//UI创建完成
				this.dispatchEvent(new UIEvent(UIEvent.CREATE_COMPLETE));
				return;
			}
			
			var i:int;
			var disObj:starling.display.DisplayObject;
			for (i = 0; i < displayList.length; i++) {
				
				disObj = displayList[i] as starling.display.DisplayObject;
				
				if (disObj == null) {
					continue;
				}
				
				if (disObj.name in pool) {
					if (disObj.name != null)
						throw new Error("界面中存在相同name的组件");
					
				} else {
					
					pool[disObj.name] = disObj;
				}
				
				if (!this.contains(disObj)) {
					this.addChild(disObj);
				}
			}
			
			//UI创建完成
			this.dispatchEvent(new UIEvent(UIEvent.CREATE_COMPLETE));
		}
		
		/*public function addElement(child:starling.display.DisplayObject):starling.display.DisplayObject {
			if (child && !this.contains(child)) {
				return this.addChild(child);
			}
			return null;
		}*/
		
		/*public function addElementAt(child:starling.display.DisplayObject, index:int):starling.display.DisplayObject {
			if (child && !this.contains(child)) {
				return this.addChildAt(child,index);
			}
			return null;
		}*/
		
		/*public function removeElement(child:starling.display.DisplayObject, dispose:Boolean = false):starling.display.DisplayObject {
			if (child && this.contains(child)) {
				return this.removeChild(child,dispose);
			}
			return null;
		}*/
		
		/*public function removeElementAt(index:int, dispose:Boolean = false):starling.display.DisplayObject {
			
			if ( this.getChildAt(index) != null ) {
				return this.removeChildAt(index, dispose);
			}
			return null;
		}*/
		
		/**
		 * 添加传统元件到舞台
		 * @param	child
		 */
		public function addChildToNative( child : flash.display.DisplayObject ):void {
			
			if ( !Starling.current.nativeOverlay.contains( child ) ) {
				Starling.current.nativeOverlay.addChild( child );
			}
		}
		
		/**
		 * 从传统舞台移除
		 * @param	child
		 */
		public function removeChildFromNative( child : flash.display.DisplayObject ):void {
			
			if ( Starling.current.nativeOverlay.contains( child ) ) {
				Starling.current.nativeOverlay.removeChild( child );
			}
		}
		
		/**
		 * 指定传统焦点
		 */
		public function set nativeFocus( child:InteractiveObject ):void {
			
			Starling.current.nativeStage.focus = child;
		}
		
		override public function dispose():void {
			
			super.dispose();
			
			displayList = null;
			pool = null;
		}
	}

}