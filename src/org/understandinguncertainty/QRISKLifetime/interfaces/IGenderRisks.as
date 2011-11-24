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

		/**
		 * Get cvd smoking log hazard ratio
		 */
		function getSmokeCVDAt(index:int):Number;
		
		/**
		 * Get death smoking log hazard ratio
		 */
		function getSmokeDeathAt(index:int):Number;
	}
}