package rust.ui {
	
	public class Overlay extends UIControl {
		
		public static const COLOR:uint = 0x000000;
		public static const ALPHA:Number = 0.7;
		
		private var _width:Number = 0;
		private var _height:Number = 0;
		
		public function Overlay() {
			alpha = ALPHA;
		}
		
		public override function get width():Number {
			return _width;
		}
		
		public override function set width(value:Number):void {
			_width = value;
			redraw();
		}
		
		public override function get height():Number {
			return _height;
		}
		
		public override function set height(value:Number):void {
			_height = value;
			redraw();
		}
		
		private function redraw():void {
			graphics.clear();
			graphics.lineStyle();
			graphics.beginFill(COLOR);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
		
	}

}
