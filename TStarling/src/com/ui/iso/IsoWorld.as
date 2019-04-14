package com.ui.iso;

	import com.ui.componet.Rect;
	import com.ui.IsoObject;
	import com.utils.ObjectPool;
	import flash.geom.Rectangle;
	import starling.display.Sprite;
	
	/**
	 * 等角世界
	 * @author cl 2013/11/15 10:48
	 */
	public class IsoWorld extends Sprite {
		
		private var _floor:Sprite;
		private var _world:Sprite;
		private var _player:Sprite;//角色层
		
		private var _objects:Array;//存储元素，IsoObject
		
		public function IsoWorld() {
			
			_floor  = new Sprite();
			_world  = new Sprite();
			_player = new Sprite();
			
			this.addChild( _floor );
			this.addChild( _world );
			this.addChild( _player );
			
			_objects = new Array();
		}
		
		public function addChildToPlayer( child:IsoObject ):IsoObject {
			
			if ( !hasChildAtPlayer( child ) && child != null ) {
				return _player.addChild( child ) as IsoObject;				
			}			
			return null;
		}
		
		public function removeChildToPlayer( child:IsoObject ):IsoObject {
			
			if ( hasChildAtFloor( child ) ) {
				return _player.removeChild( child ) as IsoObject ;
			}
			return null;
		}
		
		public function addChildToFloor( child:IsoObject ):IsoObject {
			
			if ( !hasChildAtFloor( child ) && child != null ) {
				return _floor.addChild( child ) as IsoObject;
			}	
			return null;
		}
		
		public function removeChildAtFloor( child:IsoObject ):IsoObject {
			
			if ( hasChildAtFloor( child ) ) {
				return _floor.removeChild( child ) as IsoObject;
			}
			return null;
		}
		
		public function hasChildAtFloor( child:IsoObject ):Boolean {
			
			return child != null && _floor.contains( child );
		}
		
		public function hasChildAtPlayer( child:IsoObject ):Boolean {
			
			return child != null && _player.contains( child );
		}
		
		public function addChildToWorld( child:IsoObject ):void {
			
			_world.addChild( child );
			_objects.push( child );
			
			sort();
		}
		
		public function removeChildAtWorld( child:IsoObject ):void {
			
			if ( child == null) {
				return;
			}
			if ( child && _world.contains( child ) ) {
				_world.removeChild( child );
			}
			var ind:int = _objects.indexOf( child );
			if ( ind != -1 ) {
				_objects.splice( ind , 1 );
			}
			sort();
		}
		
		public function sort():void {
			
			_objects.sortOn("depth", Array.NUMERIC);
			
			for (var i:int = 0; i < _objects.length;i++ ) {
				_world.setChildIndex( _objects[i] , i );
			}
		}
		
		public function canMove( obj:IsoObject ):Boolean {
			
			var rect:Rectangle = obj.rect;
			rect.offset( obj.vx , obj.vz );
			
			var objB:IsoObject;
			for ( var i:int = 0; i < _objects.length;i++ ) {
				
				objB = _objects[ i ];
				if ( obj != objB && !objB.walkable && rect.intersects(objB.rect)) {
					return false;
				}
			}
			
			return true;
		}
		
		public function removeAllPlayers():void {
			
			while ( _player.numChildren > 0 ) {
				
				ObjectPool.recovery( _player.removeChildAt(0) );
			}
		}
		
		public function removeAllFloors():void {
			
			while ( _floor.numChildren > 0 ) {
				
				ObjectPool.recovery( _floor.removeChildAt(0) );
			}
		}
		
		private var _contentWidth:Number 	= 0;
		private var _contentHeight:Number 	= 0;
		
		public function get contentWidth():Number {
			
			return _contentWidth * 2;
		}
		
		public function get contentHeight():Number {
			
			return _contentHeight ;
		}
		
		public function measure():void {
			
			_contentWidth = 0;
			_contentHeight = 0;
			var disObj:DisplayObject;
			for ( var i:int = 0; i < _floor.numChildren;i++ ) {
				
				disObj = _floor.getChildAt(i);
				if ( disObj is IsoObject) {					
					_contentWidth  = Math.max( IsoObject( disObj ).pX + IsoObject( disObj ).contentWidth / 2 , _contentWidth );
					_contentHeight = Math.max( IsoObject( disObj ).pY + IsoObject( disObj ).size / 2 , _contentHeight );
				}
				else {
					_contentWidth  = Math.max( disObj.x + disObj.width , _contentWidth );
					_contentHeight = Math.max( disObj.y + disObj.height , _contentHeight );
				}
			}
			
			showBorder();
		}
		
		public function removeAllWorlds():void {
			
			while ( _world.numChildren > 0 ) {
				
				ObjectPool.recovery( _world.removeChildAt( 0 ) );
			}
			
			while ( _objects && _objects.length > 0 ) {
				_objects.shift();
			}
		}
		
		private var borderRect:Rect;
		/**显示动态高度边框**/
		public function showBorder( color:uint = 0xff0000 ):void {
			
			borderRect = borderRect || new Rect();
			borderRect.drawRect( contentWidth , contentHeight , 0 , 0 , 0xff0000 , 1 , 2 );
			if ( !this.contains( borderRect ) ) {
				this.addChild( borderRect );
			}
			this.setChildIndex( borderRect , this.numChildren - 1 );
		}
	}
}