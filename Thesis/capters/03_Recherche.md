<!-- Fachbegriffe, techn. Grundlagen -->


\part[Teil ii]{Technische Grundlagen und Architekturen}


# Recherche

Dieses Kapitel erklärt die wichtigsten Grundbegriffe und wiedergibt die während der Recherche gesammelten Informationen.


## Fachbegriffe
Eine Aufführung und Erlährung der Fachbegriffe befindet sinch im Appendix unter "[Glossar]"

## Erläuterung der Grundlagen
<!-- Ausführliche Einführung in die wichtigesten Themengebiete -->

### Datenbanken
Eine Datenbank [^Datenbanken_DBS] ist ein System zur Verwaltung und Speicherung von strukturierten Daten. Erst durch den Kontext des Datenbankschemas wird aus den Daten Informationen, die zur weiteren Verarbeitung genutzt werden können. Ein Datenbanksystem umfasst die beiden Komponenten Datenbankmanagementsystem (DBMS) sowie die zu veraltenden Daten selbst.
Ein DBMS muss die vier Aufgaben [^Datenbanken_ACID] erfüllen.

- Atomarität
- Konsistenzerhaltung
- Isolation
- Dauerhaftigkeit

Neben den vielen neu auf den Markt erschienen Technologien wie Document Store oder Key-Value Store ist das Relationale Datenbankmodell immer noch am weit verbreitet. [@dbenginesranking]. 


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
Falls innerhalb eines Rechenknoten echte Nebenläufigkeit[^log_dist_system_nebenläufigkeit] oder Modularität[^log_dist_system_modularität] erreicht wird, kann von einem logisch verteilten System gesprochen werden. Einzelne Rechenschritte und Aufgaben werden unabhängig voneinander auf der selben Hardware ausgeführt. Dies ermöglicht den flexiblen Austauschen[^logic_dist_system_modularprogramming] einzelner Aufgaben.


[^log_dist_system_nebenläufigkeit]: Von echter Nebenläufigkeit wird gesprochen, wenn verschiedene Prozesse zur selben Zeit ausgeführt werden. (Multiprozessor)

[^log_dist_system_modularität]: Modularität beschreibt die Unabhängigkeit und Austauschbarkeit einzelner (Software-) Komponenten. (Auch Lose Kopplung gennant)

[^logic_dist_system_modularprogramming]: Austauschbarkeit einzelner Programmteile wird durch die Einhaltung der Grundsätze von modularer Programmierung erreicht.


### Verteilte Algorithmen
Verteilte Algorithmen sind Prozesse welche miteinander über Nachrichten (synchron oder asynchron) kommunizieren und so idealerweise ohne Zentrale Kontrolle eine Kooperation erreichen. [@ethdistribalgo]
Performance-Gewinn, bessere Skalierbarkeit und eine breitere Abdeckung der unterstützen von verschiedenen Hardware-Architekturen kann durch den Einsatz von verteilten Algorithmen erreicht werden.


### Verteilte Datenbanken
[Präsenzbibliothek ZHAW]

### Replikation
Replikation vervielfacht ein sich möglicherweise mutierendes Objekt (Datei, Dateisystem, Datenbank usw.), um hohe Verfügbarkeit, hohe Performance, hohe Integrität oder eine beliebige Kombination davon zu erreichen. [@SWB-327013990 p. 19]


#### Synchrone Replikation
Eine synchrone Replikation stellt sicher, dass zu jeder Zeit der gesamte Objektbestand auf allen Replikationsteilnehmern identisch ist.

Wird ein Objekt eines Replikationsteilnehmer mutiert, wird zum erfolgreichen Abschluss dieser Transaktion, von allen anderen Replikationsteilnehmern verlangt, dass sie diese Operation ebenfalls erfolgreich abschliessen. 
Üblicherweise wird dies über ein Primary-Backup Verfahren realisiert. Andere Verfahren wie der 2-Phase-Commit und 3-Phase-Commit ermöglichen darüber hinaus auch das synchrone Editieren von Objekten auf allen Replikationsteilnehmern. [@SWB-327013990 p. 23ff, 134ff]


#### Asynchrone Replikation
Eine asynchrone Replikation, stellt periodisch sicher, dass der gesamte Objektbestand auf allen Replikationsteilnehmern identisch ist. Mutationen können nur auf dem Master-Knoten durchgeführt werden. Einer oder mehrere Backup-Knoten übernehmen dann periodisch die Mutationen. 
Entgegen der [synchronen Replikation][Synchrone Replikation] müssen nicht alle Replikationsteilnehmer zu jedem Zeitpunkt verfügbar sein[^async_repl_bsp].

[^async_repl_bsp]: So kann der Backup-Knoten nur Nachts über verfügbar sein, damit die dazwischen liegende Verbindung Tags über nicht belastet wird.


#### Merge Replikation
<!-- Merge Konflikt beschreiben -->
Die merge Replikation erlaubt das mutieren des Objekts auf einem beliebigen Replikationsteilnehmer. 
Mutationen auf einem einzelnen Replikationsteilnehmer werden periodisch allen übrigen Replikationsteilnehmern mitgeteilt. Da ein Objekt zwischenzeitlich[^merge_repl_latenz] auch auf anderen Teilnehmern mutiert worden sein kann, müssen während des Synchronisationsvorgang[^merge_repl] eventuell auftretenden Konflikte aufgelöst werden.

[^merge_repl_latenz]: Zwischen der lokalen Mutation und der Publikation dieser an die übrigen Replikationsteilnehmer, liegt eine beliebige Latenz.

[^merge_repl]: Da die Replikation nicht notwendigerweise nur unidirektional, sondern im Falle von einem Multi-Master Setup auch bidirektional durchgeführt werden kann, wird hier von einer Synchronisation gesprochen.


### Block-Chain
Die Block-Chain ist eine verteilte Datenbank die ohne Zentrale Kontrolle auskommt. Jede Transaktion wird kryptographisch gesichert, der Kette von Transaktionen hinzugefügt. So ist das entfernen oder ändern vorhergehender Einträge nicht mehr möglich[^block_chani_proof_of_work]. Jeder Teilnehmer darf also alle Einträge lesen und neue Einträge hinzufügen. Da Einträge nur hinzugefügt werden und nie ein Eintrag geändert wird, kann eine Block-Chain immer ohne Synchronisationskonflikte repliziert werden. Konflikte können nur in den darüberlegenden logischen Schichten[^block_chain_logic_layer] auftreten. [@block-chain]

[^block_chani_proof_of_work]: Das ändern vorhergehender Einträge benötigt mehr Rechenzeit, als alle anderen Teilnehmer ab diesem Zeitpunkt zusammen aufgewendet haben.

[^block_chain_logic_layer]: So prüft die Bitcoin-Implementation ob eine Transaktion (Überweisung eines Betrags) bereits schon einmal ausgeführt wurde, und verweigert gegebenenfalls eine erneute Ausführung.