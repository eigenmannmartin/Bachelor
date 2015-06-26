
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
In diesem Kapitel wird ein Prototyp entworfen, der, der Konklusion aus dem Kapitel [Konzept Untersuchung] und den Richtlinien aus dem Kapitel [Leitfaden] genügt.

Designentscheidungen
--------------------
Die im [Leitfaden] vorgeschlagenen Lösungsansätze sollen in das Design des Prototypen mit einfliessen. Die beiden Konventionen "Zuständigkeit für Daten" und "Lock" bedingen jedoch eine Benutzerverwaltung und finden daher keinen Eingang.

Die Datenübermittlung wird basierend auf den Erkenntnissen aus den vorhergehenden Kapiteln, Unterschieds basiert durchgeführt und serverseitig mit einem, auf dem Konzept des Singlestate basierenden, Datenspeicher komplettiert. Dieses Nachrichten basierte Kommunikationskonzept wird geradezu perfekt durch die [Flux Architektur] umgesetzt. Jede Benutzerinteraktion mit dem Client, erzeugt eine neue Nachricht. Daten verändernde Nachrichten können so auf einfache Art und Weise auch dem Server übermittelt werden. Um die Modulare Struktur, welche vom Flux vorgegeben wird zu komplettieren wird das AMD Pattern verwendet. Dadurch können Module und deren Abhängigkeiten gleichermassen für Server und Client definiert werden.

Serverfunktionen sind über Nachrichten mit dem darin enthaltenen Argumenten aufrufbar und über aufgetretene Konflikte wird der Client mit einer entsprechenden Nachricht informiert. Die Konvention "Objekte erstellen" besitzt im umzusetzenden Fallbeispiel nur einen geringen Einfluss, da die Datenstruktur bereits auf ein einziges Objekt pro Kontakt festgelegt ist.


Auswahl Synchronisations- und Konfliktauflösungsverfahren
----------------------------------------------------------
Zur Konfliktvermeidung werden die beiden erarbeiteten Konzepte Update Transformation und Serverfunktionen umgesetzt. Bezüglich der Konfliktauflösung wird nur die Zusammenführung umgesetzt, da einerseits Konflikte explizit erlaubt sind und andererseits nur die Zusammenführung garantiert fehlerfreie Resultate liefert.


Design
------
Der Prototyp besteht aus den drei Bausteinen: Server, API und Client.
![Bausteinübersicht](img/design_components.jpg)
Die API-Komponente steht für sich alleine, obschon sie sowohl im Server als auch im Client direkt eingebettet ist. Die API-Komponente selbst ist aufgeteilt in einen Server- und Client-Teil und stellt den Austausch der Nachrichten zwischen Server und Client sicher.

Die Bausteine und deren Interaktion miteinander, werden in den folgenden Kapiteln genauer erläutert.

### Datenfluss
Der Datenfluss des Prototypen ist wie in der Abbildung {@fig:dataflow} dargestellt, nur unidirektional. Daraus ergibt sich auch, dass die gesamte Interkomponenten-Kommunikation, vom Client bis hin zum Server, asynchron durchgeführt wird.

