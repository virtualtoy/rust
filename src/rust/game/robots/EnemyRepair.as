package rust.game.robots {
	
	import rust.game.Room;
	
	public class EnemyRepair extends Enemy {
		
		public static const FRAME_IDS:Vector.<String> = Vector.<String>([
			"images/enemy_3_1.png",
			"images/enemy_3_2.png",
			"images/enemy_3_3.png",
			"images/enemy_3_4.png",
		]);
		
		public static const ARMOR:Number = 0.8;
		public static const ATTACK_HEALTH:Number = 0.05;
		public static const MIN_FOLLOW_PLAYER_DIST:Number = 5;
		
		public function EnemyRepair(uid:uint, x:Number, y:Number, item:uint, room:Room) {
			super(uid, x, y, ARMOR, item, room, FRAME_IDS);
		}
		
		public override function startMove():void {
			if (canAttackPlayer) {
				attackPlayer(ATTACK_HEALTH);
			}else if (room.player.attacked) {
				if (distToPlayer < MIN_FOLLOW_PLAYER_DIST) {
					startMoveFollowPlayer();
				}else {
					startMoveWander();
				}
			}else {
				startMoveWander();
			}
		}
		
	}

}
