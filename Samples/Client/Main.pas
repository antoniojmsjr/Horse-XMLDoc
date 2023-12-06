unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  Xml.xmldom, Xml.XMLIntf, Xml.Win.msxmldom, Xml.XMLDoc, Xml.omnixmldom;

type
  TfrmMain = class(TForm)
    gbxURLBase: TGroupBox;
    edtURLBase: TEdit;
    lblURLBase: TLabel;
    pgcSamples: TPageControl;
    btnClose: TBitBtn;
    tbsExemplo1: TTabSheet;
    gbxExemplo1: TGroupBox;
    edtExemplo1Resource: TEdit;
    btnExemplo1Execute: TBitBtn;
    HTTPClient: TNetHTTPClient;
    HTTPRequest: TNetHTTPRequest;
    mmoExemplo1XML: TMemo;
    tbsExemplo2: TTabSheet;
    gbxExemplo2: TGroupBox;
    edtExemplo2Resource: TEdit;
    btnExemplo2Execute: TBitBtn;
    mmoExemplo2XML: TMemo;
    tbsExemplo3: TTabSheet;
    gbxExemplo3: TGroupBox;
    edtExemplo3Resource: TEdit;
    btnExemplo3Execute: TBitBtn;
    mmoExemplo3XML: TMemo;
    tbsExemplo4: TTabSheet;
    gbxExemplo4: TGroupBox;
    edtExemplo4Resource: TEdit;
    btnExemplo4Execute: TBitBtn;
    mmoExemplo4XML: TMemo;
    procedure btnCloseClick(Sender: TObject);
    procedure btnExemplo1ExecuteClick(Sender: TObject);
    procedure btnExemplo2ExecuteClick(Sender: TObject);
    procedure btnExemplo3ExecuteClick(Sender: TObject);
    procedure btnExemplo4ExecuteClick(Sender: TObject);
  private
    { Private declarations }
    function GerarXMLExemplo3: string;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.btnExemplo1ExecuteClick(Sender: TObject);
var
  lHTTPResponse: IHTTPResponse;
  lXMLDoc: TXMLDocument;
  lURL: string;
begin
  //https://www.w3schools.com/xml/note.xml

  mmoExemplo1XML.Clear;
  Application.ProcessMessages;

  lURL := Format('%s%s', [edtURLBase.Text, edtExemplo1Resource.Text]);

  // REQUEST
  lHTTPResponse := HTTPRequest.Client.Get(lURL);

  if (lHTTPResponse.StatusCode <> 200) then
    raise Exception.CreateFmt('%d - %s', [lHTTPResponse.StatusCode, lHTTPResponse.StatusText]);

  lHTTPResponse.ContentStream.Position := 0;
  if not Assigned(lHTTPResponse.ContentStream) then
    raise Exception.Create('Content response empty.');

  mmoExemplo1XML.Lines.Add('Content-Type: ' + lHTTPResponse.HeaderValue['Content-Type']);
  mmoExemplo1XML.Lines.Add('');

  // CARREGA XML
  lXMLDoc := TXMLDocument.Create(Application);
  try
    lXMLDoc.DOMVendor := GetDOMVendor(SMSXML);
    lXMLDoc.Active := True;

    lXMLDoc.LoadFromStream(lHTTPResponse.ContentStream);

    mmoExemplo1XML.Lines.Add(lXMLDoc.DocumentElement.XML);
  finally
    lXMLDoc.Free;
  end;
end;

procedure TfrmMain.btnExemplo2ExecuteClick(Sender: TObject);
var
  lHTTPResponse: IHTTPResponse;
  lXMLDoc: TXMLDocument;
  lURL: string;
  lXMLStr: string;
