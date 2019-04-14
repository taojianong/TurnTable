package com {
	
	/**
	 * 转盘静态数据
	 * @author taojianlong 2015/3/18 0:16
	 */
	public class TurntableConst {
		
		/**
		 * 随机值精度
		 */
		public static var ratPre:int 	= 1000;
		
		/**
		 * 转的圈数
		 */
		public static var rotCnt:int	= 10;
		
		/**
		 * 转的圈数花费时间,秒
		 */
		public static var costTime:int 	= 8;
		
		/**
		 * 转盘对应区域的数据
		 */
		public static var tableAward:Object = 	{
												"1": { "id":1, "from":0, "to":30, "rat":"0-100", "desc":"1元话费" } ,
												"2": { "id":2, "from":30, "to":60, "rat":"190-200", "desc":"10元代金卷" } ,
												"3": { "id":3, "from":60, "to":90, "rat":"200-300", "desc":"创意生活小凳" } ,
												"4": { "id":4, "from":90, "to":120, "rat":"392-400", "desc":"50元代金卷" } ,
												"5": { "id":5, "from":120, "to":150, "rat":"400-500", "desc":"财源广进" } ,
												"6": { "id":6, "from":150, "to":180, "rat":"594-600", "desc":"100元代金卷" } ,
												"7": { "id":7, "from":180, "to":210, "rat":"600-700", "desc":"5元话费" } ,
												"8": { "id":8, "from":210, "to":240, "rat":"700-800", "desc":"羊年大吉" } ,
												"9": { "id":9, "from":240, "to":270, "rat":"896-900", "desc":"200元代金卷" } ,
												"10": { "id":10, "from":270, "to":300, "rat":"900-940", "desc":"3元话费" } ,
												"11": { "id":11, "from":300, "to":330, "rat":"940-1000", "desc":"吉祥如意" } ,
												"12": { "id":12,"from":330,"to":360,"rat":"1001-1001", "desc":"500元代金卷"} 
											};
											
		public static function decode( xml:XML ):void {
			
			ratPre = int( xml.ratPre.@value );
			rotCnt = int( xml.rotCnt.@value );
			costTime = int( xml.costTime.@value );
			for ( var i:int = 0; i < xml.tableAward.item.length();i++ ) {
				var item:XML = xml.tableAward.item[ i ];
				tableAward[ int(item.@id) ] = { "id":int(item.@id) , "from":int(item.@from) , "to":int(item.@to) , "rat":String(item.@rat) , "desc":String(item.@desc) };
			}
		}
	}

}