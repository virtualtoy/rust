package rust.core {
	
	import flash.ui.Keyboard;
	import rust.Application;
	import rust.input.KeyInput;
	import rust.save.UserProfile;
	
	public class Globals {
		
		private static var _application:Application;
		private static var _userProfile:UserProfile;
		private static var _keyInput:KeyInput;
		
		rust_ns static function init(value:Application):void {
			_application = value;
			
			_userProfile = new UserProfile();
			
			_keyInput = new KeyInput(_application.stage);
			_keyInput.mapKey(KeyInputAction.LEFT, Keyboard.LEFT);
			_keyInput.mapKey(KeyInputAction.LEFT, Keyboard.A);
			_keyInput.mapKey(KeyInputAction.RIGHT, Keyboard.RIGHT);
			_keyInput.mapKey(KeyInputAction.RIGHT, Keyboard.D);
			_keyInput.mapKey(KeyInputAction.UP, Keyboard.UP);
			_keyInput.mapKey(KeyInputAction.UP, Keyboard.W);
			_keyInput.mapKey(KeyInputAction.DOWN, Keyboard.DOWN);
			_keyInput.mapKey(KeyInputAction.DOWN, Keyboard.S);
			_keyInput.mapKey(KeyInputAction.ACTION, Keyboard.SPACE);
			_keyInput.mapKey(KeyInputAction.INTERFACE, Keyboard.ENTER);
			_keyInput.mapKey(KeyInputAction.EXIT, Keyboard.ESCAPE);
		}
		
		public static function get application():Application {
			return _application;
		}
		
		public static function get keyInput():KeyInput {
			return _keyInput;
		}
		
		public static function get userProfile():UserProfile {
			return _userProfile;
		}
		
	}

}
