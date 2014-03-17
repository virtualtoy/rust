package rust.game {
	
	public class GameObjectFlags {
		
		public static const TILE_WALKABLE:uint 					= 1;
		public static const TILE_UNEXPLORED:uint 				= 2 << 0;
		
		public static const TILE_TYPE_HOLE:uint 				= 2 << 2;
		public static const TILE_TYPE_FLOOR:uint 				= 2 << 3;
		public static const TILE_TYPE_DOOR_NORTH:uint 			= 2 << 4;
		public static const TILE_TYPE_DOOR_SOUTH:uint 			= 2 << 5;
		public static const TILE_TYPE_DOOR_WEST:uint 			= 2 << 6;
		public static const TILE_TYPE_DOOR_EAST:uint 			= 2 << 7;
		public static const TILE_TYPE_TELEPORT_UP:uint 			= 2 << 8;
		public static const TILE_TYPE_TELEPORT_DOWN:uint		= 2 << 9;
		public static const TILE_TYPE_DEBRIS:uint				= 2 << 10;
		public static const TILE_TYPE_POWER_SUPPLY:uint			= 2 << 11;
		public static const TILE_TYPE_BLOCK:uint 				= 2 << 12;
		public static const TILE_TYPE_TERMINAL_1:uint 			= 2 << 13;
		public static const TILE_TYPE_TERMINAL_2:uint 			= 2 << 14;
		public static const TILE_TYPE_POD_1:uint 				= 2 << 15;
		public static const TILE_TYPE_POD_2:uint 				= 2 << 16;
		public static const TILE_TYPE_POD_3:uint 				= 2 << 17;
		public static const TILE_TYPE_AI:uint 					= 2 << 18;
		public static const TILE_TYPE_AI_ACTIVE_AREA:uint 		= 2 << 19;
		public static const TILE_TYPE_HUMAN:uint 				= 2 << 20;
		public static const TILE_TYPE_HUMAN_ACTIVE_AREA:uint	= 2 << 21;
		
		public static const ITEM_TYPE_MEMORY_BANK:uint			= 2 << 22;
		public static const ITEM_TYPE_TELEPORT_ADAPTER:uint		= 2 << 23;
		public static const ITEM_TYPE_DEVICE_DETECTOR:uint 		= 2 << 24;
		public static const ITEM_TYPE_MANIPULATOR:uint	 		= 2 << 25;
		public static const ITEM_TYPE_STEEL_DRILL:uint	 		= 2 << 26;
		public static const ITEM_TYPE_CARBIDE_CUTTER:uint 		= 2 << 27;
		public static const ITEM_TYPE_LASER_CUTTER:uint 		= 2 << 28;
		
		public static const ROBOT_TYPE_JANITOR:uint 			= 1;
		public static const ROBOT_TYPE_UTILITY:uint 			= 2 << 0;
		public static const ROBOT_TYPE_REPAIR:uint	 			= 2 << 1;
		public static const ROBOT_TYPE_SECURITY:uint 			= 2 << 2;
		public static const ROBOT_TYPE_MILITARY:uint 			= 2 << 3;
		
		public static const TILE_DOORS_MASK:uint 				= 	TILE_TYPE_DOOR_NORTH |
																	TILE_TYPE_DOOR_SOUTH |
																	TILE_TYPE_DOOR_WEST |
																	TILE_TYPE_DOOR_EAST;
																	
		public static const TILE_TYPE_MASK:uint 				=	TILE_TYPE_HOLE |
																	TILE_TYPE_FLOOR |
																	TILE_TYPE_DOOR_NORTH |
																	TILE_TYPE_DOOR_SOUTH |
																	TILE_TYPE_DOOR_WEST |
																	TILE_TYPE_DOOR_EAST |
																	TILE_TYPE_TELEPORT_UP |
																	TILE_TYPE_TELEPORT_DOWN |
																	TILE_TYPE_DEBRIS |
																	TILE_TYPE_POWER_SUPPLY |
																	TILE_TYPE_BLOCK |
																	TILE_TYPE_TERMINAL_1 |
																	TILE_TYPE_TERMINAL_2 |
																	TILE_TYPE_POD_1 |
																	TILE_TYPE_POD_2 |
																	TILE_TYPE_POD_3 |
																	TILE_TYPE_AI |
																	TILE_TYPE_AI_ACTIVE_AREA |
																	TILE_TYPE_HUMAN |
																	TILE_TYPE_HUMAN_ACTIVE_AREA;
																	
		public static const ITEM_TYPES:Vector.<uint> = Vector.<uint>([
			ITEM_TYPE_MEMORY_BANK,
			ITEM_TYPE_TELEPORT_ADAPTER,
			ITEM_TYPE_DEVICE_DETECTOR,
			ITEM_TYPE_MANIPULATOR,
			ITEM_TYPE_STEEL_DRILL,
			ITEM_TYPE_CARBIDE_CUTTER,
			ITEM_TYPE_LASER_CUTTER
		]);
		
		public static function isFlagSet(value:uint, mask:uint):Boolean {
			return (value & mask) == mask;
		}
		
	}

}
