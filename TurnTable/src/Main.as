package {
	
	import com.UIGlobal;
	import com.utils.StarlingUtils;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.utils.AssetManager;
	import starling.utils.formatString;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	/**
	 * 用于Starling 测试
	 * @author cl 2015/3/6 15:17
	 */
	[SWF(width="762", height="480", frameRate="60", backgroundColor="#000000")]
	public class Main extends Sprite {
		
		private var mStarling:Starling;
		private var assets:AssetManager;
		
		public function Main():void {
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align 	= StageAlign.TOP_LEFT;
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			init();
		}
		
		private function init():void {
			
			//this.addChild( new FPS() );
			
			Starling.multitouchEnabled = true;//是否支持多点触摸
			Starling.handleLostContext = StarlingUtils.isIOS;
			
			var vw:int = StarlingUtils.isAndroid ? Capabilities.screenResolutionX : 762;
			var vh:int = StarlingUtils.isAndroid ? Capabilities.screenResolutionY : 480;
			
			//视口
			var viewPort:Rectangle = RectangleUtil.fit( new Rectangle( 0 , 0 , UIGlobal.stageWidth , UIGlobal.stageHeight ) , new Rectangle( 0 , 0 , vw , vh ) , ScaleMode.SHOW_ALL , StarlingUtils.isIOS );
			//自适应屏幕，根据频幕大小加载不同的资源
			var scaleFactor:int = viewPort.width < 720 ? 1 : 2; // 480 midway between 320 and 640
			
			//开始Starling
			mStarling = new Starling( Game , stage , viewPort );
			mStarling.stage.stageWidth  	= UIGlobal.stageWidth;  // <- same size on all devices!
            mStarling.stage.stageHeight 	= UIGlobal.stageHeight; // <- same size on all devices!
            mStarling.simulateMultitouch  	= false;
            mStarling.enableErrorChecking 	= false;
			
			mStarling.addEventListener( Event.ROOT_CREATED , starlingCreated );
            
			//stage.addEventListener( flash.events.Event.DEACTIVATE , deactivate);
            //NativeApplication.nativeApplication.addEventListener( "activate" , activate );            
            NativeApplication.nativeApplication.addEventListener( "deactivate" , deactivate );
		}
		
		//Starling创建完成
		private function starlingCreated():void {
			
			var appDir:File = File.applicationDirectory;
            assets = new AssetManager();            
            assets.verbose = Capabilities.isDebugger;
            assets.enqueue(
                appDir.resolvePath( "config/table.xml" )
            );
			
			var game:Game = mStarling.root as Game;
			
			startGame( game , assets );
		}
		
		private function startGame( game:Game , assets:AssetManager ):void {
			
			game.start( assets );
			mStarling.start();
		}
		
		//程序激活时
		private function activate( e:* ):void {
			
			mStarling.start();
		}
		
		//后台运行时
		private function deactivate( event:* ):void {
			
			//mStarling.stop(true);
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();			
		}	
	}
}