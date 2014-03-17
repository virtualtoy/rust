package rust.input.events {
	
	import flash.events.Event;
	
	public class KeyInputEvent extends Event {
		
		public static const KEY_DOWN:String = "KeyInputEvent.keyDown";
		public static const KEY_UP:String = "KeyInputEvent.keyUp";
		
		private var _action:String;
		private var _keyCode:uint;
		
		public function KeyInputEvent(type:String, action:String, keyCode:uint) {
			super(type, false, false);
			_action = action;
			_keyCode = keyCode;
		}
		
		public function get action():String { return _action; }
		
		public function get keyCode():uint { return _keyCode; }
		
		override public function clone():Event {
			return new KeyInputEvent(type, action, _keyCode);
		}
		
		override public function toString():String {
			return formatToString("KeyInputEvent", "type", "action", "keyCode");
		}
		
	}
	
}