begin
  // https://www.w3schools.com/xml/note_error.xml

  mmoExemplo2XML.Clear;
  Application.ProcessMessages;

  lURL := Format('%s%s', [edtURLBase.Text, edtExemplo2Resource.Text]);

  // Request
  lHTTPResponse := HTTPRequest.Client.Get(lURL);

  if (lHTTPResponse.StatusCode <> 200) then
    raise Exception.CreateFmt('%d - %s', [lHTTPResponse.StatusCode, lHTTPResponse.StatusText]);

  lHTTPResponse.ContentStream.Position := 0;
  if not Assigned(lHTTPResponse.ContentStream) then
    raise Exception.Create('Content response empty.');

  lXMLStr := lHTTPResponse.ContentAsString(TEncoding.UTF8);

  mmoExemplo2XML.Lines.Add('Content-Type: ' + lHTTPResponse.HeaderValue['Content-Type']);
  mmoExemplo2XML.Lines.Add('');

  lXMLDoc := TXMLDocument.Create(Application);
  try
    lXMLDoc.DOMVendor := GetDOMVendor(SMSXML);
    lXMLDoc.Active := True;
    lXMLDoc.Encoding := 'utf-8';

    try
      lXMLDoc.LoadFromStream(lHTTPResponse.ContentStream);
    except
      on E: EDOMParseError do
      begin
        mmoExemplo2XML.Lines.Add('##### ERRO PARSE #####');
        mmoExemplo2XML.Lines.Add('');
        mmoExemplo2XML.Lines.Add(E.Message);

        mmoExemplo2XML.Lines.Add('');
        mmoExemplo2XML.Lines.Add(E.QualifiedClassName);

        mmoExemplo2XML.Lines.Add('');
        mmoExemplo2XML.Lines.Add('##### XML #####');
        mmoExemplo2XML.Lines.Add('');
        mmoExemplo2XML.Lines.Add(lXMLStr);
      end;
      on E: exception do
      begin
        mmoExemplo2XML.Lines.Add('##### ERRO GERAL #####');
        mmoExemplo2XML.Lines.Add('');
        mmoExemplo2XML.Lines.Add(E.Message);

        mmoExemplo2XML.Lines.Add('');
        mmoExemplo2XML.Lines.Add(E.QualifiedClassName);

        mmoExemplo2XML.Lines.Add('');
        mmoExemplo2XML.Lines.Add('##### XML #####');
        mmoExemplo2XML.Lines.Add('');
        mmoExemplo2XML.Lines.Add(lXMLStr);
      end;
    end;
  finally
    lXMLDoc.Free;
  end;
end;

function TfrmMain.GerarXMLExemplo3: string;
var
  lXMLDoc: TXMLDocument;
  lNodeCustomers: IXMLNode;
  lNodeCustomer: IXMLNode;
  lNodeAddress: IXMLNode;
  lNodeAux: IXMLNode;
begin
  // https://www.ibm.com/docs/en/iis/11.5?topic=rows-sample-xml-document

  lXMLDoc := TXMLDocument.Create(Application);
  try
    lXMLDoc.DOMVendor := GetDOMVendor(SMSXML);
    lXMLDoc.Options := lXMLDoc.Options + [doNodeAutoIndent];
    lXMLDoc.Active := True;
    lXMLDoc.Version := '1.0';
    lXMLDoc.Encoding := 'utf-8';

     // <customers> - CRIANDO NÓ RAIZ
    lNodeCustomers := lXMLDoc.AddChild('customers');

    // <customer>
    lNodeCustomer := lXMLDoc.CreateNode('customer', ntElement);

    lNodeAux := lXMLDoc.CreateNode('id', ntAttribute);
    lNodeAux.Text := '55000';
    // <customer id="55000">
    lNodeCustomer.AttributeNodes.Add(lNodeAux);

    // <customers>
    //   <customer id="55000">
    lNodeCustomers.ChildNodes.Add(lNodeCustomer);

    // <name>
    lNodeAux := lXMLDoc.CreateNode('name', ntElement);
    lNodeAux.Text := 'Charter Group';

    // <customers>
    //   <customer id="55000">
    //     <name>Charter Group</name>
    lNodeCustomer.ChildNodes.Add(lNodeAux);

    // <address> - 1º
    lNodeAddress := lXMLDoc.CreateNode('address', ntElement);

    // <street>
    lNodeAux := lXMLDoc.CreateNode('street', ntElement);
    lNodeAux.Text := '100 Main';
    // <address>
    //   <street>
    lNodeAddress.ChildNodes.Add(lNodeAux);

    // <city>
    lNodeAux := lXMLDoc.CreateNode('city', ntElement);
    lNodeAux.Text := 'Framingham';
    // <address>
    //   <city>
    lNodeAddress.ChildNodes.Add(lNodeAux);

    // <state>
    lNodeAux := lXMLDoc.CreateNode('state', ntElement);
    lNodeAux.Text := 'MA';
    // <address>
    //   <state>
    lNodeAddress.ChildNodes.Add(lNodeAux);

    // <zip>
    lNodeAux := lXMLDoc.CreateNode('zip', ntElement);
    lNodeAux.Text := '01701';
    // <address>
    //   <zip>
    lNodeAddress.ChildNodes.Add(lNodeAux);

    lNodeCustomer.ChildNodes.Add(lNodeAddress);

    // <address> - 2º
    lNodeAddress := lXMLDoc.CreateNode('address', ntElement);

    // <street>
    lNodeAux := lXMLDoc.CreateNode('street', ntElement);
    lNodeAux.Text := '720 Prospect';
    // <address>
    //   <street>
    lNodeAddress.ChildNodes.Add(lNodeAux);

    // <city>
    lNodeAux := lXMLDoc.CreateNode('city', ntElement);
    lNodeAux.Text := 'Framingham';
    // <address>
    //   <city>
    lNodeAddress.ChildNodes.Add(lNodeAux);

    // <state>
    lNodeAux := lXMLDoc.CreateNode('state', ntElement);
    lNodeAux.Text := 'MA';
    // <address>
    //   <state>
    lNodeAddress.ChildNodes.Add(lNodeAux);

    // <zip>
    lNodeAux := lXMLDoc.CreateNode('zip', ntElement);
    lNodeAux.Text := '01701';
    // <address>
    //   <zip>
    lNodeAddress.ChildNodes.Add(lNodeAux);

    lNodeCustomer.ChildNodes.Add(lNodeAddress);

  // <address> - 3º
    lNodeAddress := lXMLDoc.CreateNode('address', ntElement);

    // <street>
    lNodeAux := lXMLDoc.CreateNode('street', ntElement);
    lNodeAux.Text := '120 Ridge';
    // <address>
    //   <street>
    lNodeAddress.ChildNodes.Add(lNodeAux);

    // <state>
    lNodeAux := lXMLDoc.CreateNode('state', ntElement);
    lNodeAux.Text := 'MA';
    // <address>
    //   <state>
    lNodeAddress.ChildNodes.Add(lNodeAux);

    // <zip>
    lNodeAux := lXMLDoc.CreateNode('zip', ntElement);
    lNodeAux.Text := '01760';
    // <address>
    //   <zip>
    lNodeAddress.ChildNodes.Add(lNodeAux);

    lNodeCustomer.ChildNodes.Add(lNodeAddress);

    Result := lXMLDoc.DocumentElement.XML;
  finally
    lXMLDoc.Free;
  end;
