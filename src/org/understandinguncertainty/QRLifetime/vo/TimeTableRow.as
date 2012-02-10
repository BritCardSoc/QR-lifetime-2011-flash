/*
This file forms part of the library which provides the JBS3Risk Risk Model.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk

It contains code derived from http://qrisk.org/lifetime/QRISK-lifetime-2011-opensource.v1.0.tgz released by ClinRisk Ltd.

*/
package org.understandinguncertainty.QRLifetime.vo
{
	public class TimeTableRow
	{
		public var t:Number;
		public var q_dth:Number;
		public var q_cvd:Number;
		public var prod_dth:Number;
		public var prod_cvd:Number;
		
		public function TimeTableRow(t:Number, baseHazard_death:Number, baseHazard_cvd:Number)
		{
			this.t = t;
			q_dth = baseHazard_death;
			q_cvd = baseHazard_cvd;
			prod_dth = 1 - baseHazard_death;
			prod_cvd = 1 - baseHazard_cvd;
		}
		
		public function toString():String {
			return "" + t + ", " + q_dth + ", " + q_cvd; 
		}
	}
}