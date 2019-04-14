package com.sound {
	
	import com.greensock.TweenLite;
	import com.log.TLog;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * 循环播放音乐 
	 * @author taojianlong 2012.10.30
	 *
	 */
	public class MusicMgr {
		/**<b>是否打开音效</b> 默认是 1为是 2为否**/
		//public var isSoundOn:int = 1;
		//声音
		private var soundFactory:Sound;
		/**<b>背景音乐声道对象</b>**/
		public var musicChannel:SoundChannel;
		/**<b>当前播放地址</b>**/
		private var url:String;
		/**<b>重复播放音乐次数</b>**/
		private var repeat:int;
		/**<b>每次播放完成间歇delay秒再播放</b>**/
		private var delay:Number = 0;
		/**<b>播放完成事件</b>**/
		private var complete:Function;
		/**<b>是否渐入渐出</b>**/
		private var isEasy:Boolean = false;
		/**渐入渐出的时间/秒**/
		private var easyTime:Number;
		/**id**/
		private var id:String;
		
		/**
		 * <b>播放指定音乐文件</b>
		 * @param url      音乐文件地址
		 * @param repeat   重复次数
		 * @param relay    延迟
		 * @param complete 完成事件
		 **/
		public function playSound(url:String, repeat:int = 9999, delay:Number = 0, complete:Function = null, easy:Boolean = false, easyTime:Number = 0, id:String = ""):void {
			if (url == null || url == "" || this.url == url)
				return;
			
			clear();
			this.id = id;
			this.isEasy = easy;
			this.easyTime = easyTime;
			this.url = url;
			this.repeat = repeat;
			this.delay = delay;
			this.complete = complete;
			
			SoundPool.getSound(id, url, completeSoundHandler, ioSoundErrorHandler);
		}
		
		private var position:int = 0; //声音播放位置
		
		/**<b>暂停播放音乐</b>**/
		public function pause():void {
			
			if (this.musicChannel != null) {
				
				position = this.musicChannel.position;
				
				this.musicChannel.stop();
			}
		}
		
		/**<b>继续播放音乐</b>**/
		public function play():Boolean {
			
			if (this.musicChannel == null) {
				
				return false;
			}
			
			toPlay(position);
			
			return true;
		}
		
		/**
		 * 声音渐出(可关闭音乐)
		 * @param	time 渐出时间
		 * @param	isClose 是否关闭声音
		 */
		public function soundTurnDown(time:Number, isClose:Boolean = true, easy:Boolean = true):void {
			
			soundTrans = new SoundTransform(1);
			
			easyTime = time;
			
			isEasy = easy;
			//声音渐出
			if (isEasy && this.musicChannel) {
				
				this.musicChannel.soundTransform = soundTrans;
				
				if (isClose) {
					
					TweenLite.to(soundTrans, time, {volume: 0, onUpdate: updateVoice, onComplete: clear});
				} else {
					TweenLite.to(soundTrans, time, {volume: 0, onUpdate: updateVoice});
				}
			}
		}
		
		/**
		 * 声音渐入
		 * @param	time 渐入时间
		 */
		public function soundTurnUp(time:Number):void {
			
			soundTrans = new SoundTransform(0);
			
			easyTime = time;
			//声音渐入
			if (isEasy) {
				
				this.musicChannel.soundTransform = soundTrans;
				
				TweenLite.to(soundTrans, time, {volume: 1, onUpdate: updateVoice});
			}
		
		}
		
		/**<b>停止播放音乐</b>**/
		public function stopSound():void {
			
			clear();
		}
		
		private function completeSoundHandler(sound:Sound):void {
			
			this.soundFactory = sound;
			
			toPlay();
			
			TLog.addLog( "url: " + this.url + " repeat: " + this.repeat , TLog.LOG_LOAD );
		}
		
		private function updateVoice():void {
			
			if ( this.musicChannel != null ) {
				
				this.musicChannel.soundTransform = soundTrans;
			}		
		}
		
		private var soundTrans:SoundTransform = new SoundTransform(0);
		
		private function toPlay(position:int = 0):void {
			
			if (position >= 0 && this.musicChannel != null) {
				
				this.musicChannel.stop();
				//监听声音是否播放完成      
				this.musicChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				this.musicChannel = null;
			}
			
			if (this.repeat > 0 && this.soundFactory) {
				
				this.musicChannel = this.soundFactory.play(position, 1);
				
				if (this.musicChannel && !this.musicChannel.hasEventListener(Event.SOUND_COMPLETE)) {
					
					this.musicChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				}
			} else {
				
				if (complete != null) {
					
					complete();
				}
					//clear();
			}
		}
		
		public function get isPlaying():Boolean {
			
			return this.musicChannel != null;
		}
		
		private function soundCompleteHandler(event:Event):void {
			
			this.repeat--;
			
			if (delay > 0) {
				
				//延迟
				TweenLite.to(instance, this.delay, {delay: 0, onComplete: toPlay});
			} else {
				
				toPlay();
			}
		}
		
		private function ioSoundErrorHandler():void {
			
			TLog.addLog( "加载" + url + "背景音乐文件失败." , TLog.LOG_ERROR );
			
			clear();
		}
		
		public function clear():void {
			
			complete = null;
			position = 0;
			url = "";
			if (this.musicChannel != null) {
				this.musicChannel.stop();
				//监听声音是否播放完成      
				this.musicChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				this.musicChannel = null;
			}
			if (this.soundFactory != null) {
				this.soundFactory = null;
			}
		}
		
		private static var instance:MusicMgr;
		
		public static function get Instance():MusicMgr {
			
			if (instance == null) {
				
				instance = new MusicMgr;
			}
			return instance;
		}
	}
}
