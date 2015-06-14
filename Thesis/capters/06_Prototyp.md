
<!-- !!!!!!!!!!!!!!!!!!!!Auswahl der Konzepte -->


<!--
Create Contact -> Server Funktion


Wo kann Multistate eingesetzt werden?
-> wenn nur Schreibend zugegriffen wird. (z.B. git? -> Tests, welche alle Versionen validieren (lauffähig))

Wo und wann kann die geschätzte Zusammenführung angewendet werden?
-> Statische Analysen, gut analysierbare daten.

Gibt es bessere Synch Verfahre?
-> klar - aber immer an ein Problem angepasst

-->


Design des Prototypen
=====================
In diesem Kapitel wird ein Prototyp entworfen, der, der Konklusion aus dem Kapitel [Konzept Untersuchung] und den Richtlinien aus dem Kapitel [Leitfaden] genügt. Da der Quellcode einsehbar ist, wird hier nur auf die Entscheide und Details der Implementation eigegangen, welche nicht aus dem Quellcode ersichtlich sind.


Designentscheidungen
--------------------
Die Datenübermittlung wird basierend auf den Erkenntnissen aus den vorhergehenden Kapiteln, Unterschieds basiert durchgeführt und serverseitig mit einem, auf dem Konzept des Singlestate basierenden, Datenspeicher komplettiert. Dieses Nachrichten basierte Kommunikationskonzept wird geradezu perfekt durch die [Flux Architektur] umgesetzt. Jede Benutzerinteraktion mit dem Client erzeugt eine neue Nachricht. Daten verändernde Nachrichten können so auf einfache Art und Weise auch dem Server übermittelt werden.

Um die Modulare Struktur, welche vom Flux vorgegeben wird zu komplettieren wird das AMD Pattern verwendet. Dadurch können Module und deren Abhängigkeiten gleichermassen für Server und Client definiert werden.


Auswahl Synchronisations- und Konfliktauflösungs-verfahren
----------------------------------------------------------
Zur Konfliktvermeidung werden alle erarbeiten Konzepte umgesetzt, es werden also sowohl die Update Transformation, wiederholbare Transaktionen als auch Serverfunktionen implementiert. Bezüglich der Konfliktauflösung wird nur die Zusammenführung umgesetzt, da einerseits Konflikte explizit erlaubt sind und andererseits nur die Zusammenführung garantiert fehlerfreie Resultate liefert.


Design
------
Der Prototyp besteht aus den drei Bausteinen: Server, API und Client.
![Bausteinübersicht](img/design_components.jpg)
Die API-Komponente steht für sich alleine, obschon sie sowohl im Server als auch im Client direkt eingebettet ist. Die API-Komponente selbst ist aufgeteilt in einen Server- und Client-Teil und stellt den Austausch der Nachrichten zwischen Server und Client sicher.

Die Bausteine, sowie deren Interaktion miteinander, wird in den folgenden Kapitel genauer erläutert.

### Datenfluss
Der Datenfluss des Prototypen ist wie in der Abbildung {@fig:dataflow} dargestellt, nur unidirektional. Daraus ergibt sich auch, dass die gesamte Interkomponenten-Kommunikation, vom Client bis hin zum Server, asynchron durchgeführt wird.

