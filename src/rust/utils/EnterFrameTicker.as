package rust.utils {
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;
	import rust.core.IUpdatable;

	public class EnterFrameTicker {
		
		private static var _maxFrameTime:Number = 1000.0 / 60.0;
		
		private static var _ticker:Shape = new Shape();
		private static var _prevTimer:int = 0;
		private static var _dTime:Number = 0;
		private static var _numListeners:int = 0;
		private static var _listeners:Vector.<IUpdatable> = new Vector.<IUpdatable>();
		
		public static function addListener(listener:IUpdatable):void {
			if (_listeners.indexOf(listener) == -1) {
				_numListeners = _listeners.push(listener);
				if (_numListeners == 1) {
					_ticker.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}
		}
		
		public static function removeListener(listener:IUpdatable):void {
			var index:int = _listeners.indexOf(listener);
			if (index != -1) {
				_listeners[index] = null;
			}
		}
		
		public static function get dTime():Number {
			return _dTime;
		}
		
		private static function onEnterFrame(event:Event):void {
			_dTime = calculateDTime();
			for (var i:int = 0; i < _numListeners; i++) {
				var listener:IUpdatable = _listeners[i];
				if (listener) {
					listener.update();
				}else {
					_listeners.splice(i--, 1);
					if (--_numListeners == 0) {
						_ticker.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					}
				}
			}
		}
		
		private static function calculateDTime():Number {
			var timer:int = getTimer();
			
			if (_prevTimer == 0) {
				_prevTimer = timer;
				return 0;
			}
			
			var dt:Number = timer - _prevTimer;
			_prevTimer = timer;
			
			return dt > _maxFrameTime ? _maxFrameTime : dt;
		}
		
	}
	
}
