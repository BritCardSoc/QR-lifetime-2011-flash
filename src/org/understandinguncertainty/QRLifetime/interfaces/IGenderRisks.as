/*
This file forms part of the library which provides the JBS3Risk Risk Model.
It is ©2012 University of Cambridge.
It is released under version 3 of the GNU General Public License
Source code, including a copy of the license is available at https://github.com/BritCardSoc/JBS3Risk
*/
package org.understandinguncertainty.QRLifetime.interfaces
{
	import org.understandinguncertainty.QRLifetime.vo.QParametersVO;

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