package rust.assets {
	
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class Assets {
		
		include "Assets_include.as"
		
		public static const TYPE_BITMAP:String = "bitmap";
		public static const TYPE_XML:String = "xml";
		public static const TYPE_SOUND:String = "sound";
		
		private static const _idToAssetDict:Dictionary = new Dictionary();
		
		public function Assets() {
			
		}
		
		public static function getAsset(id:String):* {
			if (!(id in _idToAssetDict)) {
				var assetDef:Object = idToAssetDefHash[id];
				if (!assetDef) {
					throw new ArgumentError("No asset with id: " + id);
				}
				var assetClass:Class = assetDef["class"];
				var assetInstance:Object = new assetClass();
				var asset:Object;
				var type:String = assetDef.type;
				if (type == TYPE_BITMAP) {
					asset = Bitmap(assetInstance).bitmapData;
				}else if (type == TYPE_SOUND) {
					asset = assetInstance;
				}else if (type == TYPE_XML) {
					var bytes:ByteArray = ByteArray(assetInstance);
					asset = XML(bytes.readUTFBytes(bytes.length));
				}else {
					throw new ArgumentError("Asset type is not supported: " + type);
				}
				_idToAssetDict[id] = asset;
			}
			return _idToAssetDict[id];
		}
		
	}
	
}
