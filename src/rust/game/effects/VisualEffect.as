package rust.game.effects {
	
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import rust.core.IUpdatable;
	
	public class VisualEffect extends Sprite implements IUpdatable {
		
		public function VisualEffect() {
			
		}
		
		public function update():void {
			
		}
		
		public function get completed():Boolean {
			throw new IllegalOperationError("Override required");
		}
		
	}

}
