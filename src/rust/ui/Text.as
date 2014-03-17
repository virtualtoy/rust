package rust.ui {
	
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Text extends UIControl {
		
		private static const TEXT_FORMAT:TextFormat =
			new TextFormat("defaultFont", 16, 0xFFFFFF, false, false, false, null, null, null, null, null, null, 8);
		
		private static const FILTERS:Array = [new GlowFilter(0x000000, 1, 4, 4, 10)];
		
		private var _textField:TextField = new TextField();
		
		public function Text() {
			_textField.filters = FILTERS;
			_textField.defaultTextFormat = TEXT_FORMAT;
			_textField.selectable = false;
			_textField.multiline = true;
			_textField.wordWrap = false;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.embedFonts = true;
			_textField.text = "";
			addChild(_textField);
		}
		
		public function get text():String {
			return _textField.text;
		}
		
		public function set text(value:String):void {
			_textField.text = value;
		}
		
		public function get wordWrap():Boolean {
			return _textField.wordWrap;
		}
		
		public function set wordWrap(value:Boolean):void {
			_textField.wordWrap = value;
		}
		
		public override function get width():Number {
			return _textField.textWidth;
		}
		
		public override function set width(value:Number):void {
			_textField.width = value;
		}
		
		public override function get height():Number {
			return _textField.textHeight;
		}
		
		public override function set height(value:Number):void {
			_textField.height = value;
		}
		
	}

}
