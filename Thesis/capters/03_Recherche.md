<!-- Fachbegriffe, techn. Grundlagen -->


\part[Grundlagen]{Technische Grundlagen und Architekturen}


# Recherche
<!--
Dieses Kapitel erklärt die wichtigsten Grundbegriffe und wiedergibt die während der Recherche gesammelten Informationen.-->

## Fachbegriffe
Eine Aufführung und dazugehörende Ernährung der für das Verständnis der Arbeit notwendigen Fachbegriffe befindet sich im Anhang unter dem Kapitel "[Glossar]".

## Erläuterung der Grundlagen
In diesem Kapitel werden Funktionsweisen und Grundlage ausgeführt, die als für die Bearbeitung dieser Bachlorthesis herangezogen wurden.

### Datenbanken
Eine Datenbank [^Datenbanken_DBS] ist ein System zur Verwaltung und Speicherung von strukturierten Daten. Erst durch den Kontext des Datenbankschemas wird aus den Daten Informationen, die zur weiteren Verarbeitung genutzt werden können. Ein Datenbanksystem umfasst die beiden Komponenten Datenbankmanagementsystem (DBMS) sowie die zu veraltenden Daten selbst.
Ein DBMS muss die vier Aufgaben [^Datenbanken_ACID] erfüllen.

- Atomarität
- Konsistenzerhaltung
- Isolation
- Dauerhaftigkeit

Neben den vielen neu auf den Markt erschienen Technologien wie Document Store oder Key-Value Store ist das Relationale Datenbankmodell immer noch am weitesten verbreitet. [@dbenginesranking]. 


[^Datenbanken_DBS]: In der Literatur oft auch als **D**aten**B**ank**S**ystemen (DBS) oder Informationssystem bezeichnet. [@rupDatenbanken pp. 3-4]

[^Datenbanken_ACID]: Bekannt als ACID-Prinzip [@rupDatenbanken pp.105] umfasst es **A**tomicity, **C**onsistency, **I**solation und **D**urability. 


### Monolithische Systeme
Als Monolithisch wird ein logisches System bezeichnet, wenn es in sich geschlossen, ohne Abhängigkeiten zu anderen Systemen operiert. Alle zur Erfüllung der Aufgaben benötigten Ressourcen sind im System selbst enthalten. Es müssen also keine Ressourcen anderer Systeme alloziert werden und somit ist auch keine Kommunikation oder Vernetzung notwendig.
Das System selbst muss jedoch nicht notwendigerweise aus nur einem Rechenknoten bestehen, sondern darf auch als Cluster implementiert sein.

### Verteilte Systeme
Man kann zwischen physisch und logisch verteilten Systemen unterscheiden. Weiter kann das System auf verschiedenen Abstraktionsstufen betrachtet werden. So sind je nach Betrachtungsvektor unterschiedliche Aspekte relevant und interessant. [@ethdistribsystems]

#### physisch verteilte Systeme
Rechnernetze und Cluster-Systeme werden typischerweise als physisch verteiltes System betrachtet. Die Kommunikation zwischen den einzelnen Rechenknoten erfolgt nachrichtenorientiert und ist somit asynchron ausgelegt. Jeder Rechenknoten verfügt über exklusive Speicherressourcen und einen eigenen Zeitgeber.
Durch die Implementation eines Systems über mehrere unabhängige physische Rechenknoten kann eine erhöhte Ausfallsicherheit und/oder ein Performance-Gewinn erreicht werden.

#### logisch verteilte Systeme
Falls innerhalb eines Rechenknoten echte Nebenläufigkeit[^log_dist_system_nebenläufigkeit] oder Modularität[^log_dist_system_modularität] erreicht wird, kann von einem logisch verteilten System gesprochen werden. Einzelne Rechenschritte und Aufgaben werden unabhängig voneinander auf der selben Hardware ausgeführt. Dies ermöglicht den flexiblen Austausch[^logic_dist_system_modularprogramming] einzelner Module.


[^log_dist_system_nebenläufigkeit]: Von echter Nebenläufigkeit wird gesprochen, wenn verschiedene Prozesse zur selben Zeit ausgeführt werden. (Multiprozessor)

[^log_dist_system_modularität]: Modularität beschreibt die Unabhängigkeit und Austauschbarkeit einzelner (Software-) Komponenten. (Auch Lose Kopplung gennant)

[^logic_dist_system_modularprogramming]: Austauschbarkeit einzelner Programmteile wird durch die Einhaltung der Grundsätze von modularer Programmierung erreicht.


### Verteilte Algorithmen
Verteilte Algorithmen sind Prozesse welche miteinander über Nachrichten (synchron oder asynchron) kommunizieren und so idealerweise ohne Zentrale Kontrolle eine Kooperation erreichen. [@ethdistribalgo]
Performance-Gewinn, bessere Skalierbarkeit und eine bessere Unterstützung von verschiedenen Hardware-Architekturen kann durch den Einsatz von verteilten Algorithmen erreicht werden.

