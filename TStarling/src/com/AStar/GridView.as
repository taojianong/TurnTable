package com.AStar {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * Test View Grid for AStart
	 * @author taojianlong 2015/4/6 23:04
	 */
	public class GridView extends Sprite {
		
		private var _grid:Grid;
		
		public function GridView( grid:Grid ) 	{
			
			_grid = grid;
			drawGrid();
			findPath();
			addEventListener( "click", onGridClick );
		}
		
		public function drawGrid():void {
			
			graphics.clear();
			for ( var i:int = 0; i < _grid.numCols;++i ) {
				
				for ( var j:int = 0; j < _grid.numRows;++j ) {
					
					var node:Node = _grid.getNode(i, j );
					graphics.lineStyle(0.5);
					graphics.beginFill( getColor(node ),0.5 );
					graphics.drawRect( i * _grid.gridSize, j * _grid.gridSize, _grid.gridSize, _grid.gridSize );
				}
			}
		}
		
		private function getColor( node:Node ):uint {
			
			if ( !node.walkable ) {
				
				return 0x000000;
			}
			if ( node == _grid.startNode ) {
				
				return 0x666666;
			}
			if ( node == _grid.endNode ) {
				
				return 0x666666 ;
			}
			return 0xffffff;
		}
		
		private function onGridClick( event:MouseEvent ):void {
			
			var xpos:int = Math.floor( event.localX / _grid.gridSize );
			var ypos:int = Math.floor( event.localY / _grid.gridSize );
			
			_grid.setWalkable( xpos, ypos, !_grid.getNode( xpos, ypos ).walkable );
			
			//drawGrid();
			graphics.clear();
			findPath();
		}
		
		private function findPath():void {
			
			var astar:AStar = new AStar();
			
			if ( astar.findPath( _grid ) ) {
				
				//showVisited( astar );
				showPath( astar );
			}
		}
		
		private function showVisited( astar:AStar ):void {
			
			for each( var node:Node in astar.visited ) {
				
				graphics.beginFill( 0xcccccc );
				graphics.drawRect( node.x * _grid.gridSize, node.y * _grid.gridSize, _grid.gridSize, _grid.gridSize );
				graphics.endFill();
			}
		}
		
		public function showPath( astar:AStar ):void {
			
			
			for each( var node:Node in astar.path ) {
				
				graphics.lineStyle(0.5);
				graphics.beginFill(0xff0000);
				graphics.drawCircle( node.x * _grid.gridSize + .5 * _grid.gridSize, node.y * _grid.gridSize + .5 * _grid.gridSize, _grid.gridSize / 3);
				graphics.endFill();
			}
		}
	}

}