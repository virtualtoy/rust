package rust.save {
	
	import flash.utils.Dictionary;
	import rust.game.GameObjectFlags;
	import rust.game.MapData;
	import rust.utils.PRNG;
	import rust.utils.UidUtil;
	
	public class UserProfile {
		
		public static const DEFAULT_POWER_SUPPLY_AMOUNT:Number = 1.2;
		
		private var _enemyUidToHealth:Object = { };
		private var _debrisUidToDebris:Object = { };
		private var _roomUidToVisited:Object = { };
		private var _powerSupplyUidToAmount:Object = { };
		private var _mapSeed:int;
		private var _playerX:int;
		private var _playerY:int;
		private var _playerMapX:int;
		private var _playerMapY:int;
		private var _playerFloorNum:int;
		private var _playerItems:uint;
		private var _fixedMemoryBanksNum:int;
		private var _memoryBankEncrypted:Boolean;
		private var _playerHealth:Number;
		
		private var _finalChoiceOption:int;
		
		public function UserProfile() {
			setDefaults();
		}
		
		public function setDefaults():void {
			_enemyUidToHealth = { };
			_debrisUidToDebris = { };
			_roomUidToVisited = { };
			_powerSupplyUidToAmount = { };
			_mapSeed = Math.random() * PRNG.MAX_SEED;
			_playerMapX = -1;
			_playerMapY = -1;
			_playerX = -1;
			_playerY = -1;
			_playerFloorNum = -1;
			_playerItems = 0;
			_playerHealth = 1;
			_memoryBankEncrypted = true;
			_fixedMemoryBanksNum = 1;
		}
		
		public function load(data:Object):void {
			_enemyUidToHealth = copyObject(data["_enemyUidToHealth"]);
			_debrisUidToDebris = copyObject(data["_debrisUidToDebris"]);
			_roomUidToVisited = copyObject(data["_roomUidToVisited"]);
			_powerSupplyUidToAmount = copyObject(data["_powerSupplyUidToAmount"]);
			
			_mapSeed = data["_mapSeed"];
			_playerX = data["_playerX"];
			_playerY = data["_playerY"];
			_playerMapX = data["_playerMapX"];
			_playerMapY = data["_playerMapY"];
			_playerFloorNum = data["_playerFloorNum"];
			_playerItems = data["_playerItems"];
			_fixedMemoryBanksNum = data["_fixedMemoryBanksNum"];
			_memoryBankEncrypted = data["_memoryBankEncrypted"];
			_playerHealth = data["_playerHealth"];
			_finalChoiceOption = data["_finalChoiceOption"];
		}
		
		public function save():Object {
			var data:Object = { };
			data["_enemyUidToHealth"] = copyObject(_enemyUidToHealth);
			data["_debrisUidToDebris"] = copyObject(_debrisUidToDebris);
			data["_roomUidToVisited"] = copyObject(_roomUidToVisited);
			data["_powerSupplyUidToAmount"] = copyObject(_powerSupplyUidToAmount);
			
			data["_mapSeed"] = _mapSeed;
			data["_playerX"] = _playerX;
			data["_playerY"] = _playerY;
			data["_playerMapX"] = _playerMapX;
			data["_playerMapY"] = _playerMapY;
			data["_playerFloorNum"] = _playerFloorNum;
			data["_playerItems"] = _playerItems;
			data["_fixedMemoryBanksNum"] = _fixedMemoryBanksNum;
			data["_memoryBankEncrypted"] = _memoryBankEncrypted;
			data["_playerHealth"] = _playerHealth;
			data["_finalChoiceOption"] = _finalChoiceOption;
			return data;
		}
		
		private static function copyObject(object:Object):Object {
			var copy:Object = { };
			for (var name:String in object) {
				if (object.hasOwnProperty(name)) {
					copy[name] = object[name];
				}
			}
			return copy;
		}
		
		public function get finalChoiceOption():int {
			return _finalChoiceOption;
		}
		
		public function set finalChoiceOption(value:int):void {
			_finalChoiceOption = value;
		}
		
		public function get mapSeed():int {
			return _mapSeed;
		}
		
		public function get playerX():int {
			return _playerX;
		}
		
		public function set playerX(value:int):void {
			_playerX = value;
		}
		
		public function get playerY():int {
			return _playerY;
		}
		
		public function set playerY(value:int):void {
			_playerY = value;
		}
		
		public function get playerMapX():int {
			return _playerMapX;
		}
		
		public function set playerMapX(value:int):void {
			_playerMapX = value;
		}
		
		public function get playerMapY():int {
			return _playerMapY;
		}
		
		public function set playerMapY(value:int):void {
			_playerMapY = value;
		}
		
		public function get playerFloorNum():int {
			return _playerFloorNum;
		}
		
		public function set playerFloorNum(value:int):void {
			_playerFloorNum = value;
		}
		
		public function get playerItems():uint {
			return _playerItems;
		}
		
		public function set playerItems(value:uint):void {
			_playerItems = value;
		}
		
		public function get playerHealth():Number {
			return _playerHealth;
		}
		
		public function set playerHealth(value:Number):void {
			_playerHealth = value;
			if (_playerHealth < 0) {
				_playerHealth = 0;
			}else if (_playerHealth > 1) {
				_playerHealth = 1;
			}
		}
		
		public function get fixedMemoryBanksNum():int {
			return _fixedMemoryBanksNum;
		}
		
		public function set fixedMemoryBanksNum(value:int):void {
			_fixedMemoryBanksNum = value;
		}
		
		public function get memoryBankEncrypted():Boolean {
			return _memoryBankEncrypted;
		}
		
		public function set memoryBankEncrypted(value:Boolean):void {
			_memoryBankEncrypted = value;
		}
		
		public function getEnemyHealth(uid:uint):Number {
			return uid in _enemyUidToHealth ? _enemyUidToHealth[uid] : 1;
		}
		
		public function setEnemyHealth(uid:uint, health:Number):void {
			if (health < 0) {
				health = 0;
			}else if (health > 1) {
				health = 1;
			}
			_enemyUidToHealth[uid] = health;
		}
		
		public function getRoomVisited(roomX:int, roomY:int, floorNum:int):Boolean {
			var uid:uint = UidUtil.getRoomUid(roomX, roomY, floorNum);
			return _roomUidToVisited[uid];
		}
		
		public function setRoomVisited(roomX:int, roomY:int, floorNum:int):Boolean {
			var uid:uint = UidUtil.getRoomUid(roomX, roomY, floorNum);
			return _roomUidToVisited[uid] = true;
		}
		
		public function setCurrentRoomVisited():void {
			setRoomVisited(_playerMapX, _playerMapY, _playerFloorNum);
		}
		
		public function getDebrisInCurrentRoom(x:int, y:int):uint {
			var uid:uint = UidUtil.getTileUid(x, y, _playerMapX, _playerMapY, _playerFloorNum);
			return uid in _debrisUidToDebris ? _debrisUidToDebris[uid] : 0;
		}
		
		public function setDebrisInCurrentRoom(x:int, y:int, value:uint):void {
			var uid:uint = UidUtil.getTileUid(x, y, _playerMapX, _playerMapY, _playerFloorNum);
			_debrisUidToDebris[uid] = value;
		}
		
		public function getPowerSupplyAmountInCurrentRoom(x:int, y:int):Number {
			var uid:uint = UidUtil.getTileUid(x, y, _playerMapX, _playerMapY, _playerFloorNum);
			return uid in _powerSupplyUidToAmount ? _powerSupplyUidToAmount[uid] : DEFAULT_POWER_SUPPLY_AMOUNT;
		}
		
		public function setPowerSupplyAmountInCurrentRoom(x:int, y:int, amount:Number):void {
			var uid:uint = UidUtil.getTileUid(x, y, _playerMapX, _playerMapY, _playerFloorNum);
			_powerSupplyUidToAmount[uid] = amount;
		}
		
	}

}
