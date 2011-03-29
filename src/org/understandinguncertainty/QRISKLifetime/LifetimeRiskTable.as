package org.understandinguncertainty.QRISKLifetime
{
	import org.understandinguncertainty.QRISKLifetime.vo.LifetimeRiskRow;

	public class LifetimeRiskTable
	{
		public var rows:Vector.<LifetimeRiskRow> = new Vector.<LifetimeRiskRow>;
		public var index:int = 0;
				
		public function push(a:Number, basehaz_cvd_1:Number, basehaz_death_1:Number):void
		{
			// // S_1
			//*lifetimeRiskIndex=*(lifetimeRiskIndex-2)*a;
			
			// // cif_cvd
			//*(lifetimeRiskIndex+1) = *(lifetimeRiskIndex-1) + *(lifetimeRiskIndex-2) * basehaz_cvd_1;
			
			if(!(a==a && basehaz_cvd_1==basehaz_cvd_1))
				trace("bad parameters");
			
			if(rows.length == 0) {
				rows.push(new LifetimeRiskRow(a, 0, 0));
			}
			else {
				var lastRow:LifetimeRiskRow = rows[rows.length - 1];
				rows.push(new LifetimeRiskRow(lastRow.S_1*a, 
											lastRow.cif_cvd + lastRow.S_1 * basehaz_cvd_1, 
											lastRow.cif_death + lastRow.S_1 * basehaz_death_1));
			}
		}		
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
	}
}