end;

procedure TfrmMain.btnExemplo3ExecuteClick(Sender: TObject);
var
  lHTTPResponse: IHTTPResponse;
  lXMLStream: TStringStream;
  lXMLStr: string;
  lResponseStr: string;
  lURL: string;
  lHeaders: TNetHeaders;
begin
  mmoExemplo3XML.Clear;
  Application.ProcessMessages;

  lURL := Format('%s%s', [edtURLBase.Text, edtExemplo3Resource.Text]);

  mmoExemplo3XML.Lines.Add('##### XML GERADO #####');
  lXMLStr := GerarXMLExemplo3;
  mmoExemplo3XML.Lines.Add(lXMLStr);
  mmoExemplo3XML.Lines.Add('');

  mmoExemplo3XML.Lines.Add('##### RETORNO DO SERVIDOR #####');
  mmoExemplo3XML.Lines.Add('');

  lXMLStream := TStringStream.Create(lXMLStr, TEncoding.UTF8);
  try
    lHeaders := [TNetHeader.Create('Content-Type', 'application/xml')];

    // Request
    lHTTPResponse := HTTPRequest.Client.Post(lURL, lXMLStream, nil, lHeaders);

    if (lHTTPResponse.StatusCode <> 200) then
      raise Exception.CreateFmt('%d - %s', [lHTTPResponse.StatusCode, lHTTPResponse.StatusText]);

    lResponseStr := lHTTPResponse.ContentAsString(TEncoding.UTF8);

    mmoExemplo3XML.Lines.Add(lResponseStr);
  finally
    lXMLStream.Free;
  end;
end;

procedure TfrmMain.btnExemplo4ExecuteClick(Sender: TObject);
var
  lHTTPResponse: IHTTPResponse;
  lXMLDoc: TXMLDocument;
  lURL: string;
begin
  mmoExemplo4XML.Clear;
  Application.ProcessMessages;

  lURL := Format('%s%s', [edtURLBase.Text, edtExemplo4Resource.Text]);

  // REQUEST
  lHTTPResponse := HTTPRequest.Client.Get(lURL);

  if (lHTTPResponse.StatusCode <> 200) then
    raise Exception.CreateFmt('%d - %s', [lHTTPResponse.StatusCode, lHTTPResponse.StatusText]);

  lHTTPResponse.ContentStream.Position := 0;
  if not Assigned(lHTTPResponse.ContentStream) then
    raise Exception.Create('Content response empty.');

  mmoExemplo4XML.Lines.Add('Content-Type: ' + lHTTPResponse.HeaderValue['Content-Type']);
  mmoExemplo4XML.Lines.Add('');

  // CARREGA XML
  lXMLDoc := TXMLDocument.Create(Application); // Free pelo middleware Horse-XMLDoc depois do "Send".
  try
    lXMLDoc.DOMVendor := GetDOMVendor(SMSXML);
    lXMLDoc.Options := lXMLDoc.Options + [doNodeAutoIndent];
    lXMLDoc.Active := True;
    lXMLDoc.Version := '1.0';
    lXMLDoc.Encoding := 'utf-8';

    lXMLDoc.LoadFromStream(lHTTPResponse.ContentStream);

    mmoExemplo4XML.Lines.Add(lXMLDoc.DocumentElement.XML);
  finally
    lXMLDoc.Free;
  end;
end;

end.
