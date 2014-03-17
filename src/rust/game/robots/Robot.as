package rust.game.robots {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.errors.IllegalOperationError;
	import rust.assets.Assets;
	import rust.game.GameObject;
	import rust.game.GameObjectFlags;
	import rust.game.MapData;
	import rust.game.Room;
	
	public class Robot extends GameObject {
		
		public static const OFFSET_X:Number = 0;
		public static const OFFSET_Y:Number = -62;
		
		private var _view:Bitmap = new Bitmap(null, PixelSnapping.NEVER, false);
		private var _frames:Vector.<BitmapData> = new Vector.<BitmapData>();
		private var _startMoveX:Number;
		private var _startMoveY:Number;
		private var _directionX:int;
		private var _directionY:int;
		private var _room:Room;
		
		public function Robot(x:Number, y:Number, room:Room, frameIds:Vector.<String>) {
			super(_view, 1, OFFSET_X, OFFSET_Y);
			_room = room;
			for (var i:int = 0; i < frameIds.length; i++) {
				_frames.push(Assets.getAsset(frameIds[i]));
			}
			setFrame(0, 0);
			move(x, y, false);
		}
		
		protected function doStartMove(directionX:int, directionY:int):void {
			_directionX = directionX;
			_directionY = directionY;
			_startMoveX = x;
			_startMoveY = y;
			setFrame(directionX, directionY);
		}
		
		protected function setFrame(directionX:int, directionY:int):void {
			var frameNum:int = 0;
			if (directionX == 1) {
				frameNum = 0;
			}else if (directionX == -1) {
				frameNum = 2;
			}else if (directionY == 1) {
				frameNum = 1;
			}else if (directionY == -1) {
				frameNum = 3;
			}
			_view.bitmapData = _frames[frameNum];
		}
		
		protected function canMove(x:Number, y:Number):Boolean {
			if (x < 0 || x >= MapData.ROOM_WIDTH || y < 0 || y >= MapData.ROOM_HEIGHT) {
				return false;
			}
			var tileValue:uint = _room.getTileValue(x, y);
			return GameObjectFlags.isFlagSet(tileValue, GameObjectFlags.TILE_WALKABLE);
		}
		
		protected function getTileValue(x:Number, y:Number):uint {
			return _room.getTileValue(x, y);
		}
		
		public function updateMove(moveProgress:Number):void {
			if (_directionX != 0 || _directionY != 0) {
				var moveX:Number = _startMoveX + _directionX * (1 - moveProgress);
				var moveY:Number = _startMoveY + _directionY * (1 - moveProgress);
				move(moveX, moveY);
			}
		}
		
		public function endMove():void {
			_directionX =
			_directionY = 0;
		}
		
		public function get room():Room {
			return _room;
		}
		
		public function get directionX():int {
			return _directionX;
		}
		
		public function get directionY():int {
			return _directionY;
		}
		
		public function get health():Number {
			throw new IllegalOperationError("Override required");
		}
		
		public function set health(value:Number):void {
			throw new IllegalOperationError("Override required");
		}
		
		public function get armor():Number {
			throw new IllegalOperationError("Override required");
		}
		
	}
	
}
