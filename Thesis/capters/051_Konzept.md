

# Konzept Untersuchung


In diesem Kapitel werden die Konzeptansätze konkretisiert und auf ihre Anwendbarkeit hin untersucht.


## Datenhaltung
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
Die einfachste Implementation einer Update-Transformation besteht darin, sowohl das mutierte Objekt, also auch das Ausgangsobjekt zu übertragen. Implizit wird so eine Mutationsfunktion übermittelt. Es wird der referenzierte Zustand des Objekts sowie die geänderten Attribute des neuen Status übermittelt.
<!-- Übermittlung von ausführbarem Code ist nicht sinnvoll -->

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


#### Pro/Contra
Mutationen können konfliktfrei eingespielt werden, da die Operation automatisiert mit dem neueren Status wiederholt werden kann.
Ein sehr grosses Hindernis besteht aber darin, dass viele Benutzereingaben nur mit einer Zuweisung abgebildet werden können und deshalb die ursprüngliche Daten gar nicht in die Mutationsfunktion miteinbezogen werden. 

### Wiederholbare Transaktion
Eine sehr triviale Implementation besteht darin, sobald eine Nachricht abgelehnt wird, alle nachfolgenden Nachrichten einer Synchronisation auch abzulehnen und den Client neu zu initialisieren. 
Ein ähnliches Konzept ist im Gebiet der Datenbanken auch als Transaktion bekannt. Nur wird hier kein Rollback durchgeführt.

<!-- #### Anwendungsbeispiel Synchronisation von Kontakten
Es werden keine spezifischen Konflikte gelöst. Es wird nur verhindert dass es zu Logischen Fehlern auf höheren Schichten kommt, da keine Mutation Synchronisiert wird, die auf nicht akzeptierten Daten fusst. -->

#### Probleme/Lösungen
Da bei einem nicht auflösbaren Konflikt alle Mutationen gelöscht werden, ist garantiert dass keine auf falschen Daten basierten Mutationen synchronisiert werden.
Aber gerade wegen diesem aggressivem Vorgehen, geht unter Umständen viel an Arbeit verloren.


## Konfliktauflösung

### Zusammenführung
Die einfachste Implementation besteht darin, nur geänderte Attribute zu übertragen. So werden Konflikte nur behandelt, wenn das entsprechende Attribut mutiert wurde.

``` {.coffee}
resolvConflict (valid, reference, current): ->

    NewState = new State
    
    for AttrName, Attribut in current
        if reference[AttrName] is valid[AttrName]
        or not context
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
Entstandene Konflikte können aufgelöst werden, ohne dass manuell eingegriffen werden muss.
Die Unsicherheit liegt jedoch darin, dass entweder Ausreisser so nicht akzeptiert werden oder für die vorliegenden Daten (z.B. Telefonnummern, Adressen, ...) gar nicht erst eine Distanzfunktion erstellt werden kann.
Eine zentrale Einschränkung, liegt jedoch darin, dass diese Art der Zusammenführung nur mit Multistate funktioniert.


### manuelle Zusammenführung
Eine manuelle Zusammenführung muss in Form eines GUI implementiert werden, womit ein Benutzer diese durchführen kann.

#### Probleme/Lösungen
Durch die händische Validation der Daten ist sichergestellt, dass der Konflikt richtig aufgelöst wurde.
Gerade bei grossen Datenbeständen gestaltet sich die Organisation einer Validierung sehr aufwändig.




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
