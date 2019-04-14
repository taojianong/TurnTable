package com.ui.componet {
	
	import com.manager.AnimationRenderManager;
	import com.manager.IRender;
	import com.ui.event.AnimationEvent;
	import com.utils.TextureUtils;
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	
	/**
	 * 基于Starling的动画组建
	 * @author cl 2015/3/7 15:10
	 */
	public class Animation extends TSprite implements IRender{
		
		private var mc:TImage;
		
		private var _animationData:AnimationData = null;
		private var _fps:int 			= 12;
		private var _isCenter:Boolean 	= false;
		
		protected var _fpsTimer:int 	= 0; //帧计时器
		protected var _frameIndex:int 	= 1; //当前帧索引
		protected var _playCount:int 	= 0; //当前播放次数
		
		protected var _isPause:Boolean = false;//是否暂停
		//是否暂停
		public function set isPause( value:Boolean ):void { _isPause = value ; }
		public function get isPause():Boolean { return _isPause; }
		
		//public var isDispose:Boolean = false;//是否释放渲染
		
		public function set loop( value:int ):void {
			
			if ( _animationData ) {
				_animationData.loop = value;
			}			
		}
		/**
		 * 循环
		 */
		public function get loop():int {
			
			return _animationData ? _animationData.loop : 0;
		}
		
		/**
		 * 构造函数
		 * @param	animationData 	动画数据
		 * @param	isCenter		是否居中
		 */
		public function Animation( animationData:AnimationData = null , isCenter:Boolean = false ) {
			
			super();
			
			//默认图片纹理
			mc = new TImage(null,false);
			mc.x = -2;
			mc.y = -2;
			this.addChild( mc );
			
			_isCenter = isCenter;
			this.animationData = animationData;
		}
		
		public function set isCenter(value:Boolean):void {
			
			_isCenter = value;
			
			if (mc == null) {
				return;
			}
			if (_isCenter) {
				mc.x = this.animationData != null ? -this.animationData.frameWidth * 0.5 + this.animationData.offsetX : -mc.width * 0.5;
				mc.y = this.animationData != null ? -this.animationData.frameHeight * 0.5 + this.animationData.offsetY : -mc.height * 0.5;
			} else {
				
				mc.x = this.animationData != null ? this.animationData.offsetX : 0;
				mc.y = this.animationData != null ? this.animationData.offsetY : 0;
			}	
		}
		
		public function get isCenter():Boolean {
			
			return _isCenter;
		}
		
		public function set fps(value:int):void {
			
			_fps = value;
			if (_animationData != null) {
				_animationData.fps = _fps;
			}
		}
		
		/**
		 * 帧频
		 */
		public function get fps():int {
			
			return _fps;
		}
		
		private var _frames:Vector.<Texture> = null; //动画帧纹理集		
		/**
		 * 总帧数
		 */
		public function get frames():Vector.<Texture> {
			
			return _frames;
		}
		
		public function set animationData(value:AnimationData):void {
			
			this.changeAnimation( value , 1 , 1 );
		}		
		/**
		 * 设置动画数据
		 */
		public function get animationData():AnimationData {
			
			return _animationData;
		}
		
		/**
		 * 播放动画
		 * @param	value	动画数据
		 * @param	row		行
		 * @param	list	列
		 */
		public function changeAnimation( value:AnimationData , row:int = 1 , list:int = 1 ):void {
			
			_animationData = value;
			
			if ( _animationData != null ) {
				_frames = _animationData.getTextures( row , list );
				_frameIndex = _frameIndex > ( _frames.length - 1 ) ? 1 : _frameIndex;	
				
				renderAnimation();
			}
			else {
				stop();
			}			
		}
		
		/**
		 * 列数
		 */
		public function get list():int {
			
			return _animationData ? _animationData.list : 1;
		}
		
		/**
		 * 更新动画坐标
		 */
		private function updateMCXY():void {
			
			this.isCenter = _isCenter;
			
			this.showPiovtBall();//显示中心点
		}
		
		/**
		 * 停在第一帧
		 */
		public function restart():void {
			
			_frameIndex = 1;
			
			this.isPause = false;
		}
		
		public function set currentFrame( value:int ):void {
			
			_frameIndex = value;			
		}
		
		public function get currentFrame():int {
			
			return _frameIndex;
		}
		
		/**
		 * 是否到最后一帧
		 */
		public function get bLastFrame():Boolean {
			
			return this.frames && this.currentFrame == this.frames.length;
		}
		
		override public function get width():Number {
			
			var w:Number = _animationData != null ? _animationData.frameWidth : ( mc != null ? mc.width : super.width )
			
			return w;
		}
		
		override public function get height():Number {
			
			var h:Number = _animationData != null ? _animationData.frameHeight : ( mc != null ? mc.height : super.height );
			
			return h;
		}
		
		/**
		 * 渲染动画
		 */
		public function renderAnimation():void {
			
			if (this.isPause || _animationData == null || (_animationData.loop > 0 && _playCount >= _animationData.loop)) {
				return;
			}
			
			//播放一帧
			var fps:int = _animationData.fps <= 0 ? (stage != null ? Starling.current.nativeOverlay.stage.frameRate : 10) : _animationData.fps;
			if (int(_fpsTimer % fps) == 0) {
				
				//设置每帧纹理
				mc.texture = _animationData.getTexture( _frameIndex );
				this.isCenter = _isCenter;
				
				//播放完一次
				if (_frameIndex == _animationData.list) {
					
					_playCount++;
					
					if (this.hasEventListener(AnimationEvent.PLAY_ONCE)) {
						this.dispatchEvent(new AnimationEvent(AnimationEvent.PLAY_COMPLETE));
					}
				}
				
				//播放完成
				if (_playCount >= _animationData.loop && _animationData.loop > 0) {
					if (this.hasEventListener(AnimationEvent.PLAY_COMPLETE)) {
						this.dispatchEvent(new AnimationEvent(AnimationEvent.PLAY_COMPLETE));
					}
				}
				
				_frameIndex++;
				if (_frameIndex > _animationData.list) {
					_frameIndex = 1;
				}
			}
			
			//帧频计时
			_fpsTimer++;
		}
		
		/**
		 * 停止渲染
		 */
		public function stop():void {
			
			_animationData 	= null;
			_frameIndex 	= 1;
			_isPause 		= false;
			_fpsTimer 		= 0;
			_playCount 		= 0;
		}
		
		public function update():void { };
		
		/**
		 * 释放资源
		 */
		override public function dispose():void {
			
			super.dispose();
			
			mc.dispose();
			_animationData = null;
			_fps = 12;
			_isPause = false;
			
			this.removeChildren();
		}
		
		
		
		private var ball:Ball;
		//显示中心点
		private function showPiovtBall():void {
			
			ball = ball || new Ball();
			if ( !this.contains(ball) ) {
				this.addChild( ball );
			}		
			
			this.setChildIndex( ball , this.numChildren - 1 );
		}
		
		//显示边框
		private var rect:Rect;
		public function showBorder( color:uint = 0xff0000 ):void {
			
			if ( mc != null ) {
				mc.showBorder( color );
			}
			else {
				rect = rect || new Rect( this.width , this.height );
				rect.drawRect( this.width , this.height , 0 , 0 , color , 1 , 2 );
				rect.x = -rect.width * 0.5;
				rect.y = -rect.height * 0.5;				
				this.addElement( rect );
			}
		}
		
		public function hideBorder():void {
			
			if ( mc != null ) {
				mc.hideBorder();
			}
			else {
				this.removeElement( rect );
			}			
		}
	}
}