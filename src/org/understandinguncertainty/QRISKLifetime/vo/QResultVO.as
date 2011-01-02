package org.understandinguncertainty.QRISKLifetime.vo
{
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
		
		public function QResultVO(nYearRisk:Number, lifetimeRisk:Number, error:Error=null)
		{
			this.nYearRisk = nYearRisk;
			this.lifetimeRisk = lifetimeRisk;
			this.error = error;
		}
	}
}