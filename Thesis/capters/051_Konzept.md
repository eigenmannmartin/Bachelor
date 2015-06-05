

Konzept Untersuchung
====================

Synchronsation
--------------

Zur Übermittlung von Informationen über Mutationen am Datenbestand, wird eine Form der Marierung benötigt. Die mutierten Daten müssen markiert werden, damit sie, sobald die Synchronisierung durchgeführt werden soll, übermittelt werden können. 

### Unterschieds basiert
Die Unterschieds basierte Synchronisation zeichnet direkt bei der Mutation eines Objekts die an den Server zu sendende Nachricht auf und speichert diese in einer Messagequeue zur späteren Synchronisation ab. Sobald also die Synchronisation ausgelöst wird, werden alle aufgezeichneten Nachrichten, in der gleichen Reihenfolge wie bei der Aufzeichnung, dem Server zugestellt. 


``` {.coffee}
synchronize(): ->
    for Message in @MessageQueue
        sendToServer(Message)

mutateObject(Mutation, referenceObject): ->
    @Messagequeue.add(Mutation, referenceObject)

``` 
<!-- 
```
 -->

### Objekt basiert
Bei der Objekt basierten Synchronisation wird direkt bei der Mutation eines Objekts, dessen _dirty_ Flag gesetzt. Bei der Auslösung der Synchronisation werden alle Objekte, welche dieses Flag gesetzt haben, dem Server übermittelt und das _dirty_ Flag wieder entfernt.

<!-- Object ist ein reserviertes Key-Word -> Element -->
``` {.coffee}
synchronize(): ->
    for Element in @Store.getAll()
        if Element.dirty
            sendToServer(Element)
            Element.dirty = false

mutateObject(Element): ->
    obj = @Store.get(Element)
    obj.attrs = Element.attrs
    obj.dirty = true

``` 
<!-- 
```
 -->

Datenhaltung
------------

Eine sehr elegante Form der Datenhaltung ist die Messagequeue. Der aktuell gültige Staus ist durch die Anwendung aller in der Messagequeue enthaltenen Nachrichten auf den initialen Status erreichbar.
Der wahlfreie Zugriff auf jeden beliebigen Staus zeichnet dieses einfache Design aus. Gerade wegen diesem wahlfreien Zugriff auf beliebige Stati ist diese Form ideal für die Verwendung im Rahmen dieser Thesis geeignet.  


Die beiden im Kapitel [Konzept] untersuchten Datenhaltungskonzepte sind nachfolgend genauer untersucht. Gezeigt wird wie ansatzweise eine Implementation aussehen könnte, um Probleme und Vorteile besser erkennen zu können. Konflikt-verhinderung und -auflösung wird in den darauf folgenden Kapiteln genauer untersucht.

### Singlestate
Beim Eingehen einer neuen Nachricht wird die Funktion addMessage() aufgerufen.
Die Funktion @State($t$) gibt den Staus zum Zeitpunkt $t$ zurück. Falls kein Zeitpunkt angegeben ist, wird der neueste zurückgegeben.
Die MessageQueue wird durch das Stausobjekt verwaltet.


``` {.coffee}
getState(t): ->
    return @State(t)

addMessage(Message): ->
    if Message.refState is @State
        @State().apply Message.Mutation
    else
        if not @State().conflictsWith Message 
        or @State().canResolvConfict Message
            @State().apply Message
        else
            break

``` 
<!-- 
```
 -->

Die Funktionen canResolvConfict sowie resolveConflict greifen auf den referenzierten Status der Nachricht zu.

#### Performance
Der Zugriff auf einen beliebigen Status ist von der Laufzeitkomplexität $O(n)$ (mit $n$ = Grösse der MessageQueue).

#### Verbesserung
Da jede schreibende Operation zuerst den referenzierten Staus auslesen muss, und dies sehr Rechenintensiv ist, wird jeder errechneter Zustand zwischengespeichert. So existiert für jede Nachricht bereits ein zwischengespeicherter Status und muss daher nicht für jede Operation erneut generiert werden.

#### Probleme/Lösungen
Das Konzept des Singlestate ist sehr konservativ und ist in ähnlicher Form weit verbreitet. MongoDB und MySQL bieten beide das Konzept eines einzigen gültigen und unveränderbaren Status. Auch eine Versionierung und somit ein wahlfreier Zugriff auf alle Stati ist implementierbar.

Das grösste Manko liegt jedoch im Umstand, einen Konflikt direkt beim Auftreten auflösen zu müssen. Konflikte die nicht aufgelöst werden können blockieren den gesamten Vorgang oder müssen abgebrochen werden.




### Multistate
Beim Eingehen einer neuen Nachricht wird ebenfalls die Funktion addMessage() aufgerufen.
Die Funktion @StateTree($t$) gitb den Status zum Zeitpunkt $t$ zurück. Neu wird jedoch die MessageQueue separat geführt, da der Statusbaum bei jeder schreibenden Operation neu aufgebaut werden muss.

``` {.coffee}
getState(t): ->
    return @StateTree(t)


