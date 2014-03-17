package rust.ui {
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import rust.assets.Assets;
	
	public class Image extends UIControl {
		
		private var _bitmap:Bitmap = new Bitmap(null, PixelSnapping.NEVER);
		private var _assetId:String = "";
		
		public function Image() {
			addChild(_bitmap);
		}
		
		public function get assetId():String {
			return _assetId;
		}
		
		public function set assetId(value:String):void {
			_assetId = value;
			_bitmap.bitmapData = Assets.getAsset(value);
		}
		
		override public function get width():Number {
			return _bitmap.width;
		}
		
		public override function set width(value:Number):void {
			_bitmap.width = value;
		}
		
		override public function get height():Number {
			return _bitmap.height;
		}
		
		public override function set height(value:Number):void {
			_bitmap.height = value;
		}
		
	}

}
