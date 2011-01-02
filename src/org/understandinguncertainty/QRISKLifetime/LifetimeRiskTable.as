package org.understandinguncertainty.QRISKLifetime
{
	import org.understandinguncertainty.QRISKLifetime.vo.LifetimeRiskRow;

	public class LifetimeRiskTable
	{
		public var rows:Vector.<LifetimeRiskRow>;
		public var index:int = 0;
		
		public function setFirstRow(a:Number):void
		{
			rows = new Vector.<LifetimeRiskRow>;
			rows.push(new LifetimeRiskRow(a, 0));
		}
		
		public function push(a:Number, basehaz_cvd_1:Number):void
		{
			// // S_1
			//*lifetimeRiskIndex=*(lifetimeRiskIndex-2)*a;
			
			// // cif_cvd
			//*(lifetimeRiskIndex+1) = *(lifetimeRiskIndex-1) + *(lifetimeRiskIndex-2) * basehaz_cvd_1;

			var lastRow:LifetimeRiskRow = rows[rows.length - 1];
			rows.push(new LifetimeRiskRow(lastRow.S_1*a, lastRow.cif_cvd + lastRow.S_1 * basehaz_cvd_1));
		}
		
		public function get lifetimeRisk():Number
		{
			var lastRow:LifetimeRiskRow = rows[rows.length - 1];
			return lastRow.cif_cvd;
		}

		public function getRiskAt(index:int):Number
		{
			var lastRow:LifetimeRiskRow = rows[index];
			return lastRow.cif_cvd;
		}
	}
}