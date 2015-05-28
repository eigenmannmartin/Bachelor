

# Design des Prototypen
In diesem Kapitel werden die aus dem Kapitel [Konzept] gewonnenen Erkenntnisse so umgesetzt dass sie den Anforderungen aus dem Kapitel [Anforderungsanalyse] genügen.

## Design-Ansätze

!!!! Verwendung von Singlestate
!!!! Anforderungsanalyse

### Nachrichtenbasierte Architektur
Versenden einzelner Nachrichten -> Direkte Anwendung für Konzept

### Modellbasierte Architektur
Versenden der daraus resultierenden Stati -> Indirekte Anwendung für Konzept

## Entscheid
Nachrichtenbasiert -> weniger verbreitet, komplexer in der Implementation -> einfachere Transition.




## Design
Der Prototyp besteht aus 3 Bausteinen; Server, API und Client.
![Bausteinübersicht](img/design_components.jpg)

Die Bausteine werden in den folgenden Kapitel erläutert.

### Nachrichten
Alle im System versendeten Nachrichten sind nach dem selben Schema strukturiert, um so unnötige Konvertierungen zu vermeiden.

Eine Nachricht wir entsprechend ihrem Ziel und Funktion benannt.

[Target] _ [Layer] _ [Modul] _ [Funktion]

-------------------------------------------------------------------------------
__Teil__                    __Beschreibung__
--------------------------- --------------------------------------------------
__Target__                  _S_ für Server und _C_ für Client

__Layer__                   Layername

__Modul__                   Modulname

__Funktion__                Funktionsname

-------------------------------------------------------------------------------

Der Payload besteht aus dem Meta-Teil, welcher die Collection angibt, sowie dem Data Teil, welcher das neue Objekt und das alte Objekt, falls vorhanden, beinhaltet.

Somit ist implizit eine Mutationsfunktion, und die Referenz auf den Status definiert.


### Backend
Jede über die API eingehende Nachricht wird an den Logik-Layer weitergeleitet.
Der Logik-Layer übernimmt die Verarbeitung, also die Konfliktauflösung und die Verwaltung der Datenhaltung.


#### Logik
Der Logik-Layer führt die Konfliktauflösung sowie die Verwaltung des Status durch. Es werden vier Nachrichten akzeptiert, welche dem SQL Jargon nachempfunden sind.

-------------------------------------------------------------------------------
__Nachrichtname__           __Beschreibung__
--------------------------- --------------------------------------------------
S_LOGIC_SM_select           Die Abfrage-Nachricht gibt eine oder mehrere
                            Objekte zurück.

S_LOGIC_SM_create           Die Einfügenachricht erstellt ein neues Objekt
                            und gibt dieses zurück.

S_LOGIC_SM_update           Die Mutationsnachricht aktualisiert ein
                            vorhandenes Objekt.

S_LOGIC_SM_delete           Die Löschnachricht löscht ein vorhandenes Objekt.

-------------------------------------------------------------------------------

Die Resultate werden nach vollständiger Bearbeitung dem Sender der ursprünglichen Nachrichten über eine neue Nachricht mitgeteilt.

#### Persistenz
Das Verhalten des Singlestate Konzepts ist mit einer Datenbank abbildbar.


### API
Die API besteht sowohl aus einem serverseitigem als auch clientseitigem Modul. Nachrichten werden zwischen beiden Modulen ausgetauscht. Im Falle eines Verbindungsunterbruchs werden die Nachrichten zwischengespeichert und bei einer Wiederverbindung zugestellt.

Die Benennung der Nachrichten ist den bekannten Funktionen des HTTP Standards nachempfunden.

-------------------------------------------------------------------------------
__Nachrichtname__           __Beschreibung__
--------------------------- --------------------------------------------------
S_API_WEB_get               Die Get-Nachricht gibt eines oder alle Objekte
                            einer Collection zurück.

S_API_WEB_put               Ein neues Objekt wird mit der Put-Nachricht
                            erstellt.

S_API_WEB_update            Mit der Update-Nachricht können bestehende Objekte 
                            aktualisiert werden.   

S_API_WEB_delete            Bestehende Objekte können mit der Delete-Nachricht 
                            gelöscht werden.

-------------------------------------------------------------------------------


### Frontend
Das Frontend ist der Flux-Architektur nachempfunden. Die beiden Nachrichten können von den Views versendet werden, aktualisieren somit den Store und werden dem Backend übermittelt.

-------------------------------------------------------------------------------
__Nachrichtname__           __Beschreibung__
--------------------------- --------------------------------------------------
C_PRES_STORE_update         Fügt ein Objekt hinzu oder aktualisiert ein
                            bestehendes.

C_PRES_STORE_delete         Löscht ein bestehendes Objekt.

-------------------------------------------------------------------------------

### Datenfluss
Frontend    <->  API    <->     Backend

