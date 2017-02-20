//+------------------------------------------------------------------+
//|                      VerysVeryInc.MetaTrader4.Base.TrendLine.mq4 |
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
#property description "VsV.MT4.VsVBL - Ver.0.7.0 Update:2017.02.20"
#property strict


//--- Base.TrendLine : Initial Setup ---//
#property indicator_chart_window

//--- Base.TrendLine : indicator parameters
extern int BLPeriod=3;
input int MaxLimit = 360;
input int PriceField = 0;
// extern int st0=0, st1=0, st2=0;

//--- Base.TrendLine : Widners Osiletor
int cnt, BLCurBar=0;

//--- Base.TrendLine : Indicator Buffer
double BufLow[];
double BufHigh[];



//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.0.7.0)             |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- Base.TrendLine.Initial.Setup ---//
//--- 2 Additional Buffer used for Counting.
  IndicatorBuffers( 2 );

  //*--- Lowest Buffer
  SetIndexBuffer( 0, BufLow );
  ArraySetAsSeries( BufLow, true );
  //*--- Highest Buffer
  SetIndexBuffer( 1, BufHigh );
  ArraySetAsSeries( BufHigh, true );


//--- Output in Char
  for( cnt=0; cnt<=2; cnt++ )
  {
    //*--- Base.TrendLine : Support.Setup
    ObjectCreate( "BaseSup:" + string(cnt), OBJ_HLINE, 0, 0, 0 );
    ObjectSet( "BaseSup:" + string(cnt), OBJPROP_COLOR, Goldenrod );

    //*--- Base.TrendLine : Resistance.Setup
    ObjectCreate( "BaseRes:"+ string(cnt), OBJ_HLINE, 0, 0, 0 );
    ObjectSet( "BaseRes:" + string(cnt), OBJPROP_COLOR, Goldenrod );    
  }

//---
  // SetIndexDrawBegin( 0, MaxLimit );
  // SetIndexDrawBegin( 1, MaxLimit );

//--- initialization done
   return(INIT_SUCCEEDED);
}

//***//


//+------------------------------------------------------------------+
//| Custom Deindicator initialization function (Ver.0.7.0)           |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
//--- ToDo & Code Here
  
  // ObjectDelete( "BaseSup:" + string(cnt) );

  
  for( cnt=0; cnt<=2; cnt++ )
  {
    ObjectDelete( "BaseSup:" + string(cnt) );
    ObjectDelete( "BaseRes:" + string(cnt) );
  }
  
  
}

//***//


//+------------------------------------------------------------------+
//| Base.TrendLine (Ver.0.7.0)                                       |
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

//--- Base.TrendLine.Calculate.Setup ---//
//--- ToDo & Code Here
  //*--- Support Initial
  int     st0=0, st1=0, st2=0;
  double  s0=0.00, s1=0.00, s2=0.00;
  //*--- Resistance Initial
  int     rt0=0, rt1=0, rt2=0;
  double  r0=0.00, r1=0.00, r2=0.00;

  ArraySetAsSeries( Low, true );
  ArraySetAsSeries( High, true );
  

//--- Base.TrendLine : Support & Resistance
  int limit = Bars - prev_calculated;
  // int limit = MaxLimit - prev_calculated;
  // int limit = Bars - MaxLimit;
  // int limit = prev_calculated - MaxLimit;

  // for(int i=MaxLimit-1; i>=0; i--)
  // for(int i=0; i<=MaxLimit; i++)
  for(int i=limit-1; i>=0; i--)
  {
    // BufLow[i]=Low[iLowest( NULL, 0, MODE_LOW, MaxLimit-1, i )];
    BufLow[i]=Low[ArrayMinimum( low, MaxLimit-1, i )];

    // BufHigh[i]=High[iHighest( NULL, 0, MODE_HIGH, MaxLimit-1, i )];
    BufHigh[i]=High[ArrayMaximum( high, MaxLimit-1, i )];
  }

  //--- Support.Minimum Data
  st0=ArrayMinimum( BufLow, MaxLimit-1, MaxLimit );
  s0=BufLow[st0];
  //--- Resistance.Maximum Data
  rt0=ArrayMaximum( BufHigh, MaxLimit-1, MaxLimit );
  r0=BufHigh[rt0];


  //*--- Support.Minimum Moved Draw
  ObjectMove( "BaseSup:0", 0, Time[st0], s0 );
  Print( "Time.Sup.00=" + TimeToStr( Time[st0], TIME_DATE )+"."+TimeToStr( Time[st0] ,TIME_MINUTES )
    + "/" + DoubleToStr( s0, Digits ) + "/" + string( st0 ) );
  //*--- Resistance.Maximum Moved Draw
  ObjectMove( "BaseRes:0", 0, Time[rt0], r0 );
  Print( "Time.Res.00=" + TimeToStr( Time[rt0], TIME_DATE )+"."+TimeToStr( Time[rt0] ,TIME_MINUTES )
    + "/" + DoubleToStr( r0, Digits ) + "/" + string( rt0 )  );
    // + "/" + DoubleToStr( r0, Digits ) + "/" + string( rt0 ) + "/!" + string( rd0 ) );


//---- OnCalculate done. Return new prev_calculated.
    return(rates_total);
}

//+------------------------------------------------------------------+