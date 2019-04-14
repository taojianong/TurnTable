package ui.componet {
	
	import com.utils.TextureUtils;
	import feathers.controls.TextInput;
	import flash.text.AutoCapitalize;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * 集成自feathers的输入文本
	 * @author taojianlong 2015/3/18 23:48
	 */
	public class FTextInput extends TextInput {
		
		public var id:String = "";
		
		public function FTextInput(width:Number = 100, height:Number = 20) {
			
			super();
			
			this.width = width;
			this.height = height;
			this.fontSize = 12;
		}
		
		//mytext.textEditorProperties.autoCapitalize = AutoCapitalize.NONE;
		//mytext.textEditorProperties.autoCorrect = false;
		//mytext.textEditorProperties.color = 0xFFFFFF;
		//mytext.textEditorProperties.displayAsPassword = false;
		//mytext.textEditorProperties.fontFamily = "Helvetica";
		//mytext.textEditorProperties.fontSize =18;
		
		public function set fontSize(value:int):void {
			
			this.textEditorProperties.fontSize = value;
		}
		
		public function set fontFamily(value:String):void {
			
			this.textEditorProperties.fontFamily = value;
		}
		
		public function set color(value:uint):void {
			
			this.textEditorProperties.color = value;
		}
		
		public function set algin(value:String):void {
			
			this.alignPivot(value);
			
			//this.textEditorProperties.hAlgin = value;
		}
		
		override public function set displayAsPassword(value:Boolean):void {
			
			super.displayAsPassword = value;
		}
		
		override public function get restrict():String {
			
			return super.restrict;
		}
		
		/**
		 * 限制输入字符
		 */
		override public function set restrict(value:String):void {
			super.restrict = value;
		}
		
		/**
		 * 最大输入字符
		 */
		override public function get maxChars():int {
			return super.maxChars;
		}
		
		override public function set maxChars(value:int):void {
			super.maxChars = value;
		}
		
		override public function get text():String {
			
			return super.text;
		}
		
		override public function set text(value:String):void {
			
			super.text = value;
			
			this.border = _border;
		}
		
		private var _borderColor:uint = 0;
		
		public function set borderColor(value:uint):void {
			
			_borderColor = value;
			
			//刷新显示边框
			if (_border) {
				this.border = true;
			}
		}
		
		/**
		 * 边框颜色
		 */
		public function get borderColor():uint {
			
			return _borderColor;
		}
		
		private var _border:Boolean = false;
		
		public function set border(value:Boolean):void {
			
			_border = value;
			
			this.backgroundDisabledSkin = null;
			this.backgroundFocusedSkin = null;
			this.backgroundEnabledSkin = null;
			if (value) {
				
				var tx:Texture = TextureUtils.createTexture(this.width, this.height, 0, 0, 1, _borderColor, 1);
				var img:Image = new Image(tx);
				this.backgroundSkin = img;				
			} else {
				this.backgroundSkin = null;
			}
		}
		
		/**
		 * 是否显示边框
		 */
		public function get border():Boolean {
			
			return _border;
		}
		
		public function get editable():Boolean {
			
			return super.isEditable;
		}
		
		/**
		 * 是否可编辑
		 */
		public function set editable(value:Boolean):void {
			
			super.isEditable = value;
		}
	}

}