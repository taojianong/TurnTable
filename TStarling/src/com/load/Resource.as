package com.load {
	
	import com.log.TLog;
	import flash.utils.Dictionary;
	
	/**
	 * 资源
	 * @author cl 2014/11/13 14:16
	 */
	public class Resource {
		
		/**资源池**/
		private static var sourcePool:Dictionary = new Dictionary();		
		/**
		 * 加入资源
		 * */
		public static function putSource( url:String , source:* ):void {
			
			sourcePool[ url ] = source;
		}		
		/**
		 * 获取对应URL资源
		 * */
		public static function getSource( url:String ):*{
			
			return sourcePool[ url ];
		}		
		
		private static var idPool:Dictionary 	= new Dictionary();//资源ID池管理,一个ID对应个URL
		private static var urlPool:Dictionary 	= new Dictionary();//资源URL池,一个URL对应一个ID
		
		public static function getID( url:String ):String {			
			return urlPool[ url ];
		}
		
		public static function getUrl( id:String ):String {			
			return idPool[ id ];
		}
		
		//------------------------------------------------------------------
		
		public var id:String  = "";//资源ID
		public var url:String = "";//资源地质
		public var des:String = "";//资源描述
		public var complete:Function = null;//加载资源完成事件
		
		public function Resource( id:String = "" , url:String = "" , compete:Function = null , des:String = ""  ) {
			
			this.id  		= id;
			this.url 		= url;
			this.des 		= des;
			this.complete 	= complete;
			
			if ( idPool[ id ] == url ) {
				TLog.addLog( "有重复资源ID,请检测!" , TLog.LOG_ERROR );
			}
			idPool[ id ] 	= url;
			urlPool[ url ] 	= id;
		}
		
		/**
		 * 对应资源的数据
		 */
		public function get data():*{
			
			return TweenLoader.getData( this.url );
		}
		
		/**
		 * 是否已缓存
		 * @return
		 */
		public function get hasCache():Boolean {
			
			return this.data != null;
		}
		
		public function get isXML():Boolean {
			
			return this.extension.toLowerCase() == "xml";
		}
		
		public function get isSWF():Boolean {
			
			return this.extension.toLowerCase() == "swf";
		}
		
		public function get isJPG():Boolean {
			
			return this.extension.toLowerCase() == "jpg";
		}
		
		public function get isPNG():Boolean {
			
			return this.extension.toLowerCase() == "png";
		}
		
		public function get isMP3():Boolean {
			
			return this.extension.toLowerCase() == "mp3";
		}
		
		public function get isTXT():Boolean {
			
			return this.extension.toLowerCase() == "txt";
		}
		
		/**
		 * 文件后缀名
		 */
		public function get extension():String {
			
			//切掉路径后面的参数
			var searchString:String = url.indexOf("?") > -1 ? url.substring(0, url.indexOf("?")) : url;
			
			//截取后缀
			var finalPart:String = searchString.substring(searchString.lastIndexOf("/"));
			return finalPart.substring(finalPart.lastIndexOf(".") + 1).toLowerCase();
		}
		
		/**
		 * 释放资源
		 */
		public function dispose():void {
			
			TweenLoader.disposeSource( this.url );
		}
		
	}
}