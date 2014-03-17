package rust.game.ui {
	
	import flash.events.Event;
	import rust.assets.Assets;
	import rust.core.Globals;
	import rust.core.KeyInputAction;
	import rust.input.events.KeyInputEvent;
	import rust.ui.Popup;
	import rust.ui.UIControl;
	import rust.ui.UIControlXMLFactory;
	
	public class FinalChoicePopup extends Popup {
		
		public static const OPTION_CANCEL:String = "cancel";
		public static const OPTION_0:String = "option_0";
		public static const OPTION_1:String = "option_1";
		public static const OPTION_2:String = "option_2";
		
		private var _option:String;
		
		public function FinalChoicePopup() {
			init();
		}
		
		private function init():void {
			var control:UIControl = UIControlXMLFactory.create(Assets.getAsset("xml/final_choice_popup.xml"));
			addChild(control);
			var fixedMemoryBanksNum:int = Globals.userProfile.fixedMemoryBanksNum;
			if (fixedMemoryBanksNum < 3) {
				getControlByName("finalChoiceButton_2").visible = false;
			}
			if (fixedMemoryBanksNum < 2) {
				getControlByName("finalChoiceButton_1").visible = false;
			}
		}
		
		protected override function onButtonClick(event:Event):void {
			event.stopImmediatePropagation();
			var buttonName:String = event.target.name;
			switch (buttonName) {
				case "finalChoiceButton_0":
					_option = OPTION_0;
					close();
					break;
				case "finalChoiceButton_1":
					_option = OPTION_1;
					close();
					break;
				case "finalChoiceButton_2":
					_option = OPTION_2;
					close();
					break;
			}
		}
		
		protected override function onKeyDown(event:KeyInputEvent):void {
			if (event.action == KeyInputAction.INTERFACE ||
				event.action == KeyInputAction.ACTION ||
				event.action == KeyInputAction.EXIT) {
				
				_option = OPTION_CANCEL;
				close();
			}
		}
		
		public function get option():String {
			return _option;
		}
		
	}

}
