package com.manager {
	import com.TurntableConst;
	import com.UIGlobal;
	import flash.ui.Keyboard;
	import starling.core.Starling;
	import starling.events.KeyboardEvent;
	
	/**
	 * 键盘事件管理
	 * @author cl 2015/3/6 18:03
	 */
	public class KeyManager {
		
		public function keyDownHandler( event:KeyboardEvent ):void {
			
			switch( event.keyCode ) {
				
				case Keyboard.SPACE:
					Starling.current.showStats = !Starling.current.showStats;
					break;
					
				case Keyboard.X:
					Starling.context.dispose();
					break;
			}
		}
		
		public function keyUpHandler( event:KeyboardEvent ):void {
			
			switch( event.keyCode ) {
				
				case Keyboard.SPACE:
					break;
					
				case Keyboard.X:
					break;
					
				case Keyboard.S:
					if ( event.altKey ) {
						if ( UIGlobal.turnTableUI != null ) {
							UIGlobal.turnTableUI.randomTo( Math.random() * TurntableConst.ratPre );
						}
					}
					break;
			}
		}
		
		private static var instance:KeyManager;
		public static function get Instance():KeyManager {
			return instance = instance || new KeyManager();
		}
	}

}