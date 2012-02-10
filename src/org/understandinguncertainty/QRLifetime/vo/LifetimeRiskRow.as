/*
This file forms part of the library which provides the JBS3Risk Risk Model.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.QRLifetime.vo
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