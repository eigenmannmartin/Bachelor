

# Konzept Untersuchung


In diesem Kapitel werden die Konzeptansätze konkretisiert und auf ihre Anwendbarkeit hin untersucht.


## Datenhaltung
Die trivialste Form der Datenhaltung ist eine Messagequeue. Der aktuelle Staus ist die Anwendung aller Nachrichten auf einen initialen Status erreichbar.
Der wahlfreie Zugriff auf den Staus zu jedem beliebigen Zeitpunkt zeichnet dieses einfache Design aus. 

Nachfolgend findet sich eine genauere Implementations-Analyse bezüglich Single- und Multistate.

### Singlestate
Um eine Singlestate Datenhaltung zu implementieren, ist zwingend eine Message-queue, sowie ein initialer Zustand nötig. Zur effizienteren Implementierung wird darüber hinaus ein Cache-Status benötigt, der den letzten gültigen Status enthält.

Beim Eingehen einer neuen Nachricht wird die Funktion reciveMessage() aufgerufen.

``` {.coffee}
/* Verarbeitet eine eingehende Nachricht
 *
 * @Message.Sate         referenzierter Status
 * @Message.Mutation     Mutationsfunktion
 * @return               -
 */

reciveMessage (Message): ->

    if Message.State is @State
        @applyMsg Message
    else
        if @resolveConflict Message
            @State.apply Message.Mutation
            @MessageQueue.insert Message
        else
            break

resolveConflict(Message): ->

    if !@State.conflictsWith Message or @State.canResolvConfict Message
        return true
    else
        return false

``` 
<!-- 
```
 -->

Die Funktionen canResolvConfict sowie resolveConflict greifen auf den Referenzstatus der eingehenden Nachricht zu. Wie die Funktion resolveConflict genau funktioniert, wird später genauer untersucht.

#### Performance
Der Zugriff auf einen beliebigen Status ist, mit Ausnahme des aktuellen Status, von der Laufzeitkomplexität $O(n)$ (mit $n$ = Grösse der MessageQueue).

#### Verbesserung
Da jede schreibende Operation zuerst den referenzierten Staus auslesen muss, und dies sehr Rechenintensiv ist, wird jeder errechneter Zustand zwischengespeichert. So ist existiert für jede Nachricht bereits ein gecachter Status. Somit werden Operationen beschleunigt und die Laufzeitkomplexität auf $O(1)$ gesenkt.

<!-- #### Anwendungsbeispiel Synchronisation von Kontakten
Anhand des Beispiels "[Synchronisation von Kontakten]" 

##### Szenario 1
Hinzufügen -> Konfliktfrei

##### Szenario 2
Anpassen der primären Tel-NR -> Konflit, falls bereits geändert seit referenz status

##### Szenario 3
Ändern des Namens -> Konflikt, falls bereits geändert

##### Szenario 4
Hinzufügen pers. Info -> immer überschreiben, Eigenverantwortung -->



#### Pro/Contra
Das Konzept des Singlestate ist sehr konservativ und ist in ähnlicher Form weit verbreitet. MongoDB und MySQL bieten beide das Konzept eines einzigen gültigen und unveränderbaren Status. Auch eine Versionierung und somit ein wahlfreier Zugriff auf alle Stati ist implementierbar.

Das grösste Manko liegt jedoch im Umstand, einen Konflikt direkt beim Auftreten auflösen zu müssen. Konflikte die nicht aufgelöst werden können blockieren den gesamten Vorgang oder müssen abgebrochen werden.

<!-- 
Lösungen:
- Konsistenter Status

Probleme:
- nicht auflösbare Konflikte blokieren das System -->



### Multistate
Zur Implementation einer Multistate-Persistenz ist zwingend eine Messagequeue, ein Initialstatus sowie eine Shadow-Queue nötig. Zur effizienteren Implementierung wird auch hier der aktuell gültige Staus gecached.

In der Shadow-Queue werden die eingehenden Nachrichten entsprechend der referenzierten Stati geordnet und nicht mehr nach Eingangsreihenfolge.
Der Zustandsbaum wird dann entlang der Shadow-Queue aufgebaut.

Beim Eingehen einer neuen Nachricht sind folgende Schritte zu befolgen.

1. Nachricht in die Message- und Shadowqueue einsortieren
3. Zustandsbaum erneut aufbauen
4. Konflikte Auflösen

``` {.coffee}
/* Verarbeitet eine eingehende Nachricht
 *
 * @Message.Sate         referenzierter Status
 * @Message.Mutation     Mutationsfunktion
 * @return               -
 */

reciveMessage (Message): ->

    @MessageQueue.insert Message
    @StateTree = new Tree

    for Message in @MessageQueue
        @StateTree.get(Message.State).apply Message.Mutation

    for State in @stateTree
        State.tryToResolvConflict

``` 
<!-- 
```
 -->
