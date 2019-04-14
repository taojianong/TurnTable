/**
 * 寻路格子
 */

package com.AStar {	
	
	import com.AStar.AStar;
	import com.AStar.Node;
	import com.utils.CommonUtils;
	
	/**
	 * @author cl 2013/11/15 14:00
	 */
	public class Grid {
		
		public static const NOMAL:int = 1;   //正常,可寻路点
		public static const REMORA:uint = 0; //障碍物,不可寻路点
		
		protected var _startNode:Node;
		protected var _endNode:Node;
		protected var _nodes:Array;
		protected var _numCols:int;
		protected var _numRows:int;
		protected var _gridSize:int;
		
		protected var _astar:AStar;
		
		protected var _data:Array = [];
		
		public function Grid( numCols:int,numRows:int,gridSize:int ) {
			
			initGrid( numCols , numRows , gridSize );
		}
		
		public function initGrid( numCols:int, numRows:int, gridSize:int ):void {
			
			_numCols  = numCols;
			_numRows  = numRows;
			_gridSize = gridSize;
			
			_nodes = [];
			_data = [];
			var i:int;
			var j:int;			
			for ( i = 0; i < _numCols;++i ) {				
				_nodes[i] = [];				
				for ( j = 0; j < _numRows ;++j ) {	
					
					_nodes[i][j] = new Node(i, j );					
					_data.push( Grid.NOMAL );					
				}
			}
			
			_astar = new AStar( this );
		}
		
		/**
		 * 二维数组
		 */
		public function get dyadicArray():Array {
			
			return CommonUtils.toDyadicArray( _data , 20 );
		}
		
		public function findPath( startNode:Node , endNode:Node ):Array {
			
			return _astar.findPath( startNode , endNode );
		}
		
		/**
		 * 初始化阻挡中的数据
		 */
		public function initData():void {
			
			var rows:Array;
			var node:Node;
			for each( rows in _nodes ) {
				
				for each( node in rows ) {
					
					node.data.length = 0 ;
				}
			}
		}
		
		/**
		 * 设置节点是否可寻路
		 * @param	x
		 * @param	y
		 * @param	boo
		 */
		public function setNodeWalkable(x:int, y:int, boo:Boolean):void {
			
			if ( _nodes[x] == null ) {
				return;
			}
			
			var node:Node = this._nodes[x][y] as Node;			
			if ( node ) {
				node.walkable = boo;
			}
		}
		
		/**
		 * 获取指定位置节点
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function getNode( x:int, y:int ):Node {
			
			if ( !availableNode( x, y ) ) {
				
				//throw new IObitError( "out of range!" );
				return null;
			}			
			return _nodes[x][y] as Node;
		}
		
		/**
		 * 设置寻路开始节点
		 * @param	x
		 * @param	y
		 */
		public function setStartNode( x:int, y:int ):void {
			
			if ( !availableNode( x, y ) ) {
				
				//throw new IObitError( "out of range!" );
				return;
			}			
			_startNode = _nodes[x][y] as Node;
		}
		
		/**
		 * 设置寻路结束节点
		 * @param	x
		 * @param	y
		 */
		public function setEndNode( x:int, y:int ):void {
			
			if ( !availableNode( x, y ) ) {
				
				//throw new IObitError( "out of range!" );
				return;
			}	
			
			_endNode = _nodes[x][y] as Node;
		}
		
		/**
		 * 设置某位置节点是否可寻路
		 * @param	x
		 * @param	y
		 * @param	value
		 */
		public function setWalkable( x:int, y:int, value:Boolean ):void {
			
			if ( !availableNode( x, y ) ) {
				
				//throw new IObitError( "out of range!" );
				return ;
			}
			
			_nodes[x][y].walkable = value;
		}
		
		/**
		 * 判断节点是否可寻路
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function availableNode( x:int, y:int ):Boolean {
			
			if ( x < 0 || y < 0 ) {
				
				return false;
			}			
			if ( x >= _numCols || y >= _numRows ) {
				
				return false;
			}			
			return true;			
		}
		
		public function get endNode():Node {
			
			return _endNode;
		}
		
		public function get startNode():Node {
			
			return _startNode;
		}
		
		public function get numCols():int {
			
			return _numCols;
		}
		
		public function get numRows():int {
			
			return _numRows;
		}
		
		public function get gridSize():int {
			
			return _gridSize;
		}		
		
	}
}