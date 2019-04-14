package {
	
	import assets.Assets;
	import com.manager.KeyManager;
	import com.manager.LayerManager;
	import com.manager.UIManager;
	import com.TurntableConst;
	import com.ui.componet.ProgressBar;
	import com.UIGlobal;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	import starling.utils.VAlign;
	
	/**
	 * 游戏主文件
	 * @author cl 2015/3/6 15:43
	 */
	public class Game extends Sprite {
		
		private var mLoadingProgress:ProgressBar;
		private static var sAssets:AssetManager;
		
		/**
		 * 开始游戏
		 * @param	background  背景纹理
		 * @param	asset		资源管理
		 */
		public function start( asset:AssetManager = null ):void {
			
			sAssets = asset;
			
			mLoadingProgress = new ProgressBar(175, 20);
			mLoadingProgress.x = (UIGlobal.stageWidth - mLoadingProgress.width) / 2;
			mLoadingProgress.y = (UIGlobal.stageHeight - mLoadingProgress.height) * 0.5;
			this.addChild(mLoadingProgress);
			
			if ( sAssets != null ) {
				sAssets.loadQueue(function(ratio:Number):void {
					mLoadingProgress.ratio = ratio;
					if (ratio == 1)
						Starling.juggler.delayCall(function():void {
								initGame();
							}, 0.15);
				});
			}
			else {
				initGame();
			}
		}
		
		//初始化游戏
		private function initGame():void {
			
			var xml:XML = sAssets.getXml( Assets.CONFIG_TABLE );
			
			TurntableConst.decode( xml );
			
			LayerManager.bottomLayer = new Sprite();
			LayerManager.gameLayer = new Sprite();
			LayerManager.uiLayer = new Sprite();
			LayerManager.topLayer = new Sprite();
			
			this.addChild(LayerManager.bottomLayer);
			this.addChild(LayerManager.gameLayer);
			this.addChild(LayerManager.uiLayer);
			this.addChild(LayerManager.topLayer);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyManager.Instance.keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyManager.Instance.keyUpHandler);
			
			UIManager.Instance.openGameScene();
			
			//显示驱动信息
			var driverInfo:String = Starling.context.driverInfo;
			var infoText:TextField = new TextField(310, 64, driverInfo, "Verdana", 10);
			infoText.x = (UIGlobal.stageWidth - infoText.width) / 2;
			infoText.y = UIGlobal.stageHeight - infoText.height;
			infoText.vAlign = VAlign.BOTTOM;
			infoText.addEventListener(TouchEvent.TOUCH, onInfoTextTouched);
			LayerManager.topLayer.addChild(infoText);
		}
		
		private function onInfoTextTouched(event:TouchEvent):void {
			
			if (event.getTouch(this, TouchPhase.ENDED))
				Starling.current.showStats = !Starling.current.showStats;
		}
		
		/**
		 * 资源管理器
		 */
		public static function get assetsMgr():AssetManager {
			return sAssets;
		}
	}
}