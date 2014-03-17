package rust.game.ui {
	
	import rust.assets.Assets;
	import rust.ui.Text;
	import rust.ui.UIControl;
	import rust.ui.UIControlXMLFactory;
	
	public class GameUI extends UIControl {
		
		public function GameUI() {
			var control:UIControl = UIControlXMLFactory.create(Assets.getAsset("xml/game_ui.xml"));
			addChild(control);
		}
		
		public function setPlayerHealth(value:Number):void {
			var health:Number = Math.floor(value * 1000) / 10;
			(getControlByName("playerHealthText") as Text).text = "Energy: " + health + "%";
		}
		
		public function showDeviceDetected():void {
			getControlByName("deviceDetectedText").visible = true;
		}
		
		public function showDeviceDetectorUnavailable():void {
			getControlByName("deviceDetectorUnavailableText").visible = true;
		}
		
	}

}
