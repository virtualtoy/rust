package rust.end {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import rust.assets.Assets;
	import rust.core.ApplicationScene;
	import rust.core.Globals;
	import rust.ui.Button;
	import rust.ui.Image;
	import rust.ui.Text;
	import rust.ui.UIControl;
	import rust.ui.UIControlXMLFactory;
	
	public class EndScene extends ApplicationScene {
		
		private static const TEXTS:Vector.<String> = Vector.<String>([
			"Esther was found and revived 3000 years later by a friendly non-humanoid race after the colony that was expected to replace Earth as the main hub of human civilization suffered a major catastrophe after collision with Habitat \"Argo\".",
			"Habitat \"Argo\" was self-destroyed to prevent a massive catastrophe on a planet holding the most prominent human colony off Earth thus saving millions of lives. The unique self-conscious A.I. and physicist Esther Chaykin were forever lost.",
			"Upon restoring control over the Habitat, PAL 2014 has evacuated the human survivor in the escape pod. It has then taken off in the unknown direction. No trace of \"Argo\" was ever discovered again.",
		]);
		private static const IMAGE_ASSET_IDS:Vector.<String> = Vector.<String>([
			"images/ending_1.png",
			"images/ending_2.png",
			"images/ending_3.png"
		]);
		
		private var _view:Sprite = new Sprite();
		
		public function EndScene() {
			super(_view);
			init();
		}
		
		private function init():void {
			var control:UIControl = UIControlXMLFactory.create(Assets.getAsset("xml/end.xml"));
			control.addEventListener(Button.EVENT_CLICK, onButtonClick);
			_view.addChild(control);
			
			var text:String = TEXTS[Globals.userProfile.finalChoiceOption];
			var imageAssetId:String = IMAGE_ASSET_IDS[Globals.userProfile.finalChoiceOption];
			
			(control.getControlByName("text") as Text).text = text;
			(control.getControlByName("image") as Image).assetId = imageAssetId;
		}
		
		private function onButtonClick(event:Event):void {
			if (event.target.name == "mainMenuButton") {
				Globals.application.openMainMenu();
			}
		}
		
	}

}
