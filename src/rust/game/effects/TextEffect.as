package rust.game.effects {
	
	import rust.ui.Text;
	
	public class TextEffect extends VisualEffect {
		
		private var _text:Text = new Text();
		private var _completed:Boolean = false;
		private var _dy:Number = 1;
		
		public function TextEffect(text:String) {
			addChild(_text);
			_text.text = text;
			_text.x = -_text.width * 0.5;
			_text.y = -_text.height * 0.5;
		}
		
		public override function update():void {
			if (!_completed) {
				_text.y -= _dy;
				_dy -= 0.03;
				if (_dy <= 0) {
					_dy = 0;
					_completed = true;
				}
			}
		}
		
		override public function get completed():Boolean {
			return _completed;
		}
		
	}

}
