package rust.game {
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import rust.assets.Assets;
	import rust.core.Globals;
	import rust.core.IDisposable;
	import rust.core.IUpdatable;
	import rust.core.KeyInputAction;
	import rust.game.effects.TextEffect;
	import rust.game.effects.VisualEffect;
	import rust.game.robots.Enemy;
	import rust.game.robots.EnemyJanitor;
	import rust.game.robots.EnemyMilitary;
	import rust.game.robots.EnemyRepair;
	import rust.game.robots.EnemySecurity;
	import rust.game.robots.EnemyUtility;
	import rust.game.robots.Player;
	import rust.game.ui.FinalChoicePopup;
	import rust.game.ui.GameUI;
	import rust.game.ui.PlayerUI;
	import rust.input.events.KeyInputEvent;
	import rust.save.UserProfile;
	import rust.ui.Button;
	import rust.ui.InfoPopup;
	import rust.ui.Popup;
	
	public class Room implements IUpdatable, IDisposable {
		
		public static const MOVE_PROGRESS_STEP:Number = 0.20;
		
		public static const ROOM_CONTAINER_OFFSET_X:Number = 370;
		public static const ROOM_CONTAINER_OFFSET_Y:Number = 120;
		
		private static const RANDOM_DEVICE_NAMES:Vector.<String> = Vector.<String>([
			"Z80 CPU", "4004 CPU", "8080 CPU", "MC68000 CPU", "Sonic Screwdriver", "Mielophone", "Quazatron", "Proton Pack"
		]);
		
		private var _view:Sprite = new Sprite();
		private var _roomBackground:Bitmap = new Bitmap();
		private var _roomContainer:Sprite = new Sprite();
		private var _effectsContainer:Sprite = new Sprite();
		private var _gameUI:GameUI = new GameUI();
		private var _depthList:SortedDepthList = new SortedDepthList();
		
		private var _moveProgress:Number = 0;
		private var _showingPopup:Boolean = false;
		private var _effects:Vector.<VisualEffect> = new Vector.<VisualEffect>();
		private var _enemies:Vector.<Enemy> = new Vector.<Enemy>();
		private var _player:Player;
		private var _roomData:RoomData;
		private var _mapData:MapData;
		
		// accepts no parameters
		public var exitCallback:Function = null;
		// accepts teleport direction
		public var teleportCallback:Function = null;
		
		public function Room(roomData:RoomData, mapData:MapData) {
			_roomData = roomData;
			_mapData = mapData;
			init();
		}
		
		private function init():void {
			Globals.keyInput.addEventListener(KeyInputEvent.KEY_DOWN, onKeyDown);
			
			var userProfile:UserProfile = Globals.userProfile;
			userProfile.setCurrentRoomVisited();
			
			_roomBackground.bitmapData = Assets.getAsset("images/game_background.png");
			_view.addChild(_roomBackground);
			
			_roomContainer.x = ROOM_CONTAINER_OFFSET_X;
			_roomContainer.y = ROOM_CONTAINER_OFFSET_Y;
			_view.addChild(_roomContainer);
			_view.addChild(_effectsContainer);
			
			_gameUI.addEventListener(Button.EVENT_CLICK, onUIButtonClick);
			_view.addChild(_gameUI);
			_roomContainer.mouseEnabled =
			_effectsContainer.mouseEnabled = false;
			
			initTiles();
			initRobots();
			
			updatePlayerHealth();
			
			if (GameObjectFlags.isFlagSet(userProfile.playerItems, GameObjectFlags.ITEM_TYPE_DEVICE_DETECTOR)) {
				if (userProfile.playerFloorNum == MapData.DISABLED_DETECTOR_FLOOR_NUM) {
					_gameUI.showDeviceDetectorUnavailable();
				}else if (enemiesHaveItem) {
					_gameUI.showDeviceDetected();
				}
			}
		}
		
		private function onUIButtonClick(event:Event):void {
			if (event.target.name == "menuButton") {
				showPlayerUI();
			}
		}
		
		private function get enemiesHaveItem():Boolean {
			for each (var enemy:Enemy in _enemies) {
				if (enemy.item != 0) {
					return true;
				}
			}
			return false;
		}
		
		private function initRobots():void {
			
			_player = new Player(Globals.userProfile.playerX, Globals.userProfile.playerY, this);
			_player.depthChangedCallback = onDepthChange;
			var index:int = _depthList.addDepth(_player.depth);
			_roomContainer.addChildAt(_player.view, index);
			
			var uidToRobotOccupiedTile:Dictionary = new Dictionary();
			for each (var robotData:RobotData in _roomData.robots) {
				if (Globals.userProfile.getEnemyHealth(robotData.uid) > 0) {
					addEnemy(robotData, uidToRobotOccupiedTile);
				}
			}
		}
		
		private function addEnemy(robotData:RobotData, uidToRobotOccupiedTile:Dictionary):void {
			var enemyX:int;
			var enemyY:int;
			
			while (true) {
				enemyX = Math.random() * (MapData.ROOM_WIDTH - 4) + 2;
				enemyY = Math.random() * (MapData.ROOM_HEIGHT - 4) + 2;
				var tileValue:uint = _roomData.getTileValue(enemyX, enemyY);
				if (GameObjectFlags.isFlagSet(tileValue, GameObjectFlags.TILE_TYPE_FLOOR | GameObjectFlags.TILE_WALKABLE)) {
					if (Math.abs(enemyX - _player.x) >= 2 || Math.abs(enemyY - _player.y) >= 2) {
						var tileUid:uint = enemyX | enemyY << 4;
						if (!(tileUid in uidToRobotOccupiedTile)) {
							uidToRobotOccupiedTile[tileUid] = true;
							break;
						}
					}
				}
			}
			
			var enemy:Enemy = createEnemy(robotData, enemyX, enemyY);
			_enemies.push(enemy);
			enemy.depthChangedCallback = onDepthChange;
			var index:int = _depthList.addDepth(enemy.depth);
			_roomContainer.addChildAt(enemy.view, index);
		}
		
		private function createEnemy(data:RobotData, x:int, y:int):Enemy {
			switch (data.type) {
				case GameObjectFlags.ROBOT_TYPE_JANITOR:
					return new EnemyJanitor(data.uid, x, y, data.item, this);
				case GameObjectFlags.ROBOT_TYPE_UTILITY:
					return new EnemyUtility(data.uid, x, y, data.item, this);
				case GameObjectFlags.ROBOT_TYPE_REPAIR:
					return new EnemyRepair(data.uid, x, y, data.item, this);
				case GameObjectFlags.ROBOT_TYPE_SECURITY:
					return new EnemySecurity(data.uid, x, y, data.item, this);
				case GameObjectFlags.ROBOT_TYPE_MILITARY:
					return new EnemyMilitary(data.uid, x, y, data.item, this);
			}
			throw new ArgumentError("Type is invalid: " + data.type);
		}
		
		private function initTiles():void {
			var userProfile:UserProfile = Globals.userProfile;
			for (var y:int = 0; y < MapData.ROOM_HEIGHT; y++) {
				for (var x:int = 0; x < MapData.ROOM_WIDTH; x++) {
					addTile(x, y, _roomData.getTileValue(x, y));
					var debris:uint = userProfile.getDebrisInCurrentRoom(x, y);
					if (debris != 0) {
						addTile(x, y, debris);
					}
				}
			}
		}
		
		private function addTile(x:Number, y:Number, tileValue:int):void {
			var tile:Tile = new Tile(x, y, tileValue);
			var index:int = _depthList.addDepth(tile.depth);
			_roomContainer.addChildAt(tile.view, index);
			if (tile.requiresFloorTile) {
				addTile(x, y, GameObjectFlags.TILE_TYPE_FLOOR);
			}
		}
		
		private function onDepthChange(gameObject:GameObject, oldDepth:int, newDepth:int):void {
			_depthList.removeDepth(oldDepth);
			var index:int = _depthList.addDepth(newDepth);
			_roomContainer.setChildIndex(gameObject.view, index);
		}
		
		private function onKeyDown(event:KeyInputEvent):void {
			if (_moveProgress != 0 || _showingPopup) {
				return;
			}
			switch (event.action) {
				case KeyInputAction.ACTION:
					performAction();
					break;
				case KeyInputAction.INTERFACE:
					showPlayerUI();
					break;
			}
		}
		
		private function showPlayerUI():void {
			_showingPopup = true;
			var popup:PlayerUI = new PlayerUI(_mapData);
			popup.closeCallback = onPopupClosed;
			_view.addChild(popup);
		}
		
		private function showInfoPopup(text:String):void {
			_showingPopup = true;
			var popup:InfoPopup = new InfoPopup(text);
			popup.closeCallback = onPopupClosed;
			_view.addChild(popup);
		}
		
		private function onPopupClosed(popup:Popup):void {
			_showingPopup = false;
		}
		
		private function showFinalChoicePopup():void {
			_showingPopup = true;
			var popup:FinalChoicePopup = new FinalChoicePopup();
			popup.closeCallback = onFinalChoicePopupClosed;
			_view.addChild(popup);
		}
		
		private function onFinalChoicePopupClosed(popup:FinalChoicePopup):void {
			_showingPopup = false;
			switch (popup.option) {
				case FinalChoicePopup.OPTION_0:
					endGame(0);
					break;
				case FinalChoicePopup.OPTION_1:
					endGame(1);
					break;
				case FinalChoicePopup.OPTION_2:
					endGame(2);
					break;
			}
		}
		
		private function endGame(finalChoiceOption:int):void {
			Globals.userProfile.finalChoiceOption = finalChoiceOption;
			Globals.application.openEndScene();
		}
		
		private function performAction():void {
			var playerX:int = _player.x;
			var playerY:int = _player.y;
			var exploreDebrisResult:Boolean = exploreDebris(playerX, playerY);
			if (!exploreDebrisResult) {
				var tileValue:uint = getTileValue(playerX, playerY);
				if (GameObjectFlags.isFlagSet(tileValue, GameObjectFlags.TILE_TYPE_TELEPORT_UP)) {
					performTeleport(1);
				}else if (GameObjectFlags.isFlagSet(tileValue, GameObjectFlags.TILE_TYPE_TELEPORT_DOWN)) {
					performTeleport( -1);
				}else if (GameObjectFlags.isFlagSet(tileValue, GameObjectFlags.TILE_TYPE_AI_ACTIVE_AREA)) {
					if (Globals.userProfile.memoryBankEncrypted) {
						showInfoPopup("PAL 2014 welcomes you.\nPlease enter access code.\nIf you know it.\nHa.");
					}else {
						showFinalChoicePopup();
					}
				}else if (GameObjectFlags.isFlagSet(tileValue, GameObjectFlags.TILE_TYPE_HUMAN_ACTIVE_AREA)) {
					if (Globals.userProfile.memoryBankEncrypted) {
						showInfoPopup("Hey, tin-head! I'm hurt and can't leave this room. Access to escape pods is blocked. You must initiate the evacuation sequence. Wait a second... Looks like one of your memory banks is encrypted, I'll try to crack it. I hope you've got something useful in that rusty bucket of yours!");
						Globals.userProfile.memoryBankEncrypted = false;
					}else {
						showInfoPopup("Hurry up, tin-head! Go and unlock access to escape pods!");
					}
				}else if (_player.health < 1 && GameObjectFlags.isFlagSet(tileValue, GameObjectFlags.TILE_TYPE_POWER_SUPPLY)) {
					var powerAmount:Number = Globals.userProfile.getPowerSupplyAmountInCurrentRoom(playerX, playerY);
					if (powerAmount < 0.0001) {
						showInfoPopup("Charge operation failed.\nReason: Power Supply is out of energy.");
						return;
					}else {
						var powerAmountToAdd:Number = Math.min(1 - _player.health, powerAmount);
						Globals.userProfile.setPowerSupplyAmountInCurrentRoom(playerX, playerY, powerAmount - powerAmountToAdd);
						addTextEffectForView("+" + Math.floor(powerAmountToAdd * 1000) / 10 + "%", _player.view);
						_player.health += powerAmountToAdd;
						updatePlayerHealth();
					}
				}
			}
		}
		
		private function updatePlayerHealth():void {
			_gameUI.setPlayerHealth(Globals.userProfile.playerHealth);
		}
		
		private function performTeleport(direction:int):void {
			if (GameObjectFlags.isFlagSet(Globals.userProfile.playerItems, GameObjectFlags.ITEM_TYPE_TELEPORT_ADAPTER)) {
				teleportCallback(direction);
			}else {
				showInfoPopup("Teleport operation failed.\nReason: Teleport Adapter is not present.");
			}
		}
		
		private function exploreDebris(x:int, y:int):Boolean {
			var debrisValue:uint = Globals.userProfile.getDebrisInCurrentRoom(x, y);
			var itemFound:Boolean = false;
			var foundItemNames:String = "";
			
			for (var i:int = 0; i < GameObjectFlags.ITEM_TYPES.length; i++) {
				var type:uint = GameObjectFlags.ITEM_TYPES[i];
				if (GameObjectFlags.isFlagSet(debrisValue, type)) {
					Globals.userProfile.playerItems |= type;
					Globals.userProfile.setDebrisInCurrentRoom(x, y, debrisValue ^ type);
					itemFound = true;
					foundItemNames += ItemName.getName(type) + "\n";
				}
			}
			
			if (GameObjectFlags.isFlagSet(debrisValue, GameObjectFlags.ITEM_TYPE_MEMORY_BANK)) {
				Globals.userProfile.fixedMemoryBanksNum++;
			}
			
			if (itemFound) {
				showInfoPopup("Identification operation result.\nFunctional device found and equipped:\n" + foundItemNames);
				return true;
			}else if (GameObjectFlags.isFlagSet(debrisValue, GameObjectFlags.TILE_UNEXPLORED)) {
				var randomDeviceName:String = RANDOM_DEVICE_NAMES[int(Math.random() * RANDOM_DEVICE_NAMES.length)];
				showInfoPopup("Identification operation result.\nFunctional devices found but discarded due to required ports missing:\n" + randomDeviceName);
				Globals.userProfile.setDebrisInCurrentRoom(x, y, debrisValue ^ GameObjectFlags.TILE_UNEXPLORED);
				return true;
			}
			
			return false;
		}
		
		public function getTileValue(x:Number, y:Number):uint {
			return _roomData.getTileValue(Math.round(x), Math.round(y));
		}
		
		public function get view():DisplayObject {
			return _view;
		}
		
		public function get player():Player {
			return _player;
		}
		
		public function update():void {
			if (_showingPopup) {
				return;
			}
			
			for (var i:int = _effects.length - 1; i >= 0; i--) {
				var effect:VisualEffect = _effects[i];
				effect.update();
				if (effect.completed) {
					_effects.splice(i, 1);
					effect.parent.removeChild(effect);
				}
			}
			
			if (_moveProgress == 0) {
				startMove();
			}else {
				updateMove();
			}
		}
		
		public function getEnemyAt(x:Number, y:Number):Enemy {
			for each (var enemy:Enemy in _enemies) {
				if (enemy.x == x && enemy.y == y) {
					return enemy;
				}
			}
			return null;
		}
		
		public function iterateRobots(callback:Function):void {
			callback(_player);
			for each (var enemy:Enemy in _enemies) {
				callback(enemy);
			}
		}
		
		public function attackEnemy(enemy:Enemy, health:Number):void {
			addTextEffectForView("-" + Math.floor(health * enemy.armor * 1000) / 10 + "%", enemy.view);
			enemy.health -= health * enemy.armor;
			if (enemy.health == 0) {
				
				_enemies.splice(_enemies.indexOf(enemy), 1);
				_depthList.removeDepth(enemy.depth);
				_roomContainer.removeChild(enemy.view);
				enemy.dispose();
				
				var enemyX:int = enemy.x;
				var enemyY:int = enemy.y;
				
				addTile(enemyX, enemyY, GameObjectFlags.TILE_TYPE_DEBRIS);
				
				var prevDebrisValue:uint = Globals.userProfile.getDebrisInCurrentRoom(enemyX, enemyY);
				var debrisValue:uint = prevDebrisValue | GameObjectFlags.TILE_TYPE_DEBRIS | GameObjectFlags.TILE_UNEXPLORED | enemy.item;
				Globals.userProfile.setDebrisInCurrentRoom(enemyX, enemyY, debrisValue);
			}
		}
		
		public function attackPlayer(health:Number):void {
			addTextEffectForView("-" + Math.floor(health * 1000) / 10 + "%", _player.view);
			_player.health -= health * _player.armor;
			updatePlayerHealth();
			if (_player.health == 0) {
				_showingPopup = true;
				var popup:InfoPopup = new InfoPopup("R3-U3 is terminated. Future of Habitat \"Argo\" is unknown.");
				popup.closeCallback = onMissionFailedPopupClosed;
				_view.addChild(popup);
			}
		}
		
		private function onMissionFailedPopupClosed(popup:Popup):void {
			Globals.application.openMainMenu();
		}
		
		private function addTextEffectForView(text:String, view:DisplayObject):void {
			var effect:TextEffect = new TextEffect(text);
			var bounds:Rectangle = view.getBounds(view.stage);
			var pt:Point = new Point(bounds.x + bounds.width * 0.5, bounds.y + bounds.height * 0.5);
			pt = _effectsContainer.globalToLocal(pt);
			effect.x = pt.x;
			effect.y = pt.y;
			_effectsContainer.addChild(effect);
			_effects.push(effect);
		}
		
		private function startMove():void {
			var directionX:int = 	int(Globals.keyInput.isDown(KeyInputAction.RIGHT)) -
									int(Globals.keyInput.isDown(KeyInputAction.LEFT));
			var directionY:int = 	int(Globals.keyInput.isDown(KeyInputAction.DOWN)) -
									int(Globals.keyInput.isDown(KeyInputAction.UP));
			
			if (directionX != 0 || directionY != 0) {
				var moveResult:int = _player.startMove(directionX, directionX == 0 ? directionY : 0);
				switch (moveResult) {
					case Player.RESULT_MOVED:
						{
							for each (var enemy:Enemy in _enemies) {
								enemy.startMove();
							}
							_moveProgress = 1;
						}
						break;
					case Player.RESULT_EXIT_ROOM_WEST:
						enterRoom(-1, 0);
						break;
					case Player.RESULT_EXIT_ROOM_EAST:
						enterRoom(1, 0);
						break;
					case Player.RESULT_EXIT_ROOM_NORTH:
						enterRoom(0, -1);
						break;
					case Player.RESULT_EXIT_ROOM_SOUTH:
						enterRoom(0, 1);
						break;
				}
			}
		}
		
		private function updateMove():void {
			_moveProgress -= MOVE_PROGRESS_STEP;
			if (_moveProgress < 0) {
				_moveProgress = 0;
			}
			_player.updateMove(_moveProgress);
			for each (var enemy:Enemy in _enemies) {
				enemy.updateMove(_moveProgress);
			}
			
			if (_moveProgress == 0) {
				endMove();
			}
		}
		
		private function endMove():void {
			Globals.userProfile.playerX = _player.x;
			Globals.userProfile.playerY = _player.y;
			_player.endMove();
			for each (var enemy:Enemy in _enemies) {
				enemy.endMove();
			}
		}
		
		private function enterRoom(directionX:int, directionY:int):void {
			var userProfile:UserProfile = Globals.userProfile;
			var newMapX:int = userProfile.playerMapX + directionX;
			var newMapY:int = userProfile.playerMapY + directionY;
			
			if (newMapX < 0 || newMapX >= MapData.MAP_WIDTH || newMapY < 0 || newMapY >= MapData.MAP_HEIGHT) {
				return;
			}
			
			userProfile.playerMapX = newMapX;
			userProfile.playerMapY = newMapY;
			
			if (directionX == -1) {
				userProfile.playerX = MapData.ROOM_WIDTH - 1;
			}else if (directionX == 1) {
				userProfile.playerX = 0;
			}
			
			if (directionY == -1) {
				userProfile.playerY = MapData.ROOM_HEIGHT - 1;
			}else if (directionY == 1) {
				userProfile.playerY = 0;
			}
			
			if (exitCallback != null) {
				exitCallback();
			}
		}
		
		public function dispose():void {
			Globals.keyInput.removeEventListener(KeyInputEvent.KEY_DOWN, onKeyDown);
			exitCallback = null;
			teleportCallback = null;
		}
		
	}

}
