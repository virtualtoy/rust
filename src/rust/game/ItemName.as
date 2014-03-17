package rust.game {
	
	import flash.utils.Dictionary;
	
	public class ItemName {
		
		public static const MEMORY_BANK:String 		= "Memory Bank Controller";
		public static const MANIPULATOR:String 		= "Manipulator";
		public static const TELEPORT_ADAPTER:String = "Teleport Adapter";
		public static const DEVICE_DETECTOR:String 	= "Device Detector";
		public static const STEEL_DRILL:String 		= "Steel Drill";
		public static const CARBIDE_CUTTER:String 	= "Carbide Cutter";
		public static const LASER_CUTTER:String 	= "Laser Cutter";
		
		private static var TYPE_TO_NAME:Dictionary;
		
		public static function getName(item:uint):String {
			if (!TYPE_TO_NAME) {
				TYPE_TO_NAME = new Dictionary();
				TYPE_TO_NAME[GameObjectFlags.ITEM_TYPE_MEMORY_BANK] 		= MEMORY_BANK;
				TYPE_TO_NAME[GameObjectFlags.ITEM_TYPE_MANIPULATOR] 		= MANIPULATOR;
				TYPE_TO_NAME[GameObjectFlags.ITEM_TYPE_TELEPORT_ADAPTER] 	= TELEPORT_ADAPTER;
				TYPE_TO_NAME[GameObjectFlags.ITEM_TYPE_DEVICE_DETECTOR] 	= DEVICE_DETECTOR;
				TYPE_TO_NAME[GameObjectFlags.ITEM_TYPE_STEEL_DRILL] 		= STEEL_DRILL;
				TYPE_TO_NAME[GameObjectFlags.ITEM_TYPE_CARBIDE_CUTTER] 		= CARBIDE_CUTTER;
				TYPE_TO_NAME[GameObjectFlags.ITEM_TYPE_LASER_CUTTER] 		= LASER_CUTTER;
			}
			return TYPE_TO_NAME[item];
		}
		
	}

}