![Datenflussdiagramm](img/dataflow.png) {#fig:dataflow}


### Nachrichten
Jede versendete Nachricht enthält neben einem Nachrichtennamen, den zu versendenden Daten auch Meta-Informationen. In den Meta-Informationen ist der Name der versendeten Daten oder der Name der Serverfunktion eingetragen.
Neben der des gesamten veränderten Elements wird auch das zuvor aktive Element in den Daten übermittelt. Dadurch kann auf dem Server das Delta ermittelt werden.

<!--
``` {.coffee}
Message = {
    messageName: ""
    meta: {
        model: ""
        func: ""
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




### Backend
Das Backend ist in drei Schichten Api, Logik und Persistenz unterteilt, um so eine möglichst grosse Separation of Concerns (SoC) zu erreichen. Die Kommunikation zwischen diesen Schichten findet nur über Nachrichten statt. Jede über die API eingehende Nachricht wird an den Logik-Layer weitergeleitet. Der Logik-Layer übernimmt dann die Verarbeitung und leitet dann die Resultate der Persistenz-Schicht weiter.

### API
Die API stellt wenn immer möglich einen ständigen Kommunikationskanal zwischen Server und Client her. Der serverseitige Part der API kann sowohl broadcast Nachrichten als auch an nur einen Client gerichtet Nachrichten verwenden. Die API verfügt jedoch über keine MessageQueue und Nachrichten die nicht beim ersten Versucht zugestellt werden können, gehen verloren.

Die Benennung der Nachrichten ist den bekannten Funktionen des HTTP Standards nachempfunden. So ist die tatsächliche Implementation der API maximal flexibel und trotzdem immer noch Standard konform.

-------------------------------------------------------------------------------
__Nachrichtname__           __Beschreibung__
--------------------------- --------------------------------------------------
S_API_WEB_get               
                            Die Get-Nachricht gibt eines oder alle Objekte einer Collection zurück.

S_API_WEB_put               
                            Ein neues Objekt wird mit der Put-Nachricht erstellt.

S_API_WEB_update
                            Mit der Update-Nachricht können bestehende Objekte aktualisiert werden.   

S_API_WEB_delete            
                            Bestehende Objekte können mit der Delete-Nachricht gelöscht werden.

S_API_WEB_execute           
                            Die Execute-Nachricht führt eine Serverfunktion aus.

-------------------------------------------------------------------------------
Table: Nachrichten Server-API


#### Logik
Der Logik-Layer führt die Konfliktauflösung sowie die Verwaltung des Status durch. Es werden vier Nachrichten akzeptiert, welche dem SQL Jargon nachempfunden sind, sowie eine execute Nachricht. Die Resultate werden nach vollständiger Bearbeitung dem Sender der ursprünglichen Nachrichten über eine neue Nachricht mitgeteilt.

-------------------------------------------------------------------------------
__Nachrichtname__           __Beschreibung__
--------------------------- --------------------------------------------------
S_LOGIC_SM_select           
                            Die Abfrage-Nachricht gibt eine oder mehrere Objekte zurück.

S_LOGIC_SM_create           
                            Die Einfügenachricht erstellt ein neues Objekt  und gibt dieses zurück.

S_LOGIC_SM_update           
                            Die Mutationsnachricht aktualisiert ein vorhandenes Objekt.

S_LOGIC_SM_delete           
                            Die Löschnachricht löscht ein vorhandenes Objekt.

S_LOGIC_SM_execute          
                            Die Ausführnachricht löst die Ausführung einer Serverfunktion aus.

-------------------------------------------------------------------------------
Table: Nachrichten Server-Logik


#### Persistenz
Das Verhalten des Singlestate Konzepts ist mit einer Datenbank abbildbar. Der referenzierte Status wird jeweils in der Nachricht vom Client, vollständig mitgeliefert. Das Implementieren eines wahlfreier Zugriff auf vergangene Stati ist deshalb nicht notwendig.

### Frontend
Die beiden Nachrichten können von den Views versendet werden, aktualisieren den Store und werden vom Client-API Teil verarbeitet.

-------------------------------------------------------------------------------
__Nachrichtname__           __Beschreibung__
--------------------------- --------------------------------------------------
C_PRES_STORE_update         
                            Fügt ein Objekt hinzu oder aktualisiert ein bestehendes.

C_PRES_STORE_delete         
                            Löscht ein bestehendes Objekt.

-------------------------------------------------------------------------------
Table: Nachrichten Client


### Interaktionen

#### Initiale Synchronisation

![Ablauf der initiale Synchronisation](img/initsync.png)

#### Synchronisation

![Ablauf der Synchronisation](img/sync.png)

#### Serverfunktion

![Ablauf eines Aufrufs einer Serverfunktion](img/sfunc.png)






<!-- Nachrichtenbasiert, desshalb Flux -->
### Flux Architektur
Das Flux Paradigma[@facebook-flux] ist eine Applikationsarchitektur welche sehr stark auf das Konzept der nachrichtenbasierten Kommunikation verfolgt und somit auch einen unidirektionalen Datenfluss vorgibt.
Daten können nur über das versenden einer Nachricht manipuliert werden. Sowohl Views als auch die API können Aktionen auslösen, und so den Datenbestand mutieren.
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
- Modulare Konfliktauflösung (Logic [Algos -> Datenzuordnung])
- Modulare Serverfunktionen

<!-- Begründung Technologiestack -->
## Technologie Stack

--------------------------------------------------------------------
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

\newpage

Graphische Umsetzung
--------------------
Bei der Umsetzung des GUI sind die Richtleinen _"Material Design"_ angewendet worden.
<!-- Link zum Material Design -->


### Kontaktübersicht
Alle im System erfasste Kontakte werden beim Aufrufen der Web-Applikation dem Benutzer angezeigt. Die wichtigsten Attribute wie Name, Telefonnummer und Email-Adresse werden übersichtlich aufgelistet.

![Kontaktübersicht](img/umsetzung-Contacts.png)

### Kontakt Detailansicht
Die Detailansicht des Kontakts zeigt alle Attribute des Kontakts, gruppiert nach Zusammengehörigkeit an. So sind die Attribute Nachname, Vorname, akademischer Grad sowie der Mittelname auf einer Zeile zusammengefasst. Die Adresse mit den Attributen Land, Kanton, Stadt und Strasse sind darunter auf zwei Zeilen verteilt. Die Email-Adresse sowie Telefonnummer ist zuunterst aufgeführt.

![Kontakt Detailansicht](img/umsetzung-Contacts-edit.png)



Testing
=======
-Mocks!!!

Da während der Entwicklung des Prototypen viel Wert auf eine stabile Implementation gelegt wird, wir die gesamte Codebasis sowohl automatisch und manuell getestet sowie automatisiert analysiert. In den nachfolgenden Kapiteln, werden die beiden Methoden kurz ausgeführt.

### Unit-Testing
Die Testrunner-Suite Karma erlaubt es Programmcode fortlaufend zu testen. Dabei wird automatisch bei einer Änderung des Codes, die gesamten Tests erneut durchgeführt und das Ergebnis ansprechend dargestellt angezeigt. Die Tests selbst werden mit der Test-Suite Jasmine durchgeführt.

![Karma Testrunner](img/tdd.png)

### Coverage Analyse
Karma erlaubt weiter bei jedem Durchlauf der Tests auch die Durchführung einer Coverage-Analyse. Dafür wir die Coverage-Suite Istanbul verwendet. Neben der Anzahl, in den Tests durchlaufenen Befehle und Zeilen und aufgerufenen Funktionen wird auch angezeigt wie fiele Verzweigungen durchlaufen wurden.

<!-- Besseres Bild -->
![Istanbul Coverage](img/coverage.png)


### Manuelles Testen
Die durchgeführten Tests und Analysen testen nahezu die gesamte Codebasis. Durch den Einsatz der nachrichtenbasierten Architektur sind die Schnittstellen zwischen den einzelnen Bausteinen und Layers bereits sehr gut mit Unit-Testing überprüfbar.
Integrationstests werden deshalb nur manuell durchgeführt, damit die vorhandene Entwicklungsumgebung nicht durch den Einsatzt von Selenium aufgebläht wird.

Im nachfolgenden sind die Tests basierend auf den Anforderungen an den Prototypen aufgeführt.


-----------------------------------------------------------------------
__MT__  __AC__  __Status__  __Datum__   __Beschreibung__
------- ------- ----------- ----------- -------------------------------
T1      AC01    OK          21.05.2015
                                        Initiale Synchronisation wurde ausgeführt.

T2      AC02    OK          10.05.2015
                                        Mutationen können ohn Verbindung zum Server durchgeführt werden.

T3      AC03    OK          21.05.2015  
                                        Mutationen werden bei Verbindung zum Server übertragen. 

T4      AC04    OK          21.05.2015
                                        Die Konfliktauflösung wird bei der Synchronisation durchgeführt.

-----------------------------------------------------------------------
Table: Manuelle Tests



