package rust.game {
	
	public class SortedDepthList {
		
		private var _depths:Vector.<int> = new Vector.<int>();
		
		public function SortedDepthList() {
			
		}
		
		public function addDepth(depth:int):int {
			var index:int = indexOfLastEqual(depth);
			if (index > -1) {
				index++;
			} else {
				index = -index - 1;
			}
			_depths.splice(index, 0, depth);
			return index;
		}
		
		public function removeDepth(depth:int):int {
			var firstIndex:int = indexOfFirstEqual(depth);
			if (firstIndex < 0) return -1;
			_depths.splice(firstIndex, 1);
			return firstIndex;
		}
		
		public function getDepthFirstIndex(depth:int):int {
			return indexOfFirstEqual(depth);
		}
		
		private function indexOfFirstEqual(item:int):int {
			var start:uint = 0;
			var end:int = _depths.length - 1;
			var cursor:uint;
			var match:Boolean = false;
			while (start <= end) {
				cursor = (end + start) / 2;
				if (item == _depths[cursor]) {
					if (cursor == start) return cursor;
					match = true;
					end = cursor - 1;
				}else if (item < _depths[cursor]) {
					if (cursor == start) return -1 - cursor;
					end = cursor - 1;
				}else {
					if (cursor == end) {
						if (match) return cursor + 1;
						return -1 - (cursor + 1);
					}
					start = cursor + 1;
				}
			}
			return -1;
		}
		
		private function indexOfLastEqual(item:int):int {
			var start:uint = 0;
			var end:int = _depths.length - 1;
			var cursor:uint;
			var match:Boolean = false;
			while (start <= end) {
				cursor = (end + start) / 2;
				if (item == _depths[cursor]) {
					if (cursor == end) return cursor;
					match = true;
					start = cursor + 1;
				}else if (item < _depths[cursor]) {
					if (cursor == start) {
						if (match) return cursor - 1;
						return -1 - cursor;
					}
					end = cursor - 1;
				}else {
					if (cursor == end) return -1 - (cursor + 1);
					start = cursor + 1;
				}
			}
			return -1;
		}
		
	}
	
}