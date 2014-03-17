package rust.core {
	
	import flash.display.DisplayObject;
	
	public class ApplicationScene implements IUpdatable, IDisposable {
		
		private var _view:DisplayObject;
		
		public function ApplicationScene(view:DisplayObject) {
			_view = view;
		}
		
		public function get view():DisplayObject {
			return _view;
		}
		
		public function update():void {
			
		}
		
		public function dispose():void {
			
		}
		
	}

}
