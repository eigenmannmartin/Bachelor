

Design des Prototypen
=====================
In diesem Kapitel wird ein Prototyp entworfen, der die Erkenntnisse aus dem Kapitel [Konzept Untersuchung] so umgesetzt dass sie auch den Richtlinien aus dem Kapitel [Leitfaden] genügen.


Konzeptbestandteile
-------------------
Die Konventionen und Richtlinien des Kapitels [Leitfaden] berücksichtigend müssen nicht alle im Konzept erarbeiteten Ansätze umgesetzt werden.
Die Datenübermittlung wird Unterschieds basiert durchgeführt und serverseitig mit einem auf dem Konzept des Singlestate basierenden Datenspeichers komplettiert. Zur Konfliktvermeidung wird sowohl die Update Transformation, wiederholbare Transaktionen als auch Serverfunktionen verwendet. Bezüglich der Konfliktauflösung wird nur die Zusammenführung umgesetzt, da Konflikte explizit erlaubt sind.



Design
------
Der Prototyp besteht aus 3 Bausteinen; Server, API und Client.
![Bausteinübersicht](img/design_components.jpg)
Die API-Komponente steht für sich alleine, obschon sie von Server und Client direkt angesprochen wird und implementatiorisch in eine Server und eine Client Part geteilt ist. Weiter übernimmt die API-Komponente den Nachrichtenaustausch zwischen Server und Client. 
Die Bausteine, sowie deren Interaktion miteinander, wird in den folgenden Kapitel genauer erläutert.


### Backend
Das Backend ist in drei Schichten unterteilt (Api, Logik und Persistenz), um so eine möglichst grosse Separation of Concerns (SoC) zu erreichen. Die Kommunikation zwischen diesen Schichten findet nur über Nachrichten statt.

Jede über die API eingehende Nachricht wird an den Logik-Layer weitergeleitet.
Der Logik-Layer übernimmt dann die Verarbeitung und leitet dann die Resultate der Persistenz-Schicht weiter.

### API
Die API stellt wenn immer möglich einen ständigen Kommunikationskanal zwischen Server und Client her. Der serverseitige Part der API kann sowohl broadcast Nachrichten als auch an nur einen Client gerichtet Nachrichten verwenden. Die API verfügt jedoch über keine MessageQueue und Nachrichten die nicht beim ersten Versucht zugestellt werden können, gehen verloren.

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

S_API_WEB_execute           Die Execute-Nachricht führt eine Serverfunktion 
                            aus.

-------------------------------------------------------------------------------
Table: Nachrichten Server-API


#### Logik
Der Logik-Layer führt die Konfliktauflösung sowie die Verwaltung des Status durch. Es werden vier Nachrichten akzeptiert, welche dem SQL Jargon nachempfunden sind, sowie eine execute Nachricht. Die Resultate werden nach vollständiger Bearbeitung dem Sender der ursprünglichen Nachrichten über eine neue Nachricht mitgeteilt.

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

S_LOGIC_SM_execute          Die Ausführnachricht löst die Ausführung einer
                            Serverfunktion aus.

-------------------------------------------------------------------------------
Table: Nachrichten Server-Logik


#### Persistenz
Die Persistenz muss nur einen einzigen Status verwalten. Das Verhalten des Singlestate Konzepts ist mit einer Datenbank abbildbar. Der referenzierte Status wird jeweils in der Nachricht vom Client mitgeliefert. Ein wahlfreier Zugriff auf vergangene Stati ist deshalb nicht notwendig.

### Frontend
Das Frontend ist auf der Flux-Architektur aufbauen. Die beiden Nachrichten können von den Views versendet werden, aktualisieren den Store und werden vom Client-API Teil verarbeitet.

-------------------------------------------------------------------------------
__Nachrichtname__           __Beschreibung__
--------------------------- --------------------------------------------------
C_PRES_STORE_update         Fügt ein Objekt hinzu oder aktualisiert ein
                            bestehendes.

