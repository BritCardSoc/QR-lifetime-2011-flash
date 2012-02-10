/*
This file forms part of the library which provides the JBS3Risk Risk Model.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk

It contains code derived from http://qrisk.org/lifetime/QRISK-lifetime-2011-opensource.v1.0.tgz released by ClinRisk Ltd.

*/
package org.understandinguncertainty.QRLifetime.vo
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