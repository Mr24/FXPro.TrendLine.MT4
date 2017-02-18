//+------------------------------------------------------------------+
//|                           VerysVeryInc.MetaTrader4.TrendLine.mq4 |
//|                  Copyright(c) 2016, VerysVery Inc. & Yoshio.Mr24 |
//|                             https://github.com/Mr24/MetaTrader4/ |
//|                                                 Since:2016.09.24 |
//|                                Released under the Apache license |
//|                       https://opensource.org/licenses/Apache-2.0 |
//|                                                            &     |
//+------------------------------------------------------------------+
//|                                               AutoTrendLines.mq5 |
//|                                            Copyright 2012, Rone. |
//|                                            rone.sergey@gmail.com |
//|                                https://www.mql5.com/en/code/1220 |
//+------------------------------------------------------------------+
#property copyright "Copyright(c) 2016 -, VerysVery Inc. && Yoshio.Mr24"
#property link      "https://github.com/VerysVery/MetaTrader4/"
#property description "VsV.MT4.VsVTL - Ver.0.0.1 Update:2017.02.18"
#property strict


//--- Auto_TrendLine : Initial Setup ---//
#property indicator_chart_window

//*--
enum AUTO_LINE_TYPE {
  TL_EXM,    // 1: By 2 Extremums
  TL_DELTA   // 2: Extremum and Delta
};


//+------------------------------------------------------------------+
//| Class Current Point                                              |
//+------------------------------------------------------------------+
class CPoint
{
//--- Current Point : Initial Setup ---//
  private:
    double cPrice;
    datetime cTime;
  public:
    CPoint();
    CPoint(const double p, const datetime t);
    ~CPoint() {};

    void setPoint(const double p, const datetime t);
    bool operator==(const CPoint &other) const;
    bool operator!=(const CPoint &other) const;
    void operator=(const CPoint &other);
    double getPrice() const;
    datetime getTime() const;
};

//---
CPoint::CPoint(void)
{
   cPrice = 0;
   cTime = 0;
}
//---
CPoint::CPoint(const double p, const datetime t)
{
  cPrice=p;
  cTime=t;
}
//---
void CPoint::setPoint(const double p, const datetime t)
{
  cPrice=p;
  cTime=t;
}
//---
bool CPoint::operator==(const CPoint &other) const
{
  return cPrice == other.cPrice && cTime == other.cTime;
}
//---
bool CPoint::operator!=(const CPoint &other) const
{
  return !operator==(other);
}
//---
void CPoint::operator=(const CPoint &other)
{
  cPrice=other.cPrice;
  cTime=other.cTime;
}
//---
double CPoint::getPrice(void) const 
{
  return(cPrice);
}
//---
datetime CPoint::getTime(void) const
{
  return(cTime);
}


//+------------------------------------------------------------------+
//| CPoint Drow Line (Ver.0.0.1)                                     |
//+------------------------------------------------------------------+
CPoint curLeftSup, curRightSup, curleftRes, curRightRes, nullPoint;

//--- Auto_TrendLine : input parameters
input AUTO_LINE_TYPE  TLLineType    = TL_DELTA; // Line Type
input int             TLLeftExm     = 10;       // Left Extremum (Type1,2)
input int             TLRightExm    = 3;        // Right Extremum (Type1)
input int             TLFromCurrent = 3;        // Offset from the Current (Type2)
input bool            TLPrevExm     = false;    // Account for bar before Extremum (Type2)
//*---
input int             TLLinesWidth  = 2;
input color           TLSupColor    = clrRed;   // Support Line Color
input color           TLResColor    = clrBlue;  // Resistance Line Color
//*--- Global Variables
int minRequiredBars;


//+------------------------------------------------------------------+
//| Custom indicator initialization function (Ver.0.0.1)             |
//+------------------------------------------------------------------+
int OnInit(void)
{
//--- Auto_TrendLine.Initial.Setup ---//
//--- Indicator Buffers Mapping
  minRequiredBars = TLLeftExm * 2 + MathMax( TLRightExm, TLFromCurrent ) * 2;


//--- initialization done
   return(INIT_SUCCEEDED);
}

//***//


//+------------------------------------------------------------------+
//| Custom Deindicator initialization function (Ver.0.0.1)           |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
  ObjectsDeleteAll( 0, 0, OBJ_TREND);
}

//***//


//+------------------------------------------------------------------+
//| Auto_TrendLine (Ver.0.0.1)                                       |
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
//--- Auto_TrendLine.Calculate.Setup ---//
  int LeftIndex, RightIndex, TmpIndex;
  double Delta, tmpDelta;

//---
  if(rates_total < minRequiredBars)
  {
    Print( "Not Enough data to Calculate!!" );
    return(0);
  }

