//+------------------------------------------------------------------+
//|                        VerysVeryInc.MetaTrader4.FX.TrendLine.mq4 |
//|                  Copyright(c) 2016, VerysVery Inc. & Yoshio.Mr24 |
//|                             https://github.com/Mr24/MetaTrader4/ |
//|                                                 Since:2016.09.24 |
//|                                Released under the Apache license |
//|                       https://opensource.org/licenses/Apache-2.0 |
//|                                                            &     |
//+------------------------------------------------------------------+
//|                                                ExportLevels2.mq4 |
//|                      Copyright © 2006, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
//|                                       Ind-WSO+WRO+Trend Line.mq4 |
//|                    Copyright © 2004, http://www.expert-mt4.nm.ru |
//| Индикатор был разработан на основе индикатора Widners Oscilator. |
//|          Мною была разработана торговая стратегия, основанная на |
//|        показаниях Ind-WSO+WRO+Trend Line индикатора. Подробности |
//|                          вы можете узнать в форуме на моем сайте |
//|                          http://www.expert-mt4.nm.ru/forum.dhtml |
//+------------------------------------------------------------------+
#property copyright "Copyright(c) 2016 -, VerysVery Inc. && Yoshio.Mr24"
#property link      "https://github.com/VerysVery/MetaTrader4/"
#property description "VsV.MT4.VsVFX_TL - Ver.0.11.3.17 Update:2017.10.12"
#property strict


//--- FX.Indicator : Setup ---//
//*--- VsVFX_BL.0.11.2.2 : Base.TrendeLine : 1x Base.TrendLine
//*--- (OLD) 1. Base.TrendeLine(BL) : 3 TrendLine

//*--- VsVFX_SAR.0.0.2 & VsVFX_TL.0.11.3.3 : TL.Up&Down.TrendCheck : Up+1.Down-1
//*--- VsVFx_TL.0.11.3.14. TrendLine(TL) : Next.Point = SAR & MACD & Sto & RSI
//*--- 2-3. TrendLine(TL) : TL & Base.TL : 3x Base.TL & TL * HL
//*--- (OLD) 2. TrendLIne(TL) : TL Cross * HL TrendLine
//*--- (OLD) 2-1. TrendLine(TL) : TL & Base.TL : 3x Base.TL & TL
//*--- (OLD) 2-2. TrendLine(TL) : TL Cross * HL TrendLine

//*--- 3-1. EntryPoint & ExitPoint : TL Cross * HL TrendLine
//*--- 3-2. EntryPoint & Exitpoint : Tick * HL
//*--- 3-3. EntryPoint & Exitpoint : RSI & Sto & MACD
//*--- 3-4. EntryPoint & ExitPoint : SAR & BB & MA
//*--- (OLD) 3-1. EntryPoint & Exitpoint : RSI & Sto & HL
//*--- (OLD) 3-2. EntryPoint & ExitPoint : SAR & BB & MA

//--- FX.Indicator : Initial Setup ---//
#property indicator_chart_window


//--- 1. Base.TrendLine : Indicator Setup ---//
// (0.11.3.0) extern int BLPeriod = 3;
// (0.11.3.0) input int MaxLimit = 360;
int cnt;
int UpTL, DwTL;

//--- 1. Base.TrendLine : Indicator Buffer ---//
// (0.11.3.0) double BufLow[];
// (0.11.3.0) double BufLowPos[];
// (0.11.3.0) double BufHigh[];
// (0.11.3.0) double BufHighPos[];
/// int st0[];
// (0.11.3.0) double s0[], sTime0[];
// (0.11.3.0) double r0[], rTime0[];

//--- 2-1. TrendLine : TL.Up&Down.TrendCheck
extern int SupportTime, ResistanceTime;
extern double sTime0, sPrice0, SupportPrice;
extern double rTime0, rPrice0, ResistancePrice;
extern double vSAR, vSAR01;
extern double vLow, vLow01;
extern double vHigh, vHigh01;
extern double tLots;		// TrendCheckLots

//--- SAR_Band : indicator parameters
extern double SAR_Step = 0.02;
extern double SAR_Max  = 0.2;