### Replikation
Replikation vervielfacht ein sich möglicherweise mutierendes Objekt (Datei, Dateisystem, Datenbank usw.), um hohe Verfügbarkeit, hohe Performance, hohe Integrität oder eine beliebige Kombination davon zu erreichen. [@SWB-327013990 p. 19]


#### Synchrone Replikation
Eine synchrone Replikation stellt sicher, dass zu jeder Zeit der gesamte Objektbestand auf allen Replikationsteilnehmern identisch ist.

Wird ein Objekt eines Replikationsteilnehmers mutiert, wird zum erfolgreichen Abschluss dieser Transaktion, von allen anderen Replikationsteilnehmern verlangt, dass sie diese Operation ebenfalls erfolgreich abschliessen. 
Üblicherweise wird dies über ein Primary-Backup Verfahren realisiert. Andere Verfahren wie der 2-Phase-Commit und 3-Phase-Commit ermöglichen darüber hinaus auch das synchrone Editieren von Objekten auf allen Replikationsteilnehmern. [@SWB-327013990 p. 23ff, 134ff]


#### Asynchrone Replikation
Eine asynchrone Replikation, stellt periodisch sicher, dass der gesamte Objektbestand auf allen Replikationsteilnehmern identisch ist. Mutationen können nur auf dem Master-Knoten durchgeführt werden. Einer oder mehrere Backup-Knoten übernehmen dann periodisch die Mutationen. 
Entgegen der [synchronen Replikation][Synchrone Replikation] müssen nicht alle Replikationsteilnehmer zu jedem Zeitpunkt verfügbar sein[^async_repl_bsp].

[^async_repl_bsp]: So kann der Backup-Knoten nur Nachts über verfügbar sein, damit der dazwischen liegende Kommunikationsweg Tags über nicht belastet wird.


#### Merge Replikation
<!-- Merge Konflikt beschreiben -->
Die merge Replikation erlaubt das mutieren der Objekte auf jedem beliebigen Replikationsteilnehmer. 
Mutationen auf einem einzelnen Replikationsteilnehmer werden periodisch allen übrigen Replikationsteilnehmern mitgeteilt. Da ein Objekt zwischenzeitlich[^merge_repl_latenz] auch auf anderen Teilnehmern mutiert worden sein kann, müssen während des Synchronisationsvorgang[^merge_repl] eventuell auftretenden Konflikte aufgelöst werden.

[^merge_repl_latenz]: Zwischen der lokalen Mutation und der Publikation dieser an die übrigen Replikationsteilnehmer, liegt eine beliebige Latenz.

[^merge_repl]: Da die Replikation nicht notwendigerweise nur unidirektional, sondern im Falle von einem Multi-Master Setup auch bidirektional durchgeführt werden kann, wird hier von einer Synchronisation gesprochen.


### Block-Chain
Die Block-Chain ist eine verteilte Datenbank die ohne Zentrale Autorität auskommt. Jede Transaktion wird kryptographisch gesichert der Kette von Transaktionen hinzugefügt. So ist das entfernen oder ändern vorhergehender Einträge nicht mehr möglich[^block_chani_proof_of_work]. Jeder Teilnehmer darf also alle Einträge lesen und neue Einträge hinzufügen. Da Einträge nur hinzugefügt werden und nie ein Eintrag geändert wird, kann eine Block-Chain immer ohne Synchronisationskonflikte repliziert werden. Konflikte können nur in den darüberlegenden logischen Schichten[^block_chain_logic_layer] auftreten. [@block-chain]

[^block_chani_proof_of_work]: Das ändern vorhergehender Einträge benötigt mehr Rechenzeit, als alle anderen Teilnehmer ab dem Zeitpunkt des Hinzufügens des Eintrages, zusammen aufgewendet haben.

[^block_chain_logic_layer]: So prüft die Bitcoin-Implementation ob eine Transaktion (Überweisung eines Betrags) bereits schon einmal ausgeführt wurde, und verweigert gegebenenfalls eine erneute Überweisung.


## Replikationsverfahren

### MySQL
Das Datenbanksystem MySQL unterstützt asynchrone als auch synchrone Replikation. Beide Betriebsmodi können entweder in der Master-Master[^mysql_active_active] oder in der Master-Slave Konfiguration betreiben werden. 

[^mysql_active_active]: Oft wird Master-Master Replikation auch als Active-Active Replikation referenziert.

Die Master-Slave Replikation unterstützt nur einen einzigen Master und daher werden Mutationen am Datenbestand nur vom Master entgegengenommen und verarbeitet. Ein Slave-Knoten kann aber im Fehlerfall des Masters, sich selbst zum Master befördern.

Der Master-Master Betrieb erlaubt die Mutation des Datenbestand auf allen Replikationsteilnehmern. Dies wird mit dem 2-Phase-Commit (2PC) Protokoll erreicht. Somit sind Konflikte beim Betrieb eines Master-Master Systems ausgeschlossen.


