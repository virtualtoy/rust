package rust.game.robots {
	
	import rust.game.Room;
	
	public class EnemyMilitary extends Enemy {
		
		public static const FRAME_IDS:Vector.<String> = Vector.<String>([
			"images/enemy_5_1.png",
			"images/enemy_5_2.png",
			"images/enemy_5_3.png",
			"images/enemy_5_4.png",
		]);
		
		public static const ARMOR:Number = 0.6;
		public static const ATTACK_HEALTH:Number = 0.2;
		
		public function EnemyMilitary(uid:uint, x:Number, y:Number, item:uint, room:Room) {
			super(uid, x, y, ARMOR, item, room, FRAME_IDS);
		}
		
		public override function startMove():void {
			if (canAttackPlayer) {
				attackPlayer(ATTACK_HEALTH);
			}else {
				startMoveFollowPlayer();
			}
		}
		
	}

}
