package rust.game {
	
	public class RobotData {
		
		private var _uid:uint;
		private var _type:uint;
		private var _item:uint;
		
		public function RobotData(uid:uint, type:uint, item:uint) {
			_uid = uid;
			_type = type;
			_item = item;
		}
		
		public function get uid():uint {
			return _uid;
		}
		
		public function get type():uint {
			return _type;
		}
		
		public function get item():uint {
			return _item;
		}
		
	}

}