//--- 2-2. TrendLine : Next.Point
//--- MACD & MACD.Center ---//
extern double vMACD, vMACD01, vMACD02;
extern double vMACDSig, vMACDSig01, vMACDSig02;
extern double mdCheck;		// MACD & Signal.Up&Down.Check
extern double mdCheckC00;	// MACD & Signal & C-0.Up&Down.Check
//--- Stochastic & Sto.Center ---//
extern double vSto, vSto01;
extern double vStoSig, vStoSig01;
extern double stoCheck;		// Sto & Signal.Up.Down.Check
// extern double stoCheckC00;	// Sto & Singnal & C-50.Up&Down.Check
extern double stoCheckC50;	// Sto & Singnal & C-50.Up&Down.Check
extern double stoPos;		// Sto & Signal & C-50.CurrentPosition
//--- RSI & RSI.Center ---//
extern double vRSI, vRSI01;
extern double rsiCheck;		// RSI Up.Down.Check
extern double rsiCheckC50; 	// RSI & C-50.Up&Down.Check
extern double rsiPos;		// RSI & C-50 & 30.70.Over & 40.60.Range.CurrentPosition

//--- 2-3. TrendLine(TL) : TL & Base.TL : 3x Base.TL & TL * HL
//--- Trend Buffer ---//
double BufTLUp[];
double BufTLDown[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.0.11.3.1)          |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- 2-3. TrendLine(TL) : TL & Base.TL : 3x Base.TL & TL * HL
  //--- 2 addtional Buffer used for Conting.
  IndicatorBuffers( 2 );

  //*--- Trend.Up Buffer
  SetIndexBuffer( 0, BufTLUp );
  ArraySetAsSeries( BufTLUp, true );
  //*-- Trend.Down Buffer
  SetIndexBuffer( 1, BufTLDown );
  ArraySetAsSeries( BufTLDown, true );


//--- 1. Base.TrendLine.Initial.Setup ---//
  //--- 2 Additional Buffer used for Conting.
  /* (0.11.3.0)
  IndicatorBuffers( 8 );

  //*--- Lowest Buffer
  SetIndexBuffer( 0, BufLow );
  ArraySetAsSeries( BufLow, true );
  //*--- Lowest Position Buffer
  SetIndexBuffer( 1, BufLowPos );
  ArraySetAsSeries( BufLowPos, true );

  //*--- Highest Buffer
  SetIndexBuffer( 2, BufHigh );
  ArraySetAsSeries( BufHigh, true );
  //*--- Highest Position Buffer
  SetIndexBuffer( 3, BufHighPos );
  ArraySetAsSeries( BufHighPos, true );

  //*--- Support.Data ---//
  // SetIndexBuffer( 4, st0 );
  // ArraySetAsSeries( st0, true );
  SetIndexBuffer( 4, s0 );
  ArraySetAsSeries( s0, true );
  SetIndexBuffer( 5, sTime0 );
  ArraySetAsSeries( sTime0, true );

  //*--- Resistance.Data ---//
  SetIndexBuffer( 6, r0 );
  ArraySetAsSeries( r0, true );
  SetIndexBuffer( 7, rTime0 );
  ArraySetAsSeries( rTime0, true );
  */

  //--- Output in Char
  for( cnt=0; cnt<=2; cnt++ )
  {
    //*--- 1. Base.TrendLine : Support.Setup
    ObjectCreate( "BaseSup:" + string(cnt), OBJ_HLINE, 0, 0, 0 );
    ObjectSet( "BaseSup:" + string(cnt), OBJPROP_COLOR, Goldenrod );

    //*--- 2-3. TrendLine(TL) : Trend.Up.Setup
    if(cnt<2)
    {
      ObjectCreate( "Trend.Up:" + string(cnt), OBJ_TREND, 0, 0, 0, 0, 0 );
      ObjectSet( "Trend.Up:" + string(cnt), OBJPROP_COLOR, Red );
      ObjectSet( "Trend.Up:" + string(cnt), OBJPROP_STYLE, STYLE_DOT );
    }


    //*--- 1. Base.TrendLine : Resistance.Setup
    ObjectCreate( "BaseRes:" + string(cnt), OBJ_HLINE, 0, 0, 0 );
    ObjectSet( "BaseRes:" + string(cnt), OBJPROP_COLOR, Goldenrod ); 
    ObjectSet( "BaseRes:" + string(cnt), OBJPROP_STYLE, STYLE_DOT ); 

    //*--- 2-3. TrendLine(TL) : Trend.Down.Setup
    if(cnt<2)
    {
      ObjectCreate( "Trend.Down:" + string(cnt), OBJ_TREND, 0, 0, 0, 0, 0 );
      ObjectSet( "Trend.Down:" + string(cnt), OBJPROP_COLOR, Blue );
      ObjectSet( "Trend.Down" + string(cnt), OBJPROP_STYLE, STYLE_DOT );
    }

    //--- Default.Trend.Setup
    //*--- 2-3. TrendLine(TL) : New.TrendLine
    ObjectSet( "Trend.Up:0", OBJPROP_COLOR, Red );
    ObjectSet( "Trend.Up:0", OBJPROP_STYLE, STYLE_SOLID );
    ObjectSet( "Trend.Down:0", OBJPROP_COLOR, Blue );
    ObjectSet( "Trend.Down:0", OBJPROP_STYLE, STYLE_SOLID );
  }


