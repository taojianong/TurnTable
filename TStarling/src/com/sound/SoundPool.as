package com.sound {
	
	import flash.media.Sound;
	import flash.utils.Dictionary;
	
	/**
	 * 声音池
	 * @author cl 2015/4/20 22:59
	 */
	public class SoundPool {
		
		/**<b>声音池</b>**/
		public static var pool:Dictionary = new Dictionary;
		
		/**
		 * 从池中获取对应音乐
		 * @param	url
		 * @param	complete
		 * @param	error
		 * @return
		 */
		public static function getSound(id:String, url:String, complete:Function = null, error:Function = null):void {
			
			if (url == null || url == "") {
				
				return;
			}
			
			/*var soundRes:Resource = new Resource(id, url, function loadComplete(data:Sound):void {
				
					if (complete != null) {
						
						complete(data);
					}
				});
			
			soundRes.isAddLoadNum = false;*/
			
			//没有在缓存中则加载
			/*if (!ResourceMgr.getInstance().hasBuffer(soundRes.url)) {				
				ResourceMgr.getInstance().load(soundRes);
			}*/
			
			/*if (ResourceMgr.getInstance().hasBuffer(soundRes.url)) {				
				if (complete != null) {					
					complete(ResourceMgr.getInstance().getSound(soundRes.id));
				}
			}*/
		}
		
		/**
		 * 回收音乐到池中 2012.11.19
		 * @param	url
		 */
		public static function reback(sound:Sound):void {
			
			if (pool[sound.url] != null) {
				
				throw new Error("池中已存在该音乐");
			}
			pool[sound.url] = sound;
		}
	}

}