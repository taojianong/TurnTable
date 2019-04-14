package com.ui.componet {
	import com.ui.UITexture;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * Alert框
	 * @author taojianlong 2015/4/20 23:34
	 */
	public class Alert extends UIComponet {
		
		public static const NULL:uint 	= 0;
		public static const OK:uint 	= 1;
		public static const CANCEL:uint = 2;
		
		protected var back:TSImage;
		protected var titLab:TSLabel;
		protected var infoLab:TSLabel;
		protected var yesBtn:TSButton;
		protected var noBtn:TSButton;
		protected var closeBtn:TSButton;
		
		protected var _data:Object 			= null;
		protected var _okFunc:Function 		= null;
		protected var _noFunc:Function 		= null;
		protected var _closeFunc:Function 	= null;
		
		public function Alert( width:Number=100, height:Number=100 ) {
			
			super( width , height );
			
			this.init();
		}	
		
		protected function init():void {
			
			var backTx:Texture 	= UITexture.getTexture( this.width , this.height , 0xcccccc , 0.5 , 0x00ff00 , 1 , 1 , 4 );
			var upTx:Texture 	= UITexture.getTexture( 60 , 30 , 0x000000 , 0.5 , 0xff0000 , 1 , 1 , 4 );
			var downTx:Texture 	= UITexture.getTexture( 60 , 30 , 0xcccccc , 0.8 , 0xff0000 , 1 , 1 , 4 );
			var closeupTx:Texture 	= UITexture.getTexture( 40 , 40 , 0x000000 , 0.5 , 0xff0000 , 1 , 1 , 4 );
			var closedownTx:Texture 	= UITexture.getTexture( 40 , 40 , 0xcccccc , 0.8 , 0xff0000 , 1 , 1 , 4 );
			
			back = new TSImage( backTx );
			
			yesBtn		= new TSButton( upTx , "确定" , downTx );
			noBtn	 	= new TSButton( upTx , "取消" , downTx );
			
			yesBtn.width = noBtn.width = upTx.nativeWidth;
			
			closeBtn 	= new TSButton( closeupTx , "X" , closedownTx );
			closeBtn.width = closeupTx.nativeWidth;
			closeBtn.x = this.width - closeBtn.width;
			
			titLab 			= new TSLabel();
			titLab.width 	= this.width;
			titLab.height 	= 40;
			titLab.algin 	= "center";
			titLab.color 	= 0xffffff;
			titLab.fontSize = 24;
			titLab.text 	= "标题";
			
			infoLab = new TSLabel();
			infoLab.width = this.width - 20 ;
			infoLab.height = 40;
			infoLab.x = (this.width - infoLab.width ) / 2;
			infoLab.y = titLab.y + titLab.height + 20;
			infoLab.fontSize = 20;
			infoLab.text = "Alert提示信息";
			
			this.addElement( back );
			this.addElement( titLab );
			this.addElement( infoLab );
			this.addElement( closeBtn );
			
			yesBtn.addEventListener( TouchEvent.TOUCH , touchYesHandler );
			noBtn.addEventListener( TouchEvent.TOUCH , touchNoHandler );
			closeBtn.addEventListener( TouchEvent.TOUCH , touchCloseHandler );			
		}
		
		//确定
		protected function touchYesHandler( event:TouchEvent ):void {
			
			var target:* = event.currentTarget;
			if (event.getTouch(this, TouchPhase.ENDED)) {
				if ( _okFunc != null ) {
					_okFunc();
				}
			}
		}
		
		//取消
		protected function touchNoHandler( event:TouchEvent ):void {
			
			if (event.getTouch(this, TouchPhase.ENDED)) {
				if ( _noFunc != null ) {
					_noFunc();
				}
			}
		}
		
		//关闭
		protected function touchCloseHandler( event:TouchEvent ):void {
			
			var target:Touch = event.getTouch(this, TouchPhase.ENDED);
			//target.globalX
			//target.globalY			
			if ( target ) {				
				if ( _closeFunc != null ) {
					_closeFunc();
				}
			}
		}
		
		/**
		 * 显示Alert提示
		 * @param	info
		 * @param	title
		 * @param	flag
		 * @param	okFunc
		 * @param	noFunc
		 * @param	closeFunc
		 */
		public function show( info:String , title:String = "", flag:int = 1 , data:Object = null , okFunc:Function = null , noFunc:Function = null , closeFunc:Function = null ):void {
			
			_data 		= data;
			_okFunc 	= okFunc;
			_noFunc 	= noFunc;
			_closeFunc 	= closeFunc;
			
			this.setTitle( title );
			
			this.showTxt( info );
			
			this.showBtn( flag );
		}
		
		/**
		 * 附加值
		 */
		public function get data():Object {
			
			return _data;
		}
		
		/**显示标题**/
		public function setTitle( value:String, fontSize:Number = 16 , color:uint = 0x9a7443, offsetY:Number = 0 ):void {
			
			titLab.fontSize = fontSize;
			titLab.color 	= color;
			titLab.y 		= offsetY;
			titLab.height 	= 35;
			titLab.text 	= value;
		}
		
		/**
		 * 显示文本
		 * @param	text
		 * @param	isHtml
		 */
		public function showTxt( text:String , offsetX:Number = 0 , offsetY:Number = 0 ):void {
			
			infoLab.text = text;
			
			infoLab.x = (this.width - infoLab.width ) / 2 + offsetX;
			infoLab.y = titLab.y + titLab.height + 20 + offsetY;
		}
		
		//显示确定取消按钮
		public function showBtn(flag:int = 1, offsetX:Number = 50 , offsetY:Number = 30):void {
			
			this.removeElement( yesBtn );
			this.removeElement( noBtn );
			
			if (flag & OK) {
				this.addChild(yesBtn);
			}
			
			if (flag & CANCEL) {
				this.addChild(noBtn);
			}
			
			//当只有确定按钮或取消按钮时，居中显示确定按钮或取消按钮
			if (this.contains(yesBtn) && this.contains(noBtn)) {
				yesBtn.horizontalCenter = -offsetX;
				noBtn.horizontalCenter = offsetX;
			} else if (this.contains(yesBtn) && !this.contains(noBtn)) {
				yesBtn.horizontalCenter = 0;// offsetX;
			}
			
			yesBtn.bottom 	= offsetY;
			noBtn.bottom 	= offsetY;
		}
		
		/**
		 * 设置确定取消按钮文本
		 * @param	yesLab
		 * @param	noLab
		 */
		public function setLabel( yesLab:String , noLab:String ):void {
			
			yesBtn.label	= yesLab;
			noBtn.label 	= noLab;
		}
		
		/**
		 * 设置皮肤
		 * @param	backSkin
		 * @param	okUpSkin
		 * @param	okDownSkin
		 * @param	noUpSkin
		 * @param	noDownSkin
		 * @param	closeUpSkin
		 * @param	closeDownSkin
		 */
		public function setSkin( backSkin:Texture , okUpSkin:Texture = null , okDownSkin:Texture = null , noUpSkin:Texture = null , noDownSkin:Texture = null , closeUpSkin:Texture = null , closeDownSkin:Texture = null ):void {
			
			this.back.texture 		= backSkin;
			this.yesBtn.upState 	= okUpSkin;
			this.yesBtn.downState 	= okDownSkin;
			this.noBtn.upState 		= noUpSkin;
			this.noBtn.downState 	= noDownSkin;
			this.closeBtn.upState 	= closeUpSkin;
			this.closeBtn.downState = closeDownSkin;
		}
	}
}