//--- initialization done
  return(INIT_SUCCEEDED);

}

//***//


//+------------------------------------------------------------------+
//| Custom Deindicator initialization function (Ver.0.11.0)          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//--- 1. Base.TrendLine : ToDo & Code Here
  for( cnt=0; cnt<=2; cnt++ ){
    ObjectDelete( "BaseSup:" + string(cnt) );
    ObjectDelete( "BaseRes:" + string(cnt) );

    //*--- 2-3. TrendLine(TL) : TL & Base.TL : 3x Base.TL & TL * HL
    ObjectDelete( "Trend.Up:" + string(cnt) );
    ObjectDelete( "Trend.Down:" + string(cnt) );
  }

}

//***//


//+------------------------------------------------------------------+
//| FX.TrendLine (Ver.0.11.3.10) vSAR + vMACD + vSto + vRSI          |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
//--- 1. Base.TrendLine : Caluculate.Setup ---//
  //---* ToDo & Code Here
  //---* Support.Initial
  /// int     st0=0,    st1=0,    st2=0, sPos;
  // (0.11.3.0) int st0=0, sPos;
  /// double  s0=0.00,  s1=0.00,  s2=0.00;
  /// double  sTime0;

  //---* Resistance.Initial
  /// int     rt0=0,    rt1=0,    rt2=0, rPos;
  // (0.11.3.0) int rt0=0, rPos;
  /// double  r0=0.00,  r1=0.00,  r2=0.00;
  ///  double  rTime0;

  // (0.11.3.15) ArraySetAsSeries( low, true );
  // (0.11.3.15) ArraySetAsSeries( high, true );

  //---* Support & Resistance : Calculate ---//
  /* (0.11.3.0)
  for( int i=MaxLimit-1; i>=0; i-- )
  {
    //---* Support Calculate ---//
    BufLowPos[i] = ArrayMinimum( low, (MaxLimit-1)/2, i );
    sPos = (int)BufLowPos[i];
    BufLow[i]=low[sPos];

    //---* Resistance Calculate ---//
    BufHighPos[i] = ArrayMaximum( high, (MaxLimit-1)/2, i );
    rPos = (int)BufHighPos[i];
    BufHigh[i]=high[rPos];
  }
  */

  //---* Support & Resistance : Data
  //---* Support.Minimum Data ---//
  sTime0  = iCustom( NULL, 0, "VsVFX_BL", 5, 0 );
  sPrice0 = iCustom( NULL, 0, "VsVFX_BL", 4, 0 );
  /* (0.11.3.0)
  st0 = ArrayMinimum( BufLow, MaxLimit-1, 0 );
  s0[0] = BufLow[st0];
  sTime0[0] = BufLowPos[st0];
  */
  

  //---* Resistance.Maximum Data ---//
  rTime0  = iCustom( NULL, 0, "VsVFX_BL", 7, 0 );
  rPrice0 = iCustom( NULL, 0, "VsVFX_BL", 6, 0 ); 
  /* (0.11.3.0)
  rt0 = ArrayMaximum( BufHigh, MaxLimit-1, 0 );
  r0[0] = BufHigh[rt0];
  // rTime0[1] = BufLowPos[rt0];
  // rTime0[0] = (MaxLimit-1)/2+rTime0[1]-(rTime0[1]-rt0+1);
  rTime0[0] = BufHighPos[rt0];ƒ
  */

  //---* Support & Resistance : Moved Draw
  //---* Support.Minimum Moved Draw
  ObjectMove( "BaseSup:0", 0, time[(int)sTime0], sPrice0 );
  Print( "Time.Sup.00=" + TimeToStr( time[(int)sTime0], TIME_DATE ) + "." 
    + TimeToStr( time[(int)sTime0], TIME_MINUTES ) 
    + "/" + DoubleToStr( sPrice0, Digits )
    // + "/" + string(sTime0) 
    + "/" + DoubleToStr( sTime0, 0 ) );

  /* (0.11.3.7)
  Print( "TLTime.Sup00=" + TimeToStr( time[(int)sTime0], TIME_DATE ) + "." + TimeToStr( time[(int)sTime0], TIME_MINUTES )
      + "/" + DoubleToStr( sPrice0, Digits ) + "/" + DoubleToStr( sTime0, 0 ) );
  */
  /* (0.11.3.0)
  ObjectMove( "BaseSup:0", 0, time[st0], s0[0] );
  Print( "Time.Sup.00=" + TimeToStr( time[(int)sTime0[0]], TIME_DATE ) + "." + TimeToStr( time[(int)sTime0[0]], TIME_MINUTES ) 
    + "/" + DoubleToStr( s0[0], Digits ) + "/" + string(st0) + "/" + DoubleToStr( sTime0[0], 0 ) );
  */

  //---* Resistance.Maximum Moved Draw
  ObjectMove( "BaseRes:0", 0, time[(int)rTime0], rPrice0 );
  Print( "Time.Res.00=" + TimeToStr( time[(int)rTime0], TIME_DATE ) + "." 
    + TimeToStr( time[(int)rTime0], TIME_MINUTES ) 
    + "/" + DoubleToStr( rPrice0, Digits ) 
    // + "/" + string(rTime0) 
    + "/" + DoubleToStr( rTime0, 0 ) );

  /* (0.11.3.7)
  Print( "TLTime.Res00=" + TimeToStr( time[(int)rTime0], TIME_DATE ) + "." + TimeToStr( time[(int)rTime0], TIME_MINUTES )
    + "/" + DoubleToStr( rPrice0, Digits ) + "/" + DoubleToStr( rTime0, 0 ) );
  */
  /* (0.11.3.0)
  ObjectMove( "BaseRes:0", 0, time[rt0], r0[0] ); 
  // Print( "Time.Res.00=" + TimeToStr( time[(int)((MaxLimit-1)/2+rTime0[0]-(rTime0[0]-rt0+1))], TIME_DATE ) + "." + TimeToStr( time[(int)((MaxLimit-1)/2+rTime0[0]-(rTime0[0]-rt0+1))], TIME_MINUTES ) 
  Print( "Time.Res.00=" + TimeToStr( time[(int)rTime0[0]], TIME_DATE ) + "." + TimeToStr( time[(int)rTime0[0]], TIME_MINUTES ) 
    + "/" + DoubleToStr( r0[0], Digits ) + "/" + string(rt0) + "/" + DoubleToStr( rTime0[0], 0 ) );
    // + "/" + DoubleToStr( r0[0], Digits ) + "/" + string(rt0) + "/" + DoubleToStr( rTime0[1], 0 ) + "/" + DoubleToStr( rTime0[0], 0 ) );
  */

