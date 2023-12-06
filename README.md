![Maintained YES](https://img.shields.io/badge/Maintained%3F-yes-green.svg?style=flat-square&color=important)
![Memory Leak Verified YES](https://img.shields.io/badge/Memory%20Leak%20Verified%3F-yes-green.svg?style=flat-square&color=important)
![Release](https://img.shields.io/github/v/release/antoniojmsjr/Horse-XMLDoc?label=Latest%20release&style=flat-square&color=important)
![Stars](https://img.shields.io/github/stars/antoniojmsjr/Horse-XMLDoc.svg?style=flat-square)
![Forks](https://img.shields.io/github/forks/antoniojmsjr/Horse-XMLDoc.svg?style=flat-square)
![Issues](https://img.shields.io/github/issues/antoniojmsjr/Horse-XMLDoc.svg?style=flat-square&color=blue)</br>
![Compatibility](https://img.shields.io/badge/Compatibility-Horse-3db36a?style=flat-square)
![Delphi Supported Versions](https://img.shields.io/badge/Delphi%20Supported%20Versions-XE7%20and%20above-3db36a?style=flat-square)

# Horse-XMLDoc

**Horse-XMLDoc** é um middleware de tratamento para requisições que contenham XML no body, desenvolvido parar o framework [Horse](https://github.com/HashLoad/horse).

## ❓ O que é um XML?

O **XML(eXtensible Markup Language)** é uma linguagem de marcação como o HTML, utilizada para **estruturar**, **armazenar** e **transportar dados** e que pudesse ser lido por software, e integrar-se com as demais linguagens.

[Continue lendo...](https://github.com/antoniojmsjr/Horse-XMLDoc/blob/main/XML.md)

## ⚙️ Instalação Automatizada

Utilizando o [**Boss**](https://github.com/HashLoad/boss/releases/latest) (Dependency manager for Delphi) é possível instalar a biblioteca de forma automática.

```
boss install github.com/antoniojmsjr/Horse-XMLDoc
```

## ⚙️ Instalação Manual

Se você optar por instalar manualmente, basta adicionar as seguintes pastas ao seu projeto, em *Project > Options > Delphi Compiler > Target > All Configurations > Search path*

```
..\Horse-XMLDoc\Source
```

## ⚡️ Uso

#### Uso e definição do middleware

```delphi
uses Horse, Horse.XMLDoc, Xml.XMLDoc;

THorse
  .Use(THorseXMLDoc.New
       .DOMVendor(TDOMVendorType.MsXML)
       .ContentTypeXML(['application/xhtml+xml'])
       .Encoding('utf-8')
       .Intercept);
OU

THorse
  .Use(THorseXMLDoc.New.Intercept);
```

```delphi
THorseXMLDoc.New
  .DOMVendor(...)
  .ContentTypeXML([...])
  .Encoding(...)
  .Intercept;
```
* `DOMVendor`: Identificação do motor de processsamento do XML. [Verificar](https://github.com/antoniojmsjr/Horse-XMLDoc/blob/main/XML.md)
  * Default: TDOMVendorType.MsXML (Ambiente Microsoft Windows) / TDOMVendorType.OmniXML (Ambiente Cross-platform)
* `ContentTypeXML`: Identificação do [MIME types](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types) que serão interceptados pelo middleware.
  * Default: application/xml e text/xml
* `Encoding`: Identificação do Encoding do documento XML.
  * Default: utf-8
* `Intercept`: Função responsável pela interceptação e tratatamento das requisições com XML.

#### Exemplo

```delphi
uses Horse, Horse.XMLDoc, Xml.XMLDoc;

THorse
  .Use(THorseXMLDoc.New.Intercept);

THorse.Get('ping',
  procedure(Req: THorseRequest; Res: THorseResponse)
  var
    lBodyXML: TXMLDocument;
  begin
    //Parse usando middleware Horse-XMLDoc
    lBodyXML := Req.Body<TXMLDocument>;
  
    Res.Send<TXMLDocument>(lBodyXML);  
  end);
```

#### Exemplo com manipulação

**ATENÇÃO:** Para manipular o XML utilizando o middleware Horse-XMLDoc com o componente **TXMLDocument** é necessário cria a variável com um **container**, internamente o componente TXMLDocument utilia interface para manipular o XML, e não informando um container a interface é eliminada pelo ARC do Delphi gerando alguns erros, como, "No active document", "Invalid pointer operation" ou até mesmo o travamento do aplicativo.

```delphi
var
  lXMLDoc: TXMLDocument;

  lXMLDoc: TXMLDocument

  lXMLDoc := TXMLDocument.Create(XMLContainer); // Container da unit Horse.XMLDoc

  .....
```


