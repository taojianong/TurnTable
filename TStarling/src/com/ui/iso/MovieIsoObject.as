package com.ui.iso {
	
	import starling.animation.IAnimatable;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	/**
	 * 动画投影
	 * @author cl 2013/11/15 10:51
	 */
	public class MovieIsoObject extends RoleIsoObject implements IAnimatable {
		
		//偏移XY坐标
		protected var _offsetX:Number = 0;
		protected var _offsetY:Number = 0;
		protected var _frames:Vector.<Texture> = null; //纹理帧列表
		protected var mc:MovieClip; //英雄影片
		
		/**
		 * 影片动画投影
		 * @param	size	尺寸
		 * @param	frames 	动画纹理帧
		 */
		public function MovieIsoObject(frames:Vector.<Texture> = null , size:Number = 20) {
			
			super(size, 0x804040, 0);
			
			this.frames = frames;
		}
		
		public function set frames(value:Vector.<Texture>):void {
			
			_frames = value;
			
			if (mc != null) {
				mc.dispose();
				this.removeElement(mc);
				mc = null;
			}
			
			if (_frames != null) {
				
				mc = new MovieClip(frames,12);				
				this.addElement(mc);
				//mc.x = -mc.width * 0.5 + _offsetX;
				//mc.y = -mc.height * 0.5 + _offsetY;
				this.updateXY();
			}
		}
		
		/**
		 * 纹理帧列表
		 */
		public function get frames():Vector.<Texture> {
			
			return _frames;
		}
		
		private function updateXY():void {
			
			if ( mc != null ) {
				mc.x = -mc.width * 0.5 + _offsetX;
				mc.y = -mc.height * 0.5 + _offsetY;
			}
		}
		
		public function set offsetX(value:Number):void {
			
			_offsetX = value;
			
			this.updateXY();
		}
		
		/**
		 * 偏移X坐标
		 */
		public function get offsetX():Number {
			
			return _offsetX;
		}
		
		public function set offsetY(value:Number):void {
			
			_offsetY = value;
			
			this.updateXY();
		}
		
		/**
		 * 偏移Y坐标
		 */
		public function get offsetY():Number {
			
			return _offsetY;
		}
		
		override public function get scaleX():Number {
			
			return mc ? mc.scaleX : 1;
		}
		
		override public function set scaleX(value:Number):void {
			if (mc != null) {
				mc.scaleX = value;
			}
			this.updateXY();
		}
		
		override public function get scaleY():Number {
			return mc ? mc.scaleY : 1;
		}
		
		override public function set scaleY(value:Number):void {
			if (mc != null) {
				mc.scaleY = value;
			}
			this.updateXY();
		}
		
		public function pause():void {
			
			if (mc != null) {
				mc.pause();
			}
		}
		
		public function play():void {
			
			if (mc != null) {
				mc.play();
			}
		}
		
		public function set currentFrame(value:int):void {
			
			if (mc != null) {
				mc.currentFrame = value;
			}
		}
		
		public function stop():void {
			
			if (mc != null) {
				mc.stop();
			}
		}
		
		/**
		 * 实现Imcmatable接口的方法，动画基本接口
		 * @param	time
		 */
		override public function advanceTime(time:Number):void {
			if (mc != null) {
				mc.advanceTime(time);
			}
		}
	}

}