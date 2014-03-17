package rust.utils {
	
	public class PRNG {
		
		public static const MIN_SEED:uint = 1;
		public static const MAX_SEED:uint = 0X7FFFFFFE;
		
		private var _seed:uint;
		
		public function PRNG(seed:uint = 1) {
			this.seed = seed;
		}
		
		public function get seed():uint { return _seed; }
		
		public function set seed(value:uint):void {
			if (value < MIN_SEED) {
				_seed = MIN_SEED;
			}else if (value > MAX_SEED) {
				_seed = MAX_SEED;
			}else {
				_seed = value;
			}
		}
		
		public function get nextInt():int {
			return seed = (seed * 16807) % 2147483647;
		}
		
		public function get nextDouble():Number {
			return (nextInt / 2147483647);
		}
		
		public function get nextBoolean():Boolean {
			return nextDouble < 0.5;
		}
		
	}

}