Frontend: ActionCreator -> Dispatcher -> Store -> API -> ActionCreator

API: Queue -> Transporter

Backend: API -> Logiclayer -> API 


### Flux Architektur
Das Flux Paradigma...
![Flux Diagramm](img/flux-diagram.png)

### AMD Pattern
Asyncronous module definition (AMD) ist eine JavaScript API um Module zu definieren und diese zur Laufzeit zu laden. Dadurch können Javascript-lastige Webseiten beschleunigt werden, da Module erst geladen werden, wenn sie gebraucht werden. Weiter werden durch den Loader die Module gleichzeitig geladen, dadurch kann die Bandbreite voll ausgenutzt werden. 
Da die Module durch die Vorgabe des Patterns in einzelnen Dateien abgelegt sind, wird eine Kapselung ähnlich wie bei Java erreicht. Das erleichtert die Fehlersuche und erhöht die Verständlichkeit des Programmes drastisch. Auch die Wiederverwendbarkeit der Module wird dadurch erhöht.
Da in jedem Modul die Abhängigkeiten definiert werden müssen, kann während dem Build-Prozess die Abhängigkeiten geprüft werden, um so die Verfügbarkeit aller benötigten Module sicher zu stellen.


## Beispielapplikation
Gem. Aufgabenstellung soll der Prototyp anhand eines passenden Fallbeispiel die Funktionsfähigkeit Zeigen.

Die Beispielapplikation soll eine Ressourcenplan-Software sein. Folgendes soll möglich sein:

1. einen neuen Raum erfassen (Name, Grösse, Anzahl Sitze)
2. einen bestehenden Raum anpassen/löschen
3. einen Termin auf einem Raum Buchen (Name, Zeit&Datum, Kurzbeschreibung, Besucherliste, persönliche Notizen)
4. einen Bestehenden Termin anpassen/absagen



\part[Implementation]{Implementierung und Testing}


# Prototyp
Dieses Kapitel adressiert die Implementation des Prototypen gemäss den Anroderungen aus Kapitel [Analyse].

## Umsetzung
<!-- Konkrete Implementations-Streategie/Algorythmen --> 

## Technologie Stack

-------------------------------------------------------------
Software            Beschreibung/Auswahlgrund
------------------- ------------------------------------------------
__Grunt__           
                    Grunt ermöglicht es dem Benutzer vordefinierte Tasks von der Kommandozeile aus durchzuführen. So sind Build- und Test-Prozesse für alle Benutzer ohne detaillierte Kenntnisse durchführbar.
                    Da Grunt eine sehr grosse Community besitzt und viele Plugins sowie hervorragende Dokumentationen verfügbar, wurde Grunt eingesetzt.

__Karma__           
                    Karma ist ein Testrunner, der Tests direkt im Browser ausführt. Weiter können automatisch Coverage-Auswertungen durchgeführt werden.

__CoffeeScript__
                    CoffeeScript ist ein einfach zu schreibende Sprache die zu JavaScript compiliert. Das generierte JavaScript ist optimiert und ist meist schneller als selbst geschriebenes JavaScript.

__RequireJS__       
                    RequireJS ermöglicht die Implementierung des AMD Pattern.Dadurch können auch in JavaScript Code-Abhängigkeiten definiert werden. Zusammen mit r.js kann dies bereits zur Compilierzeit geprüft werden.
                    Da weder Backbone noch Django über eine Depencency-Control für JavaScript verfügen, setze ich RequireJS ein.

__ReactJS__         
                    ReactJS ist eine Frontend Library die eine starke Modularisierung fordert. Das Paradigma des "Source of Trouth" verhindert darüber hinaus, dass "komische" Anzeigefehler auftreten.

__FluxifyJS__       
                    FluxifyJS ist eine leichtgewichtige Implementierung des Flux Paradigmas. Sie bietet sowohl Stores als auch einen Dispatcher.

__SequelizeJS__     
                    SequelizeJS ist eine sehr bekannte und weit verbreitete ORM Implementation für Node und Express.

__Express__         
                    Express ist ein WebFrameowrk für Node. Die weite Verbreitung und ausführliche Dokumentation machen Express zur idealen Grundlage einer Node Applikation.

__Socket.io__
                    Socket.io ist eine Implementation des Websocket Standards und erlaubt eine Asynchrone Kommunikation zwischen Client und Server.

-------------------------------------------------------------

## Entwicklungsumgebung
Grunt + Karma = All you need

## Entwicklung
Tricks mit API & Message Routing, binding to io.on 'message' -> flux.doAction

Express Server: 
Statisches Daten -> Frontend /
Socket.io -> /socket.io
Message-Bus -> Fluxify also in the backend


RequireJS Modules testable in the Browser :-D

Stores in the Frontend
Models in the Backend


## Grafische Umsetzung Fallbeispiel


# Testing

## Unit-Testing

## Integration-Testing
