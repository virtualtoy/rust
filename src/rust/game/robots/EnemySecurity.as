package rust.game.robots {
	
	import rust.game.Room;
	
	public class EnemySecurity extends Enemy {
		
		public static const FRAME_IDS:Vector.<String> = Vector.<String>([
			"images/enemy_4_1.png",
			"images/enemy_4_2.png",
			"images/enemy_4_3.png",
			"images/enemy_4_4.png",
		]);
		
		public static const ARMOR:Number = 0.7;
		public static const ATTACK_HEALTH:Number = 0.1;
		public static const MIN_FOLLOW_PLAYER_DIST:Number = 7;
		public static const MAX_FOLLOW_PLAYER_DIST:Number = Number.MAX_VALUE;
		
		public function EnemySecurity(uid:uint, x:Number, y:Number, item:uint, room:Room) {
			super(uid, x, y, ARMOR, item, room, FRAME_IDS);
		}
		
		public override function startMove():void {
			if (canAttackPlayer) {
				attackPlayer(ATTACK_HEALTH);
			}else {
				var minDist:Number = room.player.attacked ? MAX_FOLLOW_PLAYER_DIST : MIN_FOLLOW_PLAYER_DIST;
				if (distToPlayer < minDist) {
					startMoveFollowPlayer();
				}else {
					startMoveWander();
				}
			}
		}
		
	}

}
