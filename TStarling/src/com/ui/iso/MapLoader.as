package com.ui.iso {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 加载tile地图
	 * @author cl 2013/11/15 10:51
	 */
	public class MapLoader extends EventDispatcher {
		
		private var _grid:Array;
		private var _loader:URLLoader;
		private var _tileTypes:Object;		
		
		public function MapLoader() {
			
			_tileTypes = new Object();
		}
		
		public function loadMap( url:String ):void {
			
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onLoad);
			_loader.load( new URLRequest( url ));			
		}
		
		private function onLoad( event:Event ):void {
			
			_grid = new Array();
			
			var data:String = _loader.data;
			var lines:Array = data.split("\n");
			var line:String;
			for (var i:int = 0; i < lines.length;i++ ) {
				line = lines[i];
				line = line.replace(" \r","");
				if ( isDefinition( line ) ) {
					parseDefinition( line );
				}
				else if(!lineIsEmpty(line) && !isComment(line)) {
					var cells:Array = line.split(" ");
					_grid.push( cells );
				}
			}
			
			this.dispatchEvent( new Event(Event.COMPLETE));
			
		}
		
		private function parseDefinition(line:String):void {
			
			var tokens:Array = line.split(" " );
			tokens.shift();
			
			var symbol:String = tokens.shift() as String;
			
			var definition:Object = new Object();
			for (var i:int = 0; i < tokens.length;i++ ) {
				var key:String = tokens[i].split(":")[0];
				var val:String = tokens[i].split(":")[1];
				definition[ key ] = val;
			}
			setTileType( symbol , definition );
		}
		
		public function setTileType( symbol:String , definition:Object ):void {
			
			_tileTypes[ symbol ] = definition;
		}
		
		public function makeWorld( size:Number ):IsoWorld {
			
			var world:IsoWorld = new IsoWorld();
			for ( var i:int = 0; i < _grid.length;i++ ) {
				
				for ( var j:int = 0; j < _grid[i].length;j++ ) {
					
					var cellType:String = _grid[i][j];
					if ( cellType == "" ) continue;
					var cell:Object = _tileTypes[ cellType ];
					var tile:IsoObject;
					switch( cell.type ) {
						
						case "DrawnIsoTile":
							tile = new DrawnIsoTile(size , parseInt(cell.color) , parseInt(cell.height));
							break;
							
						case "DrawnIsoBox":
							tile = new DrawnIsoBox( size , parseInt(cell.color) , parseInt(cell.height)); 
							break;
							
						case "GraphicsTile":	
							var grahpicsClas:Class = getDefinitionByName( cell.graphicsClass ) as Class;
							tile = new GraphicsTile( size , grahpicsClas , parseInt( cell.xoffset ) , parseInt( cell.yoffset ) );
							break;						
					}
					
					tile.walkable = cell.walkable == "true";
					tile.x = j * size;
					tile.z = i * size;
					world.addChild( tile );
				}
			}
			
			return world;
		}
		
		private function lineIsEmpty( line:String ):Boolean {
			
			for (var i:int = 0; i < line.length;i++ ) {
				if (line.charAt(i) != "" ) return false;
			}
			
			return true;
		}
		
		private function isComment( line:String ):Boolean {
			
			return line.indexOf("//") == 0;
		}
		
		private function isDefinition( line:String ):Boolean {
			
			return line.indexOf("#") == 0;
		}
	}

}