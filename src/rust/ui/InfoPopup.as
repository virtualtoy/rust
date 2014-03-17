package rust.ui {
	
	import flash.events.Event;
	import rust.assets.Assets;
	import rust.core.Globals;
	import rust.core.KeyInputAction;
	import rust.input.events.KeyInputEvent;
	
	public class InfoPopup extends Popup {
		
		public function InfoPopup(text:String) {
			init(text);
		}
		
		private function init(text:String):void {
			var control:UIControl = UIControlXMLFactory.create(Assets.getAsset("xml/info_popup.xml"));
			addChild(control);
			var textControl:Text = getControlByName("text") as Text;
			textControl.text = text;
		}
		
		protected override function onButtonClick(event:Event):void {
			event.stopImmediatePropagation();
			var buttonName:String = event.target.name;
			if (buttonName == "infoPopupCloseButton") {
				close();
			}
		}
		
		protected override function onKeyDown(event:KeyInputEvent):void {
			if (event.action == KeyInputAction.INTERFACE ||
				event.action == KeyInputAction.ACTION ||
				event.action == KeyInputAction.EXIT) {
				
				close();
			}
		}
		
	}

}
