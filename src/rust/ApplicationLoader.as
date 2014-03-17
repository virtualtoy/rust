package rust {
	
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	public class ApplicationLoader extends MovieClip {
		
		private var _background:Shape = new Shape();
		private var _preloader:Shape = new Shape();
		private var _preloaderBar:Shape = new Shape();
		
		public function ApplicationLoader() {
			
			var g:Graphics = _background.graphics;
			g.beginFill(0x000000, 1);
			g.drawRect(0, 0, 800, 600);
			g.endFill();
			
			g = _preloader.graphics;
			g.lineStyle(0, 0xFFFFFF, 1, true);
			g.drawRect(100, 500, 600, 20);
			
			g = _preloaderBar.graphics;
			g.lineStyle(0, 0xFFFFFF, 1, true);
			g.beginFill(0xFFFFFF, 1);
			g.drawRect(0, 502, 596, 16);
			g.endFill();
			
			_preloaderBar.x = 102;
			_preloaderBar.scaleX = 0;
			
			addChild(_background);
			addChild(_preloader);
			addChild(_preloaderBar);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void {
			if (root) {
				var loadingPercent:Number = getPercentLoaded();
				_preloaderBar.scaleX = loadingPercent;
				if (loadingPercent >= 1) {
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					stepNextFrame(null);
				}
			}
		}
		
		private function getPercentLoaded():Number {
			var bytesLoaded:uint = root.loaderInfo.bytesLoaded;
			var bytesTotal:uint = root.loaderInfo.bytesTotal;
			if (bytesTotal == 0 || bytesLoaded > bytesTotal) {
				return bytesLoaded > 0 ? 1 : 0;
			}
			return (bytesLoaded / bytesTotal);
		}
		
		private function stepNextFrame(event:Event):void {
			removeEventListener(Event.ENTER_FRAME, stepNextFrame);
			if (currentFrame == totalFrames) {
				loadingComplete();
			}else {
				addEventListener(Event.ENTER_FRAME, stepNextFrame);
				if (currentFrame < framesLoaded) {
					nextFrame();
				}
			}
		}
		
		private function loadingComplete():void {
			removeChild(_preloader);
			removeChild(_preloaderBar);
			
			var payloadClass:Class = getDefinitionByName("rust.Payload") as Class;
			var payload:Class = payloadClass["PAYLOAD_CLASS"];
			var payloadBytes:ByteArray = new payload();
			var loader:Loader = new Loader();
			loader.loadBytes(payloadBytes);
			addChild(loader);
		}
		
	}

}
