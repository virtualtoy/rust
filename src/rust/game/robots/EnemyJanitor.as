package rust.game.robots {
	
	import rust.game.Room;
	
	public class EnemyJanitor extends Enemy {
		
		public static const FRAME_IDS:Vector.<String> = Vector.<String>([
			"images/enemy_1_1.png",
			"images/enemy_1_2.png",
			"images/enemy_1_3.png",
			"images/enemy_1_4.png",
		]);
		
		public static const ARMOR:Number = 1;
		
		public function EnemyJanitor(uid:uint, x:Number, y:Number, item:uint, room:Room) {
			super(uid, x, y, ARMOR, item, room, FRAME_IDS);
		}
		
		public override function startMove():void {
			startMoveWander();
		}
		
	}

}
