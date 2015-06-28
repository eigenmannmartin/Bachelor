

Konzeptuntersuchung
====================

Synchronsation
--------------

Zur Aufzeichnung der Informationen über Mutationen am Datenbestand, wird eine Form der Markierung benötigt. Die mutierten Daten müssen markiert werden, damit sie, sobald die Synchronisierung durchgeführt werden soll, übermittelt werden können. 

### Unterschiedsbasiert
Die unterschiedsbasierte Synchronisation zeichnet direkt bei der Mutation eines Objekts die an den Server zu sendende Nachricht auf und speichert diese in einer Messagequeue zur späteren Synchronisation ab. Sobald also die Synchronisation ausgelöst wird, werden alle aufgezeichneten Nachrichten, in der gleichen Reihenfolge wie bei der Aufzeichnung, dem Server zugestellt. 


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

### Objektbasiert
Bei der objektbasierten Synchronisation wird direkt bei der Mutation eines Objekts, dessen _dirty_ Flag gesetzt. Bei der Auslösung der Synchronisation werden alle Objekte, welche dieses Flag gesetzt haben, dem Server übermittelt und das _dirty_ Flag wieder entfernt.

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

Eine sehr elegante Form der Datenhaltung ist die Messagequeue. Der aktuell gültige Status ist durch die Anwendung aller in der Messagequeue enthaltenen Nachrichten auf den initialen Status erreichbar.
Der wahlfreie Zugriff auf jeden beliebigen Status zeichnet dieses einfache Design aus. Gerade wegen diesem wahlfreien Zugriff auf beliebige Stati ist diese Form ideal für die Verwendung im Rahmen dieser Thesis geeignet.  


Die beiden im Kapitel [Konzept] untersuchten Datenhaltungskonzepte sind nachfolgend genauer untersucht. Gezeigt wird wie ansatzweise eine Implementation aussehen könnte, um Probleme und Vorteile besser erkennen zu können. Konfliktverhinderung und -auflösung wird in den darauf folgenden Kapiteln genauer untersucht.

### Singlestate
Das Konzept des Singlestate ist sehr konservativ und ist in ähnlicher Form weit verbreitet. MongoDB und MySQL bieten beide das Konzept eines einzigen gültigen und rückwirkend unveränderbaren Status. Auch eine Versionierung und somit ein wahlfreier Zugriff auf alle Stati ist implementierbar.

Die Implementation auf konzeptioneller Stufe ist dabei wenig anspruchsvoll.
Beim Eingehen einer neuen Nachricht wird die Funktion _addMessage_ aufgerufen.
Die Funktion _State_ gibt den Status zum Zeitpunkt $t$ zurück. Falls kein Zeitpunkt angegeben ist, wird der neueste zurückgegeben.
Die MessageQueue wird durch das Statusobjekt verwaltet.