![Datenflussdiagramm von Server und Client](img/dataflow.png) {#fig:dataflow}


### Nachrichten
Jede versendete Nachricht enthält neben einem Nachrichtennamen und den zu versendenden Daten, auch Meta-Informationen. In den Meta-Informationen ist der Name des mutierten Objekts oder der Name der Serverfunktion eingetragen.
Neben der des gesamten veränderten Elements wird auch das zuvor aktive Element in den Daten übermittelt. Implizit ist mit der Übermittlung der alten und neuen Daten die Mutationsfunktion definiert.

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
Das Backend ist in drei Schichten, Api, Logik und Persistenz, unterteilt, um so eine möglichst grosse Separation of Concerns (SoC) zu erreichen. Die Kommunikation zwischen diesen Schichten findet nur über Nachrichten statt. Jede über die API eingehende Nachricht wird an den Logik-Layer weitergeleitet. Der Logik-Layer übernimmt dann die Verarbeitung und leitet die Resultate der Persistenz-Schicht weiter.

### API
Die API stellt wenn immer möglich einen ständigen Kommunikationskanal zwischen Server und Client her. Der serverseitige Part der API kann sowohl Broadcastnachrichten als auch an nur einen Client gerichtete Nachrichten versenden. Die API verfügt jedoch über keine MessageQueue und Nachrichten die nicht beim ersten Versucht zugestellt werden können, gehen verloren.

Die Benennung der Nachrichten ist den bekannten Funktionen des HTTP Standards nachempfunden. So ist die tatsächliche Implementation der API maximal flexibel und trotzdem immer noch standardkonform.

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
                            Eine Serverfunktion kann mit der Execute-Nachricht ausgeführt werden.

-------------------------------------------------------------------------------
Table: Nachrichten Server-API


#### Logik
Der Logik-Layer führt die Konfliktauflösung sowie die Verwaltung des Status durch. Es werden vier Nachrichten akzeptiert, welche dem SQL Jargon nachempfunden sind, sowie eine Execute-Nachricht. Die Resultate werden nach vollständiger Bearbeitung dem Sender der ursprünglichen Nachrichten, mit einer neuen Nachricht mitgeteilt.

-------------------------------------------------------------------------------
__Nachrichtname__           __Beschreibung__
--------------------------- --------------------------------------------------
S_LOGIC_SM_select           
                            Die Select-Nachricht gibt eine oder mehrere Objekte zurück.

S_LOGIC_SM_create           
                            Die Create-Nachricht erstellt ein neues Objekt  und gibt dieses zurück.

S_LOGIC_SM_update           
                            Die Update-Nachricht aktualisiert ein vorhandenes Objekt.

S_LOGIC_SM_delete           
                            Die Delete-Nachricht löscht ein vorhandenes Objekt.

S_LOGIC_SM_execute          
                            Die Execute-Nachricht löst die Ausführung einer Serverfunktion aus.

-------------------------------------------------------------------------------
Table: Nachrichten Server-Logik


#### Persistenz
Das Verhalten des Singlestate Konzepts ist mit einer Datenbank abbildbar. Der referenzierte Status wird jeweils in der Nachricht vom Client, vollständig mitgeliefert. Das Implementieren eines wahlfreien Zugriffs auf vergangene Stati ist deshalb nicht notwendig.

### Frontend
Die beiden Nachrichten können von den Views versendet werden, aktualisieren den Store und werden vom Client-API Teil verarbeitet. Nur diese beiden Nachrichten aktualisieren den Store des Clients.

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
Die Ausgestaltung des Ablaufs der Interaktionen zwischen Client und Server ist für die drei wichtigsten Fälle im Folgenden aufgeführt.

#### Initiale Synchronisation
Die Abbildung {@fig:initsync} illustriert den Ablauf der initialen Synchronisation. Sobald sich der Client mit dem Server verbunden hat, wird der initiale Datenbestand des Servers an den Client übermittelt. Dazu wird jedes Element des Servers einzeln in einer Nachricht an den Client gesendet. Der Vorgang ist abgeschlossen sobald eine Kopie aller Elemente versendet wurde.

![Ablauf der initiale Synchronisation](img/initsync.png) {#fig:initsync}

\FloatBarrier

#### Synchronisation
Beim durchführen lokaler Änderungen werden die dazugehörenden Nachrichten bereits an die API weitergereicht und dort zur Weiterleitung an den Server zwischengespeichert.
Sobald eine Verbindung mit dem Server besteht werden diese zwischengespeicherten Nachrichten, wie in Abbildung {@fig:ssync}, an den Server übermittelt.

![Ablauf der Synchronisation](img/sync.png) {#fig:ssync}

\FloatBarrier

#### Serverfunktion
Der Aufruf einer Serverfunktion wird asynchron durchgeführt. Der Aufruf wird zusammen mit den dazu gehörenden Parametern in Form einer Nachricht an den Server gesendet. Die geänderten Elemente werden anschliessend vom Server, wie im Abbildung {@fig:sfunc}, retourniert.

![Ablauf eines Aufrufs einer Serverfunktion](img/sfunc.png) {#fig:sfunc}

\FloatBarrier


<!-- Nachrichtenbasiert, desshalb Flux -->
### Flux Architektur
Das Flux Paradigma[@facebook-flux] ist eine Applikationsarchitektur welche sehr stark auf das Konzept der nachrichtenbasierten Kommunikation basiert und somit auch einen unidirektionalen Datenfluss, wie in Abbildung {@fig:flux} vorgibt. Daten können nur über das versenden einer Nachricht manipuliert werden. Sowohl Views als auch die API können Aktionen auslösen, und so den Datenbestand mutieren.

![Flux Diagramm [@facebook-flux]](img/flux-diagram.png) {#fig:flux} 

\FloatBarrier

Die Verwendung des Dispatchers ermöglicht es, Abhängigkeiten zwischen verschiedenen Stores zentral zu verwalten, da jede Mutation zwangsweise zuerst von ihm bearbeitet wird.

<!-- Testing und Modularität, desshalb AMD -->
<!--### AMD Pattern
Asyncronous module definition (AMD) ist eine JavaScript API um Module zu definieren und diese zur Laufzeit zu laden. Dadurch können Javascript-lastige Webseiten beschleunigt werden, da Module erst geladen werden, wenn sie gebraucht werden. Weiter werden durch den Loader die Module gleichzeitig geladen, dadurch kann die Bandbreite voll ausgenutzt werden. 
Da die Module durch die Vorgabe des Patterns in einzelnen Dateien abgelegt sind, wird eine Kapselung ähnlich wie bei Java erreicht. Das erleichtert die Fehlersuche und erhöht die Verständlichkeit des Programmes drastisch. Auch die Wiederverwendbarkeit der Module wird dadurch erhöht.
Da in jedem Modul die Abhängigkeiten definiert werden müssen, kann während dem Build-Prozess die Abhängigkeiten geprüft werden, um so die Verfügbarkeit aller benötigten Module sicher zu stellen.-->


## Beispielapplikation
Die Aufgabenstellung verlangt, dass der Prototyp anhand eines passenden Fallbeispiels die Funktionsfähigkeit und Praxistauglichkeit der Synchronisations- und Konfliktlösungs-Verfahren zeigt. Dazu wird das Fallbeispiel "Synchronisation von Kontakten" umgesetzt. Die Umsetzung konzentriert sich auf die Synchronisationsverfahren und lässt Aspekte der Benutzerverwaltung und Usability, bewusst weg.
\
Die Beispielapplikation muss aufgrund der Anforderungen der [Anforderungsanalyse] und der Beschreibung des Fallbeispiels, auf der für den Endbenutzer sichtbaren Ebene, folgende Funktionalität aufweisen:

1. Ein neuer Kontakt kann erfassen werden.
2. Ein bestehender Kontakt kann mutiert werden.
3. Ein bestehender Kontakt kann gelöscht werden. 
4. Die gesamten Funktionalität ist online wie auch offline verfügbar.




\part[Implementation]{Implementierung und Testing}


# Prototyp
In diesem Kapitel wird die Implementation des Prototypen gemäss den Anforderungen aus dem Kapitel [Analyse] adressiert, sowie auf die dafür verwendeten Technologien und Frameworks eingegangen.

## Umsetzung Konfliktauflösungsverfahren
Die Implementation der Konfliktauflösungsverfahren "Zusammenführung", "kontextbezogene Zusammenführung" sowie die traditionelle Synchronisation ist mit wenigen Zeilen Code implementierbar. 

Die traditionelle Synchronisation überprüft auf Zeile 3 ob das Attribut des übermittelten Objekts (_new_obj_) auf dem Server (_db_obj_) bereits verändert wurde und übernimmt, nur falls dies nicht der Fall ist, das neue Attribut.


``` {.coffee .numberLines}
traditional: (data, db_obj, new_obj, prev_obj, attr) ->
    if new_obj[attr]?
        data[attr] = if prev_obj[attr] is db_obj[attr] 
        then new_obj[attr] else db_obj[attr] 
``` 
<!-- 
```
-->

Zur Umsetzung des Konzepts der Zusammenführung wird auf Zeile 3 überprüft, ob das Attribut des übermittelten Objekts in dieser Nachricht mutiert wurde und nur, falls dies der Fall ist, das neue Attribut übernommen.

``` {.coffee .numberLines}
combining: (data, db_obj, new_obj, prev_obj, attr) ->
    if new_obj[attr]?
        data[attr] = if new_obj[attr] is prev_obj[attr] 
        then db_obj[attr] else new_obj[attr]
``` 
<!-- 
```
-->

Die kontextbasierte Zusammenführung wird umgesetzt indem auf Zeile 4 geprüft wird, ob das Kontextattribut des Objekts auf dem Server bereits mutiert wurde. Nur wenn dies nicht der Fall ist, wird das neue Attribut übernommen.

``` {.coffee .numberLines}
contextual: (data, db_obj, new_obj, prev_obj,
                attr, cont) ->
    if new_obj[attr]?
        data[attr] = if prev_obj[cont] is db_obj[cont] 
        then new_obj[attr] else db_obj[attr] 
``` 
<!-- 
```
 -->

Umsetzung Konfliktverhinderungsverfahren
----------------------------------------
Da der Prototyp durch sein Design bereits die Unterschiedsbasierte Synchronisation einsetzt und die Konfliktauflösung bereits auf Ebene der Attribute durchführt und somit das Konzept der Update Transformation bereits unterstützt, muss nur das Konzept der Serverfunktion gesondert implementiert werden.

Entwicklung
-----------
Die beim Server über die Verbindung zum Client eingehenden Nachrichten, werden über den Nachrichtenbus weitergeleitet. Auf Zeile 3 wird die Server-Interne _dispatch_-Funktion mit dem Nachrichtennamen und der tatsächlichen Nachricht aufgerufen und somit auf den Nachrichtenbus publiziert.

``` {.coffee .numberLines}
me = @
@Socket.on 'message', ( msg ) ->
    me.dispatch msg.messageName, msg.message
``` 
<!-- 
```
-->
Sowohl über die API eingehende Nachrichten, als auch interne Nachrichten des Servers werden gleichwertig behandelt. Alle Nachrichten werden gleichermassen über den Nachrichtenbus verteilt.

Auf dem Client werden eingehenden Nachrichten nur in den Nachrichtenbus des Clients eingespeist, wenn diese gültig sind. Auf Zeile 2 wird überprüft ob der Name der empfangenen Nachricht gültig ist. Falls dem so ist, wird dem clientseitigen Nachrichtenbus eine neue Nachricht übergeben. Um später zu erkennen, ob die Nachricht von einer View oder der API selbst kam, wird das Flag _updated_ gesetzt.

``` {.coffee .numberLines}
@.io.on 'message', ( msg ) ->
    if msg.messageName is 'C_PRES_STORE_update'
        flux.doAction 'C_PRES_STORE_update',
        meta:
            model:msg.message.meta.model
            updated:true
        data:
            msg.message.data
``` 
<!-- 
```
-->


Die Struktur der Daten muss nur auf dem Server definiert werden. Der Client selbst übernimmt automatisch die vom Server verwendete Struktur. Lediglich der Name des Objekts muss in der Storedefinition des Clients eingetragen werden (Zeile 2 und 8). Die Datenhaltung des Clients selbst reagiert auch auf die _update_ Nachrichten (Zeile 7) und aktualisiert sich dem entsprechend.
``` {.coffee .numberLines}
flux.createStore
    id: "prototype_contact",
    initialState: 
        contacts : []
            
    actionCallbacks:
        C_PRES_STORE_update: ( updater, msg ) ->
            if msg.meta.model is "Contact"
                ...
``` 
<!-- 
```
-->


Die Datenstruktur wird auf dem Server direkt in den Datendefinitionen von Sequelize eingetragen. Sequelize stellt dafür verschiedene Datentypen zur Verfügung. Die so definierten Objekte können automatisiert in einem relationalen Datenbanksystem abgespeichert werden.

``` {.coffee .numberLines}
module.exports = (sequelize, DataTypes) ->
    Contact = sequelize.define "Contact", { 
        first_name: DataTypes.STRING
        last_name: DataTypes.STRING
        ...
    }, {}
``` 
<!-- 
```
-->

Die Konfiguration der Konfliktauflösungsstrategie wird in der Logikschicht für jedes Attribut einzeln definiert.

``` {.coffee .numberLines}
_traditional data, db_objs, me.obj, me.prev, 'first_name'
_traditional data, db_objs, me.obj, me.prev, 'last_name'
``` 
<!-- 
```
-->

<!-- Begründung Technologiestack -->
## Technologie Stack
Die für die Entwicklung eingesetzten Technologien und Frameworks sind in der Tabelle \ref{techstack} aufgeführt.


------------------------------------------------------------------------------
Software            Beschreibung/Auswahlgrund
------------------- ----------------------------------------------------------
__Grunt__           
                    Grunt ermöglicht es dem Benutzer vordefinierte Tasks von der Kommandozeile aus durchzuführen. So sind Build- und Test-Prozesse für alle Benutzer ohne detaillierte Kenntnisse durchführbar.
                    Da Grunt eine sehr grosse Community besitzt und viele Plugins sowie hervorragende Dokumentationen verfügbar ist, wurde Grunt eingesetzt.

__Karma__           
                    Karma ist ein Testrunner, der Tests direkt im Browser ausführt. Weiter können automatisch Coverage-Auswertungen durchgeführt werden.

__CoffeeScript__
                    CoffeeScript ist eine einfach zu schreibende Sprache die zu JavaScript kompiliert wird. Das generierte JavaScript ist optimiert und ist meist schneller als selbst geschriebenes JavaScript.

__RequireJS__       
                    RequireJS ermöglicht die Implementierung des AMD Pattern.Dadurch können auch in JavaScript Code-Abhängigkeiten definiert werden. Zusammen mit r.js kann dies bereits zur Kompilierzeit geprüft werden.
                    Da weder Backbone noch Django über eine Depencency-Control für JavaScript verfügen, setze ich RequireJS ein.

__ReactJS__         
                    ReactJS ist eine Frontend Library die eine starke Modularisierung fordert. Das Paradigma des "Source of Truth" verhindert darüber hinaus das Auftreten von Anzeigefehler.

__FluxifyJS__       
                    FluxifyJS ist eine leichtgewichtige Implementierung des Flux Paradigmas. Sie bietet sowohl Stores als auch einen Dispatcher.

__SequelizeJS__     
                    SequelizeJS ist eine sehr bekannte und weit verbreitete ORM Implementation für Node und Express.

__Express__         
                    Express ist ein Web-Framework für Node. Die weite Verbreitung und ausführliche Dokumentation machen Express zur idealen Grundlage einer Node Applikation.

__Socket.io__
                    Socket.io ist eine Implementation des Websocket Standards und erlaubt eine Asynchrone Kommunikation zwischen Client und Server.

-------------------------------------------------------------
Table: Technologie Stack  \label{techstack}

## Entwicklungsumgebung
Die Entwicklungsumgebung ist so portabel wie möglich gestaltet. Alle benötigten Abhängigkeiten sind automatisiert installierbar. Die dazu nötigen Befehle sind nachfolgend aufgeführt und müssen direkt im Repository ausgeführt werden.

``` {.bash}
> bower install
> npm install
``` 
<!-- 
```
-->


\newpage

Graphische Umsetzung
--------------------
Bei der Umsetzung des GUI sind die Richtlinien Material Design[^matdesign] angewendet worden.

[^matdesign] [https://www.google.com/design/spec/material-design/introduction.html](https://www.google.com/design/spec/material-design/introduction.html)


### Kontaktübersicht
Alle im System erfassten Kontakte werden beim Aufrufen der Web-Applikation dem Benutzer angezeigt. Die wichtigsten Attribute wie Name, Telefonnummer und Email-Adresse werden übersichtlich aufgelistet.

![Kontaktübersicht](img/umsetzung-Contacts.png)

### Kontakt Detailansicht
Die Detailansicht des Kontakts zeigt alle Attribute des Kontakts, gruppiert nach Zusammengehörigkeit, an. So sind die Attribute Nachname, Vorname, akademischer Grad sowie der Mittelname auf einer Zeile zusammengefasst. Die Adresse mit den Attributen Land, Kanton, Stadt und Strasse sind darunter auf zwei Zeilen verteilt. Die Email-Adresse sowie Telefonnummer ist zuunterst aufgeführt.

![Kontakt Detailansicht](img/umsetzung-Contacts-edit.png)



Testing
=======
Da während der Entwicklung des Prototypen viel Wert auf eine stabile Implementation gelegt wird, wir die gesamte Codebasis automatisch und manuell getestet sowie automatisiert analysiert. In den nachfolgenden Kapiteln werden die beiden Methoden zur statischen Analyse und zum Testen kurz ausgeführt.

## Unit-Testing
Die Testrunner-Suite Karma erlaubt es Programmcode fortlaufend zu testen. Dabei werden automatisch bei einer Änderung des Codes, die gesamten Tests erneut durchgeführt und das Ergebnis ansprechend dargestellt. Die Tests selbst werden mit der Test-Suite Jasmine durchgeführt.

![Karma Testrunner](img/tdd.png)

## Coverage Analyse
Karma erlaubt weiter bei jedem Durchlauf der Tests auch die Durchführung einer Coverage-Analyse. Dafür wir die Coverage-Suite Istanbul verwendet. Neben der Anzahl, in den Tests durchlaufenen Befehle und Zeilen und aufgerufenen Funktionen wird auch angezeigt wie viele Verzweigungen durchlaufen und durch Tests abgedeckt werden.

<!-- Besseres Bild -->
![Istanbul Coverage](img/coverage.png)

## Manuelles Testen
Die durchgeführten Tests und Analysen decken nahezu die gesamte Codebasis ab. Durch den Einsatz der nachrichtenbasierten Architektur sind die Schnittstellen zwischen den einzelnen Bausteinen und Layers bereits sehr gut mit Unit-Testing überprüfbar.
Integrationstests werden deshalb nur manuell durchgeführt, damit die vorhandene Entwicklungsumgebung nicht durch den Einsatz dafür geeigneter Tools, wie Selenium, aufgebläht wird.

Im nachfolgenden sind die Tests basierend auf den Akzeptanzkriterien der Anforderungsanalyse an den Prototypen aufgeführt.


-----------------------------------------------------------------------
__MT__  __AC__  __Status__  __Datum__   __Beschreibung__
------- ------- ----------- ----------- -------------------------------
T1      AC01    OK          21.05.2015
                                        Initiale Synchronisation wurde ausgeführt.

T2      AC02    OK          10.05.2015
                                        Mutationen können ohne Verbindung zum Server durchgeführt werden.

T3      AC03    OK          21.05.2015  
                                        Mutationen werden bei Verbindung zum Server übertragen. 

T4      AC04    OK          21.05.2015
                                        Die Konfliktauflösung wird bei der Synchronisation durchgeführt.

-----------------------------------------------------------------------
Table: Manuelle Tests



