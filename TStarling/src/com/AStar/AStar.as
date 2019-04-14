package com.AStar {
	
	/**
	 * A*算法          
	 * @author cl 2015/4/6 23:06
	 */
	public class AStar {
		
		private var _open:Array;
		private var _closed:Array;
		private var _endNode:Node;
		private var _startNode:Node;
		private var _path:Array;
		/**
		 * 精简对角启发算法 diagonal
		 * 欧几里德启发算法 euclidian
		 * 曼哈顿启发算法 	manhattan
		 */
		private var _heuristic:Function  = manhattan;// diagonal ;
		private var _straightCost:Number = 1.0;
		private var _diagCost:Number = Math.SQRT2;
		
		private var _grid:Grid;
		
		public function AStar( grid:Grid ) {
			
			_grid = grid;
		}
		
		public function findPath( startNode:Node , endNode:Node ):Array {
			
			//trace("=====start.x: "+ _startNode.x + " start.y: " + _startNode.y + " end.x: " + _endNode.x + " end.y: " + _endNode.y );
			//CommonUtils.printDyadicArray( _grid.dyadicArray );
			
			if ( _grid == null ) {
				
				throw new Error( "fail to AStar,null map information!");
				
				return null;
			}
			
			if ( startNode == null || endNode == null ) {
				
				return null;
			}
			
			if ( _path == null ) {
				_path = new Array();
			}
			else{
				while ( _path.length > 0 ) {
					_path.shift();
				}
			}
			
			_startNode = startNode;
			_endNode   = endNode;			
			
			_open   = new Array;
			_closed = new Array;
			
			_startNode.g = 0;
			_startNode.h = _heuristic( _startNode );
			_startNode.f = _startNode.g + _startNode.h ;
			
			return search() ? _path : null ;
		}
		
		public function search():Boolean {
			
			var node:Node = _startNode;
			
			while ( node != _endNode ) {
				
				var starX:int = Math.max( 0, node.x -1 );
				var endX:int = Math.min( _grid.numCols - 1, node.x +1 );
				var startY:int = Math.max( 0 , node.y -1 );
				var endY:int = Math.min( _grid.numRows - 1, node.y +1 );
				
				for ( var i:int = starX; i <= endX;++i ) {
					
					for ( var j:int = startY; j <= endY;++j ) {
						
						var test:Node = _grid.getNode( i, j );
						
						if ( test == node || 
							!test.walkable ||
							!_grid.getNode(node.x, test.y).walkable ||
							!_grid.getNode(test.x,node.y ).walkable) {
							
							continue;
						}
						
						var cost:Number = _straightCost;
						
						if ( !((node.x == test.x ) || (node.y == test.y ))) {
							
							cost = _diagCost;
						}
						
						var g:Number = node.g +cost;
						var h:Number = _heuristic( test );
						var f:Number = g + h ;
						
						if ( isOpen(test) || isClosed(test )) {
							
							if ( test.f > f ) {
								
								test.f = f;
								test.g = g;
								test.h = h;
								test.parent = node;
								
							}
						}else {
							
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
							_open.push( test );
						}
					}
				}
				
				_closed.push( node );
				
				if ( _open.length == 0 ) {
				
					return false;
				}
				
				_open.sortOn("f", Array.NUMERIC );
				
				node = _open.shift() as Node ;				
				
			}	
			
			buildPath();
			
			return true;
		}
		
		private function buildPath():void {
			
			_path = new Array;
			
			var node:Node = _endNode;
			
			_path.push( node );
			
			while ( node != _startNode ) {
				
				node = node.parent;
				_path.unshift(node );
			}
		}
		
		public function get path():Array {
			
			return _path;
		}
		
		private function isOpen( node:Node ):Boolean {
			
			for ( var i:int = 0; i < _open.length;++i ) {
				
				if ( _open[i] == node ) {
					
					return true;
				}
			}
			return false;
		}
		
		private function isClosed( node:Node ):Boolean {
			
			for ( var i:int = 0; i < _closed.length;++i ) {
				
				if ( _closed[i] == node ) {
					
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 曼哈顿启发算法
		 * @param	node
		 * @return
		 */
		private function manhattan( node:Node ):Number {
			
			return Math.abs(node.x - _endNode.x ) * _straightCost +
					Math.abs(node.y + _endNode.y ) * _straightCost;
		}
		
		/**
		 * 欧几里德启发算法
		 * @param	node
		 * @return
		 */
		private function euclidian( node:Node ):Number {
			
			var dx:Number = node.x -_endNode.x;
			var dy:Number = node.y -_endNode.y;
			return Math.sqrt( dx * dx +dy * dy) * _straightCost;
		}
		
		/**
		 * 精简对角启发算法
		 * @param	node
		 * @return
		 */
		private function diagonal( node:Node ):Number {
			
			var dx:Number = Math.abs( node.x - _endNode.x );
			var dy:Number = Math.abs( node.y - _endNode.y );
			var diag:Number = Math.min( dx, dy );
			var straight:Number = dx + dy;
			
			return _diagCost * diag +_straightCost * ( straight - 2 * diag );
		}
		
		public function get visited():Array {
			
			return _closed.concat( _open );
		}
	}

}