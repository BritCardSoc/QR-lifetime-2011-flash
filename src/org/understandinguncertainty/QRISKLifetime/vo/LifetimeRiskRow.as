package org.understandinguncertainty.QRISKLifetime.vo
{
	public class LifetimeRiskRow
	{
		public var S_1:Number;
		public var cif_cvd:Number;
		public var cif_death:Number;
		public var S_noDeath:Number;		
		public var cvd_noDeath:Number;
		
		public function LifetimeRiskRow(S_1:Number, 
										cif_cvd_1:Number, 
										cif_death_1:Number, 
										S_noDeath:Number,
										cvd_noDeath:Number)
		{
			this.S_1 = S_1;					// survivors
			this.cif_cvd = cif_cvd_1;		// f ?
			this.cif_death = cif_death_1;	// m
			
			// these are used for Heart Age estimation
			this.S_noDeath = S_noDeath;			// survivors assuming only cvd 
			this.cvd_noDeath = cvd_noDeath;	// cumulative cvd assuming no death
		}
		
	}
}