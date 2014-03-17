package rust.game {
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import rust.utils.PRNG;
	
	public class RoomData {
		
		private static const LAYOUT_CELL_FLOOR:String 				= "0";
		private static const LAYOUT_CELL_HOLE:String 				= "1";
		private static const LAYOUT_CELL_TERMINAL_1:String 			= "2";
		private static const LAYOUT_CELL_TERMINAL_2:String 			= "3";
		private static const LAYOUT_CELL_POD_1:String 				= "4";
		private static const LAYOUT_CELL_POD_2:String 				= "5";
		private static const LAYOUT_CELL_POD_3:String 				= "6";
		private static const LAYOUT_CELL_AI:String 					= "7";
		private static const LAYOUT_CELL_AI_ACTIVE_AREA:String 		= "8";
		private static const LAYOUT_CELL_HUMAN:String 				= "9";
		private static const LAYOUT_CELL_HUMAN_ACTIVE_AREA:String 	= "A";
		
		private static const LAYOUT_CELL_TO_FLAGS:Object = {
			"0" : GameObjectFlags.TILE_TYPE_FLOOR | GameObjectFlags.TILE_WALKABLE,
			"1" : GameObjectFlags.TILE_TYPE_HOLE,
			"2" : GameObjectFlags.TILE_TYPE_TERMINAL_1,
			"3" : GameObjectFlags.TILE_TYPE_TERMINAL_2,
			"4" : GameObjectFlags.TILE_TYPE_POD_1,
			"5" : GameObjectFlags.TILE_TYPE_POD_2,
			"6" : GameObjectFlags.TILE_TYPE_POD_3,
			"7" : GameObjectFlags.TILE_TYPE_AI,
			"8" : GameObjectFlags.TILE_TYPE_AI_ACTIVE_AREA | GameObjectFlags.TILE_WALKABLE,
			"9" : GameObjectFlags.TILE_TYPE_HUMAN,
			"A" : GameObjectFlags.TILE_TYPE_HUMAN_ACTIVE_AREA | GameObjectFlags.TILE_WALKABLE
		};
		
		private static const TEMP_POINT:Point = new Point();
		
		private var _prng:PRNG = new PRNG();
		private var _tiles:Dictionary = new Dictionary();
		private var _occupiedTiles:Dictionary = new Dictionary();
		private var _width:int;
		private var _height:int;
		private var _doors:uint;
		private var _items:uint;
		private var _aiRoom:Boolean;
		private var _humanRoom:Boolean;
		private var _startX:int;
		private var _startY:int;
		private var _teleportUpX:int = -1;
		private var _teleportUpY:int = -1;
		private var _teleportDownX:int = -1;
		private var _teleportDownY:int = -1;
		private var _robots:Vector.<RobotData> = new Vector.<RobotData>();
		
		public function RoomData(seed:int, doors:uint, items:uint, aiRoom:Boolean, humanRoom:Boolean, robots:Vector.<RobotData>) {
			_humanRoom = humanRoom;
			_aiRoom = aiRoom;
			_robots = robots;
			_doors = doors;
			_items = items;
			_prng.seed = seed;
			
			initTiles();
			
			var startTile:Point = randomUnoccupiedTile;
			_startX = startTile.x;
			_startY = startTile.y;
		}
		
		private function initTiles():void {
			
			var layout:String;
			if (_aiRoom) {
				layout = AI_ROOM_LAYOUT;
			}else if (_humanRoom) {
				layout = HUMAN_ROOM_LAYOUT;
			}else {
				var layoutIndex:int = LAYOUTS.length * + _prng.nextDouble;
				layout = LAYOUTS[layoutIndex];
			}
			
			var centerX:int = MapData.ROOM_WIDTH / 2;
			var centerY:int = MapData.ROOM_HEIGHT / 2;
			
			for (var y:int = 0; y < MapData.ROOM_HEIGHT; y++) {
				for (var x:int = 0; x < MapData.ROOM_WIDTH; x++) {
					if (GameObjectFlags.isFlagSet(_doors, GameObjectFlags.TILE_TYPE_DOOR_WEST) && x == 0 && y == centerY) {
						setTileValue(x, y, GameObjectFlags.TILE_TYPE_DOOR_WEST | GameObjectFlags.TILE_WALKABLE);
					}else if (GameObjectFlags.isFlagSet(_doors, GameObjectFlags.TILE_TYPE_DOOR_EAST) && x == MapData.ROOM_WIDTH - 1 && y == centerY) {
						setTileValue(x, y, GameObjectFlags.TILE_TYPE_DOOR_EAST | GameObjectFlags.TILE_WALKABLE);
					}else if (GameObjectFlags.isFlagSet(_doors, GameObjectFlags.TILE_TYPE_DOOR_NORTH) && x == centerX && y == 0) {
						setTileValue(x, y, GameObjectFlags.TILE_TYPE_DOOR_NORTH | GameObjectFlags.TILE_WALKABLE);
					}else if (GameObjectFlags.isFlagSet(_doors, GameObjectFlags.TILE_TYPE_DOOR_SOUTH) && x == centerX && y == MapData.ROOM_HEIGHT - 1) {
						setTileValue(x, y, GameObjectFlags.TILE_TYPE_DOOR_SOUTH | GameObjectFlags.TILE_WALKABLE);
					}else if (x == 0 || y == 0 || x == MapData.ROOM_WIDTH - 1 || y == MapData.ROOM_HEIGHT - 1) {
						setTileValue(x, y, GameObjectFlags.TILE_TYPE_BLOCK);
					}else {
						var layoutCellType:String = layout.charAt(x + y * MapData.ROOM_WIDTH);
						if (!(layoutCellType in LAYOUT_CELL_TO_FLAGS)) {
							throw new Error("Not supported cell type: " + layoutCellType);
						}
						var flags:uint = LAYOUT_CELL_TO_FLAGS[layoutCellType];
						setTileValue(x, y, flags);
					}
				}
			}
			
			if (GameObjectFlags.isFlagSet(_items, GameObjectFlags.TILE_TYPE_TELEPORT_UP)) {
				var upCoords:Point = addRandomUnoccupiedTileValue(GameObjectFlags.TILE_TYPE_TELEPORT_UP | GameObjectFlags.TILE_WALKABLE);
				_teleportUpX = upCoords.x;
				_teleportUpY = upCoords.y;
			}
			if (GameObjectFlags.isFlagSet(_items, GameObjectFlags.TILE_TYPE_TELEPORT_DOWN)) {
				var downCoords:Point = addRandomUnoccupiedTileValue(GameObjectFlags.TILE_TYPE_TELEPORT_DOWN | GameObjectFlags.TILE_WALKABLE);
				_teleportDownX = downCoords.x;
				_teleportDownY = downCoords.y;
			}
			if (GameObjectFlags.isFlagSet(_items, GameObjectFlags.TILE_TYPE_POWER_SUPPLY)) {
				addRandomUnoccupiedTileValue(GameObjectFlags.TILE_TYPE_POWER_SUPPLY | GameObjectFlags.TILE_WALKABLE);
			}
		}
		
		private function addRandomUnoccupiedTileValue(value:uint):Point {
			var tile:Point = randomUnoccupiedTile;
			var x:int = tile.x;
			var y:int = tile.y;
			setTileOccupied(x, y);
			setTileValue(x, y, value);
			return tile;
		}
		
		private function setTileValue(x:int, y:int, value:uint):void {
			var uid:uint = x | y << 4;
			_tiles[uid] = value;
		}
		
		private function get randomUnoccupiedTile():Point {
			while (true) {
				var x:int = _prng.nextDouble * (MapData.ROOM_WIDTH - 4) + 2;
				var y:int = _prng.nextDouble * (MapData.ROOM_HEIGHT - 4) + 2;
				if (!getTileOccupied(x, y)) {
					TEMP_POINT.x = x;
					TEMP_POINT.y = y;
					break;
				}
			}
			return TEMP_POINT;
		}
		
		private function getTileOccupied(x:int, y:int):Boolean {
			var uid:uint = x | y << 4;
			var value:uint = _tiles[uid];
			if (GameObjectFlags.isFlagSet(value, GameObjectFlags.TILE_TYPE_FLOOR | GameObjectFlags.TILE_WALKABLE)) {
				return false;
			}
			return !(uid in _occupiedTiles);
		}
		
		private function setTileOccupied(x:int, y:int):void {
			var uid:uint = x | y << 4;
			_occupiedTiles[uid] = true;
		}
		
		public function getTileValue(x:int, y:int):uint {
			var uid:uint = x | y << 4;
			return _tiles[uid];
		}
		
		public function get robots():Vector.<RobotData> {
			return _robots;
		}
		
		public function get doors():uint {
			return _doors;
		}
		
		public function get items():uint {
			return _items;
		}
		
		public function get startX():int {
			return _startX;
		}
		
		public function get startY():int {
			return _startY;
		}
		
		public function get teleportUpX():int {
			return _teleportUpX;
		}
		
		public function get teleportUpY():int {
			return _teleportUpY;
		}
		
		public function get teleportDownX():int {
			return _teleportDownX;
		}
		
		public function get teleportDownY():int {
			return _teleportDownY;
		}
		
		private static const LAYOUTS:Vector.<String> = Vector.<String>([
		// layout #0
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000",
		// layout #1
		"0000000000000" +
		"0000000000000" +
		"0011100011100" +
		"0010000000100" +
		"0011100011100" +
		"0000000000000" +
		"0000100010000" +
		"0000000000000" +
		"0011100011100" +
		"0010000000100" +
		"0011100011100" +
		"0000000000000" +
		"0000000000000",
		// layout #2
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0001110111000" +
		"0001000001000" +
		"0001000001000" +
		"0000001000000" +
		"0001000001000" +
		"0001000001000" +
		"0001110111000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000",
		// layout #3
		"0000000000000" +
		"0000000000000" +
		"0001110111000" +
		"0000000000000" +
		"0001100011000" +
		"0000001000000" +
		"0000000000000" +
		"0000001000000" +
		"0001100011000" +
		"0000000000000" +
		"0001110111000" +
		"0000000000000" +
		"0000000000000",
		// layout #4
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000111110000" +
		"0000100010000" +
		"0000100010000" +
		"0000000000000" +
		"0000100010000" +
		"0000100010000" +
		"0000111110000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000",
		// layout #5
		"0000000000000" +
		"0000000000000" +
		"0001000001000" +
		"0000000000000" +
		"0000100010000" +
		"0000000000000" +
		"0001111111000" +
		"0000000000000" +
		"0000100010000" +
		"0000000000000" +
		"0001000001000" +
		"0000000000000" +
		"0000000000000",
		// layout #6
		"0000000000000" +
		"0000000000000" +
		"0011000001100" +
		"0010000000100" +
		"0000000000000" +
		"0000010100000" +
		"0000010100000" +
		"0000010100000" +
		"0000000000000" +
		"0010000000100" +
		"0011000001100" +
		"0000000000000" +
		"0000000000000",
		// layout #7
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0001100011000" +
		"0001100011000" +
		"0000001000000" +
		"0000011100000" +
		"0000001000000" +
		"0001100011000" +
		"0001100011000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000",
		// layout #8
		"0000000000000" +
		"0000000000000" +
		"0011100011100" +
		"0010000000100" +
		"0010001000100" +
		"0000000000000" +
		"0000100010000" +
		"0000000000000" +
		"0010001000100" +
		"0010000000100" +
		"0011100011100" +
		"0000000000000" +
		"0000000000000",
		// layout #9
		"0000000000000" +
		"0000000000000" +
		"0000010100000" +
		"0000110110000" +
		"0001000001000" +
		"0011000001100" +
		"0000000000000" +
		"0011000001100" +
		"0001000001000" +
		"0000110110000" +
		"0000010100000" +
		"0000000000000" +
		"0000000000000",
		// layout #10
		"0000000000000" +
		"0000000000000" +
		"0001000001000" +
		"0000100010000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000100010000" +
		"0001000001000" +
		"0000000000000" +
		"0000000000000",
		// layout #11
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000001000000" +
		"0000011100000" +
		"0000001000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000",
		// layout #12
		"0000000000000" +
		"0000000000000" +
		"0000010100000" +
		"0001000001000" +
		"0001000001000" +
		"0001000001000" +
		"0000001000000" +
		"0001000001000" +
		"0001000001000" +
		"0001000001000" +
		"0000010100000" +
		"0000000000000" +
		"0000000000000",
		// layout #13
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0001010101000" +
		"0000000000000" +
		"0001010101000" +
		"0000000000000" +
		"0001010101000" +
		"0000000000000" +
		"0001010101000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000",
		]);
		
		private static const AI_ROOM_LAYOUT:String =
		"0000000000000" +
		"0033330333330" +
		"0200000000000" +
		"0200000000000" +
		"0200000000000" +
		"0200088800000" +
		"0000087800000" +
		"0200088800000" +
		"0200000000000" +
		"0200000000000" +
		"0200000000000" +
		"0200000000000" +
		"0000000000000";
		
		private static const HUMAN_ROOM_LAYOUT:String =
		"0000000000000" +
		"06A9A00333330" +
		"05AAA00000000" +
		"0400000000000" +
		"0200000000000" +
		"0000000000000" +
		"0000000000000" +
		"0000000000000" +
		"0200000000000" +
		"0600000000000" +
		"0500000000000" +
		"0400000000000" +
		"0000000000000";
		
	}

}
