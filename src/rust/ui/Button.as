package rust.ui {
	
	import flash.display.PixelSnapping;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import org.bytearray.display.ScaleBitmap;
	import rust.assets.Assets;
	
	public class Button extends UIControl {
		
		public static const EVENT_CLICK:String = "Button.event.click";
		
		private static const SKIN_GRID:Rectangle = new Rectangle(2, 2, 21, 21);
		private static const TEXT_PADDING:Rectangle = new Rectangle(10, 6, 10, 2);
		
		private var _text:Text;
		private var _upSkin:ScaleBitmap;
		private var _downSkin:ScaleBitmap;
		
		public function Button() {
			init();
		}
		
		private function init():void {
			mouseChildren = false;
			
			_upSkin = new ScaleBitmap(Assets.getAsset("images/button_skin_up.png").clone(), PixelSnapping.ALWAYS, false);
			_upSkin.scale9Grid = SKIN_GRID;
			_downSkin = new ScaleBitmap(Assets.getAsset("images/button_skin_down.png").clone(), PixelSnapping.ALWAYS, false);
			_downSkin.scale9Grid = SKIN_GRID;
			_downSkin.visible = false;
			
			addChild(_upSkin);
			addChild(_downSkin);
			
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			
			_text = new Text();
			addChild(_text);
		}
		
		private function onRollOver(event:MouseEvent):void {
			event.stopImmediatePropagation();
			_upSkin.visible = false;
			_downSkin.visible = true;
		}
		
		private function onRollOut(event:MouseEvent):void {
			event.stopImmediatePropagation();
			_upSkin.visible = true;
			_downSkin.visible = false;
		}
		
		private function onClick(event:MouseEvent):void {
			event.stopImmediatePropagation();
			dispatchEvent(new Event(EVENT_CLICK, true, true));
		}
		
		public override function get width():Number {
			return _upSkin.width;
		}
		
		public override function set width(value:Number):void {
			_upSkin.width = 
			_downSkin.width = value;
			redraw();
		}
		
		public override function get height():Number {
			return _upSkin.height;
		}
		
		public override function set height(value:Number):void {
			_upSkin.height = 
			_downSkin.height = value;
			redraw();
		}
		
		public function get text():String {
			return _text.text;
		}
		
		public function set text(value:String):void {
			_text.text = value;
			redraw();
		}
		
		private function redraw():void {
			_upSkin.width = 
			_downSkin.width = int(_text.width + TEXT_PADDING.x + TEXT_PADDING.width);
			_upSkin.height = 
			_downSkin.height = int(_text.height + TEXT_PADDING.y + TEXT_PADDING.height);
			_text.x = TEXT_PADDING.x;
			_text.y = TEXT_PADDING.y;
		}
		
	}

}
