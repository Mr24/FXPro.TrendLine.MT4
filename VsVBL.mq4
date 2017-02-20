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
#property description "VsV.MT4.VsVBL - Ver.0.7.1 Update:2017.02.20"
#property strict


//--- Base.TrendLine : Initial Setup ---//
#property indicator_chart_window

//--- Base.TrendLine : indicator parameters
extern int BLPeriod=3;
input int MaxLimit = 360;
// input int PriceField = 0;
// extern int st0=0, st1=0, st2=0;

//--- Base.TrendLine : Widners Osiletor
// int cnt, BLCurBar=0;
int cnt;

//--- Base.TrendLine : Indicator Buffer
double BufLow[];
double BufLow01[];
double BufHigh[];
double BufHigh01[];


//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.0.7.1)             |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- Base.TrendLine.Initial.Setup ---//
//--- 2 Additional Buffer used for Counting.
  IndicatorBuffers( 4 );

  //*--- Lowest Buffer
  SetIndexBuffer( 0, BufLow );
  ArraySetAsSeries( BufLow, true );
  //*--- Lowest Buffer01
  SetIndexBuffer( 1, BufLow01 );
  ArraySetAsSeries( BufLow01, true );
  
  //*--- Highest Buffer
  SetIndexBuffer( 2, BufHigh );
  ArraySetAsSeries( BufHigh, true );
  //*--- Highest Buffer01
  SetIndexBuffer( 3, BufHigh01 );
  ArraySetAsSeries( BufHigh01, true );

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
//| Custom Deindicator initialization function (Ver.0.7.1)           |
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
  int     SPos;
  double  stime0;
  //*--- Resistance Initial
  int     rt0=0, rt1=0, rt2=0;
  double  r0=0.00, r1=0.00, r2=0.00;
  int     RPos;
  double  rtime0;

  ArraySetAsSeries( low, true );
  ArraySetAsSeries( high, true );
  
//--- Base.TrendLine : Support & Resistance
  int limit = Bars - prev_calculated;
  // int limit = MaxLimit - prev_calculated;
  // int limit = Bars - MaxLimit;
  // int limit = prev_calculated - MaxLimit;

  for(int i=MaxLimit - 1; i >= 0; i--)
  // (OK.01) for(int i=MaxLimit-1; i>=0; i--)
  // (OK.00) for(int i=0; i<=MaxLimit; i++)
  // for(int i=limit-1; i>=0; i--)
  {
    // BufLow[i]=Low[iLowest( NULL, 0, MODE_LOW, MaxLimit-1, i )];
    // (OK.00) BufLow[i]=Low[ArrayMinimum( low, MaxLimit-1, i )];
    // (OK.01) BufLow01[i]=ArrayMinimum( low, MaxLimit-1, i );
    BufLow01[i]=ArrayMinimum( low, (MaxLimit - 1)/2, i );
    SPos=(int)BufLow01[i];
    BufLow[i]=low[SPos];

    // BufHigh[i]=High[iHighest( NULL, 0, MODE_HIGH, MaxLimit-1, i )];
    // (0K.00) BufHigh[i]=high[ArrayMaximum( high, MaxLimit-1, i )];
    // (OK.01) BufHigh01[i]=ArrayMaximum( high, MaxLimit-1, i );
    BufHigh01[i]=ArrayMaximum( high, (MaxLimit - 1)/2, i );
    RPos=(int)BufHigh01[i];
    BufHigh[i]=high[RPos];

  }

  //--- Support.Minimum Data
  // st0=ArrayMinimum( dbl array[], int count=WHOLE_ARRAY, int start=0 );
  st0=ArrayMinimum( BufLow, MaxLimit - 1, 0 );
  s0=BufLow[st0];
  // ArrayCopy( void dest[], obj source[], int start_dest=0, int start_source=0, int count=WHOLE_ARRAY );
  // ArrayBsearch( dbl array[], dbl value, int count=WHOLE_ARRAY, int start=0, int dir=MODE_ASCEND*|MODE_DESCEND );
  // stime0  = (int)BufLow01[st0];
  stime0=BufLow01[st0];

  
  //--- Resistance.Maximum Data
  // rt0=ArrayMaximum( dbl array[], int count=WHOLE_ARRAY, int start=0 );
  // rt0=ArrayMaximum( BufHigh, MaxLimit-1, MaxLimit );
  rt0=ArrayMaximum( BufHigh, MaxLimit - 1, 0 );
  r0=BufHigh[rt0];
  rtime0=BufHigh01[rt0];

  //*--- Support.Minimum Moved Draw
  ObjectMove( "BaseSup:0", 0, time[st0], s0 );
  // Print( "Time.Sup.00=" + TimeToStr( Time[st0], TIME_DATE )+"."+TimeToStr( Time[st0] ,TIME_MINUTES )
  // Print( "Time.Sup.00=" + TimeToStr( Time[stime0], TIME_DATE )+"."+TimeTod( Time[stime0], TIME_MINUTES )
  Print( "Time.Sup.00=" + TimeToStr( time[ (int)stime0 ], TIME_DATE ) + "." + TimeToStr( time[ (int)stime0 ], TIME_MINUTES )
    // + "/" + DoubleToStr( s0, Digits ) + "/" + string( st0 ) + "/" + string(stime0) + "/" + string(limit) );
    // + "/" + DoubleToStr( s0, Digits ) + "/" + string( st0 ) + "/" + DoubleToStr( stime0, Digits ) + "/" + string(limit) );
    + "/" + DoubleToStr( s0, 0 ) + "/" + string( st0 ) + "/" + DoubleToStr( stime0, 0 ) + "/" + string(limit) );

  //*--- Resistance.Maximum Moved Draw
  ObjectMove( "BaseRes:0", 0, time[rt0], r0 );
  // Print( "Time.Res.00=" + TimeToStr( Time[rt0], TIME_DATE )+"."+TimeToStr( Time[rt0] ,TIME_MINUTES )
  Print( "Time.Res.00=" + TimeToStr( time[ (int)rtime0 ], TIME_DATE ) + "." + TimeToStr( time[ (int)rtime0 ], TIME_MINUTES )
    // + "/" + DoubleToStr( r0, Digits ) + "/" + string( rt0 ) + "/" + DoubleToStr( rtime0, Digits )  );
    + "/" + DoubleToStr( r0, 0 ) + "/" + string( rt0 ) + "/" + DoubleToStr( rtime0, 0 )  );
    // + "/" + DoubleToStr( r0, Digits ) + "/" + string( rt0 )  );
    // + "/" + DoubleToStr( r0, Digits ) + "/" + string( rt0 ) + "/!" + string( rd0 ) );


//---- OnCalculate done. Return new prev_calculated.
    return(rates_total);
}

//+------------------------------------------------------------------+