//--- 2. TrendLine : Caluculate.Setup ---//
  //---* 2-1. Trend Check : iSAR & iMACD & iSto & iRSI
  // for( int i=MaxLimit-1; i>=0; i-- )
  int limit=Bars-IndicatorCounted();
  // tLots = 0.0;
  mdCheckC00  = 0.0;
  // stoCheckC00 = 0.0;
  stoCheckC50 = 0.0;
  rsiCheckC50 = 0.0;

  for( int i=limit-1; i>=0; i-- )
  {
  //*--- 2-1. TrendLine : TL.Up&Down.TrendCheck
  vSAR    = iCustom( NULL, 0, "VsVFX_SAR", 0, i );
  vSAR01  = iCustom( NULL, 0, "VsVFX_SAR", 0, i+1 );

  vLow01  = iCustom( NULL, 0, "VsVFX_SAR", 1, i+1 );
  vHigh01 = iCustom( NULL, 0, "VsVFX_SAR", 2, i+1 );

	//*--- 2-2. TrendLine : Next.Point
	//*--- MACD ---//
	vMACD 	= iCustom( NULL, 0, "VsVMACD", 0, i );
	vMACD01 = iCustom( NULL, 0, "VsVMACD", 0, i+1 );
	vMACD02	= iCustom( NULL, 0, "VsVMACD", 0, i+2 );

	vMACDSig 	= iCustom( NULL, 0, "VsVMACD", 1, i );	
	vMACDSig01 	= iCustom( NULL, 0, "VsVMACD", 1, i+1 );
	vMACDSig02	= iCustom( NULL, 0, "VsVMACD", 1, i+2 );

	//*--- Stochastic ---//
	vSto 	= iCustom( NULL, 0, "VsVSto", 0, i );
	vSto01 	= iCustom( NULL, 0, "VsVSto", 0, i+1 );

	vStoSig 	= iCustom( NULL, 0, "VsVSto", 1, i );
	vStoSig01	= iCustom( NULL, 0, "VsVSto", 1, i+1 );

	//*--- RSI ---//
	vRSI 	= iCustom( NULL, 0, "VsVFX_RSI", 0, 0 );
	vRSI01 	= iCustom( NULL, 0, "VsVFX_RSI", 0, 1 );

  }

  //*--- 2-1. TrendLine : TL.Up&Down.TrendCheck
  /* (0.11.3.7)
  Print( "TL.SAR=" + DoubleToStr( vSAR, 4 ) + " / TL.SAR01=" + DoubleToStr( vSAR01, 4 ) 
  		+ " / TL.High01=" + DoubleToStr( vHigh01, 4 ) + " / TL.Low01=" + DoubleToStr( vLow01, 4 ) );
  */

  if( vSAR01<=vLow01 && vSAR01 < vHigh01 && vSAR >= vHigh01 )
  {
    //*--- TL.Trend.Down
    tLots = -1;
    // (0.11.3.7) Print( "TL.Trend.Down.tLots=" + DoubleToStr( tLots, 0 ) );
  }
  if( vSAR01 >= vHigh01 && vSAR01 > vLow01 && vSAR <= vLow01 )
  {
    //*--- TL.Trend.Up
    tLots = 1;
    // (0.11.3.7) Print( "TL.Trend.Up.tLots=" + DoubleToStr( tLots, 0 ) );
  }

  //*--- 2-2. TrendLine : Next.Point
  //*--- MACD ---//
  Print( "TL.MACD=" + DoubleToStr( vMACD, 4 ) 
  	+ " / TL.MACDSig=" + DoubleToStr( vMACDSig, 4 )
  	+ " / TL.MACD01=" + DoubleToStr( vMACD01, 4 ) 
  	+ " / TL.MACDSig01=" + DoubleToStr( vMACDSig01, 4 )
  	+ " / TL.MACD02=" + DoubleToStr( vMACD02, 4 ) 
  	+ " / TL.MACDSig02=" + DoubleToStr( vMACDSig02, 4 ) );
  
  /* (0.11.3.7)
  Print( "TL.MACD=" + DoubleToStr( vMACD, 4 ) + " / TL.MACD01=" + DoubleToStr( vMACD01, 4 ) 
  	+ " / TL.MACDSig=" + DoubleToStr( vMACDSig, 4 ) + " / TL.MACDSig01=" + DoubleToStr( vMACDSig01, 4 ) );
  */

  //--- MACD.Trend.Up ---//
  // (Ver.0.11.3.8) if( vMACD01 <= vMACDSig01 && vMACD > vMACDSig )
  if( vMACD02 <= vMACDSig02 && vMACD01 > vMACDSig01 )
  {
  	mdCheck = 1;
  	// (0.11.3.7) Print( "TL.MACD.Up=" + DoubleToStr( mdCheck, 0 ) );
  }
  //--- MACD.Trend.Down ---//
  // (Ver.11.3.8) if( vMACD01 >= vMACDSig01 && vMACD < vMACDSig )
  if( vMACD02 >= vMACDSig02 && vMACD01 < vMACDSig01 )
  {
  	mdCheck = -1;
  	// (0.11.3.7) Print( "TL.MACD.Down=" + DoubleToStr( mdCheck, 0 ));
  }

  //--- MACD.Center.Up ---//
  if( vMACD01 < 0 && vMACD > vMACDSig && vMACD > 0) mdCheckC00 = 1;
  //--- MACD.Center.Down ---//
  if( vMACD01 > 0 && vMACD < vMACDSig && vMACD < 0) mdCheckC00 = -1;
  // (0.11.3.7) Print( "TL.MACD.Center=" + DoubleToStr( mdCheckC00, 0 ) );


  //*--- Stochastic ---//
  /* (0.11.3.7)
  Print( "TL.Sto=" + DoubleToStr( vSto, 4 ) 
  	+ " / TL.Sto01=" + DoubleToStr( vSto01, 4 ) 
  	+ " / TL.StoSig=" + DoubleToStr( vStoSig, 4 ) 
  	+ " / TL.StoSig01=" + DoubleToStr( vStoSig01, 4 ) );
  */


  //--- Stochastic.Trend.Up ---//
  if( vSto01 <= vStoSig01 && vSto > vStoSig )
  {
  	stoCheck = 1;
  	// Print( "TL.Sto.Up=" + DoubleToStr( stoCheck, 0 ) );
  }
  //--- Stochastic.Trend.Down ---//
  if( vSto01 >= vStoSig01 && vSto < vStoSig )
  {
  	stoCheck = -1;
  	// Print( "TL.Sto.Down=" + DoubleToStr( stoCheck, 0 ));
  }

  //--- Stochastic.Center.x.Up ---//
  // if( vSto01 < 50 && vSto > 50 && vSto > vStoSig ) stoCheckC00 = 1;
  if( vSto01 < 50 && vSto > 50 && vSto > vStoSig ) stoCheckC50 = 1;
  //--- Stochastic.Center.x.Down ---//
  // if( vSto01 > 50 && vSto < 50 && vSto < vStoSig ) stoCheckC00 = -1;
  if( vSto01 > 50 && vSto < 50 && vSto < vStoSig ) stoCheckC50 = -1;
  // Print( "TL.Sto.Center=" + DoubleToStr( stoCheckC00, 0 ) );
  Print( "TL.Sto.Center.50=" + DoubleToStr( stoCheckC50, 0 )
  		 + " / TL.Sto01=" + DoubleToStr( vSto01, 4 )
  		 + " / TL.Sto=" + DoubleToStr( vSto, 4 )
  		 + " / TL.StoSig=" + DoubleToStr( vStoSig, 4 ) );

  //--- Stochastic.Position ---//
  //*--- Sto.Center.x ---//
  if( vSto01 < 50 && vSto01 >= vStoSig01 && vSto > 50 && vSto > vStoSig ) stoPos = 1;
  if( vSto01 > 50 && vSto01 <= vStoSig01 && vSto < 50 && vSto < vStoSig ) stoPos = -1;

  //*--- vSto01 > 50 & vSto > 50 ---//
  //*--- 50.UpUp
  if( vSto01 > 50 && vSto01 >= vStoSig01 && vSto > 50 && vSto > vStoSig ) stoPos = 2;
  //*--- 50.DownDown
  if( vSto01 > 50 && vSto01 <= vStoSig01 && vSto > 50 && vSto < vStoSig ) stoPos = -2;
  //*--- 50.xUp
  if( vSto01 > 50 && vSto01 <= vStoSig01 && vSto > 50 && vSto > vStoSig ) stoPos = 3;
  //*--- 50.xDown
  if( vSto01 > 50 && vSto01 >= vStoSig01 && vSto > 50 && vSto < vStoSig ) stoPos = -3;
  
  //*--- vSto01 < 50 & vSto < 50 ---//
  //*--- -50.UpUp
  if( vSto01 < 50 && vSto01 >= vStoSig01 && vSto < 50 && vSto > vStoSig ) stoPos = 4;
  //*--- -50.DownDown
  if( vSto01 < 50 && vSto01 <= vStoSig01 && vSto < 50 && vSto < vStoSig ) stoPos = -4;
  //*--- -50.xUp
  if( vSto01 < 50 && vSto01 <= vStoSig01 && vSto < 50 && vSto > vStoSig ) stoPos = 5;
  //*--- -50.xDown
  if( vSto01 < 50 && vSto01 >= vStoSig01 && vSto < 50 && vSto < vStoSig ) stoPos = -5;
  // Print( "TL.StoPos=" + DoubleToStr( stoPos, 0 ) );


  //*--- RSI ---//
  /* (Ver.0.11.3.10) */
  // Print( "TL.RSI=" + DoubleToStr( vRSI, 4 ) 
  // 	+ " / TL.RSI01=" + DoubleToStr( vRSI01, 4 ) );

  //--- RSI.Trend.Up ---//
  if( vRSI > vRSI01 )
  {
  	rsiCheck = 1;
  	//  Print( "TL.RSI.Up=" + DoubleToStr( rsiCheck, 0 ) );
  }
  //--- RSI.Trend.Down ---//
  if( vRSI < vRSI01 )
  {
  	rsiCheck = -1;
  	// Print( "TL.RSI.Down=" + DoubleToStr( rsiCheck, 0 ));
  }

  //--- RSI.Center.x.Up ---//
  if( vRSI01 < 50 && vRSI > 50 && vRSI > vRSI01 ) rsiCheckC50 = 1;
  //--- RSI.Center.x.Down ---//
  if( vRSI01 > 50 && vRSI < 50 && vRSI < vRSI01 ) rsiCheckC50 = -1;
  Print( "TL.RSI.Center.50=" + DoubleToStr( rsiCheckC50, 0 )
  		+ " / TL.RSI01=" + DoubleToStr( vRSI01, 4 )
  		+ " / TL.RSI=" + DoubleToStr( vRSI, 4 ) );

  //--- RSI.Position ---//
  //*--- RSI.Center.x ---//
  if( vRSI01 < 50 && vRSI > 50 && vRSI > vRSI01 ) rsiPos = 50;
  if( vRSI01 > 50 && vRSI < 50 && vRSI < vRSI01 ) rsiPos = -50;

  //*--- RSI.Resistance.Range ---//
  //*--- 56.UpUp : 50 < vRSI01 <= 60 && 50 < vRSI <= 60 
  if( vRSI01 > 50 && vRSI01 <= 60 && vRSI > 50 && vRSI <= 60 && vRSI > vRSI01 ) rsiPos = 56;
  //*--- 67.UpUp : 60 < vRSI01 <= 70 && 60 < vRSI <= 70
  if( vRSI01 > 60 && vRSI01 <= 70 && vRSI > 60 && vRSI <= 70 && vRSI > vRSI01 ) rsiPos = 67;
  //*--- 77.UpUp : 70 < vRSI01 <= 100 && 70 < vRSI <= 100
  if( vRSI01 > 70 && vRSI01 <= 100 && vRSI > 70 && vRSI <= 100 && vRSI > vRSI01 ) rsiPos = 77;
  //*--- 60.xUp : 50 < vRSI01 <= 60 && 60 < vRSI <= 70 
  if( vRSI01 > 50 && vRSI01 <= 60 && vRSI > 60 && vRSI <= 70 && vRSI > vRSI01 ) rsiPos = 60;
  //*--- 70.xUp : 60 < vRSI01 <= 70 && 70 < vRSI <= 100 
  if( vRSI01 > 60 && vRSI01 <= 70 && vRSI > 70 && vRSI <= 100 && vRSI > vRSI01 ) rsiPos = 70;
  //*--- 70.xUp : vRSI01 <= 70 && 70 < vRSI <= 100
  // if( vRSI01 <= 70 && vRSI > 70 && vRSI <= 100 && vRSI > vRSI01 ) rsiPos = 70;

  //*--- -56.DownDown : 50 < vRSI01 <= 60 && 50 < vRSI <= 60 
  if( vRSI01 > 50 && vRSI01 <= 60 && vRSI > 50 && vRSI <= 60 && vRSI < vRSI01 ) rsiPos = -56;
  //*--- -67.DownDown : 60 < vRSI01 <= 70 && 60 < vRSI <= 70
  if( vRSI01 > 60 && vRSI01 <= 70 && vRSI > 60 && vRSI <= 70 && vRSI < vRSI01 ) rsiPos = -67;
  //*--- -77.DownDown : 70 < vRSI01 <= 100 && 70 < vRSI <= 100
  if( vRSI01 > 70 && vRSI01 <= 100 && vRSI > 70 && vRSI <= 100 && vRSI < vRSI01 ) rsiPos = -77;
  //*--- -60.xDown : 60 < vRSI01 <= 70 && 50 < vRSI <= 60 
  if( vRSI01 > 60 && vRSI01 <= 70 && vRSI > 50 && vRSI <= 60 && vRSI < vRSI01 ) rsiPos = -60;
  //*--- -70.xDown : 70 < vRSI01 <= 100 && 60 < vRSI <= 70 
  if( vRSI01 > 70 && vRSI01 <= 100 && vRSI > 60 && vRSI <= 70 && vRSI < vRSI01 ) rsiPos = -70;
  //*--- -70.xDown : 70 < vRSI01 <= 100 && vRSI <= 70 
  // if( vRSI01 > 70 && vRSI01 <= 100 && vRSI <= 70 && vRSI < vRSI01 ) rsiPos = -70;

  //*--- RSI.Support.Range ---//
  //*--- 45.UpUp : 40 <= vRSI01 < 50 && 40 <= vRSI < 50 
  if( vRSI01 >= 40 && vRSI01 < 50 && vRSI >= 40 && vRSI < 50 && vRSI > vRSI01 ) rsiPos = 45;
  //*--- 34.UpUp : 30 <= vRSI01 < 40 && 30 <= vRSI < 40 
  if( vRSI01 >= 30 && vRSI01 < 40 && vRSI >= 30 && vRSI < 40 && vRSI > vRSI01 ) rsiPos = 34;
  //*--- 33.UpUp : 0 <= vRSI01 < 30 && 0 <= vRSI < 30 
  if( vRSI01 >= 0 && vRSI01 < 30 && vRSI >= 0 && vRSI < 30 && vRSI > vRSI01 ) rsiPos = 33;
  //*--- 40.xUp : 30 <= vRSI01 < 40 && 40 <= vRSI < 50 
  if( vRSI01 >= 30 && vRSI01 < 40 && vRSI >= 40 && vRSI < 50 && vRSI > vRSI01 ) rsiPos = 40;
  //*--- 30.xUp : 0 <= vRSI01 < 30 && 30 <= vRSI < 40 
  if( vRSI01 >= 0 && vRSI01 < 30 && vRSI >= 30 && vRSI < 40 && vRSI > vRSI01 ) rsiPos = 30;
  //*--- 30.xUp : 0 <= vRSI01 < 30 && 30 <= vRSI 
  // if( vRSI01 >= 0 && vRSI01 < 30 && vRSI >= 30 && vRSI > vRSI01 ) rsiPos = 30;
  
  //*--- -45.DownDown : 40 <= vRSI01 < 50 && 40 <= vRSI < 50 
  if( vRSI01 >= 40 && vRSI01 < 50 && vRSI >= 40 && vRSI < 50 && vRSI < vRSI01 ) rsiPos = -45;
  //*--- -34.DownDown : 30 <= vRSI01 < 40 && 30 <= vRSI < 40 
  if( vRSI01 >= 30 && vRSI01 < 40 && vRSI >= 30 && vRSI < 40 && vRSI < vRSI01 ) rsiPos = -34;
  //*--- -33.DownDown : 0 <= vRSI01 < 30 && 0 <= vRSI < 30 
  if( vRSI01 >= 0 && vRSI01 < 30 && vRSI >= 0 && vRSI < 30 && vRSI < vRSI01 ) rsiPos = -33;
  //*--- -40.xDown : 40 <= vRSI01 < 50 && 30 <= vRSI < 40 
  if( vRSI01 >= 40 && vRSI01 < 50 && vRSI >= 30 && vRSI < 40 && vRSI < vRSI01 ) rsiPos = -40;
  //*--- -30.xDown : 30 <= vRSI01 < 40 && 0 <= vRSI < 30 
  if( vRSI01 >= 30 && vRSI01 < 40 && vRSI >= 0 && vRSI < 30 && vRSI < vRSI01 ) rsiPos = -30;
  //*--- -30.xDown : 30 <= vRSI01 < 40 && 0 <= vRSI 
  // if( vRSI01 >= 30 && vRSI01 < 40 && vRSI >= 0 && vRSI < vRSI01 ) rsiPos = -30;
  
  Print( "TL.RSIPos=" + DoubleToStr( rsiPos, 0 )
  		+ " / TL.RSI01=" + DoubleToStr( vRSI01, 4 )
  		+ " / TL.RSI=" + DoubleToStr( vRSI, 4 ) );


  //*--- SAR & MACD & Sto & RSI ---//
  Print( "tLots=" + DoubleToStr( tLots, 0 ) 
  		+ " / MACDCheck=" + DoubleToStr( mdCheck, 0 )
  		+ " / MACD.CenterCheck=" + DoubleToStr( mdCheckC00, 0 )
  		+ " / StoCheck=" + DoubleToStr( stoCheck, 0 )
  		// + " / TL.Sto.CenterCheck=" + DoubleToStr( stoCheckC00, 0 )
  		+ " / Sto.Center50Check=" + DoubleToStr( stoCheckC50, 0 )
  		+ " / Sto.Position=" + DoubleToStr( stoPos, 0 )
  		+ " / RSICheck=" + DoubleToStr( rsiCheck, 0 )
  		+ " / RSI.Center50Check=" + DoubleToStr( rsiCheckC50, 0 )
  		+ " / RSI.Position=" + DoubleToStr( rsiPos, 0 ) );

  //*--- 2-3. TrendLine(TL) : TL & Base.TL : 3x Base.TL & TL * HL
  //*--- Base.TL ---//
  //*--- sTime0 < rTime0
  if( sTime0 < rTime0 )
  {
    //*--- Test.Trend.Down(OK) ---*//
    /*
    ObjectMove( "Trend.Down:0", 0, time[(int)rTime0], rPrice0 );
    ObjectMove( "Trend.Down:0", 1, time[(int)sTime0], sPrice0 );  
    */

    Print( "sTime0=" + TimeToStr( time[(int)sTime0], TIME_MINUTES ) 
    + "/" + DoubleToStr( sPrice0, Digits )); 
  }
  //*--- rTime0 < sTime0
  if( sTime0 > rTime0 )
  {
    //*--- Test.Trend.Up(OK) ---*//
    /*
    ObjectMove( "Trend.Up:0", 0, time[(int)sTime0], sPrice0 );
    ObjectMove( "Trend.Up:0", 1, time[(int)rTime0], rPrice0 );    
    */

    Print( "rTime0=" + TimeToStr( time[(int)rTime0], TIME_MINUTES ) 
    + "/" + DoubleToStr( rPrice0, Digits ) );  
  }

 
/* (Ver.0.11.3)
  if(sTime0[0]>rTime0[0])   // Sup.Price(Left) : Trend.Up
  {
    // Print( "sTime0:" + DoubleToStr( sTime0[0], 0 ) + " > rTime0:" + DoubleToStr( rTime0[0], 0 ) );
  }
  if(rTime0[0]>sTime0[0])   // Res.Price(Left) : Trend.Down
  {
    // Print( "rTime0:" + DoubleToStr( rTime0[0], 0 ) + " > sTime0:" + DoubleToStr( sTime0[0], 0 ) );
  }
*/



//---- OnCalculate done. Return new prev_calculated.
  return(rates_total);

}

//+------------------------------------------------------------------+