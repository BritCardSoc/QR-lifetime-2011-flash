package org.understandinguncertainty.QRISKLifetime.vo
{
	public class LifetimeRiskRow
	{
		public var S_1:Number;
		public var cif_cvd:Number;
		public var cif_death:Number;
		
		public function LifetimeRiskRow(S_1:Number, cif_cvd_1:Number, cif_death_1:Number)
		{
			this.S_1 = S_1;					// survivors
			this.cif_cvd = cif_cvd_1;		// f ?
			this.cif_death = cif_death_1;	// m
		}
	}
}