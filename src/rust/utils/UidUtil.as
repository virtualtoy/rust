package rust.utils {
	
	public class UidUtil {
		
		public static function getRobotUid(roomX:int, roomY:int, floorNum:int, index:int):uint {
			return (roomX | roomY << 4 | floorNum << 8 | index << 12);
		}
		
		public static function getRoomUid(roomX:int, roomY:int, floorNum:int):uint {
			return (roomX | roomY << 4 | floorNum << 8);
		}
		
		public static function getTileUid(x:int, y:int, roomX:int, roomY:int, floorNum:int):uint {
			return (x | y << 4 | roomX << 8 | roomY << 12 | floorNum << 16);
		}
		
	}

}
