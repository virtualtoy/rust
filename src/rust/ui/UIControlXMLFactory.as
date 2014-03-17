package rust.ui {
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import rust.assets.Assets;
	
	public class UIControlXMLFactory {
		
		public static const PANEL:String = "Panel";
		public static const BUTTON:String = "Button";
		public static const TEXT:String = "Text";
		public static const IMAGE:String = "Image";
		public static const OVERLAY:String = "Overlay";
		public static const UI_CONTROL:String = "UIControl";
		
		public static function create(xml:XML):UIControl {
			
			var control:UIControl = createFromXML(xml);
			
			var propsList:XMLList = xml.attributes();
			for each(var propXML:XML in propsList) {
				setProp(propXML.name(), propXML.toString(), control);
			}
			
			var childrenList:XMLList = xml.children();
			for each(var childXML:XML in childrenList) {
				control.addChild(create(childXML));
			}
			
			return control;
		}
		
		private static function setProp(propName:String, propValue:String, control:UIControl):void {
			if (!(propName in control)) {
				throw new ReferenceError("Cannot create property " + propName + " on " + control);
			}
			if (control[propName] is String) {
				control[propName] = propValue;
			}else if (control[propName] is Number) {
				control[propName] = parseFloat(propValue);
			}else if (control[propName] is Boolean) {
				control[propName] = propValue == "true";
			}else if (control[propName] is BitmapData) {
				control[propName] = Assets[propValue];
			}else if (control[propName] is Rectangle) {
				var rectProps:Array = propValue.split(",");
				control[propName] = new Rectangle(	parseFloat(rectProps[0]),
													parseFloat(rectProps[1]),
													parseFloat(rectProps[2]),
													parseFloat(rectProps[3])
													);
			}else {
				throw new ArgumentError("Property type is not supported: " + propName);
			}
		}
		
		private static function createFromXML(xml:XML):UIControl {
			var name:String = xml.name();
			switch (name) {
				case PANEL:
					return new Panel();
				case BUTTON:
					return new Button();
				case TEXT:
					return new Text();
				case IMAGE:
					return new Image();
				case OVERLAY:
					return new Overlay();
				case UI_CONTROL:
					return new UIControl();
			}
			throw new ArgumentError("Name is not supported: " + name);
		}
		
	}

}
