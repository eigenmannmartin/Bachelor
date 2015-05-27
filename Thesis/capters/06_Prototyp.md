

# Design des Prototypen
In diesem Kapitel werden die aus dem Kapitel [Konzept] gewonnenen Erkenntnisse umgesetzt.

## Design-Ansätze
Zur Lösung der Aufgabenstellung wurden drei Design-Ansätze erarbeitet. Diese werden folgend kurz erläutert.

### Server zentrierte Architektur
Der Server führt alle Berechnungen o.ä. durch. Nur mit einer aktiven Verbindung zum Server können Manipulationen am Datenbestand durchgeführt werden.

### Client zentrierte Architektur
Der Client trifft Entscheidungen und führt die Berechtigungsprüfung durch. Die Resultate werden dann dem Server übermittelt.

### Client zentrierte, Server basierte Architektur
Der Client simuliert alle Manipulationen. Der Server entscheidet über das Resultat.

## Entscheid
Anforderung UC 5-8 => {Client zentrierte, Server basierte Architektur, Message Oriented}


## Design
Der Prototyp besteht aus 3 Bausteinen; Server, API und Client.

![Bausteinübersicht](img/design_components.jpg) {#fig:bausteinübersicht}

Die Bausteine werden in den folgenden Kapitel erläutert.

### Backend
Alle Daten müssen zur Aufbereitung in das Backend transferiert werden.
Im Backend wird zwischen Persistenz- und Logik-Schicht unterschieden.

#### Logik
Die Logik-Schicht nimmt alle Nachrichten entgegen und führt, sofern aufgetreten Konfliktauflösungen vor.
Die Kommunikation mit der API findet nur über Nachrichten statt.
Die Kommunikation mit der darunter liegenden Persistenz-Schicht findet über eine Asynchrone API statt.

S_LOGIC_SM_get
S_LOGIC_SM_create
S_LOGIC_SM_update
S_LOGIC_SM_delete

#### Persistenz
Die Persistenz soll Modell-Basiert sein.


### API
Message Queuing & Message Passing - nothing else

Umsetzung mit REST-Like Verhalten (get,put,update,delete)

__Client-Side__
S_API_WEB_get
S_API_WEB_put
S_API_WEB_update
S_API_WEB_delete

__Server-Side__
S_API_WEB_send

### Frontend
Der Client bietet keine Persistenz über einen Neustart hinweg.

![Flux Diagramm](img/flux-diagram.png)

C_PRES_STORE_update
C_PRES_STORE_delete

### Message Flow

Frontend    <->  API    <->     Backend

Frontend: ActionCreator -> Dispatcher -> Store -> API -> ActionCreator

API: Queue -> Transporter

Backend: API -> Logiclayer -> API 


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

__CoffeeScript__

__RequireJS__       
                    RequireJS ermöglicht die Implementierung des AMD Pattern.Dadurch können auch in JavaScript Code-Abhängigkeiten definiert werden. Zusammen mit r.js kann dies bereits zur Compilierzeit geprüft werden.
                    Da weder Backbone noch Django über eine Depencency-Control für JavaScript verfügen, setze ich RequireJS ein.

__ReactJS__

__FluxifyJS__

__SequelizeJS__

__Express__

__Socket.io__

-------------------------------------------------------------

## Entwicklungsumgebung
Grunt + Karma = All you need

## Entwicklung
Verwendung vom Socket io (Namespaces etc)
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

## Test der Akzeptanzkriterien

## Überprüfung der Aufgabenstellung
