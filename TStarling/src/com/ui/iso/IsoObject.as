package com.ui.iso {
	
	import com.math.IsoUtils;
	import com.math.Point3D;
	import com.ui.componet.Rect;
	import com.ui.componet.TSprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.animation.IAnimatable;
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	/**
	 * 等角对象
	 * @author cl 2013/11/15 10:48
	 */
	public class IsoObject extends TSprite implements IAnimatable{
		
		public static const GRID_SIZE:uint = 20;
		
		protected var borderRect:Rect;
		
		protected var _position:Point3D;
		protected var _size:Number;
		protected var _walkable:Boolean = true;
		
		protected var _vx:Number = 0;
		protected var _vy:Number = 0;
		protected var _vz:Number = 0;
		
		protected var _contentWidth:Number  = 0;//对象宽度
		protected var _contentHeight:Number = 0;//对象高度
		
		private var _rect:Rectangle = new Rectangle(); //返回占用的矩形
		
		public var buttonMode:Boolean = false;//按钮模式
		
		public function IsoObject(size:Number) {
			
			super();
			
			_size = size;
			_position = new Point3D();
			
			updateScreenPositon();
			
			this.addEventListener( Event.ADDED_TO_STAGE , addToStageHandler );
			this.addEventListener( Event.REMOVED_FROM_STAGE , removeFromStageHandler );
		}
		
		protected function addToStageHandler( event:Event ):void { }
		protected function removeFromStageHandler( event:Event ):void { }
		
		/**
		 * 把当前时刻的一个3D坐标点转换成频幕上的2D坐标点
		 */
		protected function updateScreenPositon():void {
			
			var screenPos:Point = IsoUtils.isoToScreen(_position);
			
			super.x = screenPos.x;
			super.y = screenPos.y + size / 2;
		}
		
		/**
		 * 自身具体描述方式
		 */
		public function toString():String {
			return "[IsoObject(x:" + _position.x + ",y:" + _position.y + ",z:" + _position.z + ")]";
		}
		
		public function set vx(value:Number):void {
			
			_vx = value;
		}
		
		/**
		 * 设置X轴上的速度
		 */
		public function get vx():Number {
			
			return _vx;
		}
		
		public function set vy(value:Number):void {
			
			_vy = value;
		}
		
		/**
		 * 设置Y轴上的速度
		 */
		public function get vy():Number {
			
			return _vy;
		}
		
		public function set vz(value:Number):void {
			
			_vz = value;
		}
		
		/**
		 * 设置Z轴上的速度
		 */
		public function get vz():Number {
			
			return _vz;
		}
		
		override public function get x():Number {
			
			return _position.x;
		}
		
		/**
		 * 设置/读取3D空间中的x坐标
		 */
		override public function set x(value:Number):void {
			
			_position.x = value;
			
			updateScreenPositon();
		}
		
		override public function get y():Number {
			
			return _position.y;
		}
		
		/**
		 * 设置/读取3D空间中的y坐标
		 */
		override public function set y(value:Number):void {
			
			_position.y = value;
			
			updateScreenPositon();
		}
		
		public function get z():Number {
			
			return _position.z;
		}
		
		/**
		 * 设置/读取3D空间中的z坐标
		 */
		public function set z(value:Number):void {
			
			_position.z = value;
			
			updateScreenPositon();
		}
		
		public function setSuperXY(x:Number, y:Number):void {
			
			super.x = x;
			super.y = y;
		}
		
		/**原始坐标X**/
		public function get pX():Number {
			
			return super.x;
		}
		
		/**原始坐标Y**/
		public function get pY():Number {
			
			return super.y;
		}
		
		public function set position(value:Point3D):void {
			
			if (value == null) {
				return;
			}
			
			//_position = value;
			_position.x = value.x;
			_position.y = value.y;
			_position.z = value.z;
			
			updateScreenPositon();
		}
		
		public function get position():Point3D {
			
			return _position;
		}
		
		private var _point:Point = new Point();
		
		/**
		 * 当前坐标点
		 */
		public function get point():Point {
			
			_point.x = super.x;
			_point.y = super.y;
			
			return _point;
		}
		
		private var _pos:Point = new Point(); //在地图格子索引坐标
		
		/**
		 * 设置地图索引坐标
		 * @param	posX
		 * @param	posY
		 */
		public function setPosAt(posX:int, posY:int):void {
			
			_pos.x = posX;
			_pos.y = posY;
		}
		
		/**
		 * 地图数组索引坐标
		 */
		public function get pos():Point {
			
			return _pos;
		}
		
		/**
		 * 返回形变后的层深,计算变形后的Z坐标
		 */
		override public function get depth():Number {
			
			return (_position.x + _position.z) * .866 - _position.y * .707;
		}
		
		public function set walkable(value:Boolean):void {
			
			_walkable = value;
		}
		
		/**
		 * 指定其他对象是否可以经过所占的位置
		 */
		public function get walkable():Boolean {
			
			return _walkable;
		}
		
		/**
		 * 返回尺寸
		 */
		public function get size():Number {
			
			return _size;
		}
		
		/**
		 * 返回占用的矩形
		 */
		public function get rect():Rectangle {
			
			_rect.x = x - size / 2;
			_rect.y = z - size / 2;
			_rect.width = size;
			_rect.height = size;
			return _rect;
		}
		
		public function addElementAtBottom( child:DisplayObject ):void {
			
			this.addElementAt( child , 0 );
		}
		
		public function addElementAtTop( child:DisplayObject ):void {
			
			this.addElement( child );			
			if ( child != null ) {
				this.setChildIndex( child , this.numChildren - 1 );
			}
		}
		
		override public function addElementAt( child:DisplayObject , index:int ):DisplayObject  {
			
			if ( child != null && !this.contains( child ) ) {
				this.addChildAt( child , index );
			}
			return child;
		}
		
		override public function addElement( child:DisplayObject ):DisplayObject {
			
			if ( child != null && !this.contains( child ) ) {
				this.addChild( child );
			}
			return child;
		}
		
		override public function removeElement( child:DisplayObject , reback:Boolean=false):DisplayObject {
			
			if ( child != null && this.contains( child ) ) {
				this.removeChild( child );
			}
			return child;
		}
		
		override public function removeElementAt( index:int ):DisplayObject  {
			
			return this.removeChildAt( index , false );
		}
		
		public function clear():void {
			
			
		}
		
		public function get contentWidth():Number {
			
			return _contentWidth;
		}
		
		public function get contentHeight():Number {
			
			return _contentHeight;
		}
		
		public function showBorder( color:uint = 0x00ff00 ):void {
			
			borderRect   = borderRect || new Rect( _contentWidth , _contentHeight , 0 , 0 , color , 1 , 2 );			
			borderRect.drawRect( this._contentWidth * 2 , this._contentHeight * 2 , 0 , 0 , 1 , color , 2 );
			borderRect.x = -borderRect.width * 0.5;
			borderRect.y = -borderRect.height * 0.5;
			this.addElement( borderRect );
		}		
		
		public function advanceTime(time:Number):void{
			
		}
	}
}