C_PRES_STORE_delete         Löscht ein bestehendes Objekt.

-------------------------------------------------------------------------------
Table: Nachrichten Client

### Nachrichten
Nachrichten können entweder eine Serverfunktion aufrufen oder eine Mutation durchführen. Der Payload besteht aus dem Meta-Teil, welcher den Objektnamen oder die Serverfunktion bezeichnet, sowie dem Data-Teil, welcher die Mutationsfunktion oder die Argumente der Serverfunktion beinhaltet.

Die Mutationsfunktion wird implizit durch die Übermittlung vom neuen Status (obj) und dem vorhergehenden Status (prev) umgesetzt.

``` {.coffee}
Message = {
    messageName: ""
    meta: {
        model: ""
        function: ""
    }
    data: {
        obj: {}
        prev: {}
        args: {}
    }

}

``` 
<!-- 
```
-->


### Datenfluss
Der Datenfluss des Prototypen funktioniert wie in der Abbildung {@fig:dataflow} dargestellt. Der gesamte Datenfluss findet nur über Nachrichten

Zu beachten gilt, dass die gesamte Interkomponenten-Kommunikation asynchron durchgeführt wird.

![Datenflussdiagramm](img/dataflow.png) {#fig:dataflow}

<!--Frontend    <->  API    <->     Backend

Frontend: ActionCreator -> Dispatcher -> Store -> API -> ActionCreator

API: Queue -> Transporter

Backend: API -> Logiclayer -> API -->


<!-- Nachrichtenbasiert, desshalb Flux -->
### Flux Architektur
Das Flux Paradigma[@facebook-flux] ist eine Applikationsarchitektur entwickelt von Facebook für React, welche einen unidirektionalen Datenfluss vorgibt.
Daten können nur über eine Aktionen manipuliert werden. Die Views als auch die API können Aktionen auslösen, und so den Datenbestand mutieren.
![Flux Diagramm](img/flux-diagram.png)

Die Verwendung des Dispatchers ermöglicht es, Abhängigkeiten zwischen verschiedenen Stores zentral zu verwalten, da jeder Mutation zwangsweise zuerst von ihm bearbeitet wird.

<!-- Testing und Modularität, desshalb AMD -->
### AMD Pattern
Asyncronous module definition (AMD) ist eine JavaScript API um Module zu definieren und diese zur Laufzeit zu laden. Dadurch können Javascript-lastige Webseiten beschleunigt werden, da Module erst geladen werden, wenn sie gebraucht werden. Weiter werden durch den Loader die Module gleichzeitig geladen, dadurch kann die Bandbreite voll ausgenutzt werden. 
Da die Module durch die Vorgabe des Patterns in einzelnen Dateien abgelegt sind, wird eine Kapselung ähnlich wie bei Java erreicht. Das erleichtert die Fehlersuche und erhöht die Verständlichkeit des Programmes drastisch. Auch die Wiederverwendbarkeit der Module wird dadurch erhöht.
Da in jedem Modul die Abhängigkeiten definiert werden müssen, kann während dem Build-Prozess die Abhängigkeiten geprüft werden, um so die Verfügbarkeit aller benötigten Module sicher zu stellen.


## Beispielapplikation
Gem. Aufgabenstellung soll der Prototyp anhand eines passenden Fallbeispiel die Funktionsfähigkeit und Praxistauglichkeit zeigen Dazu wird das erste Fallbeispiel "Synchronisation von Kontakten" umgesetzt.

Die Beispielapplikation soll eine Ressourcenplan-Software sein. Folgendes soll möglich sein:

1. einen neuen Kontakt erfassen oder einen Bestehenden ändern
2. einen bestehenden Kontakt löschen
3. neue Email-Adresse oder Telefonnummer erfassen oder bestehende anpassen
4. persönliche Notizen zu einem Kontakt hinterlegen



\part[Implementation]{Implementierung und Testing}


# Prototyp
Dieses Kapitel adressiert die Implementation des Prototypen gemäss den Anroderungen aus Kapitel [Analyse].

## Umsetzung
<!-- Konkrete Implementations-Streategie/Algorythmen --> 

<!-- Begründung Technologiestack -->
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
Die Entwicklungsumgebung ist so portabel wie möglich gestaltet. Alle benötigten Abhängigkeiten sind automatisiert installierbar. Die dazu nötigen Befehle sind nachfolgend aufgeführt.

``` {.bash}
> bower install
> npm install
``` 
<!-- 
```
-->