``` {.coffee}
getState(t): ->
    return @State(t)

addMessage(Message): ->
    if Message.refState is @State
        @State().apply Message.Mutation
    else
        if not @State().conflictsWith Message 
        or @State().canResolvConflict Message
            @State().apply Message
        else
            break

``` 
<!-- 
```
 -->

Die Funktionen canResolvConflict sowie resolveConflict greifen auf den referenzierten Status der Nachricht zu.

<!--
#### Performance
Der Zugriff auf einen beliebigen Status ist von der Laufzeitkomplexität $O(n)$ (mit $n$ Grösse der MessageQueue).-->

#### Verbesserung
Da jede schreibende Operation zuerst den referenzierten Status auslesen muss, und dies sehr rechenintensiv ist, wird jeder errechneten Zustand zwischengespeichert. So existiert für jede Nachricht bereits ein zwischengespeicherter Status und muss daher nicht für jede Operation erneut generiert werden.

<!--
#### Probleme/Lösungen
Das grösste Manko liegt jedoch im Umstand, einen Konflikt direkt beim Auftreten auflösen zu müssen. Konflikte die nicht aufgelöst werden können blockieren den gesamten Vorgang oder müssen abgebrochen werden.-->


### Multistate
Die Multistate Implementation unterschiedet sich insbesondere darin, dass das Annehmen einer Nachricht und das Auflösen des Konflikts zeitlich voneinander unabhängig sind.
Beim Eingehen einer neuen Nachricht wird ebenfalls die Funktion _addMessage_ aufgerufen. Die Funktion _StateTree_ gibt den Status zum Zeitpunkt $t$ zurück. Neu wird jedoch die MessageQueue separat geführt, da der Statusbaum bei jeder schreibenden Operation neu aufgebaut werden muss.

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
<!--
#### Performance
Da bei jeder schreibenden Operation der gesamte Statusbaum neu aufgebaut wird, weist diese Implemantation eine Laufzeitkomplexität von $O(n)$ (mit $n$ Grösse der MessageQueue) auf.-->

#### Verbesserung 1
Falls eine Nachricht auf einen aktuell gültigen Zustand referenziert, muss der Baum nicht erneut aufgebaut werden, da es ausreichend ist, den Baum nur zu erweitern.

#### Verbesserung 2
Jede schreibende Operation löst die erneute Generierung des gesamten Statusbaums aus. Um diese rechenintensive Operation zu vereinfachen, wird bei jeder Verzweigung der Zustand gespeichert. Eine schreibende Aktion, muss so nur noch den betroffenen Teilbaum aktualisieren.

<!--
#### Probleme/Lösungen
Der grösste Gewinn beim Multistate Konzept liegt in der zeitlichen Entkoppelung zwischen Synchronisation und Konfliktauflösung. 
Die Richtigkeit, also die Qualität der Information, eines Status wird über die Zeit nur grösser.
Und genau darin besteht auch das grösste Problem, denn dadurch ist nicht garantiert dass Abfragen wiederholbare Ergebnisse liefern.-->

Konfliktvermeidung
------------------

Die Konfliktvermeidung zielt darauf ab, Konflikte gar nicht erst entstehen zu lassen. Dazu müssen entweder funktionale Einschränkungen oder erhöhte Komplexität des Vorgangs hingenommen werden. Die Konzepte sind im Folgenden erläutert.

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
<!--
#### Probleme/Lösungen
Mutationen können konfliktfrei eingespielt werden, da die Operation automatisiert mit dem neueren Status wiederholt werden kann.
Ein sehr grosses Hindernis besteht aber darin, dass viele Benutzereingaben nur mit einer Zuweisung abgebildet werden können und deshalb die ursprüngliche Daten gar nicht in die Mutationsfunktion miteinbezogen werden. -->

### Wiederholbare Transaktion
Eine sehr triviale Implementation besteht darin, sobald eine Nachricht abgelehnt wird, alle nachfolgenden Nachrichten einer Synchronisation auch abzulehnen und den Client neu zu initialisieren. 
Ein ähnliches Konzept ist im Gebiet der Datenbanken auch als Transaktion bekannt. Nur wird hier kein Rollback durchgeführt.

<!--
#### Probleme/Lösungen
Da bei einem nicht auflösbaren Konflikt alle Mutationen gelöscht werden, ist garantiert dass keine auf falschen Daten basierten Mutationen synchronisiert werden.
Aber gerade wegen diesem aggressivem Vorgehen, geht unter Umständen viel an Arbeit verloren.-->

### Serverfunktionen
Serverfunktionen werden nur auf dem Server ausgeführt. Dafür wird eine Nachricht generiert, die es erlaubt, Funktionen direkt auf dem Server auf zu rufen. Neben dem Funktionsnamen, können auch Argumente mitgegeben werden.

``` {.coffee}
composeMessage(FunctionName, Args): ->

    Message.type = RPC
    Message.name = FunctionName
    Message.args = Args

    return Message

``` 
<!-- 
```
 -->



Konfliktauflösung
-----------------

Die Konfliktauflösung wird erst ausgeführt, wenn Konflikte auftreten. Um eine übersichtlichere Implementation zu ermöglichen, übernimmt die Konfliktauflösung jedoch auch die Konflikterkennung.

### Zusammenführung
Die einfachste Implementation der Zusammenführung besteht darin, nur geänderte Attribute zu übertragen. So werden Konflikte nur behandelt, wenn das entsprechende Attribut mutiert wurde.

``` {.coffee}
resolveConflict (valid, reference, current): ->

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

<!--
#### Probleme/Lösungen
Die wesentlich Idee ist, einzelne Attribute als vollwertige Objekte zu behandeln. So können mehr Informationen übernommen werden.-->

### Kontextbezogene Zusammenführung
Zur Implementation der kontextbezogenen Zusammenführung, muss der Kontext auf Ebene der Attribute definiert sein. Nur Attribute bei welchen sich der Kontext nicht änderte, werden übernommen.

``` {.coffee}
resolveConflict (current, contextFor): ->

    NewState = new State
    
    for AttrName, Attribut in current
        if contextFor[AttrName].didNotChange
            NewState[AttrName] = Attribut
        else
            break

    return NewState

``` 
<!-- 
```
 -->

### geschätzte Zusammenführung
Zur Auflösung von Konflikten mittels der geschätzten Zusammenführung wird eine Distanzfunktion benötigt. Diese Distanzfunktion ermittelt den Abstand zur optimalen Lösung und wendet dann die Mutation mit dem geringsten Abstand an.

