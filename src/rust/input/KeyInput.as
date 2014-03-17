package rust.input {
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import rust.input.events.KeyInputEvent;
	
	public class KeyInput extends EventDispatcher {
		
		private var _target:InteractiveObject;
		
		private var _keyCodeToAction:Dictionary = new Dictionary();
		private var _keyCodeToIsDown:Dictionary = new Dictionary();
		private var _actionToIsDown:Dictionary = new Dictionary();
		
		public function KeyInput(target:InteractiveObject) {
			_target = target;
			_target.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_target.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_target.addEventListener(Event.DEACTIVATE, onDeactivate);
		}
		
		private function onDeactivate(event:Event):void {
			for (var keyCode:* in _keyCodeToIsDown) {
				_keyCodeToIsDown[keyCode] = false;
			}
			for (var action:* in _actionToIsDown) {
				_actionToIsDown[keyCode] = false;
			}
		}
		
		private function onKeyDown(event:KeyboardEvent):void {
			var keyCode:uint = event.keyCode;
			if (keyCode in _keyCodeToAction) {
				var action:String = _keyCodeToAction[keyCode];
				var wasDown:Boolean = _keyCodeToIsDown[keyCode];
				_keyCodeToIsDown[keyCode] = 
				_actionToIsDown[action] = true;
				if (!wasDown && hasEventListener(KeyInputEvent.KEY_DOWN)) {
					dispatchEvent(new KeyInputEvent(KeyInputEvent.KEY_DOWN, action, keyCode));
				}
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void {
			var keyCode:uint = event.keyCode;
			if (keyCode in _keyCodeToAction) {
				var wasDown:Boolean = _keyCodeToIsDown[keyCode];
				if (wasDown) {
					var action:String = _keyCodeToAction[keyCode];
					_keyCodeToIsDown[keyCode] = 
					_actionToIsDown[action] = false;
					if (hasEventListener(KeyInputEvent.KEY_UP)) {
						dispatchEvent(new KeyInputEvent(KeyInputEvent.KEY_UP, action, event.keyCode));
					}
				}
			}
		}
		
		public function mapKey(action:String, keyCode:uint):void {
			if (keyCode in _keyCodeToAction) {
				throw new ArgumentError("Already mapped for keyCode: " + keyCode);
			}
			_keyCodeToAction[keyCode] = action;
		}
		
		public function isDown(action:String):Boolean {
			return _actionToIsDown[action];
		}
		
	}

}
