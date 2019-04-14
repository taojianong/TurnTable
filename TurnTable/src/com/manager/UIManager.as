package com.manager {
	
	import com.scenes.GameScene;
	import com.UIGlobal;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import ui.TurntableUI;
	
	/**
	 * UI管理
	 * @author cl 2015/3/6 17:07
	 */
	public class UIManager {
		
		public static const ADD_NOMAL:int 	= 0;//添加一次移除一次
		public static const ADD_ONLY:int 	= 1;//只添加
		
		/**
		 * 打开游戏主场景
		 */
		public function openGameScene():void {
			
			UIGlobal.gameScene = UIGlobal.gameScene|| new GameScene();
			var cx:Number = ( UIGlobal.stageWidth - UIGlobal.gameScene.width ) * 0.5;
			var cy:Number = ( UIGlobal.stageHeight - UIGlobal.gameScene.height ) * 0.5;
			this.addElement( UIGlobal.gameScene , LayerManager.gameLayer , cx , cy );
		}
		
		/**
		 * 关闭游戏主场景
		 */
		public function closeGameScene():void {
			
			this.removeElement( UIGlobal.gameScene , LayerManager.gameLayer );
		}
		
		/**
		 * 打开转盘界面
		 */
		public function openTurnTableUI():void {
			
			UIGlobal.turnTableUI = UIGlobal.turnTableUI || new TurntableUI();
			
			var cx:Number = ( UIGlobal.stageWidth - UIGlobal.turnTableUI.width ) * 0.5;
			var cy:Number = ( UIGlobal.stageHeight - UIGlobal.turnTableUI.height ) * 0.5;
			
			addElement( UIGlobal.turnTableUI , LayerManager.uiLayer , cx , cy );
		}
		
		/**
		 * 关闭转盘界面
		 */
		public function closeTurnTableUI():void {
			
			removeElement( UIGlobal.turnTableUI , LayerManager.uiLayer );
		}
		
		/**
		 * 添加元件到容器中
		 * @param	displayObject
		 * @param	container
		 * @param	x
		 * @param	y
		 * @param	type
		 */
		public function addElement( displayObject:DisplayObject , container:DisplayObjectContainer , x:Number = 0 , y:Number = 0 , type:int = ADD_ONLY ):void {
			
			if ( displayObject != null && container != null ) {
				
				displayObject.x = x;
				displayObject.y = y;
				
				if ( type == ADD_NOMAL ) {
					if ( !container.contains( displayObject ) ) {
						container.addChild( displayObject );
					}
					else {
						container.removeChild( displayObject );
					}
				}
				else {
					if ( !container.contains( displayObject ) ) {
						container.addChild( displayObject );
					}
				}
			}
		}
		
		/**
		 * 从容器中移除元件
		 * @param	displayObject
		 * @param	container
		 */
		public function removeElement( displayObject:DisplayObject , container:DisplayObjectContainer ):void {
			
			if ( displayObject && container && container.contains( displayObject ) ) {
				container.removeChild( displayObject );
			}
		}
		
		private static var instance:UIManager;
		public static function get Instance():UIManager {
			return instance = instance || new UIManager();
		}
	}

}