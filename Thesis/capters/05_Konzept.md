
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
Das Konzept der Konfliktvermeidung verhindert das Auftreten von möglichen Konflikten durch die Definition von Einschränkungen im Funktionsumfang der Datenbanktransaktionen. So sind Objekt aktualisierende Operationen nicht möglich und werden stattdessen, Client seitig, über hinzufügende Operationen ersetzt.

### Update Transformation
<!-- Überfürung von Update in Insert -->
Damit Mutationen für eines oder mehrere Attribute konfliktfrei synchronisiert werden können, wird die Änderung als neues Objekt der Datensammlung hinzugefügt.

Änderungen eines Attributes $Ex$ werden als neues Attribut in einem neuen Objekt $Ix(Ex)$ erfasst. (Abbildung {@fig:updatetransform})

![Update Transformation](img/update-transformation.jpg)  {#fig:updatetransform}

Solange die Einfüge-Funktion $Ix(Ex)$ eine Numerische Operation (+ oder -) ist, spielt es meist! Rolle in welcher Kausalität die Funktionen auf dem Server angewendet werden.

#### Kontextbezogene Daten
Kontextbezogene Daten können nur aktualisiert werden, wenn der Kontext sich nicht geändert hat.

#### Unabhängige Daten
Unabhängige Daten können ohne Abhängigkeit des Zustandes anderer Daten aktualisiert werden.
Zu beachten ist, dass nur numerische, boolsche und binäre Werte und nur die beiden Grundoperationen + und - immer funktionieren.

#### Exklusive Daten
Für den Fall dass von 2 Geräten ein Update ausgeführt wird, müssen beide Versionen gespeichert werden, und der User muss entscheiden welche Version verwendet werden soll

#### Gemeinsame Daten
Im Falle von Text-Daten kann diese Art der Synchronisation nur für den tatsächlichen Add verwendet werden. 


### Wiederholbare Transaktion
<!--  -->
Statt nur einer Überführung einer Einzelnen Mutation in ein Insert wird die gesamte Transaktion so gemacht.
Falls nun eine Leseaktion auf eine bereits mutiertes Objekt geschieht, welches noch nicht synchronisiert wurde, und aufgrund dieser Lesekation eine andere Mutation passiert, darf die zweite Mutation nur synchronisiert werden, falls die erste Mutation auch erfolgreich war.

Es werden applikatorische Inkonsistenzen vermieden. Zusätzlich müssen auf dem Client alle Lese- und Schreib-Operationen "ge-trackt" werden.


## Konfliktauflösung
Das Konzept der Konfliktauflösung beschäftigt sich mit der Auflösung von Konflikten, die im Rahmen der Synchronisation aufgetreten sind. 
Da die Beschaffenheit und Struktur der Daten, bei dieser Problemstellung eine entscheidende Rolle einnehmen, ist im folgendn für jede Klassifikations-Gruppe ein geeigneter Konfliktauflösungs-Algorithmus aufgeführt.


### Zusammenführung (Merge)
<!-- Manueller Merge -->
Einzelne Attribute oder Attributsgruppen innerhalb eines Objekts werden als eigenständige Objekte betrachtet. So kann ein Konflikt, der auftritt wenn zwei Objekte mit Mutationen in unterschiedlichen Attributsgruppen synchronisiert werden , aufgelöst werden, indem nur die jeweils mutierten Attributgrupen als synchronisationswürdig betrachtet werden.

Kontextbezogene Attribute sind in der selben Attributgruppe wie der Kontext.

<!-- ~~~~~ {.dot .scale=100% .title=Zusammenführung .label=fig:merge}
digraph g {
    node [shape = record,height=.1];
    node0 [label = "<f0> A1|<f1> A2|<f2> A3"];
    node1 [label = "<f0> A1|<f1> A2|<f2> A3"];
    node2 [label = "<f0> A1|<f1> A2|<f2> A3"];
    "node0":f0 -> "node2":f0;
    "node0":f1 -> "node2":f1;
    "node1":f2 -> "node2":f2;
}
~~~~~ -->

![Merge](./img/merge.jpg)

Diese Operation ist unabhängig von Datentyp, Struktur und Art.
Der (automatisierte) Merge kann nur durchgeführt werden, wenn nur eine einzige Version eines Attributs existiert. -> nie konkurrierende Versionen entstehen.

Darüber hinaus versieht der Server jede Attribut-Version mit einer Versions-Nummer. So kann verhindert werden, dass ein Attribut mit einer niederen Versions-Nummer über ein neueres Attribut synchronisiert wird.

### normalisierte Zusammenführung (Normalized Merge)
<!-- Maschineller Merge (wahrscheinlichste Lösung) -->
Wenn bei einer Synchronisierung mit zwei Objekten die selben Attribute mutiert wurden, kann im Falle von numerischen Attributen, das Objekt mit den geringsten Abweichungen vom Meridian über alle verfügbaren Datensätze verwendet werden. Es wird also das normalisierteste Attribut verwendet.
Bei Attributsgruppen wird die Gruppe mit der insgesamt geringsten Abweichung verwendet.
Es muss eine Abstandsfunktion für jedes Attribut oder jede Attributgruppe erstellt werden.

Es kann so die warscheinlichste Version verwendet werden. Wenn zu $t_1$ $A_1$ und zu $t_2$ $A_2$, also das selbe Attribut synchronisiert wird, wird es beide male angenommen. Beide Versionen basieren auf der gleichen Ursprungsversion. $A_2$ besitzt aber die kleinere Abweichung und gewinnt deshalb. 
Hätte es die grössere Abweichung, würde es nicht synchronisiert werden.

### Kausalitäts Zusammenführung (Merge)
<!-- Vector-Timestamp & neueste Version gewinnt-->
Statt das wahrscheinlichsten oder des erste eingehenden Attribut zu verwenden wird die Kausalität sichergestellt. So wird für jede Mutation ein "quasi" Timestamp generiert (auch auf den mobilen Endgeräten) um so den Zeitpunkt der Synchronisierung zu egalisieren. Mutationen die echt zu erst durchgeführt wurden, gelten.


## Gesamtkonzept

Das Gesamtkonzept besteht in einer Zusammenführung aller bereits erwähnter Konzepte. Je nach zu synchronisierendem Datenbestand müssend entsprechend Passende Lösungsverfahren angewendet werden.