//---
  if(prev_calculated != rates_total)
  {
    switch(TLLineType)
    {
      case TL_DELTA:
        //*--- Suport Left Point
        LeftIndex= rates_total - TLLeftExm - 2;
        
        for( ; !isLowestLow(LeftIndex, TLLeftExm, low) && LeftIndex > minRequiredBars; LeftIndex--);
        curLeftSup.setPoint(low[LeftIndex], time[LeftIndex]);
        
        //*--- Suport Right Point
        RightIndex = rates_total - TLFromCurrent - 2;

        //*--- Delta Value
        Delta = (low[RightIndex] - low[LeftIndex]) / (RightIndex - LeftIndex);

        //---  
        if(!TLPrevExm)
        {
          LeftIndex +=1;
        }

        TmpIndex = 0;
        for(TmpIndex = RightIndex - 1 ; TmpIndex>LeftIndex; TmpIndex--)
        {
          tmpDelta=(low[TmpIndex] - curLeftSup.getPrice()) / (TmpIndex - LeftIndex);

          if(tmpDelta<Delta)
          {
            Delta=tmpDelta;
            RightIndex=TmpIndex;
          }
        }
        curRightSup.setPoint(low[RightIndex], time[RightIndex]);

        //*--- Resistance Left Point
        LeftIndex = rates_total - TLLeftExm - 2;

        for( ; !isHighestHigh(LeftIndex, TLLeftExm, high) && LeftIndex>minRequiredBars; LeftIndex--);
        curleftRes.setPoint(high[LeftIndex], time[LeftIndex]);

        //*--- Resistance Right Point
        RightIndex = rates_total - TLFromCurrent - 2;

        //*--- Delta Value
        Delta = (high[LeftIndex] - high[RightIndex]) / (RightIndex - LeftIndex);

        //---
        if(!TLPrevExm)
        {
          LeftIndex += 1;
        }

        TmpIndex = 0;
        for(TmpIndex = RightIndex - 1; TmpIndex > LeftIndex; TmpIndex--)
        {
          tmpDelta = (curleftRes.getPrice() - high[TmpIndex]) / (TmpIndex - LeftIndex);

          if(tmpDelta<Delta)
          {
            Delta = tmpDelta;
            RightIndex = TmpIndex;
          }
        }
        curRightRes.setPoint(high[RightIndex], time[RightIndex]);

      //---
      break;

      case TL_EXM:
        default:
        //*--- Support Right Point
        RightIndex = rates_total - TLRightExm - 2;

        for( ; !isLowestLow(RightIndex, TLRightExm, low) && RightIndex > minRequiredBars; RightIndex--);
        curRightSup.setPoint(low[RightIndex], time[RightIndex]);

        //*--- Support Light Point
        LeftIndex = RightIndex - TLRightExm;

        for( ; !isLowestLow(LeftIndex, TLLeftExm, low) && LeftIndex > minRequiredBars; LeftIndex--);
        curLeftSup.setPoint(low[LeftIndex], time[LeftIndex]);

        //*--- Resistance Right Point
        RightIndex = rates_total - TLRightExm - 2;

        for( ; !isHighestHigh(RightIndex, TLRightExm, high) && RightIndex > minRequiredBars; RightIndex--);
        curRightRes.setPoint(high[RightIndex], time[RightIndex]);

        //*--- Resistance Left Point
        LeftIndex = RightIndex - TLRightExm;

        for( ; !isHighestHigh(LeftIndex, TLLeftExm, high) && LeftIndex > minRequiredBars; LeftIndex--);
        curleftRes.setPoint(high[LeftIndex], time[LeftIndex]);

      //---
      break;

    }

    //--- Draw Support & Resistance
    if(curLeftSup != nullPoint && curRightSup != nullPoint)
    {
      TL_DrawLine("Current_Support", curRightSup, curLeftSup, TLSupColor);
    }
    if(curleftRes != nullPoint && curRightRes != nullPoint)
    {
      TL_DrawLine("Current_Resistance", curRightRes, curleftRes, TLResColor);
    }

  }

//---- OnCalculate done. Return new prev_calculated.
  return(rates_total);
}

//***//


//+------------------------------------------------------------------+
//| The Local Low search function                                    |
//+------------------------------------------------------------------+
bool isLowestLow(int bar, int side, const double &low[])
{
  //---
  for(int i=1; i<=side; i++)
  {
    if(low[bar]>low[bar-i] || low[bar]>low[bar+i])
    {
      return(false);
    }
  }

  //---
  return(true);
}

//***//


//+------------------------------------------------------------------+
//| The Local High search function                                   |
//+------------------------------------------------------------------+
bool isHighestHigh(int bar, int side, const double &high[])
{
  //---
  for(int i=1; i<=side; i++)
  {
    if(high[bar]<high[bar-i] || high[bar]<high[bar+i])
    {
      return(false);
    }
  }

  //---
  return(true);
}

//***//


//+------------------------------------------------------------------+
//| Draw trend line function                                         |
//+------------------------------------------------------------------+
void TL_DrawLine(string name, CPoint &right, CPoint &left, color clr)
{
  //---
  ObjectDelete(0, name);

  //---
  ObjectCreate(0, name, OBJ_TREND, 0,
    right.getTime(), right.getPrice(), left.getTime(), left.getPrice());
  ObjectSetInteger(0, name, OBJPROP_WIDTH, TLLinesWidth);
  ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
  ObjectSetInteger(0, name, OBJPROP_RAY_LEFT, true);
  ObjectSetInteger(0, name, OBJPROP_SELECTABLE, true);
  //---

}

//+------------------------------------------------------------------+