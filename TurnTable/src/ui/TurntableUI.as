package ui {
	
	import assets.Assets;
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.TurntableConst;
	import com.ui.componet.TImage;
	import com.ui.componet.TSButton;
	import com.ui.componet.TSLabel;
	import feathers.controls.PickerList;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.deg2rad;
	import ui.componet.FTextInput;
	
	/**
	 * 转盘游戏界面
	 * @author cl 2015/3/12 10:57
	 */
	public class TurntableUI extends BaseUI {
		
		private var backImg:TImage;
		private var arrowImg:TImage;
		
		private var startBtn:TSButton;
		private var lab:TSLabel;
		
		private var ratPreLab:TSLabel;
		private var rotCntLab:TSLabel;
		private var costTimeLab:TSLabel;
		
		private var ratPreInp:FTextInput;
		private var rotCntInp:FTextInput;
		private var costTimeInp:FTextInput;
		
		public function TurntableUI() {
			
			super(null, 480, 480);
			
			initUI();
		}
		
		private function initUI():void {
			
			backImg = new TImage(null, true);
			arrowImg = new TImage(null, true);
			
			backImg.x = this.width * 0.5;
			backImg.y = this.height * 0.5;
			arrowImg.x = this.width * 0.5;
			arrowImg.y = this.height * 0.5 - 18;
			
			backImg.bitmapData = Assets.getBitmapData("ZP_BACK");
			arrowImg.bitmapData = Assets.getBitmapData("ZP_ARROW");
			
			this.addElement(backImg);
			this.addElement(arrowImg);
			
			startBtn = new TSButton();
			startBtn.id	= "startBtn";
			startBtn.label = "开始转动";
			startBtn.upState = Assets.getTexture("blue_out");
			startBtn.downState = Assets.getTexture("blue_over");
			startBtn.x = this.width + 10;
			startBtn.y = 20;
			this.addElement( startBtn );
			startBtn.addEventListener( TouchEvent.TOUCH , startTouchHandler );
			
			lab = new TSLabel();
			lab.x = 0;// startBtn.x;
			lab.y = 10;// startBtn.y + 80;
			lab.color = 0x0000ff;
			lab.width = this.width;
			lab.hAlign = "center";
			lab.text = "test";
			//this.addChild( lab );
			
			ratPreLab = new TSLabel();
			rotCntLab = new TSLabel();
			costTimeLab = new TSLabel();
			
			ratPreLab.width = rotCntLab.width = costTimeLab.width = 200;
			ratPreLab.hAlign = rotCntLab.hAlign = costTimeLab.hAlign = "left";
			ratPreLab.color = rotCntLab.color = costTimeLab.color = 0xff0000;
			ratPreLab.x = rotCntLab.x = costTimeLab.x = 480;
			ratPreLab.y = 80;
			rotCntLab.y = 110;
			costTimeLab.y = 140;
			
			ratPreLab.text 		= "随机精度值: ";
			rotCntLab.text 		= "转的圈数: " ;
			costTimeLab.text 	= "花费时间: ";
			
			this.addElement( ratPreLab );
			this.addElement( rotCntLab );
			this.addElement( costTimeLab );
			
			ratPreInp 	= new FTextInput( 50 );
			rotCntInp 	= new FTextInput( 50 );
			costTimeInp = new FTextInput( 50 );
			
			ratPreInp.id 		= "ratPreInp";
			rotCntInp.id 		= "rotCntInp";
			costTimeInp.id 		= "costTimeInp";
			ratPreInp.algin 	= rotCntInp.algin 	= costTimeInp.algin 	= "center";
			ratPreInp.color 	= rotCntInp.color 	= costTimeInp.color 	= 0xff0000;
			ratPreInp.border 	= rotCntInp.border 	= costTimeInp.border 	= true;
			
			ratPreInp.text 		= "" + TurntableConst.ratPre.toString();
			rotCntInp.text 		= "" + TurntableConst.rotCnt.toString();
			costTimeInp.text 	= "" + TurntableConst.costTime.toString();
			
			ratPreInp.x 	= ratPreLab.x + 100;
			ratPreInp.y 	= ratPreLab.y + 10;
			rotCntInp.x		= rotCntLab.x + 100;
			rotCntInp.y 	= rotCntLab.y + 10;
			costTimeInp.x 	= costTimeLab.x + 100;
			costTimeInp.y 	= costTimeLab.y + 10;
			
			this.addElement( ratPreInp );
			this.addElement( rotCntInp );
			this.addElement( costTimeInp );	
			
			ratPreInp.addEventListener( Event.CHANGE , textInputChangeHandler );
			rotCntInp.addEventListener( Event.CHANGE , textInputChangeHandler );
			costTimeInp.addEventListener( Event.CHANGE , textInputChangeHandler );
			
			//设置选择列表
			var list:PickerList = new PickerList();  
			list.dataProvider = new ListCollection(
			[
				{ text: TurntableConst.tableAward["1"].desc, "id":1 , "thumbnail":null},
				{ text: TurntableConst.tableAward["2"].desc, "id":2 , "thumbnail":null},
				{ text: TurntableConst.tableAward["3"].desc, "id":3 , "thumbnail":null},
				{ text: TurntableConst.tableAward["4"].desc, "id":4 , "thumbnail":null},
				{ text: TurntableConst.tableAward["5"].desc, "id":5 , "thumbnail":null},
				{ text: TurntableConst.tableAward["6"].desc, "id":6 , "thumbnail":null},
				{ text: TurntableConst.tableAward["7"].desc, "id":7 , "thumbnail":null},
				{ text: TurntableConst.tableAward["8"].desc, "id":8 , "thumbnail":null},
				{ text: TurntableConst.tableAward["9"].desc, "id":9 , "thumbnail":null},
				{ text: TurntableConst.tableAward["10"].desc, "id":10 , "thumbnail":null},
				{ text: TurntableConst.tableAward["11"].desc, "id":11 , "thumbnail":null},
				{ text: TurntableConst.tableAward["12"].desc, "id":12 , "thumbnail":null },
				{ text: TurntableConst.tableAward["13"].desc, "id":13 , "thumbnail":null },
				{ text: TurntableConst.tableAward["14"].desc, "id":14 , "thumbnail":null },
				{ text: TurntableConst.tableAward["15"].desc, "id":15 , "thumbnail":null },
				{ text: TurntableConst.tableAward["16"].desc, "id":16 , "thumbnail":null },
				{ text: TurntableConst.tableAward["17"].desc, "id":17 , "thumbnail":null },
				{ text: TurntableConst.tableAward["18"].desc, "id":18 , "thumbnail":null },
				
			]);
			 
			list.listProperties.itemRendererFactory = function():IListItemRenderer{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "text";
				//renderer.data = 
				//renderer.iconSourceField = "thumbnail";
				return renderer;
			};
			 
			//list.addEventListener( Event.CHANGE, list_changeHandler );			 
			//this.addChild( list );
		}
		
		private function list_changeHandler( event:Event ):void {
			
			trace("desc: " + event.data.desc );
		}
		
		private function textInputChangeHandler( event:Event ):void {
			
			var target:FTextInput = event.currentTarget as FTextInput;
			trace( target.text );
			switch( target && target.id ) {
				
				case "ratPreInp":
					
					break;
					
				case "rotCntInp":
					
					break;
					
				case "costTimeInp":
					
					break;
			}
		}
		
		private function startTouchHandler( event:TouchEvent ):void {
			
			if ( event.getTouch(this, TouchPhase.ENDED) ) {
				this.randomTo( Math.random() * TurntableConst.ratPre );
			}
		}
		
		/**
		 * 指向对应的盘
		 * @param random 随机数，指精度,默认为1000
		 */
		public function randomTo( random:int = 1000 ):void {
			
			trace("random: " + random );
			var index:int = 1;
			for each( var obj:Object in TurntableConst.tableAward ) {
				var from:int = int( String( obj.rat ).split("-")[0] );
				var to:int = int( String( obj.rat ).split("-")[1] );
				if ( random >= from && random <= to ) {
					index = int( obj.id );
					break;
				}
			}
			startTurn( index );
		}
		
		private var _to:int = 1;
		private var rotObj:Object = { "angle":0 , "toAngle":0 };
		
		/**
		 * 开始转动
		 */
		private function startTurn( to:int = 1 ):void {
			
			this.removeElement( lab );
			
			_to = to <= 0 ? 1 : to;
			var obj:Object = TurntableConst.tableAward[ _to ];
			if ( obj != null ) {
				lab.text = "指向 index: " + _to + " from: " + obj.from + " to: " + obj.to + " rat: " + obj.rat + " desc: " + obj.desc;
				trace("[info] "+ lab.text );
			}
			
			var toAngle:int 	= rotObj.toAngle;	
			
			rotObj.toAngle 		= _to <= 1 ? 0 : ( _to - 1 ) * 20;	
			rotObj.angle 		= int( rotObj.angle % 360 );
			
			TweenMax.killAll();
			toAngle = 360 * TurntableConst.rotCnt + rotObj.toAngle ;
			TweenLite.to( rotObj , TurntableConst.costTime , { angle:toAngle , onUpdate:addSpeed , onComplete:endTurn , ease:Sine.easeOut } );
		}
		
		//加速旋转
		private function addSpeed():void {
			
			var rot:Number = deg2rad( Number( rotObj.angle ) );
			//trace("rot: " + rot);
			backImg.rotation = rot;
		}
		
		private function endTurn():void {
			
			backImg.rotation = deg2rad( Number( rotObj.toAngle ) );
			
			trace("最终为：" +　rotObj.toAngle + " rotation: " + backImg.rotation );
			
			this.addElement( lab );
		}
		
		/**
		 * 暂停
		 */
		public function pause():void {
			
		}
		
		/**
		 * 停止
		 */
		public function stop():void {
				
		}
	}
}