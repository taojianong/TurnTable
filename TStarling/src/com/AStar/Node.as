package com.AStar {
	
	public class Node {
		
		public var x:int;
		public var y:int;
		public var f:Number = .0;
		public var g:Number = .0;
		public var h:Number = .0;		
		public var walkable:Boolean = true;
		public var parent:Node = null;
		public var data:*= null;
		
		public function Node( x:int, y:int ) {
			
			this.x = x;
			this.y = y;
		}		
	}
}