{******************************************************************************}
{                                                                              }
{           Horse.XMLDoc                                                       }
{                                                                              }
{           Copyright (C) Antônio José Medeiros Schneider Júnior               }
{                                                                              }
{           https://github.com/antoniojmsjr/Horse-XMLDoc                       }
{                                                                              }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
unit Horse.XMLDoc;

interface

uses
  System.Classes, System.Generics.Collections, Web.HTTPApp, Xml.xmldom,
  Xml.XMLIntf, Xml.XMLDoc, Xml.Win.msxmldom, Xml.omnixmldom, Xml.adomxmldom,
  Horse, Horse.Commons;

type
  TDOMVendorType = (MsXML, OmniXML);

  THorseXMLDoc = class
  strict private
    { private declarations }
    FDOmVendor: TDOMVendorType;
    FEncoding: string;
    FContentTypes: TList<string>;
    function ContainsContentType(const pContentType: string): Boolean;
    function GetCharsetContentType(const pContentType: string): string;
    procedure SetConfig(pXMlDoc: TXMLDocument; const pCharset: string);
    procedure MiddlewareDelphi(pRequest: THorseRequest; pResponse: THorseResponse; pNext: TNextProc);
  private
    class var FXMLDoc: THorseXMLDoc;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
    {$IFDEF MSWINDOWS}
    function DOMVendor(const DOmVendor: TDOMVendorType): THorseXMLDoc;
    {$ENDIF}
    function Encoding(const Encoding: string): THorseXMLDoc;
    function ContentTypeXML(const ContentTypes: array of string): THorseXMLDoc;
    function Intercept: THorseCallback;
    class destructor UnInitialize;
    class function New: THorseXMLDoc;
  end;

  TXMLContainer = class(TComponent);

var
  XMLContainer: TXMLContainer;

implementation

uses
  System.SysUtils, Winapi.ActiveX,
  {$IFDEF MSWINDOWS}
  Vcl.Forms;
  {$ELSE}
  Fmx.Forms;
  {$ENDIF}

{ THorseXMLDoc }

constructor THorseXMLDoc.Create;
begin
  {$IFDEF MSWINDOWS}
  FDOmVendor := TDOMVendorType.MsXML;
  {$ELSE}
  FDOmVendor := TDOMVendorType.OmniXML;
  {$ENDIF}
  FEncoding := 'utf-8';
  FContentTypes := TList<string>.Create;
  FContentTypes.Add('application/xml');
  FContentTypes.Add('text/xml');
end;

destructor THorseXMLDoc.Destroy;
begin
  FContentTypes.Free;
  inherited Destroy;
end;

class function THorseXMLDoc.New: THorseXMLDoc;
begin
  if not Assigned(FXMLDoc) then
    FXMLDoc := THorseXMLDoc.Create;
  Result := FXMLDoc;
end;

class destructor THorseXMLDoc.UnInitialize;
begin
  FreeAndNil(FXMLDoc);
end;

function THorseXMLDoc.ContainsContentType(const pContentType: string): Boolean;
var
  lText: string;
  lContentType: string;
  lContentTypeInput: string;
begin
  Result := False;
  for lText in FContentTypes do
  begin
    lContentType := LowerCase(lText);
    lContentTypeInput := LowerCase(pContentType);
    if lContentType.Contains(lContentTypeInput) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function THorseXMLDoc.ContentTypeXML(
  const ContentTypes: array of string): THorseXMLDoc;
var
  lContentType: string;
begin
  Result := Self;
  for lContentType in ContentTypes do
    if not ContainsContentType(lContentType) then
      FContentTypes.Add(lContentType);
end;

procedure THorseXMLDoc.SetConfig(pXMlDoc: TXMLDocument; const pCharset: string);
begin
  pXMlDoc.Active := False;
  pXMlDoc.FileName := EmptyStr;
  pXMlDoc.XML.Text := EmptyStr;

  case FDOmVendor of
    Msxml: pXMlDoc.DOMVendor := GetDOMVendor(SMSXML);
    OmniXML: pXMlDoc.DOMVendor := GetDOMVendor(sOmniXmlVendor);
  end;

  pXMlDoc.Options := [];
  pXMlDoc.Options := [doNodeAutoCreate, doNodeAutoIndent, doAttrNull];
  pXMlDoc.ParseOptions := [];
  if (FDOmVendor = MsXML)  then
    pXMlDoc.ParseOptions := [poValidateOnParse];

  pXMlDoc.Active := True;
  pXMlDoc.Encoding := pCharset;
end;

function THorseXMLDoc.Intercept: THorseCallback;
begin
  Result := MiddlewareDelphi;
end;

function THorseXMLDoc.Encoding(const Encoding: string): THorseXMLDoc;
begin
  Result := Self;
  FEncoding := Encoding;
end;

function THorseXMLDoc.GetCharsetContentType(const pContentType: string): string;
var
  lContentType: string;
begin
  Result := EmptyStr;
  lContentType := LowerCase(pContentType);
  if lContentType.Contains('charset=') then
    Result := Trim(Copy(lContentType,
                        (System.Pos('charset=', lContentType) + Length('charset=')),
                        Length(lContentType)));
end;

{$IFDEF MSWINDOWS}
function THorseXMLDoc.DOMVendor(const DOmVendor: TDOMVendorType): THorseXMLDoc;
begin
  Result := Self;
  FDOmVendor := DOmVendor;
end;
{$ENDIF}

procedure THorseXMLDoc.MiddlewareDelphi(pRequest: THorseRequest;
  pResponse: THorseResponse; pNext: TNextProc);
var
  lXMLDocument: TXMLDocument;
  lCharsetContentType: string;
begin
  if (pRequest.MethodType in [mtPost, mtPut, mtPatch]) then
  begin
    if ContainsContentType(pRequest.RawWebRequest.ContentType) then
    begin
      try
        if (FDOmVendor = MsXML) then
          CoInitialize(nil);

        //application/xml; charset=utf-8
        lCharsetContentType := GetCharsetContentType(pRequest.RawWebRequest.ContentType);
        if (lCharsetContentType = EmptyStr) then
          lCharsetContentType := FEncoding;

        lXMLDocument := TXMLDocument.Create(XMLContainer);
        try
          SetConfig(lXMLDocument, lCharsetContentType);

          lXMLDocument.LoadFromXML(pRequest.RawWebRequest.Content);
        except
          pResponse.Send('Invalid XML').Status(THTTPStatus.BadRequest);
          lXMLDocument.Free;
          raise EHorseCallbackInterrupted.Create;
        end;

        if lXMLDocument.IsEmptyDoc then
        begin
          pResponse.Send('XML Empty').Status(THTTPStatus.BadRequest);
          lXMLDocument.Free;
          raise EHorseCallbackInterrupted.Create;
        end;

        pRequest.Body(lXMLDocument);
      finally
        if (FDOmVendor = MsXML) then
          CoUninitialize;
      end;
    end;
  end;

  try
    pNext;
  finally
    if  ((pResponse.Content <> nil)
    and pResponse.Content.InheritsFrom(TXMLDocument)) then
    begin
      pResponse.RawWebResponse.Content := TXMLDocument(pResponse.Content).DocumentElement.XML;
      pResponse.RawWebResponse.ContentType := 'application/xml; charset=' + FEncoding;
    end;
  end;
end;

initialization
  XMLContainer := TXMLContainer.Create(Application);

finalization
  XMLContainer.Free;

end.
