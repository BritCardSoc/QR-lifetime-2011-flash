/*
This file forms part of the library which provides the JBS3Risk Risk Model.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk

It contains code derived from http://qrisk.org/lifetime/QRISK-lifetime-2011-opensource.v1.0.tgz released by ClinRisk Ltd.

*/
package org.understandinguncertainty.QRLifetime.vo
{
	import org.understandinguncertainty.QRLifetime.LifetimeRiskTable;

	/**
	 * QRisk lifetime result value object.
	 * 
	 * If error is null then nYearRisk and lifetimeRisk should be valid
	 * else error contains a valid error message.
	 * 
	 * The value object is shared between Native and Flash implementations
	 *  
	 * @author gmp26
	 * 
	 */
	public class QResultVO
	{
		public var nYearRisk:Number;
		public var lifetimeRisk:Number;
		public var error:Error;
		public var annualRiskTable:LifetimeRiskTable;
		public var annualRiskTable_int:LifetimeRiskTable;
		
		public function QResultVO(nYearRisk:Number, lifetimeRisk:Number, error:Error=null, 
								  annualRiskTable: LifetimeRiskTable = null,
								  annualRiskTable_int: LifetimeRiskTable = null
		)
		{
			this.nYearRisk = nYearRisk;
			this.lifetimeRisk = lifetimeRisk;
			this.annualRiskTable = annualRiskTable;
			this.annualRiskTable_int = annualRiskTable_int;
			this.error = error;
		}
	}
}