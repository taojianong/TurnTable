package com.ui.iso {
	
	import com.manager.IRender;
	import com.ui.componet.Animation;
	import com.ui.componet.AnimationData;
	import com.ui.componet.Rect;
	
	/**
	 * 动画等角阴影对象
	 * @author cl 2015/3/9 15:34
	 */
	public class AnimationIsoObject extends DrawnIsoTile implements IRender {
		
		private var ani:Animation;
		
		private var _aniOffsetX:Number = 0;
		private var _aniOffsetY:Number = 0;
		
		public function AnimationIsoObject(data:AnimationData = null) {
			
			super(30, 0xff0000);
			
			ani = new Animation( null , true );
			//ani.touchable = false;
			this.addElement(ani);
			
			this.setAnimationData(data);
			this.touchable = true;
		}
		
		public function play():void {
			
		}
		
		public function pause():void {
			
		}
		
		public function set aniOffsetX( value:Number ):void {
			
			_aniOffsetX = value;
			
			this.updateAniXY();
		}
		/**
		 * 动画偏移X坐标
		 */
		public function get aniOffsetX():Number {
			
			return _aniOffsetX;
		}
		
		public function set aniOffsetY( value:Number ):void {
			
			_aniOffsetY = value;
			
			this.updateAniXY();
		}
		/**
		 * 动画偏移Y坐标
		 */
		public function get aniOffsetY():Number {
			
			return _aniOffsetY;
		}
		
		override public function get scaleX():Number {
			
			return ani.scaleX;
		}
		
		override public function set scaleX(value:Number):void {
			
			ani.scaleX = value;
			
			this.updateAniXY();
		}
		
		override public function get scaleY():Number {
			
			return ani.scaleY;
		}
		
		override public function set scaleY(value:Number):void {
			
			ani.scaleY = value;
			
			this.updateAniXY();
		}
		
		public function setLabel( text:String , offsetY:Number = 0 ):void {
			
			this.showTxt(text);
			
			_txt.y = -this.contentHeight - _txt.height * 0.5 + offsetY;
			
			this.addElementAtTop(_txt);
		}
		
		override public function get contentWidth():Number {
			
			return ani.animationData != null ? -ani.animationData.frameWidth : super.contentWidth;
		}
		
		override public function get contentHeight():Number {
			
			return ani.animationData != null ? -ani.animationData.frameHeight : super.contentHeight;
		}
		
		/**
		 * 设置动画
		 * @param	data
		 */
		public function setAnimationData(data:AnimationData):void {
			
			ani.animationData = data;
			
			this.updateAniXY();
		}
		
		protected function updateAniXY():void {
			
			if (ani.animationData != null) {
				
				_contentWidth  = ani.animationData.frameWidth;
				_contentHeight = ani.animationData.frameHeight;
				
				ani.x = _aniOffsetX;// -ani.animationData.frameWidth * ani.scaleX * 0.5;
				ani.y = -_contentHeight * ani.scaleY * 0.5 + _aniOffsetY;
				
			} else {
				
				_contentWidth = this.width;
				_contentHeight = this.height;
				
				ani.x = ani.animationData.frameWidth * ani.scaleX * 0.5 + _aniOffsetX;
				ani.y = _aniOffsetY;
			}		
		}
		
		public function set isPause( value:Boolean ):void {
			
			if (ani != null) {
				ani.isPause = value;
			}
		}
		
		public function get isPause():Boolean {
			
			return ani && ani.isPause;
		}
		
		public function renderAnimation():void {
			
			if ( ani != null ) {
				ani.renderAnimation();
			}
		}
		
		public function set currentFrame(value:int):void {
			
			if (ani != null) {
				ani.currentFrame = value;
			}
		}
		
		public function stop():void {
			
			if (ani != null) {
				ani.stop();
			}
		}
		
		override public function showBorder(color:uint = 0xff0000):void {
			
			borderRect   = borderRect || new Rect( _contentWidth * this.scaleX , _contentHeight * this.scaleY , 0 , 0 , color , 1 , 2 );			
			borderRect.drawRect( this._contentWidth * this.scaleX , this._contentHeight * this.scaleY , 0 , 0 , 1 , color , 2 );
			borderRect.x = -borderRect.width * 0.5;
			borderRect.y = -borderRect.height + 17;
			this.addElement( borderRect );
			
			//ani.showBorder(color);
		}
	}
}