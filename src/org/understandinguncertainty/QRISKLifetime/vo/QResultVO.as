package org.understandinguncertainty.QRISKLifetime.vo
{
	import org.understandinguncertainty.QRISKLifetime.LifetimeRiskTable;

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