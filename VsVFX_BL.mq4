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
#property copyright "Copyright(c) 2016 -, VerysVery Inc. && Yoshio.Mr24"
#property link      "https://github.com/VerysVery/MetaTrader4/"
#property description "VsV.MT4.VsVFX_BL - Ver.0.11.2 Update:2017.02.25"
#property strict


//--- FX.Indicator : Setup ---//
//*--- 1. Base.TrendeLine(BL) : 3 TrendLine
//*--- 2. TrendLIne(TL) : TL Cross * HL TrendLine
//*--- 3-1. EntryPoint & Exitpoint : RSI & Sto
//*--- 3-2. EntryPoint & ExitPoint : SAR & BB & MA

//--- FX.Indicator : Initial Setup ---//
#property indicator_chart_window


//--- 1. Base.TrendLine : Indicator Setup ---//
extern int BLPeriod = 3;
input int MaxLimit = 360;
int cnt;

//--- 1. Base.TrendLine : Indicator Buffer ---//
double BufLow[];
double BufLowPos[];
double BufHigh[];
double BufHighPos[];
// int st0[];
double s0[], sTime0[];
double r0[], rTime0[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.0.11.0)            |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- 1. Base.TrendLine.Initial.Setup ---//
  //--- 2 Additional Buffer used for Conting.
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


  //--- OUtput in Char
  for( cnt=0; cnt<=2; cnt++ )
  {
    //*--- 1. Base.TrendLine : Support.Setup
    ObjectCreate( "BaseSup:" + string(cnt), OBJ_HLINE, 0, 0, 0 );
    ObjectSet( "BaseSup:" + string(cnt), OBJPROP_COLOR, Goldenrod );

    //*--- 1. Base.TrendLine : Resistance.Setup
    ObjectCreate( "BaseRes:" + string(cnt), OBJ_HLINE, 0, 0, 0 );
    ObjectSet( "BaseRes:" + string(cnt), OBJPROP_COLOR, Goldenrod );  
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
//| FX.TrendLine (Ver.0.11.1)                                        |
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
  // int     st0=0,    st1=0,    st2=0, sPos;
  int st0=0, sPos;
  // double  s0=0.00,  s1=0.00,  s2=0.00;
  // double  sTime0;

  //---* Resistance.Initial
  // int     rt0=0,    rt1=0,    rt2=0, rPos;
  int rt0=0, rPos;
  // double  r0=0.00,  r1=0.00,  r2=0.00;
  // double  rTime0;

  ArraySetAsSeries( low, true );
  ArraySetAsSeries( high, true );

  //---* Support & Resistance : Calculate ---//
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

  //---* Support & Resistance : Data
  //---* Support.Minimum Data ---//
  st0 = ArrayMinimum( BufLow, MaxLimit-1, 0 );
  s0[0] = BufLow[st0];
  sTime0[0] = BufLowPos[st0];

  //---* Resistance.Maximum Data ---//
  rt0 = ArrayMaximum( BufHigh, MaxLimit-1, 0 );
  r0[0] = BufHigh[rt0];
  // rTime0[0] = BufLowPos[rt0];
  // rTime0[0] = (MaxLimit-1)/2+rTime0[0]+(rTime0[0]-rt0+1);
  // rTime0[0] = (MaxLimit-1)/2+BufLowPos[rt0]+(BufLowPos[rt0]-rt0+1);
  rTime0[1] = BufLowPos[rt0];
  rTime0[0] = (MaxLimit-1)/2+rTime0[1]-(rTime0[1]-rt0+1);



  //---* Support & Resistance : Moved Draw
  //---* Support.Minimum Moved Draw
  ObjectMove( "BaseSup:0", 0, time[st0], s0[0] );
  Print( "Time.Sup.00=" + TimeToStr( time[(int)sTime0[0]], TIME_DATE ) + "." + TimeToStr( time[(int)sTime0[0]], TIME_MINUTES ) 
    + "/" + DoubleToStr( s0[0], Digits ) + "/" + string(st0) + "/" + DoubleToStr( sTime0[0], 0 ) );

  //---* Resistance.Maximum Moved Draw
  ObjectMove( "BaseRes:0", 0, time[rt0], r0[0] ); 
  // Print( "Time.Res.00=" + TimeToStr( time[(int)((MaxLimit-1)/2+rTime0[0]-(rTime0[0]-rt0+1))], TIME_DATE ) + "." + TimeToStr( time[(int)((MaxLimit-1)/2+rTime0[0]-(rTime0[0]-rt0+1))], TIME_MINUTES ) 
  Print( "Time.Res.00=" + TimeToStr( time[(int)rTime0[0]], TIME_DATE ) + "." + TimeToStr( time[(int)rTime0[0]], TIME_MINUTES ) 
    // + "/" + DoubleToStr( r0[0], Digits ) + "/" + string(rt0) + "/" + DoubleToStr( rTime0[0], 0 ) );
    + "/" + DoubleToStr( r0[0], Digits ) + "/" + string(rt0) + "/" + DoubleToStr( rTime0[1], 0 ) + "/" + DoubleToStr( rTime0[0], 0 ) );


//---- OnCalculate done. Return new prev_calculated.
  return(rates_total);

}

//+------------------------------------------------------------------+