{***********************************************************
Copyright (C) 2012-2016
Zeljko Cvijanovic www.zeljus.com (cvzeljko@gmail.com) &
Miran Horjak usbdoo@gmail.com
***********************************************************}
unit PandoidModule;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, typinfo, jni,  ZCPascalScript;

var
 Module : TStringList;

function Java_zeljus_com_PandroidModule_CreateObject(env: PJNIEnv; this: jobject; AClassName: jString): jlong; cdecl;
procedure Java_zeljus_com_PandroidModule_SetPropValue(env: PJNIEnv; this: jobject; AID: jlong; AProperty: jString; AValue: jString); cdecl;
function Java_zeljus_com_PandroidModule_GetPropValue(env: PJNIEnv; this: jobject; AID: jlong; AProperty: jString): jString; cdecl;
procedure Java_zeljus_com_PandroidModule_SetObjectProp(env: PJNIEnv; this: jobject; AID: jlong; AProperty: jString; AIDObject: jlong); cdecl;

procedure Java_zeljus_com_PandroidModule_Free(env: PJNIEnv; this: jobject; AID: jlong); cdecl;


implementation


var
   PropInfo: PPropInfo;

function JNI_JStringToString(env: PJNIEnv; JStr: JString): string;
var
 pAnsiCharTMP: pAnsiChar;
 pIsCopy: Byte;
begin
  // IsCopy := JNI_TRUE;

   if (JStr = nil) then begin
     Result := '';
     Exit;
   end;

    pAnsiCharTMP := env^^.GetStringUTFChars(env, JStr, @pIsCopy);

   if (pAnsiCharTMP = nil) then begin
     Result := '';
   end else begin
     Result := StrPas(pAnsiCharTMP); //Return the result;
      //Release the temp string
     Env^^.ReleaseStringUTFChars(env, JStr, pAnsiCharTMP);
   end;
end;

function JNI_StringToJString(env: PJNIEnv; Str: string): jstring;
begin
    Result := env^^.NewStringUTF(env, @Str[1]);
end;

function Java_zeljus_com_PandroidModule_CreateObject(env: PJNIEnv; this: jobject; AClassName: jString): jlong; cdecl;
var
 ClassName : String;
begin
  ClassName := JNI_JStringToString(env, AClassName);
  try
    if CompareText(ClassName, 'TZCPascalScript') = 0 then
       Result := Module.AddObject(ClassName, TZCPascalScript.Create(nil))
    else
       Result := -1;

  finally

  end;
end;

procedure Java_zeljus_com_PandroidModule_SetPropValue(env: PJNIEnv; this: jobject; AID: jlong; AProperty: jString; AValue: jString); cdecl;
begin
  PropInfo := GetPropInfo(Module.Objects[AID].ClassInfo, JNI_JStringToString(env, AProperty));
  if Assigned(PropInfo) then
    SetPropValue(Module.Objects[AID], PropInfo, JNI_JStringToString(env, AValue));
end;

function Java_zeljus_com_PandroidModule_GetPropValue(env: PJNIEnv; this: jobject; AID: jlong; AProperty: jString): jString; cdecl;
begin
  try
    Result := JNI_StringToJString(env, GetPropValue(Module.Objects[AID], JNI_JStringToString(env, AProperty)) );
  except on E: Exception do
    Result := JNI_StringToJString(env, E.Message);
  end;
end;

procedure Java_zeljus_com_PandroidModule_SetObjectProp(env: PJNIEnv; this: jobject; AID: jlong; AProperty: jString; AIDObject: jlong); cdecl;
begin
  PropInfo := GetPropInfo(Module.Objects[AID].ClassInfo, JNI_JStringToString(env, AProperty));
  if Assigned(PropInfo) then
    SetObjectProp(Module.Objects[AID], PropInfo, Module.Objects[AIDObject]);
end;

procedure Java_zeljus_com_PandroidModule_Free(env: PJNIEnv; this: jobject; AID: jlong); cdecl;
begin
  Module.Objects[AID].Free;
end;

initialization
   Module := TStringList.Create;
finalization
   Module.Free;

end.

