package ui.componet {
	
	import assets.Assets;
	import com.ui.BaseUI;
	import com.ui.UIEvent;
	import flash.system.System;
	import starling.display.Quad;
	import starling.display.Stage;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 基于Starling弹框
	 * @author taojianlong 2014/7/5 23:41
	 */
	public class TSAlert extends BaseUI {
		
		public var id:String = "";
		
		public static const NULL:uint = 0;
		public static const OK:uint = 1;
		public static const CANCEL:uint = 2;
		
		//autoScale="true" 
		private var xml:XML =   <data>				
				<TSLabel name="titTxt" x="0" y="0" autoSize="horizontal" color="#00ff00" fontSize="16" text="提示" />
				<TSLabel name="infoTxt" x="10" y="100" autoScale="true" color="#00ff00"/>
				<TSButton name="yesBtn" x="0" y="0" text="确定" />
				<TSButton name="noBtn" x="0" y="0" text="取消" />								
			</data>
		private var titTxt:TSLabel;
		private var infoTxt:TSLabel;
		private var yesBtn:TSButton;
		private var noBtn:TSButton;
		
		private var _confimFunc:Function;
		private var _cancelFunc:Function;
		
		public function TSAlert(width:Number = 320, height:Number = 400) {
			
			super(xml, width, height);
			
			this.background.color = 0x2A2A2A;
		}
		
		override protected function createComplete(event:UIEvent):void {
			
			super.createComplete(event);
			
			background  = this.getChildByName("background") as BackGround;
			titTxt 		= this.getChildByName("titTxt") as TSLabel;
			infoTxt 	= this.getChildByName("infoTxt") as TSLabel;
			yesBtn 		= this.getChildByName("yesBtn") as TSButton;
			noBtn 		= this.getChildByName("noBtn") as TSButton;
			
			yesBtn.upState = Assets.getTexture("blue_out");
			yesBtn.downState = Assets.getTexture("blue_over");
			
			noBtn.upState = Assets.getTexture("blue_out");
			noBtn.downState = Assets.getTexture("blue_over");
			
			//titTxt.width = this.width;
			titTxt.x = (this.width - titTxt.width) >> 1;
			titTxt.y = 5;
			//titTxt.color = 0x00ff00;
			
			infoTxt.width = this.width - 20;
			infoTxt.height = 100;
			this.removeChild(yesBtn);
			this.removeChild(noBtn);
			
			yesBtn.addEventListener(TouchEvent.TOUCH, btnTouchHandler);
			noBtn.addEventListener(TouchEvent.TOUCH, btnTouchHandler);
			System.disposeXML(xml);
			xml = null;
		}
		
		protected function btnTouchHandler(event:TouchEvent):void {
			
			var touch:Touch = event.getTouch( stage );
			if ( touch == null ) {
				return;
			}
			var target:TSButton = event.currentTarget as TSButton;
			
			switch( touch.phase ) {
				
				case TouchPhase.BEGAN:
					
					break;
					
				case TouchPhase.MOVED:
					
					break;
				
				case TouchPhase.ENDED:
					if ( target.name == "yesBtn" ) {
						if ( _confimFunc != null ) {
							_confimFunc.apply();
						}
					}
					else if ( target.name == "noBtn" ) {
						if ( _cancelFunc != null ) {
							_cancelFunc.apply();
						}
					}
					break;
			}
		}
		
		/**
		 * 显示弹框
		 * @param	text
		 * @param	flag = 1
		 * @param	confimFunc
		 * @param	cancelFunc
		 * @param	offsetX
		 * @param	offsetY
		 */
		public function show( text:String, flag:int = 1, confimFunc:Function = null, cancelFunc:Function = null, offsetX:Number = 50, offsetY:Number = 5):void {
		
			_confimFunc  = confimFunc;
			_cancelFunc  = cancelFunc;
			
			infoTxt.text = text;
			infoTxt.x = this.width - infoTxt.width >> 1;
			
			showBtn( flag , offsetX , offsetY );
		}
		
		//显示确定取消按钮
		protected function showBtn(flag:int = 1, offsetX:Number = 50, offsetY:Number = 5):void {
			
			if (this.contains(yesBtn)) {
				this.removeChild(yesBtn);
			}
			if ( this.contains( noBtn ) ) {
				this.removeChild( noBtn );
			}
			
			if ( flag & OK ) {
				this.addChild( yesBtn );
			}
			
			if ( flag & CANCEL ) {
				this.addChild( noBtn );
			}
			
			setOffset( offsetX , offsetY );
		}
		
		public function setOffset( offsetX:Number = 50 , offsetY:Number = 5 , closeOffsetX:Number = 0 , closeOffsetY:Number = 0 ):void {
			
			//当只有确定按钮或取消按钮时，居中显示确定按钮或取消按钮
			if (this.contains(yesBtn) && this.contains(noBtn)) {
				yesBtn.x = offsetX;
				noBtn.x = this.width - noBtn.width - offsetX;
			} else if (this.contains(yesBtn) && !this.contains(noBtn)) {
				yesBtn.x = offsetX;
			}
			
			yesBtn.y = this.height - yesBtn.height - offsetY - offsetY;
			noBtn.y = this.height - noBtn.height - offsetY - offsetY;
		}
		
		public function hide():void {
			
			if ( this.parent ) {
				this.parent.removeChild( this );
			}
		}
		
		//------------------------------------------------------
		
		private static var alert:TSAlert;
		private static var rect:Quad;
		
		/**
		 * 显示弹框
		 * @param	text 提示文字
		 * @param	flag TSAlert.OK TSAlert.CANCEL
		 * @param	isLock 是否锁定背景
		 * @param	confimFunc
		 * @param	cancelFunc
		 * @param	offsetX
		 * @param	offsetY
		 */
		public static function show( text:String , flag:int = 1, stage:Stage = null , isLock:Boolean = true , confimFunc:Function = null, cancelFunc:Function = null, offsetX:Number = 50, offsetY:Number = 5 ):void {
			
			alert = alert || new TSAlert( 320 , 400 );
			alert.show( text , flag , confimFunc , cancelFunc , offsetX , offsetY );
			if ( stage != null ) {
				if ( isLock ) {
					rect = rect || new Quad( stage.width , stage.height , 0 );
					rect.alpha = 0.5;
					rect.width = stage.width ;
					rect.height = stage.height;
					if ( !stage.contains( rect ) ) {
						stage.addChild( rect );
					}
				}
				else if ( rect && stage.contains( rect ) ) {
					stage.removeChild( rect );
				}
				alert.x = ( stage.stageWidth - alert.width ) / 2;
				alert.y = ( stage.stageHeight - alert.height ) / 2;
				if ( !stage.contains( alert ) ) {
					stage.addChild( alert );
				}
			}			
		}
		
		public static function hide():void {
			
			if ( alert ) {
				if ( rect && alert.parent && alert.parent.contains( rect ) ) {
					alert.parent.removeChild( rect );
				}
				alert.hide();
			}
		}
	}
}