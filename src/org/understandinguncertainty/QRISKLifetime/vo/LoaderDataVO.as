package org.understandinguncertainty.QRISKLifetime.vo
{
	import flash.net.URLLoader;

	public class LoaderDataVO
	{
		public var path:String;
		public var loader:URLLoader;
		public var completeHandler:Function;
		public var ioErrorHandler:Function;
	}
}