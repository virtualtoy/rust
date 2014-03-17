package rust.ui {
	
	import flash.display.Sprite;
	
	public class UIControl extends Sprite {
		
		[Embed(source="../../../fonts/04B_20__.TTF", embedAsCFF="false", fontFamily = "defaultFont")]
		private static const DEFAULT_FONT:Class;
		
		private static var _idCount:int = 1;
		
		public function UIControl() {
			
		}
		
		public function getControlByName(name:String):UIControl {
			if (this.name == name) {
				return this;
			}
			for (var i:int = 0, l:int = numChildren; i < l; i++) {
				var child:UIControl = getChildAt(i) as UIControl;
				if (child) {
					var control:UIControl = child.getControlByName(name);
					if (control) {
						return control;
					}
				}
			}
			return null;
		}
		
	}

}