addMessage(Message): ->

    @MessageQueue.insert Message
    @StateTree() = new Tree

    for Message in @MessageQueue
        @StateTree().apply Message

    for State in @stateTree
        State.tryToResolvConflict

``` 
<!-- 
```
 -->

#### Performance
Da bei jeder schreibenden Operation der gesamte Statusbaum neu aufgebaut wird, weist diese Implemantation eine Laufzeitkomplexität von $O(n)$ (mit $n$ = Grösse der MessageQueue) auf.

#### Verbesserung 1
Falls eine Nachricht auf einen aktuell gültigen Zustand referenziert, muss der Baum nicht erneut aufgebaut werden, da es ausreichend ist, den Baum nur zu erweitern.

#### Verbesserung 2
Jede schreibende Operation löst die erneute Generierung des gesamten Statusbaums aus. Um diese rechenintensive Operation zu vereinfachen, wird bei jeder Verzweigung der Zustand gespeichert. Eine Schreibende Aktion, muss so nur noch den betroffenen Teilbaum aktualisieren.

#### Probleme/Lösungen
Der grösste Gewinn beim Multistate Konzept liegt in der zeitlichen Entkoppelung zwischen Synchronisation und Konfliktauflösung. 
Die Richtigkeit, also die Qualität der Information, eines Status wird über die Zeit nur grösser.
Und genau darin besteht auch das grösste Problem, denn dadurch ist nicht garantiert dass Abfragen wiederholbare Ergebnisse liefern.


Konfliktvermeidung
------------------

### Update Transformation
Die einfachste Implementation einer Update-Transformation besteht darin, sowohl das mutierte Objekt, also auch das Ausgangsobjekt zu übertragen. Implizit wird so eine Mutationsfunktion übermittelt. Es wird der referenzierte Zustand des Objekts sowie die geänderten Attribute des neuen Status übermittelt.

``` {.coffee}
composeMessage(reference, current): ->

    for AttrName, Attribut in current
        if Attribut isnt reference[AttrName]
            Message.Mutation[AttrName] = Attribut

    Message.State = reference

    return Message

``` 
<!-- 
```
 -->

#### Probleme/Lösungen
Mutationen können konfliktfrei eingespielt werden, da die Operation automatisiert mit dem neueren Status wiederholt werden kann.
Ein sehr grosses Hindernis besteht aber darin, dass viele Benutzereingaben nur mit einer Zuweisung abgebildet werden können und deshalb die ursprüngliche Daten gar nicht in die Mutationsfunktion miteinbezogen werden. 

### Wiederholbare Transaktion
Eine sehr triviale Implementation besteht darin, sobald eine Nachricht abgelehnt wird, alle nachfolgenden Nachrichten einer Synchronisation auch abzulehnen und den Client neu zu initialisieren. 
Ein ähnliches Konzept ist im Gebiet der Datenbanken auch als Transaktion bekannt. Nur wird hier kein Rollback durchgeführt.

#### Probleme/Lösungen
Da bei einem nicht auflösbaren Konflikt alle Mutationen gelöscht werden, ist garantiert dass keine auf falschen Daten basierten Mutationen synchronisiert werden.
Aber gerade wegen diesem aggressivem Vorgehen, geht unter Umständen viel an Arbeit verloren.


Konfliktauflösung
-----------------

### Zusammenführung
Die einfachste Implementation besteht darin, nur geänderte Attribute zu übertragen. So werden Konflikte nur behandelt, wenn das entsprechende Attribut mutiert wurde.

``` {.coffee}
resolvConflict (valid, reference, current): ->

    NewState = new State
    
    for AttrName, Attribut in current
        if reference[AttrName] is valid[AttrName]
            NewState[AttrName] = Attribut
        else
            break

    return NewState

