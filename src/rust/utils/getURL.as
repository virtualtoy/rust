package rust.utils {
	
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	public function getURL(url:String, window:String = "_blank"):void {
		try {
			navigateToURL(new URLRequest(url), window);
		}catch (error:Error) { }
	}

}
