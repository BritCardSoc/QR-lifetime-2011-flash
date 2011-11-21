package org.understandinguncertainty.QRISKLifetime
{
	import org.understandinguncertainty.QRISKLifetime.vo.LifetimeRiskRow;

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