``` 
<!-- 
```
 -->

#### Probleme/Lösungen
Die wesentlich Idee ist, einzelne Attribute als vollwertige Objekte zu behandeln. So können mehr Informationen übernommen werden.

### geschätzte Zusammenführung
Um eine normalisierte Zusammenführung um zu setzten, ist zwingend ein wahlfreier Zugriff auf jeden vorherigen Stati notwendig.

``` {.coffee}
resolvConflict (valid, reference, average): ->

    NewState = new State
    Distances = new DistanceArray( average )

    for update in reference
        Distances.add update

    bestUpdate = Distances.smallest
    NewState[bestUpdate.AttrName] = bestUpdate.Attribut

    return NewState

``` 
<!-- 
```
 -->

#### Probleme/Lösungen
Entstandene Konflikte können aufgelöst werden, ohne dass manuell eingegriffen werden muss.
Die Unsicherheit liegt jedoch darin, dass entweder Ausreisser so nicht akzeptiert werden oder für die vorliegenden Daten (z.B. Telefonnummern, Adressen, ...) gar nicht erst eine Distanzfunktion erstellt werden kann.
Eine zentrale Einschränkung, liegt jedoch darin, dass diese Art der Zusammenführung nur mit Multistate funktioniert.

### kontextbezogene Zusammenführung

``` {.coffee}
resolvConflict (valid, reference, current): ->

    NewState = new State
    
    for AttrName, Attribut in current
        if reference[AttrName] is valid[AttrName]
        or not contextDidChange
            NewState[AttrName] = Attribut
        else
            break

    return NewState

``` 
<!-- 
```
 -->

### manuelle Zusammenführung
Eine manuelle Zusammenführung muss in Form eines GUI implementiert werden, womit ein Benutzer diese durchführen kann.

#### Probleme/Lösungen
Durch die händische Validation der Daten ist sichergestellt, dass der Konflikt richtig aufgelöst wurde.
Gerade bei grossen Datenbeständen gestaltet sich die Organisation einer Validierung sehr aufwändig.


<!-- Big Question - what are we going to do here? -->
Zusammenfassung
--------------

### Datenhaltung
Obwohl die Idee, Konfliktauflösungen zeitlich entkoppelt von Synchronisationsvorgang zu betreiben, sehr verlockend klingt, überwiegen die Nachteile. Keine garantierte Isolation, keine garantierte Atomarität, und keine garantierten Ergebnisse bei wiederholten Abfragen. Alle Eigenschaften die in Datenbanksystemen als wichtig eingestuft werden, sind hier eingeschränkt oder ausgehebelt.


### Konfliktauflösung/Konfliktverhinderung
Sowohl die Wiederholbare Transaktion, als auch die Normalisierte Zusammenführung lösen ansonsten nicht auflösbare Konflikte. Da das Konfliktauflösung jedoch nicht notwendigerweise korrekt sein muss und die Implementation sehr aufwändig ist, ist die Einsetzbarkeit nicht gegeben.

Die übrigen Verfahren wie Update Transformation, Zusammenführung sowie die Kontextbezogene Zusammenführung zeigten sich als einsetzbar.

-------------------------------------------------------------------------------
__Konzept__                  __Betrieb__    __Implementation__
--------------------------- --------------- -----------------------------------
Update Transformation       einfach         schwierig

Wiederholbare Transaktion   einfach         sehr schwierig

Zusammenführung             einfach         einfach

Kontext b. Zusamm.          einfach         einfach

Normalisierte Zusamm.       einfach         sehr schwierig

Manuelle Zusamm.            sehr schwierig  einfach

-------------------------------------------------------------------------------
Table: Konzept Vergleich Konfliktverhinderung - Konfliktauflösung


<!-- eventuell können wir auch direkt überschreiben, wenn wir dem Client vertrauen -> Eigene Daten -> Echter Zeitstempel-->

# Leitfaden
sync wird immer gemacht, wenn lokal daten gecached werden

## Busines-Logic muss Sync/Konflikte vorsehen
Konfliktauflösung mit Benutzerinformation

## Verwenden von persönlichen Daten
Daten sind nur von einer Person editierbar

## verwenden von Insert statt Update

## verwenden von altmodischem Lock?
First locked winns - but all can try

## Deaktivieren von Features wenn offline