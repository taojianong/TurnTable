package com.scenes {
	
	import assets.Assets;
	import com.manager.UIManager;
	import com.TurntableConst;
	import com.ui.componet.TSButton;
	import com.UIGlobal;
	import starling.display.Button;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import ui.BaseUI;
	
	/**
	 * 游戏场景
	 * @author cl 2015/3/6 17:10
	 */
	public class GameScene extends BaseUI {
		
		private var turnBtn:TSButton;//转盘按钮
		
		public function GameScene() {
			
			super(null, UIGlobal.stageWidth, UIGlobal.stageHeight);
		}
		
		override protected function init():void {
			
			UIManager.Instance.openTurnTableUI();
			
			addEventListener(Event.TRIGGERED, onButtonTriggered);
			
			//转盘按钮
			turnBtn = new TSButton();
			turnBtn.id	= "turnBtn";
			turnBtn.label = "转盘";
			turnBtn.upState = Assets.getTexture("blue_out");
			turnBtn.downState = Assets.getTexture("blue_over");
			turnBtn.x = ( UIGlobal.stageWidth - turnBtn.width ) * 0.5;
			turnBtn.y = 0;
			this.addElement( turnBtn );
			
			turnBtn.addEventListener( TouchEvent.TOUCH , turnBtnTouchHandler );
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function turnBtnTouchHandler( event:TouchEvent ):void {
			
			if ( event.getTouch(this, TouchPhase.ENDED) ) {
				UIGlobal.turnTableUI.randomTo( Math.random() * TurntableConst.ratPre );
			}
		}
		
		private function onAddedToStage():void {
			
		}
		
		private function onRemovedFromStage():void {
			
		}
		
		//点击按钮
		private function onButtonTriggered(event:Event):void {
			
			var target:Button = event.target as Button;		
		}	
	}
}