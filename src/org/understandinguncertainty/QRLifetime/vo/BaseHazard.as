/*
This file forms part of the library which provides the JBS3Risk Risk Model.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk

It contains code derived from http://qrisk.org/lifetime/QRISK-lifetime-2011-opensource.v1.0.tgz released by ClinRisk Ltd.

*/
package org.understandinguncertainty.QRLifetime.vo
{
	public class BaseHazard
	{
		public var cvd_1:Number;
		public var death_1:Number;
		
		public function BaseHazard(cvd_1:Number, death_1:Number)
		{
			this.cvd_1 = cvd_1;
			this.death_1 = death_1;
		}
	}
}