#### 2-Phase-Commit Protokoll
Um eine Transaktion erfolgreich abzuschliessen, müssen alle daran beteiligten Datenbanksysteme bekannt und in einem Zustand sein, in dem sie die Transaktion durchführen (commit) oder nicht (roll back). Die Transaktion muss auf allen Datenbanksystemen als eine einzige Atomare Aktion durchgeführt werden.

Das Protokoll unterscheidet zwischen zwei Phasen[@mysqlhandbook]:

1. In der ersten Phase werden alle Teilnehmer über den bevorstehenden Commit informiert und zeigen an ob sie die Transaktion erfolgreich durchführen können.
2. In der zweiten Phase wird der Commit durchgeführt, sofern alle Teilnehmer dazu im Stande sind.

### MongoDB
MongoDB unterstützt die Konfiguration eines Replica-Sets (Master-Slave) nur im asynchronen Modi. Das Transations-Log des Masters wird auf die Slaves kopiert, welche dann die Transaktionen nachführen. Ein Master-Master Betrieb ist nicht vorhergesehen.


## Synchronisationsverfahren

### Backbone.js
Das Web-Framework Backbone.js implementiert zur Datenhaltung und Synchronisation einen Key-Value Store. Der Key-Value Store kann entweder ein einzelnes Objekt oder ein gesamtes Set an Objekten[^backbone_model_collection] von der REST-API lesen sowie ein einzelnes Objekt schreibend an die REST-API senden.

[^backbone_model_collection]: Backbone.js verwendet die Begriffe Model für ein einzelnes Objekt, wobei einem Objekt genau ein Key, aber mehrere Values zugeordnet werden können, und Collection für eine Sammlung an Objekten.

Der REST-Standard[@restdissertation] verlangt dass für die Übermittlung eines Objekt immer der vollständige Status übermittelt wird. So wird bei lesendem und schreibenden Zugriff immer die gesamte Objekt kopiert.

Backbone.js sieht keinen Mechanismus vor, die auf dem Server stattfindenden Änderungen automatisch auf den Client zu übernehmen. Es muss entweder periodisch die gesamte Collection gelesen oder auf ein Änderungs-Log zugegriffen werden.
Darüber hinaus entscheidet der Server alleine, ob eine konkurrierende Version des Clients übernommen wird. Backbone.js sendet beim Synchronisieren eines Objekts, dessen gesamten Inhalt an den Server und übernimmt anschliessend die von der REST-API zurückgelieferten Version. Die zurückgelieferte Version kann eine auf dem Server bereits zuvor als aktiv gesetzte Version des Objekts sein und somit die gesendeten Aktualisierung gar nicht enthalten[^backbone_restapi_log].

[^backbone_restapi_log]: Auf dem Server können alle Requests aufgezeichnet werden, um Mutationen nicht zu verlieren. Dies wird vom Standard aber nicht vorausgesetzt und ist ein applikatorisches Problem.

Das Senden einer Aktualisierung an den Server wird mit drei Schritten erledigt.

1. Im ersten Schritt wird ein neues oder mutiertes Objekt an den Server übermittelt.
2. Der Server entscheidet im zweiten Schritt ob die Änderung komplett oder überhaupt nicht übernommen wird. Wird eine Änderung komplett übernommen wird dem Client dies so bestätigt.
Wird eine Änderung abgelehnt wird der Client darüber informiert.
3. Im Nachgang wird kann das Objekt vom Client erneut angefordert werden, und so die aktuellste Version zu beziehen.

### Meteor.js
Das WEB-Framework Meteor.js implementiert eine Mongo-Light-DB im Client-Teil und synchronisiert diese über das Distributed Data Protokoll mit der auf dem Server liegenden MongoDB in Echtzeit. 

Meteor.js setzt auf Optimistic Concurrency. So können Mutationen auf der Client-Datenbank durchgeführt werden und diese erst zeitlich versetzt mit dem Server synchronisiert werden. Je geringer die zeitliche Verzögerung, desto geringer ist die Wahrscheinlichkeit, dass das mutierte Objekt auch bereits auf dem Server geändert wurde. Um eine geringe zeitliche Verzögerung zu erreichen, sind alle Clients permanent mit dem Server mittels Websockets verbunden.

Der Server alleine entscheidet welche Version als aktiv übernommen wird. Somit kann nicht garantiert werden, dass alle vorgenommenen Änderungen auf dem Client erfolgreich an den Server übermittelt und übernommen werden. Da Mutationen üblicherweise zeitnah übertragen werden, treten aber nur in seltenen Fällen Konflikte auf.

Die Synchronisation einer Anpassung eines Objekts benötigt drei Schritte.

1. Im ersten Schritt wird ein neues oder die mutierten Attribute eines Objekts an den Server übermittelt.
2. Der Server entscheidet im zweiten Schritt ob die übermittelten Änderungen komplett, teilweise oder nicht angenommen werden.
3. Im dritten Schritt wird dem Client mitgeteilt welche Änderungen angenommen wurden. Der Client aktualisiert sein lokales Objekt entsprechen.