package org.understandinguncertainty.QRISKLifetime.interfaces
{
	import org.understandinguncertainty.QRISKLifetime.vo.QParametersVO;

	public interface IGenderRisks 
	{

		/**
		 * Get cardiovascular risk
		 */
		function cvd(p:QParametersVO):Number;
		
		/**
		 * Get death risk
		 */
		function death(p:QParametersVO):Number;

	}
}