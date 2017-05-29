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
#property description "VsV.MT4.VsVFX_TL - Ver.0.11.3.2 Update:2017.04.04"
#property strict


//--- FX.Indicator : Setup ---//
//*--- FX_BL.0.11.2.2 : Base.TrendeLine : 1x Base.TrendLine
//*--- 2-1. TrendLine(TL) : TL & Base.TL : 3x Base.TL & TL
//*--- 2-2. TrendLine(TL) : TL Cross * HL TrendLine
//*--- 3-1. EntryPoint & Exitpoint : RSI & Sto & HL
//*--- 3-2. EntryPoint & ExitPoint : SAR & BB & MA

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

//--- 2-1. TrendLine : TL & Base.TL : 3x Base.TL & TL
extern int SupportTime, ResistanceTime;
extern double sTime0, sPrice0, SupportPrice;
extern double rTime0, rPrice0, ResistancePrice;
extern double vSAR, vSAR01;
extern double vLow, vLow01;
extern double vHigh, vHigh01;

//--- SAR_Band : indicator parameters
extern double SAR_Step = 0.02;
extern double SAR_Max  = 0.2;


//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.0.11.3.1)          |
//+------------------------------------------------------------------+
int OnInit(void)
{
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

  //--- OUtput in Char
  for( cnt=0; cnt<=2; cnt++ )
  {
    //*--- 1. Base.TrendLine : Support.Setup
    ObjectCreate( "BaseSup:" + string(cnt), OBJ_HLINE, 0, 0, 0 );
    ObjectSet( "BaseSup:" + string(cnt), OBJPROP_COLOR, Goldenrod );

    //*--- 1. Base.TrendLine : Resistance.Setup
    ObjectCreate( "BaseRes:" + string(cnt), OBJ_HLINE, 0, 0, 0 );
    ObjectSet( "BaseRes:" + string(cnt), OBJPROP_COLOR, Goldenrod ); 
    ObjectSet( "BaseRes:" + string(cnt), OBJPROP_STYLE, STYLE_DOT ); 
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
  }

}

//***//


//+------------------------------------------------------------------+
//| FX.TrendLine (Ver.0.11.3.1) -> (Ver.0.11.3.2) vSAR               |
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

  ArraySetAsSeries( low, true );
  ArraySetAsSeries( high, true );

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
  rTime0[0] = BufHighPos[rt0];
  */

  //---* Support & Resistance : Moved Draw
  //---* Support.Minimum Moved Draw
  // ObjectMove( "BaseSup:0", 0, time[sTime0], sPrice0 );
  Print( "TLTime.Sup00=" + TimeToStr( time[(int)sTime0], TIME_DATE ) + "." + TimeToStr( time[(int)sTime0], TIME_MINUTES )
      + "/" + DoubleToStr( sPrice0, Digits ) + "/" + DoubleToStr( sTime0, 0 ) );
  /* (0.11.3.0)
  ObjectMove( "BaseSup:0", 0, time[st0], s0[0] );
  Print( "Time.Sup.00=" + TimeToStr( time[(int)sTime0[0]], TIME_DATE ) + "." + TimeToStr( time[(int)sTime0[0]], TIME_MINUTES ) 
    + "/" + DoubleToStr( s0[0], Digits ) + "/" + string(st0) + "/" + DoubleToStr( sTime0[0], 0 ) );
  */

  //---* Resistance.Maximum Moved Draw
  Print( "TLTime.Res00=" + TimeToStr( time[(int)rTime0], TIME_DATE ) + "." + TimeToStr( time[(int)rTime0], TIME_MINUTES )
    + "/" + DoubleToStr( rPrice0, Digits ) + "/" + DoubleToStr( rTime0, 0 ) );
  /* (0.11.3.0)
  ObjectMove( "BaseRes:0", 0, time[rt0], r0[0] ); 
  // Print( "Time.Res.00=" + TimeToStr( time[(int)((MaxLimit-1)/2+rTime0[0]-(rTime0[0]-rt0+1))], TIME_DATE ) + "." + TimeToStr( time[(int)((MaxLimit-1)/2+rTime0[0]-(rTime0[0]-rt0+1))], TIME_MINUTES ) 
  Print( "Time.Res.00=" + TimeToStr( time[(int)rTime0[0]], TIME_DATE ) + "." + TimeToStr( time[(int)rTime0[0]], TIME_MINUTES ) 
    + "/" + DoubleToStr( r0[0], Digits ) + "/" + string(rt0) + "/" + DoubleToStr( rTime0[0], 0 ) );
    // + "/" + DoubleToStr( r0[0], Digits ) + "/" + string(rt0) + "/" + DoubleToStr( rTime0[1], 0 ) + "/" + DoubleToStr( rTime0[0], 0 ) );
  */