## Entwicklung
<!--Tricks mit API & Message Routing, binding to io.on 'message' -> flux.doAction -->

Sowohl über die API eingehende Nachrichten, als auch interne Nachrichten des Servers werden gleichwertig behandelt.

server/api.coffee
``` {.coffee}
me = @
@Socket.on 'message', ( msg ) ->
    me.dispatch msg.messageName, msg.message

flux.dispatcher.register (messageName, message) ->
    me.dispatch messageName, message

``` 
<!-- 
```
-->



Express Server: 
Statisches Daten -> Frontend /
Socket.io -> /socket.io

<!-- Message-Bus -> Fluxify also in the backend -->
Auch das Backend verwendet Fluxify als zentralen MessageBus. Eine Einheitliche Code-Struktur sowie ein besseres Verständnis ist dadurch begünstigt.


<!--RequireJS Modules testable in the Browser :-D -->
Durch den Einsatz von RequireJS Modulen sind diese auch mit Karma direkt im Browser Testbar. So sind statische Analysen über das gesamte Projekt in nur einem Schritt durchführbar.




<!-- Implementierung Konfliktauflösung -->
Die Implementation des Konfliktverhinderungsverfahren "Wiederholbare Transaktion" sowie der Konfliktauflösungsverfahren "Zusammenführung", "kontextbezogene Zusammenführung" sowie die traditionelle Synchronisation


``` {.coffee}
_repeatable: (data, db_obj, new_obj, prev_obj, attr) ->
    if new_obj[attr]?
        data[attr] = db_obj[attr] + (new_obj[attr] - prev_obj[attr])

_combining: (data, db_obj, new_obj, prev_obj, attr) ->
    if new_obj[attr]?
        data[attr] = if new_obj[attr] is prev_obj[attr] 
        then db_obj[attr] else new_obj[attr]

_traditional: (data, db_obj, new_obj, prev_obj, attr) ->
    if new_obj[attr]?
        data[attr] = if prev_obj[attr] is db_obj[attr] 
        then new_obj[attr] else db_obj[attr] 

_contextual: (data, db_obj, new_obj, prev_obj, attr, context) ->
    if new_obj[attr]?
        data[attr] = if prev_obj[context] is db_obj[context] 
        then new_obj[attr] else db_obj[attr] 


``` 
<!-- 
```
 -->



Stores in the Frontend
client/store.coffee
``` {.coffee}
flux.createStore
     id: "prototype_rooms",
    initialState: 
        rooms : []
            
    actionCallbacks:
        C_PRES_STORE_update: ( updater, msg ) ->
            ...
``` 
<!-- 
```
-->


Models in the Backend

server/models/*
``` {.coffee}
module.exports = (sequelize, DataTypes) ->
    Room = sequelize.define "Room", { 
        name: DataTypes.STRING
        description: DataTypes.TEXT

        free: DataTypes.BOOLEAN
        beamer: DataTypes.BOOLEAN
        ac: DataTypes.BOOLEAN
        seats: DataTypes.INTEGER

        image: DataTypes.STRING
    }, {}
``` 
<!-- 
```
-->


Graphische Umsetzung
--------------------

![Edit](img/umsetzung-Contacts.png)

![Edit](img/umsetzung-Contacts-edit.png)



Testing
=======

Die Testrunner Suite Karma erlaubt es Programmcode direkt im Browser zu testen und statische Analyse darüber anzufertigen.

![Karma Testrunner](img/tdd.png)

