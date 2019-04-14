package ui {
	
	import com.ui.componet.BackGround;
	import com.ui.UIContainer;
	import com.ui.UIEvent;
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * Starling UI基类
	 * @author taojianlong 2014/6/30 0:47
	 */
	public class BaseUI extends UIContainer {
		
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		public var background:BackGround;
		
		public function BaseUI(xml:XML, width:Number = 400, height:Number = 800) {
			
			_width  = width;
			_height = height;
			
			super( xml );
			
			background = new BackGround(width, height, 0x00ff00, 1 , 2, 0xff0000, 1);
			this.addChildAt( background , 0 );
		}
		
		override protected function createComplete(event:UIEvent):void {
			
			super.createComplete(event);
			
			this.addEventListener( TouchEvent.TOUCH , touchHandler );
		}
		
		protected function touchHandler( event:TouchEvent ):void {
			
			var touch:Touch = event.getTouch( stage );
			if ( touch == null ) {
				return;
			}
			var target:DisplayObject = event.target as DisplayObject;
			
			switch( touch.phase ) {
				
				case TouchPhase.BEGAN:
					
					break;
					
				case TouchPhase.MOVED:
					
					break;
				
				case TouchPhase.ENDED:
					
					break;
			}
		}
		
		override public function get width():Number {
			
			return _width;
		}
		
		override public function set width(value:Number):void {
			
			_width = value;
		}
		
		override public function get height():Number {
			
			return _height;
		}
		
		override public function set height(value:Number):void {
			
			_height = value;
		}
	}

}