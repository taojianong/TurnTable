package com.ui.componet {
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	[Event(name = "triggered", type = "starling.events.Event")]
	
	/**
	 * 基于Starling的Button
	 * @author taojianlong 2015/4/23 22:53
	 */
	public class TSButton extends UIComponet {
		
		private var btn:Button;
		
		private var _upTexture:Texture;
		private var _downTexture:Texture;
		private var _label:String;
		private var _enabled:Boolean = true;
		
		public function TSButton(upState:Texture = null, text:String = "", downState:Texture = null) {
			
			super(100,40);
			
			init(upState, text, downState);			
		}
		
		private function init(upState:Texture = null, text:String = "", downState:Texture = null):void {
			
			_upTexture = upState;
			_label = text;
			_downTexture = downState;
			
			if (upState == null) {
				if (btn) {
					this.removeChild(btn);
				}
			} else {
				if (btn == null) {
					btn = new Button(upState, text, downState);
					btn.fontSize = 20;
				} else {
					btn.upState = upState;
					btn.text = text;
					btn.downState = downState;
				}
				if (!this.contains(btn)) {
					this.addChild(btn);
				}
			}
		}
		
		public function set upState(value:Texture):void {
			
			_upTexture = value;
			if (btn == null) {
				btn = new Button(upState, _label, _downTexture);
				this.addChild( btn );
			} else {
				btn.upState = upState;
			}
		}
		
		public function get upState():Texture {
			
			return _upTexture;
		}
		
		public function set label(value:String):void {
			
			_label = value;
			if (btn != null) {
				btn.text = value;
			}
		}
		/**
		 * 文字标签
		 */
		public function get label():String {
			
			return _label;
		}
		
		public function set downState(value:Texture):void {
			
			_downTexture = value;
			if (btn != null) {
				btn.downState = value;
			}
		}
		
		public function get downState():Texture {
			
			return _downTexture;
		}
		
		public function get enabled():Boolean {
			return btn ? btn.enabled : _enabled;
		}
		
		public function set enabled(value:Boolean):void {
			_enabled = value;
			
			if (btn) {
				btn.enabled = value;
			}
		}
	}
}