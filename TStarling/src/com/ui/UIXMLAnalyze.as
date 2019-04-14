package com.ui {
	
	import avmplus.getQualifiedClassName;
	import com.ui.componet.*;
	import flash.display.BitmapData;
	import starling.display.*;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * Starling相关组件
	 * @author taojianlong 2014/7/2 20:45
	 */
	public class UIXMLAnalyze {
		
		private static const classMap:Object = 
		     {
				"Sprite":Sprite, "Button":Button , "Image":Image , "MovieClip":MovieClip , "TextField":TextField,
				
				"TSImage":TSImage, "TSButton":TSButton, "BackGround":BackGround, "ItemBase":ItemBase, "TSLabel":TSLabel,
				
				"BackGround":BackGround , "ProgressBar":ProgressBar , "TImage":TImage , "RoundButton":RoundButton ,
				
				"TouchSheet":TouchSheet
			 };
		
		public static function addClasses( arr:Array ):void {
		
			if ( arr ) {
				for each( var cls:Class in arr ) {
					addClass( cls );
				}
			}
		}
		
		/**
		 * 添加外部要解析的类
		 * @param cls
		 */
		public static function addClass( cls:Class ):void {
			
			if ( cls != null && !hasClass( cls )  ) {
				
				var clsName:String = getClassName( cls );
				
				classMap[ clsName ] = cls;
			}
		}
		
		public static function hasClass( cls:Class ):Boolean {
			
			if ( cls == null ) {
				return false;
			}
			
			var clsName:String = getClassName( cls );
			
			return clsName && classMap[ clsName ] != null;
		}
		
		/**
		 * 获取类的名字
		 * @return
		 */
		public static function getClassName( cls:Class ):String {
			
			var clsName:String = getQualifiedClassName( cls );
			
			return clsName.indexOf( "::" ) != -1 ? clsName.split("::")[1] : clsName ;
		}
		
		private var _xml:XML;
		private var _displayList:Array;
		private var _complete:Function;           //完成事件
		
		public function UIXMLAnalyze( xml:XML = null , complete:Function = null ) {
			
			analyze( xml , complete );
		}
		
		/**
		 * 将解析的元件添加到容器中
		 * @param	uiXml     组件XML
		 * @param	container 容器
		 * @param   complete  添加完成事件
		 * @param   args      完成事件参数
		 */
		public function analyzeTo( uiXml:XML , container:DisplayObjectContainer , complete:Function = null , ...args ):void {
			
			var elements:Array = analyze( uiXml );
			
			if ( container ) {
				for ( var i:int = 0; i < elements.length;i++ ) {
					container.addChild( elements[i] );
				}
			}
			
			if ( complete != null ) {
				complete.apply( null , args );
			}
		}
		
		/**
		 * 解析UI配置文件
		 */
		public function analyze( uiXml:XML , complete:Function = null):Array {
			
			_complete   = complete;				
			_xml        = uiXml;
			
			_displayList = [];		
			
			if ( _xml == null ) {				
				return _displayList;
			}
			
			var displayObject:* , single:XML;
			
			for each( single in uiXml.children() ) {
				
				//创建对应单个组件				
				displayObject = createSingle( single );
				
				if ( displayObject != null ) {	
					
					_displayList.push( displayObject );
				}				
			}
			
			if ( _complete != null ) {
				
				_complete( _displayList );
			}
			
			return _displayList;
		}
		
		//创建单个组件,解析单个组件
		private function createSingle( xml:XML ):* {
			
			var name:String = xml.name().toString();			
			var cls:Class = classMap[ name ];		
			
			var displayObject:* = cls != null ? new cls : null;			
			displayObject = displayObject is BitmapData ? new Image( Texture.fromBitmapData( displayObject ) ) : displayObject;
			
			//给组件设置属性
			if ( displayObject) {
				
				setAttribute( displayObject , xml );
			}
			
			//检查是否有子子组件 2013/6/7 13:38 cl
			var son:XML, sonDisplayObject:*;	
			var i:int;
			
			if ( displayObject is DisplayObjectContainer && xml.children() ) {
				
				//添加容器子组件
				for ( i = 0; i < xml.children().length(); i++ ) {
					
					son = xml.children()[i];
					
					sonDisplayObject = createSingle( son );
					
					if ( sonDisplayObject && sonDisplayObject is DisplayObject ) {
						
						setAttribute( sonDisplayObject , son );
						
						if (displayObject is Sprite) {
							
							(displayObject as Sprite).addChild(sonDisplayObject);
						}
						else {
							
							DisplayObjectContainer( displayObject ).addChild( sonDisplayObject );
						}
					}
				}
			}
			return displayObject;
		}
		
		//给对应组件设置，相应属性
		private function setAttribute( displayObject:* , single:XML ):void {
			
			var attrs:XML, prop:String, value:*;
			
			for each( attrs in single.attributes() ) {
				
				prop  = attrs.name().toString();
				value = attrs;
				if ( displayObject.hasOwnProperty( prop ) ) {					
					
					//转换颜色值
					value = value.indexOf( "#" ) != -1 ? uint(String(value).replace(/#/g, "0x")) : value;					
					value = String(value).indexOf("0x") != -1 ? uint( value ) : value;
					displayObject[ prop ] = ( value == "true" ? true : (value == "false" ? false : value));
				}
			}
		}
		
		public function get displayList():Array {
			
			return _displayList;
		}
	}
}