//--- 2. TrendLine : Setup
  //---* 2-1. Trend Check : iSAR
  // for( int i=MaxLimit-1; i>=0; i-- )
  int limit=Bars-IndicatorCounted();

  for( int i=limit-1; i>=0; i-- )
  {
    vSAR    = iCustom( NULL, 0, "VsVFX_SAR", 0, i );
    vSAR01  = iCustom( NULL, 0, "VsVFX_SAR", 0, i+1 );

    vLow01  = iCustom( NULL, 0, "VsVFX_SAR", 1, i+1 );
    vHigh01 = iCustom( NULL, 0, "VsVFX_SAR", 2, i+1 );
 

    /* (Default.Setup)
    if(iSAR( NULL, 0, SAR_Step, SAR_Max, i+1 ) <= Low[i+1]
        && iSAR( NULL, 0, SAR_Step, SAR_Max, i+1 ) < High[i+1]
        && iSAR( NULL, 0, SAR_Step, SAR_Max, i ) >= High[i+1])
    {
      Print( "TL.SAR=Down.TrendLine." );
    }

    if(iSAR( NULL, 0, SAR_Step, SAR_Max, i+1 ) >= High[i+1]
        && iSAR( NULL, 0, SAR_Step, SAR_Max, i+1 ) > Low[i+1]
        && iSAR( NULL, 0, SAR_Step, SAR_Max, i ) <= Low[i+1])
    {
      Print( "TL.SAR=Up.TrendLine." );
    }
    */


    /*
    vSAR = iCustom( NULL, 0, "VsVSAR", 0, i );
    vSAR01=iCustom( NULL, 0, "VsVSAR", 0, i+1 );
 
    //---* Down.TrendLine : Setup
    if(vSAR01 <= low[i+1] && vSAR01 < high[i+1] && vSAR >= high[i+1] )
    {
      // Print( "TL.SAR=Up.TrendLine." );
      DwTL = -1;
    }
    //---* Up.TrendLine : Setup
    if(vSAR01 >= high[i+1] && vSAR01 > low[i+1] && vSAR <= low[i+1] )
    {
      // Print( "TL.SAR= Donw.TrendLine." );
      UpTL = 1;
    }
    */
  }

  // (OK) Print( "TL.SAR=" + DoubleToStr( low[0], Digits ) );

  Print( "TL.SAR=" + DoubleToStr( vSAR, 4 ) );
  Print( "TL.SAR01=" + DoubleToStr( vSAR01, 4 ) );

  Print( "TL.Low01=" + DoubleToStr( vLow01, 4 ) );
  Print( "TL.High01=" + DoubleToStr( vHigh01, 4 ) );

  if( vSAR01<=vLow01 && vSAR01 < vHigh01 && vSAR >= vHigh01 )
  {
    Print( "TL.Trend.Down" );
  }
  if( vSAR01 >= vHigh01 && vSAR01 > vLow01 && vSAR <= vLow01 )
  {
    Print( "TL.Trend.Up" );
  }




  /*
  if ( DwTL == -1)
  {
    Print( "TL.vLow=" + DoubleToStr( vLow, 4 ) );  
  }  
  if ( UpTL == 1)
  {
    Print( "TL.vHigh=" + DoubleToStr( vHigh, 4 ) );  
  }
  */

  



/* (Ver.0.11.3)
  if(sTime0[0]>rTime0[0])   // Sup.Price(Left) : Trend.Up
  {
    // Print( "sTime0:" + DoubleToStr( sTime0[0], 0 ) + " > rTIme0:" + DoubleToStr( rTime0[0], 0 ) );
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