package rust.ui {
	
	import flash.events.Event;
	import rust.assets.Assets;
	import rust.core.KeyInputAction;
	import rust.input.events.KeyInputEvent;
	
	public class PromptPopup extends Popup {
		
		public static const OPTION_OK:String = "ok";
		public static const OPTION_CANCEL:String = "cancel";
		
		private var _option:String;
		
		public function PromptPopup() {
			init();
		}
		
		private function init():void {
			var control:UIControl = UIControlXMLFactory.create(Assets.getAsset("xml/prompt_popup.xml"));
			addChild(control);
		}
		
		protected override function onButtonClick(event:Event):void {
			event.stopImmediatePropagation();
			var buttonName:String = event.target.name;
			if (buttonName == "promptPopupOKButton") {
				_option = OPTION_OK;
				close();
			}else if (buttonName == "promptPopupCancelButton") {
				_option = OPTION_CANCEL;
				close();
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
