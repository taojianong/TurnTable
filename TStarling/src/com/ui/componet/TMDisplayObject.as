package com.ui.componet {
	
	import flash.display3D.Context3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.errors.MissingContextError;
	
	/**
	 * 基于Starling实现的遮罩显示对象，可设置遮罩对象
	 * var sprite:ClippedSprite = new ClippedSprite();
		addChild(sprite);
		
		// the sprite works like you're used to
		sprite.addChild(anObject);
		sprite.addChild(anotherObject);
		
		// set the mask rectangle in stage coordinates
		sprite.clipRect = new Rectangle(10, 10, 380, 280);
	 */
	public class TMDisplayObject extends Sprite {
		
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
}