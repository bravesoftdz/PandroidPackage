{***********************************************************
Copyright (C) 2012-2020
Zeljko Cvijanovic www.zeljus.com (cvzeljko@gmail.com) &
Miran Horjak usbdoo@gmail.com
***********************************************************}
library project1;

{$IFDEF Linux}
{%BuildCommand sh compile.sh}
{%BuildScan MAKE-}
{$ELSE}
{$ENDIF}

{$mode delphi}


uses PandoidModule;

exports
  Java_zeljus_com_PandroidModule_CreateObject,
  Java_zeljus_com_PandroidModule_SetPropValue,
  Java_zeljus_com_PandroidModule_GetPropValue,
  Java_zeljus_com_PandroidModule_SetObjectProp,
  Java_zeljus_com_PandroidModule_Free;

begin
 //   FormatSettings.ShortDateFormat:='dd.MM.yyyy';
 // FormatSettings.CurrencyDecimals:=2;
 // FormatSettings.CurrencyString:='KM';
//  FormatSettings.DateSeparator:='.';
//  FormatSettings.DecimalSeparator:='.';
end.

