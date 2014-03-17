package rust {
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import rust.core.ApplicationScene;
	import rust.core.Globals;
	import rust.core.rust_ns;
	import rust.end.EndScene;
	import rust.game.GameScene;
	import rust.mainmenu.MainMenuScene;
	import rust.utils.EnterFrameTicker;
	
	public class Application extends Sprite {
		
		private var _scene:ApplicationScene;
		
		public function Application() {
			if (stage) {
				init();
			}else {
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}
		
		public function openMainMenu():void {
			setScene(MainMenuScene);
		}
		
		public function openGameScene():void {
			setScene(GameScene);
		}
		
		public function openEndScene():void {
			setScene(EndScene);
		}
		
		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		private function init():void {
			Globals.rust_ns::init(this);
			setupStage();
			openMainMenu();
		}
		
		private function setupStage():void {
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.displayState = StageDisplayState.NORMAL;
		}
		
		private function setScene(typeClass:Class):void {
			if (_scene) {
				EnterFrameTicker.removeListener(_scene);
				removeChild(_scene.view);
				_scene.dispose();
			}
			_scene = new typeClass();
			addChild(_scene.view);
			EnterFrameTicker.addListener(_scene);
		}
		
	}
	
}
