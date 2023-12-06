unit Server.Routes;

interface

uses
  System.Classes, Horse.Request, Horse.Response, Horse.Proc, Horse.XMLDoc;

function GetResourceStream(const pResourceName: string): TStream;
procedure Exemplo1(pRequest: THorseRequest; pResponse: THorseResponse; pNext: TNextProc);
procedure Exemplo2(pRequest: THorseRequest; pResponse: THorseResponse; pNext: TNextProc);
procedure Exemplo3(pRequest: THorseRequest; pResponse: THorseResponse; pNext: TNextProc);
procedure Exemplo4(pRequest: THorseRequest; pResponse: THorseResponse; pNext: TNextProc);

implementation

uses
  System.Types, Xml.XMLDoc, Xml.xmldom, Xml.Win.msxmldom, Xml.XMLIntf, Winapi.ActiveX,
  System.SysUtils;

function GetResourceStream(const pResourceName: string): TStream;
var
  lResStream: TResourceStream;
begin
  lResStream := TResourceStream.Create(HInstance, pResourceName, RT_RCDATA);
  try
    lResStream.Position := 0;
    Result := lResStream;
  except
    lResStream.Free;
    raise;
  end;
end;

procedure Exemplo1(pRequest: THorseRequest; pResponse: THorseResponse; pNext: TNextProc);
var
  lXMLDoc: TXMLDocument;
  lResourceXML: TStream;
  lXML: string;
begin
  CoInitialize(nil); // Obrigatório quando DOMVendor = SMSXML
  try
    lXMLDoc := TXMLDocument.Create(XMLContainer); // Free pelo middleware Horse-XMLDoc depois do "Send".
    lXMLDoc.DOMVendor := GetDOMVendor(SMSXML);
    lXMLDoc.Active := True;

    lResourceXML := GetResourceStream('w3schools_note');
    try
      lXMLDoc.LoadFromStream(lResourceXML);

      lXML := lXMLDoc.XML.Text;

      lXMLDoc.CreateElement('teste', EmptyStr);

      pResponse.Send<TXMLDocument>(lXMLDoc);
    finally
      lResourceXML.Free;
    end;
  finally
    CoUninitialize;
  end;
end;

procedure Exemplo2(pRequest: THorseRequest; pResponse: THorseResponse; pNext: TNextProc);
var
  lResourceStream: TStream;
  XMlStream: TStringStream;
begin
  lResourceStream := GetResourceStream('w3schools_note_error');
  try
    XMlStream := TStringStream.Create('', TEncoding.UTF8);
    try
      lResourceStream.Position := 0;
      XMlStream.CopyFrom(lResourceStream, lResourceStream.Size);

      pResponse.Send(XMlStream.DataString).ContentType('application/xml');
    finally
      XMlStream.Free;
    end;
  finally
    lResourceStream.Free;
  end;
end;

procedure Exemplo3(pRequest: THorseRequest; pResponse: THorseResponse; pNext: TNextProc);
var
  lXMLDoc: TXMLDocument;
  lID: string;
begin
  CoInitialize(nil); // Obrigatório quando DOMVendor = SMSXML
  try
    lXMLDoc := TXMLDocument.Create(XMLContainer); // Free pelo middleware Horse-XMLDoc depois do "Send".
    lXMLDoc.DOMVendor := GetDOMVendor(SMSXML);
    lXMLDoc.Active := True;

    // Parse usando middleware Horse-XMLDoc
    lXMLDoc := pRequest.Body<TXMLDocument>;

    if Assigned(lXMLDoc) then
    begin
      lID := lXMLDoc.DocumentElement.ChildNodes['customer'].Attributes['id'];
      pResponse.Send('customer id = ' + lID).Status(200);
    end
    else
      pResponse.Send('Verificar Content-Type').Status(400);

  finally
    CoUninitialize;
  end;
end;

procedure Exemplo4(pRequest: THorseRequest; pResponse: THorseResponse; pNext: TNextProc);
var
  lXMLDoc: TXMLDocument;
  lNodeBooks: IXMLNode;
  lNodeBook: IXMLNode;
  lNodeElement: IXMLNode;
  lNodeAttribute: IXMLNode;
begin
  CoInitialize(nil); // Obrigatório quando DOMVendor = SMSXML
  try
    lXMLDoc := TXMLDocument.Create(XMLContainer); // Free pelo middleware Horse-XMLDoc depois do "Send".
    lXMLDoc.DOMVendor := GetDOMVendor(SMSXML);
    lXMLDoc.Options := lXMLDoc.Options + [doNodeAutoIndent];
    lXMLDoc.Active := True;
    lXMLDoc.Version := '1.0';
    lXMLDoc.Encoding := 'utf-8';

    //<books> - CRIA O NÓ RAIZ = lXMLDocInft.DocumentElement
    lNodeBooks := lXMLDoc.AddChild('books');

    //<book>
    lNodeBook := lXMLDoc.CreateNode('book', ntElement);

    //<books>
    //  <book>
    lNodeBooks.ChildNodes.Add(lNodeBook);

    //<author>
    lNodeElement := lXMLDoc.CreateNode('author', ntElement);
    lNodeElement.Text := 'Carson';

    //<books>
    //  <book>
    //    <author>
    lNodeBook.ChildNodes.Add(lNodeElement);

    //<price>
    lNodeElement := lXMLDoc.CreateNode('price', ntElement);
    lNodeElement.Text := '31.95';

    //<price format="dollar">
    lNodeAttribute := lXMLDoc.CreateNode('format', ntAttribute);
    lNodeAttribute.Text := 'dollar';

    lNodeElement.AttributeNodes.Add(lNodeAttribute);

    //<books>
    //  <book>
    //    <price format="dollar">
    lNodeBook.ChildNodes.Add(lNodeElement);

    //<pubdate>
    lNodeElement := lXMLDoc.CreateNode('pubdate', ntElement);
    lNodeElement.Text := '05/01/2001';

    //<books>
    //  <book>
    //    <pubdate>
    lNodeBook.ChildNodes.Add(lNodeElement);

    pResponse.Send<TXMLDocument>(lXMLDoc);
  finally
    CoUninitialize;
  end;
end;

end.