``` {.coffee}
resolveConflict (valid, reference, average): ->

    NewState = new State
    Distances = new DistanceCalculator()

    for update in reference
        Distances.add update

    bestUpdate = Distances.smallest
    NewState[bestUpdate.AttrName] = bestUpdate.Attribut

    return NewState

``` 
<!-- 
```
 -->

<!--
#### Probleme/Lösungen
Entstandene Konflikte können aufgelöst werden, ohne dass manuell eingegriffen werden muss.
Die Unsicherheit liegt jedoch darin, dass entweder Ausreisser so nicht akzeptiert werden oder für die vorliegenden Daten (z.B. Telefonnummern, Adressen, ...) gar nicht erst eine Distanzfunktion erstellt werden kann.
Eine zentrale Einschränkung, liegt jedoch darin, dass diese Art der Zusammenführung nur mit Multistate funktioniert.-->




<!-- Big Question - what are we going to do here? 

we want to discuss problems and solutions provided by the conepts

some more work is needed!

-->


<!-- Zusammenführung der Aufteilung -->
Konklusion
----------
In diesem Kapitel sind die einzelnen Teile des Konzeptes kondensiert zusammengefasst und hinsichtlich der Praxistauglichkeit bewertet.


<!-- Synchronsation -->
Die unterschiedsbasierte Synchronisation ist sehr granular und flexibel einsetzbar. Die Logik des Synchronisierens ist vollständig von der Datenhaltung entkoppelt und ermöglicht einen sehr flexiblen Einsatz auch in bereits bestehenden Projekten. Dahingegen benötigt die objektbasierte Synchronisation eine Anpassung an der clientseitigen Datenhaltung.

<!-- Datenhaltung -->
Die Multistate Datenhaltung erlaubt zwar die zeitliche Entkoppelung von Synchronisation und Konfliktauflösung, garantiert jedoch keine Isolation, keine Atomarität und auch keine Konsistenz. Vor allem die Tatsache, dass wiederholte Abfragen nicht das selbe Resultat zurückliefern, birgt grosse Risiken im Betrieb. Der Singlestate ist deshalb deutlich besser zur Datenhaltung geeignet.


<!-- Konfliktauflösung/Konfliktverhinderung -->
Sowohl die wiederholbare Transaktion, als auch die geschätzte Zusammenführung lösen schwierige Konflikte. Da die Konfliktauflösung jedoch nicht notwendigerweise korrekt sein muss und die Implementation sehr aufwändig ist, ist die Einsetzbarkeit nicht gegeben.

Die übrigen Verfahren wie Update Transformation, Zusammenführung sowie die kontextbezogene Zusammenführung sind gut einsetzbar und schwächen das Synchronisationsproblem deutlich ab.


Leitfaden
---------
Dies ist ein Set von Konventionen und Richtlinien für die Synchronisation von Daten im Web-Umfeld basierend auf den Ergebnissen aus der Analyse und Bewertung der erarbeiteten Konzepte.
Diese fünf Regeln sollen das sehr schwere Synchronisationsproblem im Web-Umfeld abschwächen und somit auch die Komplexität der Software reduzieren.

### Unterschiedsbasierte Synchronisation
Mutationen am Datenbestand sollen in der chronologischen Reihenfolge ihres Auftretens zwischengespeichert werden, um sie anschliessend in genau der gleichen Reihenfolge auf dem Server anwenden zu können.

### Konflikte erlauben
Die Applikation soll die Möglichkeit des Auftretens von Konflikten vorsehen. So sollen benutzerfreundliche Fehlermeldungen generiert werden, die den Benutzer darauf hinweisen, dass von ihm bearbeitete Daten und Informationen nicht übernommen werden konnten. Konflikte sollen darüber hinaus aufgezeichnet und für Analysen gespeichert werden. Nicht übernommene Daten werden so gespeichert und gehen nicht verloren.

### Zuständigkeit für Daten
Wenn immer möglich, sollen Daten nur einem Benutzer zugewiesen sein. Somit ist Verwaltung und Veränderung der Daten nur einem Benutzer möglich. Synchronisationskonflikte entfallen so fast vollständig.

### Objekte erstellen
Wenn immer möglich sollen neue Objekte erstellt werden statt bestehende zu mutieren. Zusätzliche Informationen werden dazu in neuen Objekten, entsprechend referenziert, hinzugefügt.

### Lock
Das Setzen von Sperren erlaubt es vorübergehend alle anderen Mutationen zu verbieten. Dadurch kann ein Benutzer konfliktfrei Änderungen durchführen. Dabei wird beim Aufrufen des Editiermodus eines Objekts, dieses auf dem Server für alle anderen Benutzer gesperrt. Diese können nun, bis der aktuelle Bearbeiter das Objekt speichert und damit wieder freigibt, nur noch lesend auf das Objekt zugreifen.

### Serverfunktionen
Das Verwenden von Serverfunktionen beschränkt die Ausführung dieser nur auf den Zeitraum, in dem eine Verbindung zum Server besteht. Dadurch werden kritische Mutationen synchron vom Server verarbeitet und Konfliktfreiheit wird somit für diese eine Operation garantiert.