#### Performance
Da bei jeder schreibenden Operation der gesamte Statusbaum neu aufgebaut wird, weist diese Implemantation eine Laufzeitkomplexität von $O(n)$ (mit $n$ = Grösse der MessageQueue) auf.


#### Verbesserung 1
Falls eine Nachricht auf einen aktuellen Zustand referenziert, muss der Baum nicht erneut aufgebaut werden.

#### Verbesserung 2
Jede schreibende Operation löst die erneute Generierung des gesamten Zustandsbaums aus. Um diese rechenintensive Operation zu vereinfachen, wird bei jeder Verzweigung der Zustand gespeichert. Eine Schreibende Aktion, muss so nur noch den betroffenen Teilbaum aktualisieren.


<!-- #### Anwendungsbeispiel Synchronisation von Kontakten

##### Szenario 1
Hinzufügen -> Konfliktfrei

##### Szenario 2
Anpassen der primären Tel-NR -> Konflit => eigener Zweig. Möglicherweise aktiver Zweig.

##### Szenario 3
Ändern des Namens -> Konflikt => eigener Zweig. Möglicherweise aktiver Zweig

##### Szenario 4
Hinzufügen pers. Info -> immer überschreiben, Eigenverantwortung -->



#### Pro/Contra
Der grösste Gewinn beim Multistate Konzept liegt in der zeitlichen Entkoppelung zwischen Synchronisation und Konfliktauflösung. 
Die Richtigkeit, also die Qualität der Information, eines Status wird über die Zeit nur grösser.
Und genau darin besteht auch das grösste Problem, denn dadurch ist nicht garantiert dass Abfragen wiederholbare Ergebnisse liefern.


<!-- Lösungen:
- jede Nachricht kann verarbeitet werden - Konfliktlösung in der Zukunft

Probleme:
- Inkonsistenter Status -->




## Konfliktvermeidung

### Update Transformation
Die einfachste Implementation einer Update-Transformation besteht darin, sowohl das mutierte Objekt, also auch das Ausgangsobjekt zu übertragen. Implizit wird so eine Mutationsfunktion übermittelt.
<!-- Übermittlung von ausführbarem Code ist nicht sinnvoll -->

``` {.coffee}
/* Zusammenstellung einer Nachricht
 *
 * @old                 alter Status
 * @new                 neuer Status
 * @return              Message
 */

composeMessage (old, new): ->
    
    for AttrName, Attribut in new
        if !Attribut is old[AttrName]
            Message.Mutation[AttrName] = Attribut

    Message.State = old

    return Message

``` 
<!-- 
```
 -->

Es wird der gesamte "alte" Status aber nur die geänderte Attribute des neuen Status übermittelt.


#### Pro/Contra
Mutationen können Konfliktfrei eingespielt werden, da die Operation automatisiert mit dem neueren Status wiederholt werden kann.
Ein sehr grosses Hindernis besteht aber darin, dass viele Benutzereingaben nur mit einer Zuweisung abgebildet werden können und deshalb die ursprüngliche Daten gar nicht miteinbezogen werden. 

<!--
Lösungen:
- Nachricht kann Konfliktfrei eingespielt werden, da erneute Berechnung auf Server

Probleme:
- Nur wenige auf Operationen anwendbar 
-->

### Wiederholbare Transaktion
Eine sehr triviale Implementation besteht darin, sobald eine Nachricht abgelehnt wird, alle nachfolgenden Nachrichten einer Synchronisation auch abzulehnen und den Client neu zu initialisieren. 
Ein ähnliches Konzept ist im Gebiet der Datenbanken auch als Transaktion bekannt. Nur wird hier kein Rollback durchgeführt.

<!-- #### Anwendungsbeispiel Synchronisation von Kontakten
Es werden keine spezifischen Konflikte gelöst. Es wird nur verhindert dass es zu Logischen Fehlern auf höheren Schichten kommt, da keine Mutation Synchronisiert wird, die auf nicht akzeptierten Daten fusst. -->

#### Probleme/Lösungen
Da bei einem nicht auflösbaren Konflikt alle Mutationen gelöscht werden, ist garantiert dass keine auf falschen Daten basierten Mutationen synchronisiert werden.
Aber gerade wegen diesem aggressivem Vorgehen, geht unter Umständen viel an Arbeit verloren.

<!--
Lösungen:
- Informationen sind sicher auf korrekten Daten basierend

Probleme:
- eventuell muss viel "Arbeit" weggeschmissen werden-->



## Konfliktauflösung

### Zusammenführung
Die einfachste Implementation besteht darin, nur geänderte Attribute zu übertragen. So werden Konflikte nur behandelt, wenn das entsprechende Attribut mutiert wurde.

``` {.coffee}
/* Zusammenstellung einer Nachricht
 *
 * @valid               aktueller Status
 * @ref                 referenzierter Status
 * @update              mutierter Status
 * @return              bool
 */

resolvConflict (valid, ref, update): ->

    NewState = new State
    
    for AttrName, Attribut in update
        if ref[AttrName] is valid[AttrName]
            NewState[AttrName] = Attribut
        else
            break

    return NewState

