## ❓ O que é um XML?

O **XML(eXtensible Markup Language)** é uma linguagem de marcação como o HTML, utilizada para **estruturar**, **armazenar** e **transportar dados** e que pudesse ser lido por software, e integrar-se com as demais linguagens.

A grande vantagem do XML é facilitar o compartilhamento de dados. Seu armazenamento é feito em texto, permitindo que a leitura seja feita por diferentes aplicativos.

#### Principios

* Separação entre contéudo e formatação;
  Contéudo: Informação/Dados.
  Formatação: Utiliza-se TAG's para delimitação dos dados.
* Simplicidade e legibilidade, tanto para humanos quanto para computadores;
* Interoperabilidade entre sistemas;

#### Estrututa

XML é um formato para a criação de documentos com dados organizados de forma hierárquica.

* Declaração/cabeçalho XML: Deve sempre ser incluida pois define a versão e o encoding do XML do documento;
* Elemento raiz: Sempre deve existir um elemento raiz em um documento XML;
* Elementos: Elementos são TAG's que compõem o XML, onde os dados são encapsulados.
  * Definidos da seguinte forma: `<tag>conteúdo</tag>;`
* Atributos XML: Os atributos em XML são usados para descrever os elementos XML ou para fornecer uma informação adicional sobre os elementos.
  * Definidos da seguinte forma: `name="value"`;

Observações

* Os documentos XML são sensíveis a letras **maiúsculas** e **minúsculas**;
* Cada TAG inicial tem um tag final, ou seja, as tags são usadas sempre em pares;

![EstruturaXML](https://github.com/antoniojmsjr/Horse-XMLDoc/assets/20980984/9c92ee8c-9f28-43c5-ae71-069b04a593c0)

#### DOM(Document Object Model)

É uma representação na memória de um documento XML. O DOM permite que você leia, manipule e modifique programaticamente um documento XML.

Nota: Como a grande maioria do código que usa o DOM gira em torno da manipulação de documentos XML, é comum sempre se referir aos nós no DOM como elementos, pois em um documento XML, cada nó é um elemento.

<img loading="lazy" src="https://github.com/antoniojmsjr/Horse-XMLDoc/assets/20980984/c17e7c16-f4d5-4501-b247-8685ae927817" width="600" height="600"/>

## ⭕ XML com Delphi

O Delphi disponibiliza nativamente uma classe de tratamento de XML, para qualquer tipo de manipulação do XML;

A classe **TXMLDocument** da unit [Xml.XMLDoc](https://docwiki.embarcadero.com/Libraries/Alexandria/en/Xml.XMLDoc) que faz todo o tratamento do documento XML.

#### Motores de tratamento do XML

Hoje no Delphi existe 3 motores de tratamento do XML, internamente são conhecido como [DOMVendor](https://docwiki.embarcadero.com/RADStudio/Alexandria/en/Using_the_Document_Object_Model)

| DOMVendor | Unit | Sistema Operacional | Biblioteca |
|---|---|---|---|
|**MSXML**|[Xml.Win.msxmldom](https://docwiki.embarcadero.com/Libraries/Alexandria/en/Xml.Win.msxmldom)| Microsot Windows |msxml5.dll/msxml6.dll|
|**OmniXML**|Xml.omnixmldom| Cross-platform |[omnixml](https://code.google.com/archive/p/omnixml/)|
|**ADOM**|Xml.adomxmldom| Cross-platform |[adom](https://www.philo.de/xml/downloads.shtml)|