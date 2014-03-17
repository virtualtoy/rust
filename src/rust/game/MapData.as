package rust.game {
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import rust.utils.PRNG;
	import rust.utils.UidUtil;
	
	public class MapData {
		
		private static const TEMP_POINT:Point = new Point();
		
		public static const NUM_FLOORS:int = 5;
		public static const MAP_WIDTH:int = 5;
		public static const MAP_HEIGHT:int = 5;
		public static const ROOM_WIDTH:int = 13;
		public static const ROOM_HEIGHT:int = 13;
		public static const MAX_ROBOTS_PER_ROOM:int = 4;
		public static const START_FLOOR_NUM:int = 0;
		public static const DISABLED_DETECTOR_FLOOR_NUM:int = 2;
		
		private static const FLOOR_ITEMS:Vector.<Vector.<uint>> = Vector.<Vector.<uint>>([
			Vector.<uint>([GameObjectFlags.ITEM_TYPE_TELEPORT_ADAPTER, GameObjectFlags.ITEM_TYPE_DEVICE_DETECTOR]),
			Vector.<uint>([GameObjectFlags.ITEM_TYPE_STEEL_DRILL]),
			Vector.<uint>([GameObjectFlags.ITEM_TYPE_MEMORY_BANK]),
			Vector.<uint>([GameObjectFlags.ITEM_TYPE_CARBIDE_CUTTER]),
			Vector.<uint>([GameObjectFlags.ITEM_TYPE_MEMORY_BANK, GameObjectFlags.ITEM_TYPE_LASER_CUTTER]),
		]);
		
		private static const FLOOR_POWER_SUPPLIES_NUM:Vector.<int> = Vector.<int>([
			2, 2, 1, 1, 1
		]);
		
		private static const FLOOR_JANITOR_ROBOTS_NUM:Vector.<int> = Vector.<int>([
			10, 10, 20, 20, 20
		]);
		private static const FLOOR_UTILITY_ROBOTS_NUM:Vector.<int> = Vector.<int>([
			7, 10, 20, 15, 15
		]);
		private static const FLOOR_REPAIR_ROBOTS_NUM:Vector.<int> = Vector.<int>([
			5, 5, 5, 5, 5
		]);
		private static const FLOOR_SECURITY_ROBOTS_NUM:Vector.<int> = Vector.<int>([
			2, 5, 7, 10, 12
		]);
		private static const FLOOR_MILITARY_ROBOTS_NUM:Vector.<int> = Vector.<int>([
			0, 1, 3, 5, 5
		]);
		
		private var _prng:PRNG = new PRNG();
		private var _uidToRoomDef:Dictionary = new Dictionary();
		private var _uidToRoomData:Dictionary = new Dictionary();
		private var _floorNumToTeleportUpMapCoords:Vector.<Point> = new Vector.<Point>(NUM_FLOORS);
		private var _floorNumToTeleportDownMapCoords:Vector.<Point> = new Vector.<Point>(NUM_FLOORS);
		private var _startMapX:int;
		private var _startMapY:int;
		private var _startX:int;
		private var _startY:int;
		private var _aiMapX:int;
		private var _aiMapY:int;
		private var _humanMapX:int;
		private var _humanMapY:int;
		
		public function MapData(seed:int) {
			_prng.seed = seed;
			init();
		}
		
		private function init():void {
			
			_startMapX = _prng.nextDouble * MAP_WIDTH;
			_startMapY = _prng.nextDouble * MAP_HEIGHT;
			
			_aiMapX = _prng.nextDouble * MAP_WIDTH;
			_aiMapY = _prng.nextDouble * MAP_HEIGHT;
			
			do {
				_humanMapX = _prng.nextDouble * MAP_WIDTH;
				_humanMapY = _prng.nextDouble * MAP_HEIGHT;
			}while (_humanMapX == _aiMapX && _humanMapY == _aiMapY);
			
			for (var f:int = 0; f < NUM_FLOORS; f++) {
				addFloor(f, initMazeCells(_prng));
			}
			
			var startRoomData:RoomData = getRoomData(_startMapX, _startMapY, 0);
			_startX = startRoomData.startX;
			_startY = startRoomData.startY;
		}
		
		private function addFloor(floorNum:int, cells:Vector.<uint>):void {
			
			var usedItemCoords:Vector.<Point> = new Vector.<Point>();
			
			var teleportUpMapX:int = -1;
			var teleportUpMapY:int = -1;
			var teleportDownMapX:int = -1;
			var teleportDownMapY:int = -1;
			
			if (floorNum == 0) {
				teleportUpMapX = _prng.nextDouble * MAP_WIDTH;
				teleportUpMapY = _prng.nextDouble * MAP_HEIGHT;
			}else if (floorNum == NUM_FLOORS - 1) {
				teleportDownMapX = _prng.nextDouble * MAP_WIDTH;
				teleportDownMapY = _prng.nextDouble * MAP_HEIGHT;
			}else {
				teleportUpMapX = _prng.nextDouble * MAP_WIDTH;
				teleportUpMapY = _prng.nextDouble * MAP_HEIGHT;
				do {
					teleportDownMapX = _prng.nextDouble * MAP_WIDTH;
					teleportDownMapY = _prng.nextDouble * MAP_HEIGHT;
				}while (teleportDownMapX == teleportUpMapX && teleportDownMapY == teleportUpMapY);
			}
			
			if (teleportUpMapX != -1 && teleportUpMapY != -1) {
				usedItemCoords.push(new Point(teleportUpMapX, teleportUpMapY));
				_floorNumToTeleportUpMapCoords[floorNum] = new Point(teleportUpMapX, teleportUpMapY);
			}
			if (teleportDownMapX != -1 && teleportDownMapY != -1) {
				usedItemCoords.push(new Point(teleportDownMapX, teleportDownMapY));
				_floorNumToTeleportDownMapCoords[floorNum] = new Point(teleportDownMapX, teleportDownMapY);
			}
			
			var powerSupplyCoords:Vector.<Point> = new Vector.<Point>();
			var numPowerSupplies:int = FLOOR_POWER_SUPPLIES_NUM[floorNum];
			for (var i:int = 0; i < numPowerSupplies; i++) {
				while (true) {
					var powerSupplyX:int = _prng.nextDouble * MAP_WIDTH;
					var powerSupplyY:int = _prng.nextDouble * MAP_HEIGHT;
					var validCoords:Boolean = true;
					for (var j:int = 0; j < usedItemCoords.length; j++) {
						if (powerSupplyX == usedItemCoords[j].x && powerSupplyY == usedItemCoords[j].y) {
							validCoords = false;
							break;
						}
					}
					if (validCoords) {
						var coords:Point = new Point(powerSupplyX, powerSupplyY);
						powerSupplyCoords.push(coords);
						usedItemCoords.push(coords);
						break;
					}
				}
			}
			
			var availableItems:Vector.<uint> = FLOOR_ITEMS[floorNum].slice();
			
			var availableJanitorRobotsNum:int = FLOOR_JANITOR_ROBOTS_NUM[floorNum];
			var availableUtilityRobotsNum:int = FLOOR_UTILITY_ROBOTS_NUM[floorNum];
			var availableRepairRobotsNum:int = FLOOR_REPAIR_ROBOTS_NUM[floorNum];
			var availableSecurityRobotsNum:int = FLOOR_SECURITY_ROBOTS_NUM[floorNum];
			var availableMilitaryRobotsNum:int = FLOOR_MILITARY_ROBOTS_NUM[floorNum];
			
			var availableRobotTypes:Vector.<uint> = new Vector.<uint>();
			appendToVector(availableRobotTypes, GameObjectFlags.ROBOT_TYPE_JANITOR, availableJanitorRobotsNum);
			appendToVector(availableRobotTypes, GameObjectFlags.ROBOT_TYPE_UTILITY, availableUtilityRobotsNum);
			appendToVector(availableRobotTypes, GameObjectFlags.ROBOT_TYPE_REPAIR, availableRepairRobotsNum);
			appendToVector(availableRobotTypes, GameObjectFlags.ROBOT_TYPE_SECURITY, availableSecurityRobotsNum);
			appendToVector(availableRobotTypes, GameObjectFlags.ROBOT_TYPE_MILITARY, availableMilitaryRobotsNum);
			
			var robotCells:Vector.<Vector.<RobotData>> = new Vector.<Vector.<RobotData>>(MAP_WIDTH * MAP_HEIGHT);
			while (availableRobotTypes.length) {
				var robotMapX:int = _prng.nextDouble * MAP_WIDTH;
				var robotMapY:int = _prng.nextDouble * MAP_HEIGHT;
				var noRobotsInRoom:Boolean = (floorNum == START_FLOOR_NUM && robotMapX == _startMapX && robotMapY == _startMapY) ||
				(floorNum == NUM_FLOORS - 1 && ((robotMapX == _aiMapX && robotMapY == _aiMapY) || (robotMapX == _humanMapX && robotMapY == _humanMapY)));
				if (!noRobotsInRoom) {
					var robotsInCell:Vector.<RobotData> = robotCells[robotMapY * MAP_WIDTH + robotMapX];
					if (!robotsInCell) {
						robotsInCell = robotCells[robotMapY * MAP_WIDTH + robotMapX] = new Vector.<RobotData>();
					}
					if (robotsInCell.length < MAX_ROBOTS_PER_ROOM) {
						var randRobotIndex:int = _prng.nextDouble * availableRobotTypes.length;
						var robotUid:uint = UidUtil.getRobotUid(robotMapX, robotMapY, floorNum, availableRobotTypes.length);
						var robotType:uint = availableRobotTypes.splice(randRobotIndex, 1)[0];
						var robotItem:uint = 0;
						if (availableItems.length) {
							var randItemIndex:int = _prng.nextDouble * availableItems.length;
							robotItem = availableItems.splice(randItemIndex, 1)[0];
						}
						robotsInCell.push(new RobotData(robotUid, robotType, robotItem));
					}
				}
			}
			
			for (var y:int = 0; y < MAP_HEIGHT; y++) {
				for (var x:int = 0; x < MAP_WIDTH; x++) {
					var seed:int = _prng.nextInt;
					var doors:uint = cells[y * MAP_WIDTH + x] & GameObjectFlags.TILE_DOORS_MASK;
					var roomItems:uint = 0;
					if (x == teleportUpMapX && y == teleportUpMapY) {
						roomItems |= GameObjectFlags.TILE_TYPE_TELEPORT_UP;
					}else if (x == teleportDownMapX && y == teleportDownMapY) {
						roomItems |= GameObjectFlags.TILE_TYPE_TELEPORT_DOWN;
					}
					for (var k:int = 0; k < powerSupplyCoords.length; k++) {
						if (x == powerSupplyCoords[k].x && y == powerSupplyCoords[k].y) {
							roomItems |= GameObjectFlags.TILE_TYPE_POWER_SUPPLY;
							break;
						}
					}
					var robots:Vector.<RobotData> = robotCells[y * MAP_WIDTH + x];
					var uid:uint = UidUtil.getRoomUid(x, y, floorNum);
					var aiRoom:Boolean = floorNum == NUM_FLOORS - 1 && x == _aiMapX && y == _aiMapY;
					var humanRoom:Boolean = floorNum == NUM_FLOORS - 1 && x == _humanMapX && y == _humanMapY;
					_uidToRoomDef[uid] = new RoomDef(seed, doors, roomItems, aiRoom, humanRoom, robots);
				}
			}
			
		}
		
		private static function appendToVector(vector:Vector.<uint>, item:uint, numItems:int):void {
			for (var i:int = 0; i < numItems; i++) {
				vector[vector.length] = item;
			}
		}
		
		public function getRoomData(roomX:int, roomY:int, floorNum:int):RoomData {
			var uid:uint = UidUtil.getRoomUid(roomX, roomY, floorNum);
			var roomData:RoomData = _uidToRoomData[uid];
			if (!roomData) {
				var def:RoomDef = _uidToRoomDef[uid];
				roomData = _uidToRoomData[uid] = new RoomData(def.seed, def.doors, def.items, def.aiRoom, def.humanRoom, def.robots.slice());
			}
			return roomData;
		}
		
		public function getTeleportMapCoords(floorNum:int, direction:int):Point {
			var mapCoords:Point = direction > 0 ? 	_floorNumToTeleportUpMapCoords[floorNum] :
													_floorNumToTeleportDownMapCoords[floorNum];
			if (mapCoords) {
				TEMP_POINT.x = mapCoords.x;
				TEMP_POINT.y = mapCoords.y;
			}
			return TEMP_POINT;
		}
		
		public function get startFloorNum():int {
			return START_FLOOR_NUM;
		}
		
		public function get startMapX():int {
			return _startMapX;
		}
		
		public function get startMapY():int {
			return _startMapY;
		}
		
		public function get startX():int {
			return _startX;
		}
		
		public function get startY():int {
			return _startY;
		}
		
		/**
		 * Maze generation algorythm is taken from:
		 * http://weblog.jamisbuck.org/2011/1/10/maze-generation-prim-s-algorithm
		 */
		private static const CELL_MARKED:int = 2 << 29;
		private static const CELL_FRONTIER:int = 2 << 30;
		private static const neighbors:Vector.<Point> = new Vector.<Point>();
		
		private static function initMazeCells(prng:PRNG):Vector.<uint> {
			var cells:Vector.<uint> = new Vector.<uint>(MAP_WIDTH * MAP_HEIGHT);
			
			var frontier:Vector.<Point> = new Vector.<Point>();
			for (var y:int = 0; y < MAP_HEIGHT; y++) {
				for (var x:int = 0; x < MAP_WIDTH; x++) {
					cells[y * MAP_WIDTH + x] = 0;
				}
			}
			
			var randX:int = prng.nextDouble * MAP_WIDTH;
			var randY:int = prng.nextDouble * MAP_HEIGHT;
			
			markCell(randX, randY, cells, frontier);
			
			while (frontier.length) {
				var randCell:Point = frontier.splice(int(prng.nextDouble * frontier.length), 1)[0];
				var randNeighbor:Point = getRandomNeighbor(randCell.x, randCell.y, cells, prng);
				var direction:uint = getDirection(randCell.x, randCell.y, randNeighbor.x, randNeighbor.y);
				cells[randCell.y * MAP_WIDTH + randCell.x] |= direction;
				cells[randNeighbor.y * MAP_WIDTH + randNeighbor.x] |= getOppositeDirection(direction);
				markCell(randCell.x, randCell.y, cells, frontier);
			}
			
			return cells;
		}
		
		private static function addFrontier(x:int, y:int, cells:Vector.<uint>, frontier:Vector.<Point>):void {
			if (x >= 0 && x < MAP_WIDTH && y >= 0 && y < MAP_HEIGHT && cells[y * MAP_WIDTH + x] == 0) {
				cells[y * MAP_WIDTH + x] |= CELL_FRONTIER;
				frontier.push(new Point(x, y));
			}
		}
		
		private static function markCell(x:int, y:int, cells:Vector.<uint>, frontier:Vector.<Point>):void {
			cells[y * MAP_WIDTH + x] |= CELL_MARKED;
			addFrontier(x - 1, y, cells, frontier);
			addFrontier(x + 1, y, cells, frontier);
			addFrontier(x, y - 1, cells, frontier);
			addFrontier(x, y + 1, cells, frontier);
		}
		
		private static function getRandomNeighbor(x:int, y:int, cells:Vector.<uint>, prng:PRNG):Point {
			neighbors.length = 0;
			if (x > 0 && (cells[y * MAP_WIDTH + x - 1] & CELL_MARKED) != 0) {
				neighbors.push(new Point(x - 1, y));
			}
			if (x + 1 < MAP_WIDTH && (cells[y * MAP_WIDTH + x + 1] & CELL_MARKED) != 0) {
				neighbors.push(new Point(x + 1, y));
			}
			if (y > 0 && (cells[(y - 1) * MAP_WIDTH + x] & CELL_MARKED) != 0) {
				neighbors.push(new Point(x, y - 1));
			}
			if (y + 1 < MAP_HEIGHT && (cells[(y + 1) * MAP_WIDTH + x] & CELL_MARKED) != 0) {
				neighbors.push(new Point(x, y + 1));
			}
			return neighbors[int(prng.nextDouble * neighbors.length)];
		}
		
		private static function getDirection(fx:int, fy:int, tx:int, ty:int):uint {
			if (fx < tx) {
				return GameObjectFlags.TILE_TYPE_DOOR_EAST;
			}else if (fx > tx) {
				return GameObjectFlags.TILE_TYPE_DOOR_WEST;
			}else if (fy < ty) {
				return GameObjectFlags.TILE_TYPE_DOOR_SOUTH;
			}
			return GameObjectFlags.TILE_TYPE_DOOR_NORTH;
		}
		
		private static function getOppositeDirection(direction:uint):uint {
			if (direction == GameObjectFlags.TILE_TYPE_DOOR_WEST) {
				return GameObjectFlags.TILE_TYPE_DOOR_EAST;
			}else if (direction == GameObjectFlags.TILE_TYPE_DOOR_EAST) {
				return GameObjectFlags.TILE_TYPE_DOOR_WEST;
			}else if (direction == GameObjectFlags.TILE_TYPE_DOOR_NORTH) {
				return GameObjectFlags.TILE_TYPE_DOOR_SOUTH;
			}
			return GameObjectFlags.TILE_TYPE_DOOR_NORTH;
		}
		
	}

}

import rust.game.RobotData;

internal class RoomDef {
	
	public var seed:int;
	public var doors:uint;
	public var items:uint;
	public var aiRoom:Boolean;
	public var humanRoom:Boolean;
	public var robots:Vector.<RobotData>;
	
	public function RoomDef(seed:int, doors:uint, items:uint, aiRoom:Boolean, humanRoom:Boolean, robots:Vector.<RobotData>) {
		this.seed = seed;
		this.doors = doors;
		this.items = items;
		this.aiRoom = aiRoom;
		this.humanRoom = humanRoom;
		this.robots = robots || new Vector.<RobotData>();
	}
	
}
