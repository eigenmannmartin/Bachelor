
\part[Teil iii]{Konzept und Implementierung}

# Konzept

<!-- redo -->
Im Rahmen dieser Bachelorarbeit werden zwei grundsätzliche Umgangsmethodiken mit Synchronisationen bzw. Synchronisationskonflikten betrachtet.
Synchronisationen können so gestaltet werden, dass keine Synchronisationskonflikte auftreten.
<!-- 
Verhinderung: beschneidung Funktionsumfang

Auflösung: möglicher Datenverlust
-->


## Konfliktvermeidung
Das Konzept der Konfliktvermeidung verhindert das Auftreten von möglichen Konflikten durch die Definition von Einschränkungen im Funktionsumfang der Datenbanktransaktionen. So sind direkt Objekt aktualisierende Operationen nicht möglich und werden stattdessen, Client seitig, über hinzufügende Operationen ersetzt.

### Update Transformation
<!-- Überfürung von Update in Insert -->
Damit Mutationen für eine bestimmte Gruppe von Daten (???) konfliktfrei synchronisiert werden können, werden Mutationen in "inserts" verpackt.

>nehme einen Jogurt aus dem Kühlschrank

statt

>jetzt hat es noch 5 Jogurts im Kühlschrank


### Wiederholbare Transaktion
<!--  -->
Statt nur einer Überführung einer Einzelnen Mutation in ein Insert wird die gesamte Transaktion so gemacht.
Falls nun eine Leseaktion auf eine bereits mutiertes Objekt geschieht, welches noch nicht synchronisiert wurde, und aufgrund dieser Lesekation eine andere Mutation passiert, darf die zweite Mutation nur synchronisiert werden, falls die erste Mutation auch erfolgreich war.


## Konfliktauflösung
Das Konzept der Konfliktauflösung beschäftigt sich mit der Auflösung von Konflikten, die im Rahmen der Synchronisation aufgetreten sind. 
Da die Beschaffenheit und Struktur der Daten, bei dieser Problemstellung eine entscheidende Rolle einnehmen, ist im folgendn für jede Klassifikations-Gruppe ein geeigneter Konfliktauflösungs-Algorithmus aufgeführt.


### Zusammenführung (Merge)
<!-- Manueller Merge -->
Einzelne Attribute oder Attributsgruppen innerhalb eines Objekts werden als eigenständige Objekte betrachtet. So kann ein Konflikt, der auftritt wenn zwei Objekte mit Mutationen in unterschiedlichen Attributsgruppen synchronisiert werden , aufgelöst werden, indem nur die jeweils mutierten Attributgrupen als synchronisationswürdig betrachtet werden.

Kontextbezogene Attribute sind in der selben Attributgruppe wie der Kontext.

### normalisierte Zusammenführung (Normalized Merge)
<!-- Maschineller Merge (wahrscheinlichste Lösung) -->
Wenn bei einer Synchronisierung mit zwei Objekten die selben Attribute mutiert wurden, kann im Falle von numerischen Attributen, das Objekt mit den geringsten Abweichungen vom Meridian über alle verfügbaren Datensätze verwendet werden. Es wird also das normalisierteste Attribut verwendet.
Bei Attributsgruppen wird die Gruppe mit der insgesamt geringsten Abweichung verwendet.


### Kausalitäts Zusammenführung (Merge)
<!-- Vector-Timestamp & neueste Version gewinnt-->
Statt das wahrscheinlichsten oder des erste eingehenden Attribut zu verwenden wird die Kausalität sichergestellt. So wird für jede Mutation ein "quasi" Timestamp generiert (auch auf den mobilen Endgeräten) um so den Zeitpunkt der Synchronisierung zu egalisieren. Mutationen die echt zu erst durchgeführt wurden, gelten;




## Gesamtkonzept


