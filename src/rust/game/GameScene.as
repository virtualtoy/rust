package rust.game {
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import rust.core.ApplicationScene;
	import rust.core.Globals;
	import rust.save.UserProfile;
	
	public class GameScene extends ApplicationScene {
		
		private var _view:Sprite = new Sprite();
		private var _mapData:MapData;
		private var _room:Room;
		
		public function GameScene() {
			super(_view);
			init();
		}
		
		private function init():void {
			var userProfile:UserProfile = Globals.userProfile;
			_mapData = new MapData(userProfile.mapSeed);
			if (userProfile.playerFloorNum == -1) {
				userProfile.playerFloorNum = _mapData.startFloorNum;
				userProfile.playerMapX = _mapData.startMapX;
				userProfile.playerMapY = _mapData.startMapY;
				userProfile.playerX = _mapData.startX;
				userProfile.playerY = _mapData.startY;
			}
			
			enterCurrentRoom();
		}
		
		private function enterCurrentRoom():void {
			if (_room) {
				_view.removeChild(_room.view);
				_room.dispose();
			}
			
			var userProfile:UserProfile = Globals.userProfile;
			var roomData:RoomData = _mapData.getRoomData(	userProfile.playerMapX,
															userProfile.playerMapY,
															userProfile.playerFloorNum);
			_room = new Room(roomData, _mapData);
			_room.exitCallback = enterCurrentRoom;
			_room.teleportCallback = onTeleport;
			_view.addChild(_room.view);
		}
		
		public override function update():void {
			if (_room) {
				_room.update();
			}
		}
		
		private function onTeleport(direction:int):void {
			var userProfile:UserProfile = Globals.userProfile;
			userProfile.playerFloorNum += direction;
			var teleportMapCoords:Point = _mapData.getTeleportMapCoords(userProfile.playerFloorNum, -direction);
			userProfile.playerMapX = teleportMapCoords.x;
			userProfile.playerMapY = teleportMapCoords.y;
			
			var roomData:RoomData = _mapData.getRoomData(teleportMapCoords.x, teleportMapCoords.y, userProfile.playerFloorNum);
			userProfile.playerX = direction > 0 ? roomData.teleportDownX : roomData.teleportUpX;
			userProfile.playerY = direction > 0 ? roomData.teleportDownY : roomData.teleportUpY;
			
			enterCurrentRoom();
		}
		
	}

}
