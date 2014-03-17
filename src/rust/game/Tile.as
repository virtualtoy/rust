package rust.game {
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import rust.assets.Assets;
	import rust.utils.PRNG;
	
	public class Tile extends GameObject {
		
		private static const TEMP_MATRIX:Matrix = new Matrix();
		private static var _tileTypeToDefDict:Dictionary;
		private static var _tileBlock:TileDef;
		private static var _tileBlockLow:TileDef;
		
		private var _view:Shape = new Shape();
		private var _requiresFloorTile:Boolean;
		
		public function Tile(x:Number, y:Number, value:int) {
			var z:Number = init(x, y, value);
			super(_view, z, 0, 0);
			move(x, y, false);
		}
		
		public function get requiresFloorTile():Boolean {
			return _requiresFloorTile;
		}
		
		private function init(x:Number, y:Number, value:int):Number {
			if (!_tileTypeToDefDict) {
				populateDefDict();
			}
			
			var tileType:uint = value & GameObjectFlags.TILE_TYPE_MASK;
			var def:TileDef;
			
			if (tileType == GameObjectFlags.TILE_TYPE_BLOCK) {
				var onRoomEdge:Boolean = (x == MapData.ROOM_WIDTH - 1 && y != 0) || (y == MapData.ROOM_HEIGHT - 1 && x != 0);
				def = onRoomEdge ? _tileBlockLow : _tileBlock;
			}else {
				def = _tileTypeToDefDict[tileType];
			}
			
			var pixels:BitmapData = Assets.getAsset(def.assetId);
			var g:Graphics = _view.graphics;
			TEMP_MATRIX.identity();
			TEMP_MATRIX.tx = def.offsetX;
			TEMP_MATRIX.ty = def.offsetY;
			g.beginBitmapFill(pixels, TEMP_MATRIX, false, false);
			g.drawRect(def.offsetX, def.offsetY, pixels.width, pixels.height);
			g.endFill();
			
			_requiresFloorTile = def.requiresFloorTile;
			
			return def.z;
		}
		
		private static function populateDefDict():void {
			_tileTypeToDefDict = new Dictionary();
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_FLOOR] 			= new TileDef("images/tile_floor.png", 0, 0, 0, false);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_HOLE] 				= new TileDef("images/tile_empty.png", 0, 0, 0, false);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_DOOR_NORTH] 		= new TileDef("images/tile_floor.png", 0, 0, 0, false);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_DOOR_SOUTH] 		= new TileDef("images/tile_floor.png", 0, 0, 0, false);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_DOOR_WEST] 		= new TileDef("images/tile_floor.png", 0, 0, 0, false);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_DOOR_EAST] 		= new TileDef("images/tile_floor.png", 0, 0, 0, false);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_TELEPORT_UP] 		= new TileDef("images/tile_teleport.png", 0, 0, 0, false);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_TELEPORT_DOWN] 	= new TileDef("images/tile_teleport.png", 0, 0, 0, false);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_POWER_SUPPLY] 		= new TileDef("images/tile_power_supply.png", 0, 0, 0, false);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_DEBRIS] 			= new TileDef("images/tile_debris.png", 1, 0, 0, false);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_TERMINAL_1] 		= new TileDef("images/tile_terminal_1.png", 1, 0, -50, true);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_TERMINAL_2] 		= new TileDef("images/tile_terminal_2.png", 1, 0, -50, true);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_POD_1] 			= new TileDef("images/tile_pod_1.png", 1, 0, -50, true);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_POD_2] 			= new TileDef("images/tile_pod_2.png", 1, 0, -50, true);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_POD_3] 			= new TileDef("images/tile_pod_3.png", 1, 0, -50, true);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_AI] 				= new TileDef("images/tile_ai.png", 1, 0, -50, true);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_AI_ACTIVE_AREA] 	= new TileDef("images/tile_floor.png", 0, 0, 0, false);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_HUMAN] 			= new TileDef("images/tile_human.png", 1, 0, -62, true);
			_tileTypeToDefDict[GameObjectFlags.TILE_TYPE_HUMAN_ACTIVE_AREA] = new TileDef("images/tile_floor.png", 0, 0, 0, false);
			
			_tileBlock 		= new TileDef("images/tile_block.png", 1, 0, -50, true);
			_tileBlockLow 	= new TileDef("images/tile_block_low.png", 1, 0, -16, true);
		}
		
	}

}

internal class TileDef {
	
	public var assetId:String;
	public var z:Number;
	public var offsetX:Number;
	public var offsetY:Number;
	public var requiresFloorTile:Boolean;
	
	public function TileDef(assetId:String, z:Number, offsetX:Number, offsetY:Number, requiresFloorTile:Boolean) {
		this.requiresFloorTile = requiresFloorTile;
		this.offsetY = offsetY;
		this.offsetX = offsetX;
		this.z = z;
		this.assetId = assetId;
	}
	
}
