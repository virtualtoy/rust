package rust.game.robots {
	
	import rust.game.Room;
	
	public class EnemyUtility extends Enemy {
		
		public static const FRAME_IDS:Vector.<String> = Vector.<String>([
			"images/enemy_2_1.png",
			"images/enemy_2_2.png",
			"images/enemy_2_3.png",
			"images/enemy_2_4.png",
		]);
		
		public static const ARMOR:Number = 0.9;
		public static const ATTACK_HEALTH:Number = 0.02;
		public static const MIN_FOLLOW_PLAYER_DIST:Number = 4;
		
		public function EnemyUtility(uid:uint, x:Number, y:Number, item:uint, room:Room) {
			super(uid, x, y, ARMOR, item, room, FRAME_IDS);
		}
		
		public override function startMove():void {
			if (room.player.attacked) {
				if (canAttackPlayer) {
					attackPlayer(ATTACK_HEALTH);
				}else {
					if (distToPlayer < MIN_FOLLOW_PLAYER_DIST) {
						startMoveFollowPlayer();
					}else {
						startMoveWander();
					}
				}
			}else {
				startMoveWander();
			}
		}
		
	}

}
