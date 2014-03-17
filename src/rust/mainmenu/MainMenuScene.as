package rust.mainmenu {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import rust.assets.Assets;
	import rust.core.ApplicationScene;
	import rust.core.Globals;
	import rust.save.LocalStorage;
	import rust.ui.Button;
	import rust.ui.InfoPopup;
	import rust.ui.UIControl;
	import rust.ui.UIControlXMLFactory;
	import rust.utils.getURL;
	
	public class MainMenuScene extends ApplicationScene {
		
		public static const HELP_TEXT:String = "Controls:\nArrows or AWSD - move\nSpace - interact\nEnter - toggle menu\nEsc - cancel\n\nHints:\n- robot remains can be explored\n- try restoring all memory banks\n\nThanks to my wonderful wife for help and support!";
		
		private var _view:Sprite = new Sprite();
		
		public function MainMenuScene() {
			super(_view);
			init();
		}
		
		private function init():void {
			var control:UIControl = UIControlXMLFactory.create(Assets.getAsset("xml/main_menu.xml"));
			control.addEventListener(Button.EVENT_CLICK, onButtonClick);
			_view.addChild(control);
			
			var savedGameData:Object = LocalStorage.getData(LocalStorage.SAVE_SLOT_0);
			if (!savedGameData) {
				control.getControlByName("loadGameButton").visible = false;
			}
		}
		
		private function onButtonClick(event:Event):void {
			var targetName:String = event.target.name;
			switch (targetName) {
				case "startNewGameButton":
					startNewGame();
					break;
				case "loadGameButton":
					loadGame();
					break;
				case "helpButton":
					_view.addChild(new InfoPopup(HELP_TEXT));
					break;
				case "websiteButton":
					getURL("http://virtualtoy.me");
					break;
				case "twitterButton":
					getURL("https://twitter.com/virtualtoy");
					break;
				case "githubButton":
					getURL("https://github.com/virtualtoy/rust");
					break;
			}
		}
		
		private function startNewGame():void {
			Globals.userProfile.setDefaults();
			Globals.application.openGameScene();
		}
		
		private function loadGame():void {
			var savedGameData:Object = LocalStorage.getData(LocalStorage.SAVE_SLOT_0);
			Globals.userProfile.load(savedGameData);
			Globals.application.openGameScene();
		}
		
	}

}
