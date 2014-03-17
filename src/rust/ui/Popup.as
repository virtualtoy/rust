package rust.ui {
	
	import flash.events.Event;
	import rust.core.Globals;
	import rust.input.events.KeyInputEvent;
	
	public class Popup extends UIControl {
		
		// accepts this as parameter
		public var closeCallback:Function;
		
		public function Popup() {
			addEventListener(Button.EVENT_CLICK, onButtonClick);
			Globals.keyInput.addEventListener(KeyInputEvent.KEY_DOWN, onKeyDown);
		}
		
		protected function onButtonClick(event:Event):void {
			
		}
		
		protected function onKeyDown(event:KeyInputEvent):void {
			
		}
		
		public function close():void {
			if (parent) {
				parent.removeChild(this);
			}
			if (closeCallback != null) {
				closeCallback(this);
			}
			Globals.keyInput.removeEventListener(KeyInputEvent.KEY_DOWN, onKeyDown);
		}
		
	}

}
