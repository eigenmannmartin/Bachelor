

# Konzept


In diesem Kapitel werden die Konzeptansätze konkretisiert und auf Anwendbarkeit hin untersucht.

"konkreter Ablauf"


## Datenhaltung
Nachrichtenbasiert -> Message-Queue

### Singlestate
Message-Queue und Ausgangs-Status

Anwendung aller Elemente in der MQ auf den AStatus -> aktuell gültiger Status.
Konfliktauflösung gemäss Konzepten

1. Nachricht entgegennehmen -> in die MQ
2. ist referenzierter Status = aktueller Status? ja:6, nein:3
3. temp. Anwendung auf referenzierten Staus, Konflikt? ja:4, nein:6 
4. Konfliktauflösung möglich? ja:5, nein:4
5. Konflikt auflösen
6. Anwendung auf aktiven Status
7. Nachricht abschlissen

#### Verbesserung 1
- Cache aller Lese-Resultete
- ein Schreibzugriff lehrt den Cache

#### Verbesserung 2
- 2 MQs (verarbeitet/zu verarbeiten) -> cache wird zum aktuelle status und immer aktualisiert.
- -> Zugriff auf aktueller Status schnell, auf bestimmte Stati langsam 

#### Anwendungsbeispiel Synchronisation von Kontakten

##### Szenario 1
Hinzufügen -> Konfliktfrei

##### Szenario 2
Anpassen der primären Tel-NR -> Konflit, falls bereits geändert seit referenz status

##### Szenario 3
Ändern des Namens -> Konflikt, falls bereits geändert

##### Szenario 4
Hinzufügen pers. Info -> immer überschreiben, Eigenverantwortung



#### Probleme/Lösungen
Lösungen:
- Konsistenter Status

Probleme:
- nicht auflösbare Konflikte blokieren das System



### Multistate
Message-Queue, Shadow-Queue und Ausgangs-Status

Message-Queue ist nach Eingangsreihenfolge geordnet
Shadow-Queue ist logisch nach Zeitpunkten geordnent => nach Stati

Anwendung aller Elemente in der MQ auf den AStatus -> aktuell gültige Stati.
Konfliktauflösung gemäss Konzepten

1. Nachricht entgegennehmen -> in die MQ
2. Nachricht entsprechend des Referenz-Staus in der SQ einordnen
3. Baum ab der neuen Nachricht erneut aufbauen. (Vergabelungsfunktion)
4. Konflikte Auflösen

#### Verbesserung 1
- Cache aller Lese-Resultate
- ein Schreibzugriff lehrt den Cache

#### Verbesserung 2
- ein Schreibzugriff lehrt nur den Cache des betroffenen Teilbaums
- Jeder Ursprungsstatus einer Vergabelung wird in den Cashe geschrieben


#### Anwendungsbeispiel Synchronisation von Kontakten

##### Szenario 1
Hinzufügen -> Konfliktfrei

##### Szenario 2
Anpassen der primären Tel-NR -> Konflit => eigener Zweig. Möglicherweise aktiver Zweig.

##### Szenario 3
Ändern des Namens -> Konflikt => eigener Zweig. Möglicherweise aktiver Zweig

##### Szenario 4
Hinzufügen pers. Info -> immer überschreiben, Eigenverantwortung



#### Probleme/Lösungen
Lösungen:
- jede Nachricht kann verarbeitet werden - Konfliktlösung in der Zukunft

Probleme:
- Ikonsistenter Status




## Konfliktvermeidung

### Update Transformation
Mutations-Funktion wird immer auf den aktuellsten Status angewendet.

#### Anwendungsbeispiel Synchronisation von Kontakten

##### Szenario 1
Hinzufügen -> Konfliktfrei

##### Szenario 2
Anpassen der primären Tel-NR -> nicht möglich

##### Szenario 3
Ändern des Namens -> nicht möglich

##### Szenario 4
Hinzufügen pers. Info -> nicht möglich


#### Probleme/Lösungen
Lösungen:
- Nachricht kann Konfliktfrei eingespielt werden, da erneute Berechnung auf Server

Probleme:
- Nur wenige auf Operationen anwendbar 


### Wiederholbare Transaktion

All or nothing Sync - wenn etwas abgelehnt wird, wird nichts späteres synchronisiert.

#### Anwendungsbeispiel Synchronisation von Kontakten
Es werden keine spezifischen Konflikte gelöst. Es wird nur verhindert dass es zu Logischen Fehlern auf höheren Schichten kommt, da keine Mutation Synchronisiert wird, die auf nicht akzeptierten Daten fusst.

#### Probleme/Lösungen
Lösungen:
- Informationen sind sicher auf korrekten Daten basierend

Probleme:
- eventuell muss viel "Arbeit" weggeschmissen werden



## Konfliktauflösung

### Zusammenführung
gesamtes Objekt in der Mutations-Funktion - aber nicht jedes Attribut mutiert

#### Anwendungsbeispiel Synchronisation von Kontakten
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
Hinzufügen pers. Info -> immer überschreiben, Eigenverantwortung da temp.

#### Probleme/Lösungen
Lösungen:
- Granularere Aufteilung des Problems

Probleme:
- keine


### normalisierte Zusammenführung
Ein Attribut wird in zwei Mutationsfunktionen aktualisiert. Der Konflikt wird aufgelöst, indem die Nachricht genommen wird, die näher am Durchschnitt ist.

##### Szenario 1
Hinzufügen -> Konfliktfrei

##### Szenario 2
Anpassen der primären Tel-NR -> Grösse bezüglich "Richtigkeit" im Adressbuch
(Richtiges Format/Landesvorwahl etc.)

##### Szenario 3
Ändern des Namens -> nicht möglich

##### Szenario 4
Hinzufügen pers. Info -> nicht möglich

#### Probleme/Lösungen
Lösungen:
- Sofern Daten dafür ausreichen / guter Kompormiss

Probleme:
- eventuell "falsche Daten"


### manuelle Zusammenführung

von Hand - bei Singlestate blockierend

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