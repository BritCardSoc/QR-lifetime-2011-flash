/*
This file forms part of the library which provides the JBS3Risk Risk Model.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk

It contains code derived from http://qrisk.org/lifetime/QRISK-lifetime-2011-opensource.v1.0.tgz released by ClinRisk Ltd.

*/
package org.understandinguncertainty.QRLifetime
{
	import org.understandinguncertainty.QRLifetime.vo.LifetimeRiskRow;

	public class LifetimeRiskTable
	{
		public var rows:Vector.<LifetimeRiskRow> = new Vector.<LifetimeRiskRow>;
		public var index:int = 0;	
		
		public function get lifetimeRisk():Number
		{
			var lastRow:LifetimeRiskRow = rows[rows.length - 1];
			return lastRow.cif_cvd;
		}

		public function getRiskAt(index:int):Number
		{
			if(index < 0)
				return 0;
			return rows[index].cif_cvd;
		}
		
		public function getRiskNoDeathAt(index:int):Number
		{
			if(rows.length > index) {
				return rows[index].cvd_noDeath;
			}
			else
				return -1;
		}
		
/*		public function printTable():void {
			for(var i=0; i < 
		}
*/		
		public function getHazardAt(index:int):Number
		{
			if(index < 0)
				return 0;
			return (rows[index+1].cif_cvd - rows[index].cif_cvd)/rows[index].S_1;
		}
		
		public function getNoDeathHazardAt(index:int):Number
		{
			if(index < 0)
				return 0;
			return (rows[index+1].cvd_noDeath - rows[index].cvd_noDeath)/rows[index].S_noDeath;
		}
	}
}