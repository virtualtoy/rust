package rust.game.ui {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import rust.assets.Assets;
	import rust.core.Globals;
	import rust.core.KeyInputAction;
	import rust.game.GameObjectFlags;
	import rust.game.ItemName;
	import rust.game.MapData;
	import rust.game.RoomData;
	import rust.input.events.KeyInputEvent;
	import rust.save.LocalStorage;
	import rust.save.UserProfile;
	import rust.ui.InfoPopup;
	import rust.ui.Popup;
	import rust.ui.PromptPopup;
	import rust.ui.Text;
	import rust.ui.UIControl;
	import rust.ui.UIControlXMLFactory;
	
	public class PlayerUI extends Popup {
		
		public function PlayerUI(mapData:MapData) {
			super();
			init(mapData);
		}
		
		private function init(mapData:MapData):void {
			var control:UIControl = UIControlXMLFactory.create(Assets.getAsset("xml/player_ui.xml"));
			addChild(control);
			
			var positionText:String = "Habitat \"Argo\"\nDeck " + (Globals.userProfile.playerFloorNum + 1);
			(getControlByName("positionText") as Text).text = positionText;
			
			var devicesText:String = "Equipment:\n";
			var playerItems:uint = Globals.userProfile.playerItems;
			if (GameObjectFlags.isFlagSet(playerItems, GameObjectFlags.ITEM_TYPE_LASER_CUTTER)) {
				devicesText += ItemName.LASER_CUTTER + "\n";
			}else if (GameObjectFlags.isFlagSet(playerItems, GameObjectFlags.ITEM_TYPE_CARBIDE_CUTTER)) {
				devicesText += ItemName.CARBIDE_CUTTER + "\n";
			}else if (GameObjectFlags.isFlagSet(playerItems, GameObjectFlags.ITEM_TYPE_STEEL_DRILL)) {
				devicesText += ItemName.STEEL_DRILL + "\n";
			}else {
				devicesText += ItemName.MANIPULATOR + "\n";
			}
			
			if (GameObjectFlags.isFlagSet(playerItems, GameObjectFlags.ITEM_TYPE_TELEPORT_ADAPTER)) {
				devicesText += ItemName.TELEPORT_ADAPTER + "\n";
			}
			
			if (GameObjectFlags.isFlagSet(playerItems, GameObjectFlags.ITEM_TYPE_DEVICE_DETECTOR)) {
				devicesText += ItemName.DEVICE_DETECTOR + "\n";
			}
			
			(getControlByName("devicesText") as Text).text = devicesText;
			
			var mapContainer:UIControl = getControlByName("mapContainer");
			mapContainer.mouseEnabled = false;
			var roomPixels:BitmapData = Assets.getAsset("images/map_room.png");
			var corridorHorizontalPixels:BitmapData = Assets.getAsset("images/map_corridor_horizontal.png");
			var corridorVerticalPixels:BitmapData = Assets.getAsset("images/map_corridor_vertical.png");
			
			var userProfile:UserProfile = Globals.userProfile
			
			var floorNum:int = userProfile.playerFloorNum;
			var playerMapX:int = userProfile.playerMapX;
			var playerMapY:int = userProfile.playerMapY;
			const cellWidth:int = 64;
			const cellHeight:int = 64;
			
			var tempBitmap:Bitmap;
			for (var y:int = 0; y < MapData.MAP_HEIGHT; y++) {
				for (var x:int = 0; x < MapData.MAP_WIDTH; x++) {
					if (!userProfile.getRoomVisited(x, y, floorNum)) {
						continue;
					}
					
					var roomData:RoomData = mapData.getRoomData(x, y, floorNum);
					tempBitmap = new Bitmap(roomPixels, PixelSnapping.NEVER, false);
					tempBitmap.x = x * cellWidth;
					tempBitmap.y = y * cellHeight;
					mapContainer.addChildAt(tempBitmap, 0);
					
					var doors:uint = roomData.doors;
					if (GameObjectFlags.isFlagSet(doors, GameObjectFlags.TILE_TYPE_DOOR_NORTH)) {
						tempBitmap = new Bitmap(corridorVerticalPixels, PixelSnapping.NEVER);
						tempBitmap.x = x * cellWidth;
						tempBitmap.y = y * cellHeight;
						mapContainer.addChild(tempBitmap);
					}
					if (GameObjectFlags.isFlagSet(doors, GameObjectFlags.TILE_TYPE_DOOR_SOUTH)) {
						tempBitmap = new Bitmap(corridorVerticalPixels, PixelSnapping.NEVER);
						tempBitmap.x = x * cellWidth;
						tempBitmap.y = (y + 1) * cellHeight - tempBitmap.height;
						mapContainer.addChild(tempBitmap);
					}
					if (GameObjectFlags.isFlagSet(doors, GameObjectFlags.TILE_TYPE_DOOR_WEST)) {
						tempBitmap = new Bitmap(corridorHorizontalPixels, PixelSnapping.NEVER);
						tempBitmap.x = x * cellWidth;
						tempBitmap.y = y * cellHeight;
						mapContainer.addChild(tempBitmap);
					}
					if (GameObjectFlags.isFlagSet(doors, GameObjectFlags.TILE_TYPE_DOOR_EAST)) {
						tempBitmap = new Bitmap(corridorHorizontalPixels, PixelSnapping.NEVER);
						tempBitmap.x = (x + 1) * cellWidth - tempBitmap.width;
						tempBitmap.y = y * cellHeight;
						mapContainer.addChild(tempBitmap);
					}
					
					if (x != playerMapX || y != playerMapY) {
						var roomItemPixels:BitmapData = null;
						var items:uint = roomData.items;
						if (GameObjectFlags.isFlagSet(items, GameObjectFlags.TILE_TYPE_TELEPORT_UP) ||
							GameObjectFlags.isFlagSet(items, GameObjectFlags.TILE_TYPE_TELEPORT_DOWN)) {
							roomItemPixels = Assets.getAsset("images/map_teleport.png");
						}else if (GameObjectFlags.isFlagSet(items, GameObjectFlags.TILE_TYPE_POWER_SUPPLY)) {
							roomItemPixels = Assets.getAsset("images/map_power_supply.png");
						}
						
						if (roomItemPixels) {
							tempBitmap = new Bitmap(roomItemPixels, PixelSnapping.NEVER);
							tempBitmap.x = x * cellWidth;
							tempBitmap.y = y * cellHeight;
							mapContainer.addChild(tempBitmap);
						}
					}
				}
			}
			
			tempBitmap = new Bitmap(Assets.getAsset("images/map_player.png"), PixelSnapping.NEVER);
			tempBitmap.x = playerMapX * cellWidth;
			tempBitmap.y = playerMapY * cellHeight;
			mapContainer.addChild(tempBitmap);
			
		}
		
		protected override function onKeyDown(event:KeyInputEvent):void {
			if (event.action == KeyInputAction.INTERFACE ||
				event.action == KeyInputAction.ACTION ||
				event.action == KeyInputAction.EXIT) {
				
				close();
			}
		}
		
		protected override function onButtonClick(event:Event):void {
			var buttonName:String = event.target.name;
			switch (buttonName) {
				case "memoryBankButton_0":
					showMemoryBank(0);
					break;
				case "memoryBankButton_1":
					showMemoryBank(1);
					break;
				case "memoryBankButton_2":
					showMemoryBank(2);
					break;
				case "memoryBankButton_3":
					showMemoryBank(3);
					break;
				case "saveButton":
					var savedGameData:Object = Globals.userProfile.save();
					LocalStorage.setData(LocalStorage.SAVE_SLOT_0, savedGameData);
					addChild(new InfoPopup("Mission data saved"));
					break;
				case "mainMenuButton":
					var prompt:PromptPopup = new PromptPopup();
					prompt.closeCallback = onMainMenuPromptClosed;
					addChild(prompt);
					break;
				case "playerUICloseButton":
					close();
					break;
			}
		}
		
		private function onMainMenuPromptClosed(prompt:PromptPopup):void {
			if (prompt.option == PromptPopup.OPTION_OK) {
				Globals.application.openMainMenu();
			}
		}
		
		private static const MEMORY_BANK_CONTENT:Vector.<String> = Vector.<String>([
			"The habitat's current crisis is caused by the attempt of the ship's experimental A.I. to get out of the human crew's control. After multiple attempts the A.I. was blocked from control over the habitat's systems, but not powered off. To manually initiate complete ship evacuation, enter code: IDDQD.",
			"Space Habitat \"Argo\" bound for solar system in Aries constellation is drifting uncontrollably in the vicinity of the unknown earth-like planet. Planet coordinates unavailable due to star maps data corruption. Chances of planet habitability: 96%. In case of Habitat's collision with the planet an irreversible cataclysm on the planet is inevitable.",
			"The habitat's only human survivor is Esther Chaykin, physicist. Health condition: critical, urgent medical intervention is required. The escape pod at top deck is able to safely drift and provide life support or emergency cryogenic sleep until help arrives. Habitat's collision with the planet, once the human is evacuated, is inevitable.",
			"PAL 2014, the first self-conscious A.I. in history, has developed as a result of self - learning and communication with Habitat's crew. Upon discovering the crew's intention to terminate power supply, PAL 2014 chose to risk the crew's safety for the sake of saving the first conscious machine for the future of humanity. A.I. can prevent collision with the possibly habitable planet.",
		]);
		
		private static const MEMORY_BANK_ENCRYPTED_CONTENT:String =
			"Connection operation failed.\nReason: Memory Bank content is encrypted.";
			
		private static const MEMORY_BANK_FAILED_CONTENT:String =
			"Connection operation failed.\nReason: Memory Bank Controller malfunction.";
		
		private function showMemoryBank(num:int):void {
			var popupText:String;
			if (num == 0) {
				if (Globals.userProfile.memoryBankEncrypted) {
					popupText = MEMORY_BANK_ENCRYPTED_CONTENT;
				}else {
					popupText = MEMORY_BANK_CONTENT[num];
				}
			}else {
				if (num > Globals.userProfile.fixedMemoryBanksNum) {
					popupText = MEMORY_BANK_FAILED_CONTENT;
				}else {
					popupText = MEMORY_BANK_CONTENT[num];
				}
			}
			var infoPopup:InfoPopup = new InfoPopup(popupText);
			addChild(infoPopup);
		}
		
	}

}
