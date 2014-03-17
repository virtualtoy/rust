package rust.game.robots {
	
	import rust.core.Globals;
	import rust.game.GameObjectFlags;
	import rust.game.Room;
	
	public class Player extends Robot {
		
		public static const FRAME_IDS:Vector.<String> = Vector.<String>([
			"images/player_1.png",
			"images/player_2.png",
			"images/player_3.png",
			"images/player_4.png",
		]);
		
		public static const ARMOR:Number = 1;
		
		public static const ATTACK_HEALTH_MANIPULATOR:Number 			= 0.5;
		public static const ATTACK_HEALTH_STEEL_DRILL:Number 			= 0.75;
		public static const ATTACK_HEALTH_TYPE_CARBIDE_CUTTER:Number 	= 0.9;
		public static const ATTACK_HEALTH_LASER_CUTTER:Number 			= 1.0;
		
		public static const RESULT_NOT_MOVED:int 			= 0;
		public static const RESULT_MOVED:int 				= 1;
		public static const RESULT_EXIT_ROOM_EAST:int 		= 2 << 0;
		public static const RESULT_EXIT_ROOM_WEST:int 		= 2 << 1;
		public static const RESULT_EXIT_ROOM_NORTH:int 		= 2 << 2;
		public static const RESULT_EXIT_ROOM_SOUTH:int 		= 2 << 3;
		
		private var _attacked:Boolean = false;
		
		public function Player(x:Number, y:Number, room:Room) {
			super(x, y, room, FRAME_IDS);
		}
		
		public function startMove(directionX:int, directionY:int):int {
			var tileValue:uint = getTileValue(x, y);
			if (GameObjectFlags.isFlagSet(tileValue, GameObjectFlags.TILE_TYPE_DOOR_WEST) && directionX == -1) {
				return RESULT_EXIT_ROOM_WEST;
			}else if (GameObjectFlags.isFlagSet(tileValue, GameObjectFlags.TILE_TYPE_DOOR_EAST) && directionX == 1) {
				return RESULT_EXIT_ROOM_EAST;
			}else if (GameObjectFlags.isFlagSet(tileValue, GameObjectFlags.TILE_TYPE_DOOR_NORTH) && directionY == -1) {
				return RESULT_EXIT_ROOM_NORTH;
			}else if (GameObjectFlags.isFlagSet(tileValue, GameObjectFlags.TILE_TYPE_DOOR_SOUTH) && directionY == 1) {
				return RESULT_EXIT_ROOM_SOUTH;
			}
			var enemy:Enemy = getEnemyAtDirection(directionX, directionY);
			if (enemy) {
				_attacked = true;
				setFrame(directionX, directionY);
				room.attackEnemy(enemy, attackHealth);
				return RESULT_MOVED;
			}
			if (canMove(x + directionX, y + directionY)) {
				doStartMove(directionX, directionY);
				return RESULT_MOVED;
			}
			return RESULT_NOT_MOVED;
		}
		
		private function get attackHealth():Number {
			var playerItems:uint = Globals.userProfile.playerItems;
			if (GameObjectFlags.isFlagSet(playerItems, GameObjectFlags.ITEM_TYPE_LASER_CUTTER)) {
				return ATTACK_HEALTH_LASER_CUTTER;
			}
			if (GameObjectFlags.isFlagSet(playerItems, GameObjectFlags.ITEM_TYPE_CARBIDE_CUTTER)) {
				return ATTACK_HEALTH_TYPE_CARBIDE_CUTTER;
			}
			if (GameObjectFlags.isFlagSet(playerItems, GameObjectFlags.ITEM_TYPE_STEEL_DRILL)) {
				return ATTACK_HEALTH_STEEL_DRILL;
			}
			return ATTACK_HEALTH_MANIPULATOR;
		}
		
		private function getEnemyAtDirection(directionX:int, directionY:int):Enemy {
			return room.getEnemyAt(x + directionX, y + directionY);
		}
		
		public function get attacked():Boolean {
			return _attacked;
		}
		
		override public function get health():Number {
			return Globals.userProfile.playerHealth;
		}
		
		public override function set health(value:Number):void {
			Globals.userProfile.playerHealth = value;
		}
		
		override public function get armor():Number {
			return ARMOR;
		}
		
	}

}
