package rust.game.robots {
	
	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import rust.core.Globals;
	import rust.game.Room;
	
	public class Enemy extends Robot {
		
		public static const MIN_WANDER_DIRECTION_CHANGE_CHANCE:Number = 0.1;
		public static const MAX_WANDER_DIRECTION_CHANGE_CHANCE:Number = 0.3;
		
		protected var _directionX:int = 0;
		protected var _directionY:int = 0;
		
		private var _item:uint;
		private var _uid:uint;
		private var _armor:Number;
		
		public function Enemy(uid:uint, x:Number, y:Number, armor:Number, item:uint, room:Room, frameIds:Vector.<String>) {
			_uid = uid;
			_armor = armor;
			_item = item;
			super(x, y, room, frameIds);
			if (Math.random() < 0.5) {
				_directionX = Math.random() < 0.5 ? -1 : 1;
			}else {
				_directionY = Math.random() < 0.5 ? -1 : 1;
			}
		}
		
		public function startMove():void {
			throw new IllegalOperationError("Override required");
		}
		
		override public function get health():Number {
			return Globals.userProfile.getEnemyHealth(_uid);
		}
		
		public override function set health(value:Number):void {
			Globals.userProfile.setEnemyHealth(_uid, value);
		}
		
		override public function get armor():Number {
			return _armor;
		}
		
		protected function startMoveWander():void {
			if (canMove(x + _directionX, y + _directionY)) {
				var directionChangeChance:Number = 	room.player.attacked ?
													MAX_WANDER_DIRECTION_CHANGE_CHANCE:
													MIN_WANDER_DIRECTION_CHANGE_CHANCE;
				if (Math.random() < directionChangeChance) {
					if (Math.random() < 0.5) {
						_directionX = Math.random() < 0.5 ? -1 : 1;
						_directionY = 0;
					}else {
						_directionX = 0;
						_directionY = Math.random() < 0.5 ? -1 : 1;
					}
					if (canMove(x + _directionX, y + _directionY)) {
						doStartMove(_directionX, _directionY);
					}
				}else {
					doStartMove(_directionX, _directionY);
				}
			}else {
				if (Math.random() < 0.5) {
					if (_directionX == 0) {
						_directionX = Math.random() < 0.5 ? -1 : 1;
						_directionY = 0;
					}else {
						_directionX = 0;
						_directionY = Math.random() < 0.5 ? -1 : 1;
					}
				}else {
					_directionX = -_directionX;
					_directionY = -_directionY;
				}
				if (canMove(x + _directionX, y + _directionY)) {
					doStartMove(_directionX, _directionY);
				}
			}
		}
		
		protected function startMoveFollowPlayer():void {
			var dx:Number = room.player.x - x;
			var dy:Number = room.player.y - y;
			if (dx > dy) {
				_directionX = dx == 0 ? 0 : dx > 0 ? 1 : -1;
				_directionY = dx != 0 ? 0 : (dy == 0 ? 0 : dy > 0 ? 1 : -1);
				if (canMove(x + _directionX, y + _directionY)) {
					doStartMove(_directionX, _directionY);
				}else {
					_directionY = dy == 0 ? 0 : dy > 0 ? 1 : -1;
					_directionX = dy != 0 ? 0 : (dx == 0 ? 0 : dx > 0 ? 1 : -1);
					if (canMove(x + _directionX, y + _directionY)) {
						doStartMove(_directionX, _directionY);
					}
				}
			}else {
				_directionY = dy == 0 ? 0 : dy > 0 ? 1 : -1;
				_directionX = dy != 0 ? 0 : (dx == 0 ? 0 : dx > 0 ? 1 : -1);
				if (canMove(x + _directionX, y + _directionY)) {
					doStartMove(_directionX, _directionY);
				}else {
					_directionX = dx == 0 ? 0 : dx > 0 ? 1 : -1;
					_directionY = dx != 0 ? 0 : (dy == 0 ? 0 : dy > 0 ? 1 : -1);
					if (canMove(x + _directionX, y + _directionY)) {
						doStartMove(_directionX, _directionY);
					}
				}
			}
		}
		
		protected function get distToPlayer():Number {
			var dx:Number = room.player.x - x;
			var dy:Number = room.player.y - y;
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		protected function get canAttackPlayer():Boolean {
			var dx:Number = room.player.x + room.player.directionX - x;
			var dy:Number = room.player.y + room.player.directionY - y;
			return (Math.abs(dx) == 1 && dy == 0) || (Math.abs(dy) == 1 && dx == 0);
		}
		
		public function get item():uint {
			return _item;
		}
		
		protected function attackPlayer(health:Number):void {
			var dx:Number = room.player.x - room.player.directionX - x;
			var dy:Number = room.player.y - room.player.directionY - y;
			setFrame(dx, dy);
			room.attackPlayer(health);
		}
		
		protected override function canMove(x:Number, y:Number):Boolean {
			var superCanMove:Boolean = super.canMove(x, y);
			if (!superCanMove) {
				return false;
			}
			
			var result:Boolean = true;
			room.iterateRobots(
				function iterateRobotsCallback(robot:Robot):void {
					if ((x == robot.x && y == robot.y) ||
						(x == robot.x + robot.directionX && y == robot.y + robot.directionY)) {
						result = false;
					}
				}
			);
			
			return result;
		}
		
	}

}
