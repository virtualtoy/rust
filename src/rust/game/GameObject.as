package rust.game {
	
	import flash.display.DisplayObject;
	import rust.core.IDisposable;
	import rust.core.IUpdatable;
	
	public class GameObject implements IUpdatable, IDisposable {
		
		public static const TILE_WIDTH:Number = 60;
		public static const TILE_HEIGHT:Number = 30;
		
		private var _view:DisplayObject;
		private var _depth:int = -1;
		
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		private var _viewOffsetX:Number;
		private var _viewOffsetY:Number;
		
		// accepts 3 parameters: this, oldDepth, newDepth
		public var depthChangedCallback:Function = null;
		
		public function GameObject(view:DisplayObject, z:Number, viewOffsetX:Number, viewOffsetY:Number) {
			_view = view;
			_z = z;
			_viewOffsetX = viewOffsetX;
			_viewOffsetY = viewOffsetY;
		}
		
		public function update():void {
			
		}
		
		public function dispose():void {
			depthChangedCallback = null;
		}
		
		public function get x():Number {
			return _x;
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function get z():Number {
			return _z;
		}
		
		public function get depth():int {
			return _depth;
		}
		
		public function get view():DisplayObject {
			return _view;
		}
		
		protected function move(x:Number, y:Number, invokeDepthChangeCallback:Boolean = true):void {
			_x = x;
			_y = y;
			_view.x = (_x - _y) * TILE_WIDTH * 0.5 + _viewOffsetX;
			_view.y = (_x + _y) * TILE_HEIGHT * 0.5 + _viewOffsetY;
			var newDepth:int = (17 * _y + 19 * _x) * _z;
			if (_depth != newDepth) {
				if (invokeDepthChangeCallback && depthChangedCallback != null) {
					var oldDepth:int = _depth;
					_depth = newDepth;
					depthChangedCallback(this, oldDepth, newDepth);
				}else {
					_depth = newDepth;
				}
			}
		}
		
	}

}
