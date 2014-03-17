package rust.ui {
	
	import flash.display.PixelSnapping;
	import flash.geom.Rectangle;
	import org.bytearray.display.ScaleBitmap;
	import rust.assets.Assets;
	
	public class Panel extends UIControl {
		
		private static const SKIN_GRID:Rectangle = new Rectangle(2, 2, 21, 21);
		
		private var _skin:ScaleBitmap;
		
		public function Panel() {
			_skin = new ScaleBitmap(Assets.getAsset("images/panel_skin.png").clone(), PixelSnapping.ALWAYS, false);
			_skin.scale9Grid = SKIN_GRID;
			addChild(_skin);
		}
		
		public override function get width():Number {
			return _skin.width;
		}
		
		public override function set width(value:Number):void {
			_skin.width = int(value);
		}
		
		public override function get height():Number {
			return _skin.height;
		}
		
		public override function set height(value:Number):void {
			_skin.height = int(value);
		}
		
	}

}
