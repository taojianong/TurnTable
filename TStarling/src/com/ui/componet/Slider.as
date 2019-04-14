package com.ui.componet {
	
	import com.ui.event.SliderEvent;
	import com.ui.UITexture;
	import flash.display.Shape;
	import flash.geom.Point;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * 滑动组件
	 * @author taojianlong 2015/3/16 17:11
	 */
	public class Slider extends Sprite {
		
		private static var resp:Shape = new Shape();
		private static var renderMap:Object = { };
		
		public static function startRender( key:String = "" , func:Function = null , params:Array = null ):void {
			
			if ( key == "" || key == null || func == null ) {
				return;
			}
			
			if ( !(key in renderMap) ) {
				renderMap[ key ] = { "func":func , "params":params };
			}
			
			if ( !resp.hasEventListener( "enterFrame" ) ) {
				resp.addEventListener( "enterFrame" , renderHandler );
			}
		}
		
		private static function renderHandler( event:* ):void {
			
			for each( var obj:Object in renderMap ) {
				if ( obj && obj.func != null ) {						 
					obj.func.apply( null , obj.params ); 
				}
			}
		}
			
		public static function stopRender( key:String = "" ):void {
			
			if ( key in renderMap ) {
				delete renderMap[ key ];
			}
			
			if ( getRenders() <= 0 && resp.hasEventListener( "enterFrame" ) ) {
				resp.removeEventListener( "enterFrame" , renderHandler );
			}
		}
		
		/**
		 * 停止所有渲染
		 */
		public static function stopAllRender():void {
			
			while ( getRenders() > 0 ) {				
				for ( var key:String in renderMap ) {
					delete renderMap[ key ];
				}
			}			
			
			if ( resp.hasEventListener( "enterFrame" ) ) {
				resp.removeEventListener( "enterFrame" , renderHandler );
			}
		}
		
		/**
		 * 获取对应的渲染数
		 * @return
		 */
		public static function getRenders():int {
			
			var count:int = 0;
			for ( var key:String in renderMap ) {
				count++;
			}
			return count;
		}
		
		//-------------------------------------------------------------------
		
		public var id:String = "";
		
		/**<b>横向</b>**/
		public static const TRANSVERSE:String = "transverse";
		/**<b>纵向</b>**/
		public static const LONGITUDINAL:String = "longitudinal";
		
		private var botImg:TImage;//底层图片
		private var barBack:Rect;
		private var barBtn:TSButton;
		private var upBtn:TSButton;
		private var downBtn:TSButton;
		
		private var _baseLong:Number 	= 20; // 基本宽度
		private var _barBackLong:Number = 390; //条目背景宽度或高度
		private var _barLong:Number 	= 30; //拖动条目高度或宽度
		
		private var _autoSize:Boolean = false; //自动适应滚动条目高宽
		private var _type:String = TRANSVERSE;
		private var _progress:Number = 0;
		private var _begin:Number = 0;
		private var _end:Number = 0;
		
		private var _offsetValue:Number = 1; //上下左右时每次递加的值
		private var _isDrag:Boolean = false;
		private var _isEasing:Boolean = false; //是否缓动，暂未开发 2013-4-23 23:46
		private var easingSpeed:uint = 8; //缓动值
		
		private var sliderEvent:SliderEvent;
		private var msk:Rect; //滚动对象遮罩
		
		private var maskDisObj:TMaskDisplayObject;
		private var _target:DisplayObject; //滚动对象
		
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		/**
		 * 滚动条
		 * @param	begin 初始值
		 * @param	end   结束值
		 * @param	type  类型 TRANSVERSE 横向 LONGITUDINAL 纵向
		 * @param	autoSize 自动适应滚动条目高宽，暂未开放此功能
		 */
		public function Slider( target:DisplayObject = null , begin:Number = 0 , end:Number = 100 , type:String = "longitudinal" , autoSize:Boolean = false ) {
			
			super();
			
			_target 	= target;
			_autoSize 	= autoSize;
			_begin 		= begin;
			_end 		= end;
			_type 		= type;
			
			barBack = new Rect();
			barBack.id = "barBack";
			
			var t1:Texture = UITexture.getTexture( _baseLong , _baseLong , 0xffff00 , 0.8 ); 
			
			upBtn 			= new TSButton( t1 , "△" );
			upBtn.id		= "upBtn";
			upBtn.width		= _baseLong;
			upBtn.height	= _baseLong;
			
			downBtn 			= new TSButton( t1 , "△" );
			downBtn.id		= "downBtn";
			downBtn.width 	= _baseLong;
			downBtn.height 	= _baseLong;
			
			var t2:Texture = UITexture.getTexture( _baseLong , _barLong , 0xffffff , 0.8 ); 
			
			barBtn				= new TSButton( t2 , "" );
			barBtn.id			= "barBtn";
			barBtn.width		= _baseLong;
			barBtn.height		= _barLong;
			
			drawSlider();
			
			botImg = new TImage();
			
			this.addChild(botImg);
			this.addChild(barBack);
			this.addChild(barBtn);
			this.addChild(upBtn);
			this.addChild(downBtn);
			
			init();
			
			this.target = _target;
		}
		
		private function init():void {
			
			this.type = _type;
			
			this.addEventListener( Event.ADDED_TO_STAGE , addToStageHandler );
			this.addEventListener( Event.REMOVED_FROM_STAGE , removeFromStage );
		}
		
		public function set baseLong(value:Number):void {
			
			_baseLong = value;
			drawSlider();
			initXY();
		}
		
		/**
		 * 基本高宽度 ,默认为20;
		 */
		public function get baseLong():Number {
			
			return _barLong;
		}
		
		public function set barBackLong(value:Number):void {
			
			_barBackLong = value;
			drawSlider();
			initXY();
		}
		
		/**
		 * 重绘背景高度或宽度
		 */
		public function get barBackLong():Number {
			
			return _barBackLong;
		}
		
		public function set isEasing(value:Boolean):void {
			
			_isEasing = value;
		}
		
		/**是否是缓动**/
		public function get isEasing():Boolean {
			
			return _isEasing;
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set width(value:Number):void {
			if ( this.type == TRANSVERSE ) { //横向				
				_width = value;
				this.barBackLong = value - _baseLong * 2;
				this.drawRect(_width, _height, 0x00ff00, 1,0,1,2);
				
				if (this.barBackLong < _barLong) {
					throw(new Error("背景长度不能小于拖动条目长度"));
				}
			}
		}
		
		/**
		 * 设置滚动条高度
		 */
		override public function set height(value:Number):void {
			
			if (this.type == LONGITUDINAL) { //纵向才能设置高度
				
				_height = value;
				this.barBackLong = value - _baseLong * 2;
				this.drawRect(this.width, _height, 0x00ff00, 1, 0, 1, 2);
				if ( msk ) {
					msk.drawRect( msk.width , _height );
				}
				if (this.barBackLong < _barLong) {
					throw(new Error("背景长度不能小于拖动条目长度"));
				}
			}
		}
		
		override public function get height():Number {
			
			return _height;
		}
		
		public function set barLong(value:Number):void {
			
			_barLong = value;
			drawSlider();
			initXY();
		}
		
		/**
		 * 绘制拖动条目高度或宽度
		 */
		public function get barLong():Number {
			
			return _barLong;
		}
		
		//重绘组件,当长度改变时 
		private function drawSlider():void {
			
			if (_type == TRANSVERSE) { //横向
				
				barBack.drawRect(_barBackLong, _baseLong, 0xff0000 , 1 , 0x0000ff , 0 , 3 );
				
				upBtn.width 	= _baseLong;
				upBtn.height 	= _baseLong;
				downBtn.width 	= _baseLong;
				downBtn.height 	= _baseLong;
				barBtn.width	= _barLong;
				barBtn.height	= _baseLong;
				
				_width 			= _barBackLong + _baseLong * 2;
				_height 		= _baseLong;
			} else if (_type == LONGITUDINAL) { //纵向
				
				barBack.drawRect( _baseLong , _barBackLong , 0xff0000 , 1 , 0x00ffff , 0 , 3 );
				
				upBtn.width 	= _baseLong;
				upBtn.height 	= _baseLong;
				downBtn.width 	= _baseLong;
				downBtn.height 	= _baseLong;
				barBtn.width	= _baseLong;
				barBtn.height	= _barLong;
				
				_width 			= _baseLong;
				_height 		= _barBackLong + _baseLong * 2;
			}
		}
		
		private function stageMouseUpHandler(event:TouchEvent):void {
			
			if ( !event.getTouch( this , TouchPhase.ENDED ) ) {
				return;
			}
			
			if (_out) {
				this.isDrag = false;
			}
		}
		
		protected function addToStageHandler(event:Event):void {
			
			upBtn.addEventListener( TouchEvent.TOUCH  , mouseDownHandler); //MouseEvent.MOUSE_DOWN , mouseDownHandler
			downBtn.addEventListener( TouchEvent.TOUCH  , mouseDownHandler);
			barBtn.addEventListener( TouchEvent.TOUCH  , mouseDownHandler);
			this.addEventListener( TouchEvent.TOUCH  , mouseMoverHandler);
			
			upBtn.addEventListener( TouchEvent.TOUCH , mouseUpHandler); //MouseEvent.MOUSE_UP , mouseUpHandler
			downBtn.addEventListener( TouchEvent.TOUCH , mouseUpHandler); 
			barBtn.addEventListener( TouchEvent.TOUCH , mouseUpHandler); 
			
			this.stage.addEventListener( TouchEvent.TOUCH , stageMouseUpHandler);//MouseEvent.MOUSE_UP , stageMouseUpHandler
			barBtn.addEventListener( TouchEvent.TOUCH , outHandler); //MouseEvent.ROLL_OUT , outHandler
			
			initSlider();
		}
		
		protected function removeFromStage(event:Event):void {
			
			clear();
			if ( _target != null ) {
				if ( msk != null && _target.parent.contains( msk ) ) {
					_target.parent.removeChild( msk );
				}
			}
		}
		
		private var _out:Boolean = false;
		private var moveP:Point = new Point();//正在移动时的坐标
		
		private function outHandler(event:TouchEvent):void {
			
			if ( event.getTouch( this , TouchPhase.ENDED ) ) {
				_out = true;
			}			
		}
		
		private function mouseMoverHandler( event:TouchEvent ):void {
			
			if ( !event.getTouch( this , TouchPhase.MOVED ) ) {
				return;
			}
			
			var touch:Touch = event.getTouch( this , TouchPhase.MOVED );
			barBtnMove( touch );
		}
		
		private function mouseDownHandler(event:TouchEvent):void {
			
			if ( !event.getTouch( this , TouchPhase.BEGAN ) ) {
				return;
			}
			
			_out = false;
			
			var touch:Touch = event.getTouch( this );			
			var localPoint:Point = globalToLocal( new Point( touch.globalX , touch.globalY ) );
			var mouseX:Number = localPoint.x;
			var mouseY:Number = localPoint.y;
			
			var target:TSButton = event.currentTarget as TSButton;
			if (target == null) {
				
				this.isDrag = true;
				if (_type == TRANSVERSE) { //横向
					
					if (mouseX > upBtn.width && mouseX < upBtn.width + barBack.width && mouseY > 0 && mouseY < this.height) {
						
						barBtn.x = mouseX;
						if (barBtn.x > upBtn.width + barBack.width - barBtn.width)
							barBtn.x = upBtn.width + barBack.width - barBtn.width;
					}
				} else if (_type == LONGITUDINAL) { //纵向
					
					if (mouseX > 0 && mouseX < this.width && mouseY > upBtn.height && mouseY < upBtn.height + barBack.height) {
						
						barBtn.y = mouseY;
						if (barBtn.y > upBtn.height + barBack.height - barBtn.height)
							barBtn.y = upBtn.height + barBack.height - barBtn.height;
					}
				}
				update();
				return;
			}
			
			var temp:Number;
			switch (target.id) {
				
				case "upBtn": 
					if ( touch.phase == TouchPhase.BEGAN ) {
						startRender( "upBtnBegin" , upBtnBegin );
					}													
					break;
				
				case "barBtn": 
					if ( touch.phase == TouchPhase.BEGAN ) {
						this.isDrag = true;
					}
					break;
				
				case "downBtn": 	
					if ( touch.phase == TouchPhase.BEGAN ) {
						startRender( "downBtnBegin" , downBtnBegin );
					}
					break;			
			}
		}
		
		private function mouseUpHandler(event:TouchEvent):void {
			
			if ( !event.getTouch( this , TouchPhase.ENDED ) ) {
				return;
			}
			
			var target:TSButton = event.currentTarget as TSButton;
			if (target == null)
				return;
				
			var touch:Touch = event.getTouch( this );			
			switch (target.id) {
				
				case "upBtn":
					stopRender( "upBtnBegin" );
					break;
				
				case "bar": 
					this.isDrag = false;
					break;
				
				case "downBtn":
					stopRender( "downBtnBegin" );
					break;
			
			}
		}
		
		private function barBtnMove( touch:Touch ):void {
			
			if ( this.isDrag ) {
				if (_type == TRANSVERSE) { //横向							
					//barBtn.startDrag(false, new Rectangle(barBack.x, 0, barBack.width - barBtn.width, 0));
					
				} else if (_type == LONGITUDINAL) { //纵向
					
					touch.getPreviousLocation(this, moveP);
					//trace("x: " + moveP.x + " y: " + moveP.y );
					//barBtn.startDrag(false, new Rectangle(0, barBack.y, 0, barBack.height - barBtn.height));
					barBtn.x = 0;
					if ( (moveP.y - barBack.y) < barBack.y ) {
						barBtn.y = barBack.y;
					}
					else if ( moveP.y - barBack.y > ( downBtn.y - barBtn.height ) ) {
						barBtn.y = downBtn.y - barBtn.height;
					}
					else {
						barBtn.y = moveP.y - barBack.y;
					}								
				}
				enterFrameHandler();
			}
		}
		
		private function upBtnBegin():void {
			
			var temp:Number;
			if (_type == TRANSVERSE) { //横向							
				temp = barBtn.x;
				temp -= _offsetValue;
				barBtn.x = temp < barBack.x ? barBack.x : temp;
			} else if (_type == LONGITUDINAL) { //纵向
				
				temp = barBtn.y;
				temp -= _offsetValue;
				barBtn.y = temp < barBack.y ? barBack.y : temp;
			}
			update();
		}
		
		private function downBtnBegin():void {
			
			var temp:Number;
			if (_type == TRANSVERSE) { //横向
				
				temp = barBtn.x;
				temp += _offsetValue;
				barBtn.x = temp > (barBack.x + barBack.width - barBtn.width) ? (barBack.x + barBack.width - barBtn.width) : temp;
			} else if (_type == LONGITUDINAL) { //纵向
				
				temp = barBtn.y;
				temp += _offsetValue;
				barBtn.y = temp > (barBack.y + barBack.height - barBtn.height) ? (barBack.y + barBack.height - barBtn.height) : temp;
			}					
			update();
		}
		
		public function set offsetValue(value:Number):void {
			
			_offsetValue = value
		}
		
		/**
		 * 每次加减偏移值
		 */
		public function get offsetValue():Number {
			
			return _offsetValue
		}
		
		public function set isDrag(value:Boolean):void {
			
			_isDrag = value;
		}
		
		/**
		 * 是否处于拖动状态
		 */
		public function get isDrag():Boolean {
			
			return _isDrag;
		}
		
		private function enterFrameHandler(event:*=null):void {
			
			if (_target && msk) {
				if (_type == TRANSVERSE) { //横向					
					this.visible = _target.width > msk.width;
					
				} else if (_type == LONGITUDINAL) { //纵向					
					this.visible = _target.height > msk.height;
				}
			}
			
			if (_isDrag) {
				update();
			}
		}
		
		/**
		 * 滚动进度
		 */
		public function get progress():Number {
			
			if (_type == TRANSVERSE) { //横向
				
				return (barBtn.x - barBack.x) / (barBack.width - barBtn.width);
			} else if (_type == LONGITUDINAL) { //纵向
				
				return (barBtn.y - barBack.y) / (barBack.height - barBtn.height);
			}
			return 0;
		}
		
		/**
		 * 滚动条当前值
		 */
		public function get sliderValue():Number {
			
			return _begin + this.progress * (_end - _begin);
		}
		
		public function update():void {
			
			sliderEvent = new SliderEvent(SliderEvent.SLIDER);
			sliderEvent.progress = this.progress;
			sliderEvent.sliderValue = this.sliderValue;
			this.dispatchEvent(sliderEvent);
			
			/*if ( _target && msk!= null ) {
				if (_type == TRANSVERSE) { //横向					
					_target.x = msk.x - (_target.width - msk.width) * sliderEvent.progress;
				} else if (_type == LONGITUDINAL) { //纵向					
					_target.y = msk.y - (_target.height - msk.height) * sliderEvent.progress;
				}
			}*/
			
			if ( maskDisObj != null && msk != null ) {
				if (_type == TRANSVERSE) { //横向					
					maskDisObj.x = msk.x - (maskDisObj.width - msk.width) * sliderEvent.progress;
				} else if (_type == LONGITUDINAL) { //纵向					
					maskDisObj.y = msk.y - (maskDisObj.height - msk.height) * sliderEvent.progress;
				}
			}
		}
		
		/**
		 * 滑动到某处
		 * @param	progress 0 ~ 1
		 */
		public function slipTo(progress:Number = 0):void {
			
			//return ( bar.x - barBack.x ) / ( barBack.width - bar.width) ;				
			//return ( bar.y - barBack.y ) / ( barBack.height - bar.height );
			
			var moX:Number;
			var moY:Number;
			if (_type == TRANSVERSE) { //横向
				
				moX = upBtn.width + progress * (barBack.width - barBtn.width); //upBtn.width + progress * barBack.width;
				moY = 1;
				if (moX >= upBtn.width && moX < upBtn.width + barBack.width && moY > 0 && moY < this.height) {
					
					barBtn.x = moX;
					if (barBtn.x > upBtn.width + barBack.width - barBtn.width)
						barBtn.x = upBtn.width + barBack.width - barBtn.width;
				}
			} else if (_type == LONGITUDINAL) { //纵向
				
				moX = 1;
				moY = upBtn.height + progress * (barBack.height - barBtn.height); //upBtn.height + progress * barBack.height;
				//trace("moY: " + moY + " upBtn.height: " + (upBtn.height));
				if (moX > 0 && moX < this.width && moY >= upBtn.height && moY < upBtn.height + barBack.height) {
					
					barBtn.y = moY;
					if (barBtn.y > upBtn.height + barBack.height - barBtn.height)
						barBtn.y = upBtn.height + barBack.height - barBtn.height;
				}
			}
			update();
		}
		
		//清除事件监听
		public function clear():void {
			
			upBtn.removeEventListener( TouchEvent.TOUCH , mouseDownHandler);
			downBtn.removeEventListener( TouchEvent.TOUCH , mouseDownHandler);
			barBtn.removeEventListener( TouchEvent.TOUCH , mouseDownHandler);
			this.removeEventListener( TouchEvent.TOUCH  , mouseMoverHandler);
			
			upBtn.removeEventListener( TouchEvent.TOUCH , mouseUpHandler);
			downBtn.removeEventListener( TouchEvent.TOUCH , mouseUpHandler);
			barBtn.removeEventListener( TouchEvent.TOUCH , mouseUpHandler);
			
			barBtn.removeEventListener( TouchEvent.TOUCH , outHandler);
			
			stopAllRender();
		}
		
		public function set type(value:String):void {
			
			_type = value;
			
			initXY();
		}
		
		/**
		 * 设置滑动条为纵向(LONGITUDINAL)或横向(TRANSVERSE)，默认为横向
		 */
		public function get type():String {
			
			return _type;
		}
		
		//重新排列组件坐标
		private function initXY():void {
			
			if (_type == TRANSVERSE) { //横向
				
				upBtn.x = 0;
				upBtn.y = 0;
				barBack.x = upBtn.x + upBtn.width;
				barBack.y = 0;
				barBtn.x = barBack.x;
				barBtn.y = 0;
				downBtn.x = barBack.x + barBack.width;
				downBtn.y = 0;
			} else if (_type == LONGITUDINAL) { //纵向
				
				upBtn.x = 0;
				upBtn.y = 0;
				barBack.x = 0;
				barBack.y = upBtn.y + upBtn.height;
				barBtn.x = 0;
				barBtn.y = barBack.y;
				downBtn.x = 0;
				downBtn.y = barBack.y + barBack.height;
			}
		}
		
		public function set autoSize(value:Boolean):void {
			
			_autoSize = value;
		}
		
		/**
		 * 自动适应滚动条目高宽//TODO
		 */
		public function get autoSize():Boolean {
			
			return _autoSize;
		}
		
		public function set target( value:DisplayObject ):void {
			
			if ( value == null ) {
				if ( _target && maskDisObj && maskDisObj.contains( _target ) ) {
					_target.x = maskDisObj.x;
					_target.y = maskDisObj.y;
					maskDisObj.removeChild( _target );
					if ( maskDisObj.parent != null ) {
						maskDisObj.parent.addChild( _target );
					}
				}
				_target = null;
			}
			else {				
				_target = value;
				initSlider();
			}
		}
		
		/**
		 * 拖动对象,必须同Slider在同一个容器里
		 */
		public function get target():DisplayObject {
			
			return _target;
		}
		
		//初始化滚动条
		private function initSlider():void {
			
			if ( _target && _target.parent != null ) {
				
				if (_type == TRANSVERSE) { //横向					
					msk = msk || new Rect(this.width + 1, _target.height + 1);
					/*msk.width 	= this.width + 1;
					msk.height 	= _target.height + 1;*/
					msk.drawRect( this.width + 1 , _target.height + 1 );
				} else if (_type == LONGITUDINAL) { //纵向					
					msk = msk || new Rect(_target.width + 1, this.height + 1);
					/*msk.width 	= _target.width + 1;
					msk.height 	= this.height + 1;*/
					msk.drawRect( _target.width + 1 , this.height + 1 );
					msk.id = "msk";
				}
				
				var targetParent:DisplayObjectContainer = _target.parent as DisplayObjectContainer;
				if ( maskDisObj == null ) {
					maskDisObj = new TMaskDisplayObject();				
				}
				
				if ( !maskDisObj.contains( _target ) ) {
					
					var ox:Number = _target.x;
					var oy:Number = _target.y;				
					maskDisObj.x = ox;
					maskDisObj.y = oy;
					msk.x = maskDisObj.x;
					msk.y = maskDisObj.y;				
					_target.x = _target.y = 0;	
				}				
				
				if ( targetParent && targetParent.contains(_target) ) {
					targetParent.removeChild( _target );
				}
				
				if ( maskDisObj && _target && !maskDisObj.contains( _target ) ) {
					maskDisObj.addChild( _target );
				}				
				if ( targetParent && !targetParent.contains( maskDisObj ) ) {
					targetParent.addChild( maskDisObj );
				}			
				
				maskDisObj.mask = msk;	
			}
		}
		
		public function setMsk( width:Number , height:Number ):void {
			
			msk.width  = width;
			msk.height = height;
			
			if ( maskDisObj != null ) {
				maskDisObj.mask = msk;
			}
		}
		
		override public function set visible(value:Boolean):void {
			
			super.visible = value;
		}
		
		public function drawRect(width:int = 400, height:int = 400, color:uint = 0xff0000, alpha:Number = 1, borderColor:uint = 0xff0000, borderAlpha:Number = 1, thickness:Number = 1):void {
			
			var t:Texture = UITexture.getTexture( width , height , color , alpha , borderColor , borderAlpha , thickness );
			
			botImg.texture = t; 
			
			_width = width;
			_height = height;
		}
		
	}
}

import flash.display3D.Context3D;
import flash.geom.Point;
import flash.geom.Rectangle;
import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.errors.MissingContextError;

class TMaskDisplayObject extends Sprite {
	
	private var mClipRect:Rectangle;
		
	public override function render(support:RenderSupport, alpha:Number):void {
		if (mClipRect == null)
			super.render(support, alpha);
		else {
			var context:Context3D = Starling.context;
			if (context == null)
				throw new MissingContextError();
			support.finishQuadBatch();
			//support.scissorRectangle = mClipRect;
			support.pushClipRect( mClipRect );
			super.render( support , alpha );
			support.finishQuadBatch();
			//support.scissorRectangle = null;
			support.popClipRect();
		}
	}
	
	public override function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject {
		// without a clip rect, the sprite should behave just like before
		if (mClipRect == null)
			return super.hitTest(localPoint, forTouch);
			// on a touch test, invisible or untouchable objects cause the test to fail
		if (forTouch && (!visible || !touchable))
			return null;
		if (mClipRect.containsPoint(localToGlobal(localPoint)))
			return super.hitTest(localPoint, forTouch);
		else
			return null;
	}
	
	override public function get clipRect():Rectangle {
		return mClipRect;
	}
	
	override public function set clipRect(value:Rectangle):void {
		if (value) {
			if (mClipRect == null)
				mClipRect = value.clone();
			else
				mClipRect.setTo(value.x, value.y, value.width, value.height);
		} else
			mClipRect = null;
	}
	
	/**
	 * 设置遮罩
	 * @param target 遮罩
	 */
	public function set mask( target:DisplayObject ):void {
		
		if ( target is DisplayObject ) {
			this.clipRect = new Rectangle( target.x , target.y , target.width , target.height );
		}
		else {
			this.clipRect = null;
		}
	}
}