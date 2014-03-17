package rust.save {
	
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	public class LocalStorage {
		
		public static const SO_NAME:String = "me.virtualtoy.rust";
		public static const SAVE_SLOT_0:String = "save_slot_0";
		
		private static var _so:SharedObject;
		private static var _data:Dictionary = new Dictionary();
		
		public static function getData(name:String):Object {
			try {
				_data[name] = so.data[name];
			}catch (error:Error) { }
			return _data[name];
		}
		
		public static function setData(name:String, value:Object):void {
			_data[name] = value;
			try {
				so.data[name] = value;
				so.flush();
			}catch (error:Error) { }
		}
		
		private static function get so():SharedObject {
			if (!_so) {
				_so = SharedObject.getLocal(SO_NAME);
			}
			return _so;
		}
		
	}

}
