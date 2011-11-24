package org.understandinguncertainty.QRISKLifetime
{
	import org.understandinguncertainty.QRISKLifetime.interfaces.IGenderRisks;
	import org.understandinguncertainty.QRISKLifetime.vo.QParametersVO;

	public class Male implements IGenderRisks
	{
		public function Male()
		{
		}
				
		private const ethriskCVD:Array = [
			0,
			0,
			0.4035656542786645300000000,
			0.7159343574607238700000000,
			0.7588068966921870400000000,
			0.2778257996405138500000000,
			-0.3383277413537653700000000,
			-0.3626891973109574500000000,
			-0.2406220118164148500000000,
			-0.1055741084408314400000000
		];
		
		public const smokeCVD:Array = [
			0,
			0.1655389770495527800000000,
			0.3227167436634277900000000,
			0.4393091679622852500000000,
			0.5830168090609184600000000
		];
		
		public function getSmokeCVDAt(index:int):Number
		{
			return smokeCVD[index];
		}
		
		public function cvd(p:QParametersVO):Number
		{
			/* Applying the fractional polynomial transforms */
			/* (which includes scaling)                      */
			//var bmi:Number = Math.log(p.bmi/10);
			
			/* Centring the continuous variables */
			// bmi -= 0.967572152614594;
			// p.rati -= 4.439734935760498;
			// p.sbp -= 133.265686035156250;
			// p.town += 0.164980158209801;
		
			/* Start of Sum */
			var a:Number = 0;
			
			/* The conditional sums */
			a += ethriskCVD[p.ethRisk];
			a += smokeCVD[p.smoke_cat];
			
			/* Sum from continuous values */
			a += (Math.log(p.bmi/10) - 0.967572152614594) * 0.4325953310683352500000000;
			a += (p.rati - 4.439734935760498) * 0.1616093175199347100000000;
			a += (p.sbp - 133.265686035156250) * 0.0051706475575211365000000;
			a += (p.town + 0.164980158209801) * 0.0118372789415412600000000;
			
			/* Sum from boolean values */
			a += p.b_AF * 0.4871573476846625100000000;
			a += p.b_ra * 0.3165460738113234400000000;
			a += p.b_renal * 0.4665323499934942400000000;
			a += p.b_treatedhyp * 0.3146452536778831000000000;
			a += p.b_type2 * 0.4700445024972483300000000;
			a += p.fh_cvd * 0.6101222792348441900000000;
			
			/* Sum from interaction terms */
			
			/* Calculate the score itself */
			return a;
		}
		
		private const ethriskDeath:Array = [
			0,
			0,
			-0.7959493840935216700000000,
			-0.8983542916653508600000000,
			-0.8464836394282484500000000,
			-1.3907364202494530000000000,
			-0.7939585494106227200000000,
			-0.6696772151327180500000000,
			-1.3074649266863319000000000,
			-1.0983395480170892000000000
		];
		
		private const smokeDeath:Array = [
			0,
			0.2306667408386281800000000,
			0.5716670855343914900000000,
			0.7849316319893276900000000,
			1.0119244230108204000000000
		];
		
		public function getSmokeDeathAt(index:int):Number
		{
			return smokeDeath[index];
		}
		
		public function death(p:QParametersVO):Number
		{
			
			/* Applying the fractional polynomial transforms */
			/* (which includes scaling)                      */
			//var bmi:Number = Math.log(p.bmi/10);
			
			/* Centring the continuous variables */
			//bmi -= 0.967572152614594;
			//p.rati -= 4.439734935760498;
			//p.sbp -= 133.265686035156250;
			//p.town += 0.164980158209801;			

			/* Start of Sum */
			var a:Number = 0;
			
			/* The conditional sums */
			a += ethriskDeath[p.ethRisk];
			a += smokeDeath[p.smoke_cat];
			
			/* Sum from continuous values */
			
			a += (Math.log(p.bmi/10) - 0.967572152614594) * -0.4077463700204617700000000;
			a += (p.rati - 4.439734935760498) * -0.0137508433127115260000000;
			a += (p.sbp - 133.265686035156250) * 0.0005828619709622257200000;
			a += (p.town + 0.164980158209801) * 0.0509394028862269410000000;
			
			/* Sum from boolean values */
			a += p.b_AF * 0.4141766179931511400000000;
			a += p.b_ra * 0.4757132805164633300000000;
			a += p.b_renal * 0.8498597130356305700000000;
			a += p.b_treatedhyp * 0.0722059208073983630000000;
			a += p.b_type2 * 0.4918060293979553700000000;
			a += p.fh_cvd * -0.3664212379436541700000000;
			
			/* Sum from interaction terms */
			
			/* Calculate the score itself */
			return a;
		}
	}
}