``` 
<!-- 
```
 -->

<!-- #### Anwendungsbeispiel Synchronisation von Kontakten
Attribute werden einzeln in eine Mutationsfunktion gepackt

Exkluxive Daten -> direkt überschreiben
Gemeinsame Daten -> Kontext verändert? -> sonst Konflikt
Dynamische Daten -> nicht synchronisierbar
Statische Daten -> direkt überschreiben
Temporäre Daten -> direkt überschreiben

Unabhängige Daten => Kontext = Daten selbst

#### Anwendungsbeispiel Synchronisation von Kontakten

##### Szenario 1
Hinzufügen -> Konfliktfrei

##### Szenario 2
Anpassen der primären Tel-NR -> Kontext ist Name, Gemeinsame Daten, keine allgemeingültige Mutationsfunktion => Konflikt manuell auflösen

##### Szenario 3
Ändern des Namens -> Falls noch nicht geändert kein Konflikt

##### Szenario 4
Hinzufügen pers. Info -> immer überschreiben, Eigenverantwortung da temp. -->

#### Probleme/Lösungen
Lösungen:
- Granularere Aufteilung des Problems

Probleme:
- keine


### normalisierte Zusammenführung
Um eine normalisierte Zusammenführung um zu setzten, ist zwingend ein wahlfreier Zugriff auf jeden Status, sowie jede Mutationsfunktion notwendig.

Ein Konflikt bei einem Attribut wird in folgenden Schritten aufgelöst:

1. Resultate aller auf den Status angewendeten Mutationen berechnen
2. Resultat, welches am nächsten bei der Durchschnittsfunktion liegt, anwenden


``` {.coffee}
/* Zusammenstellung einer Nachricht
 *
 * @valid               aktueller Status
 * @ref                 referenzierter Status
 * @updates             alle angewendeten Nachrichten
 * @average             durchschnittlicher Wert des Attributs 
 * @return              bool
 */

resolvConflict (valid, ref, updates, average): ->

    NewState = new State
    Distances = new DistanceArray( average )

    for update in updates
        Distances.add update

    bestUpdate = Distances.smallest
    NewState[bestUpdate.AttrName] = bestUpdate.Attribut

    return NewState

``` 
<!-- 
```
 -->


<!-- ##### Szenario 1
Hinzufügen -> Konfliktfrei

##### Szenario 2
Anpassen der primären Tel-NR -> Grösse bezüglich "Richtigkeit" im Adressbuch
(Richtiges Format/Landesvorwahl etc.)

##### Szenario 3
Ändern des Namens -> nicht möglich

##### Szenario 4
Hinzufügen pers. Info -> nicht möglich -->

#### Probleme/Lösungen
Lösungen:
- Sofern Daten dafür ausreichen / guter Kompormiss

Probleme:
- eventuell "falsche Daten"


### manuelle Zusammenführung
Eine manuelle Zusammenführung muss in Form eines GUI implementiert werden, womit ein Benutzer diese durchführen kann.

#### Probleme/Lösungen
Lösungen:
- sicher korrekte Daten

Probleme:
- manueller Aufwand nötig




<!-- 
## Allgemein
Die drei verschiedenen Teilkonzepte für Datenhaltung, Konfliktvermeidung und Konfliktauflösung können nicht in jeder Konfiguration miteinander kombiniert werden.

{Bild: Datenhaltung + Konfliktvermeidung + Konfliktauflösung}

Die folgenden Kapitel befassen sich mit den möglichen Ausprägungen sowie deren Bewertungen.



## Datenhaltung

Die beiden Konzeptansätze zur Datenhaltung, Single- und Multi-State, sind nicht gemeinsam Implementierbar. Beide decken einen überlappenden Funktionsbereich ab, bieten aber spezifische Vor. und Nachteile. Eine Gegenüberstellung und Bewertung der beiden Ansätze ist im folgenden Kapitel aufgeführt.


### Gegenüberstellung


-------------------------------------------------------------------------------
__Eigenschaft__             __Beschreibung__                __S__   __M__
--------------------------- ------------------------------- ------- -----------
__Implementation__          besthende Implemenationen       einfach komplex

__Konsistente Abfragen__    Resultate bleiben gleich        ja      nein

__Konfliktauflösung__       Zeitpunkt der Auflösung         fix     bel.

__Performance__                                             gut     aufwändig 
-------------------------------------------------------------------------------


Single:


Multi:
Eine wiederholte Abfrage muss nicht das selbe Resultat liefern. Und ein Status kann sich in der Vergangenheit ändern. Der Status wird zwar über die Zeit richtiger - aber auf den "falschen" Daten basierte Entscheidungen sind bereits getroffen.
Die Konfliktauflösung kann 


### Auswahl


## Konfliktvermeidung
non-exklusiv

### Bewertung
### Auswahl


## Konfliktauflösung
non-exklusiv

### Bewertung
### Auswahl



-->



## Zusammenfassung