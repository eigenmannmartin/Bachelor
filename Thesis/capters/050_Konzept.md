
\part[Konzeption]{Konzeption}

# Konzeptansätze

<!-- redo -->

<!-- Synchronisationen können so gestaltet werden, dass keine Synchronisationskonflikte auftreten, oder es können auftretende Konflikte gelöst werden. -->
<!-- 
Verhinderung: beschneidung Funktionsumfang

Auflösung: möglicher Datenverlust
-->

## Synchronisation (allgemein)
Das grundlegende Idee bei der Synchronisation liegt darin, den Zustand der Servers und des Clients, bezüglich der Daten, identisch zu halten. 
Der Zustand der Daten können dabei als Status betrachtet werden. So repräsentiert der Zustand der gesamten Datensammlung zu einem bestimmten Zeitpunkt, einen Status. Aber auch der Zustand eines darin enthaltenen Objekts (z.B. eines Kontakts) wird als eigenständiger Status betrachtet.

Der Begriff der Synchronisation wird also im folgenden als Vorgang betrachtet, welcher Mutationen des Status des Clients, auch am Status des Servers durchführt.

Eine Status-Mutation kann dabei auf dem Server nur auf den selben Status angewendet werden, auf welchen sie auch auf dem Client angewendet wurde. Eine Mutation bezieht sich also immer auf einen bereits existierenden Status.

Zur Durchführung einer Syncrhonisation muss sowohl die Mutations-Funktion, sowie der Status auf welchen sie angewendet wird, gekannt sein. Beide Informationen zusammen werden als eine Einheit betrachtet und als __Nachricht__ bezeichnet.

## Datenhaltung
Die Datenhaltung beschäftigt sich mit der Frage, wie Daten verwaltet und wann und wie Mutationen darauf angewendet werden. Die beiden erarbeiteten Konzepte Singlestate und Multistate werden im Folgenden genauer erläutert.


### Singlestate
Ein Single-State System erlaubt, nach dem Vorbild traditioneller Datenhaltungssystem, zu jedem Zeitpunkt nur einen einzigen gültigen Zustand. 

Eingehende Nachrichten $N$ enthalten sowohl die Mutations-funktion als auch eine Referenz auf welchen Status $S_x$, diese Mutation angewendet werden soll. Resultiert aus der Anwendung einer Nachricht, ein ungültiger Status, wird diese nicht übernommen. Nachrichten, welche nicht übernommen wurden, müssen im Rahmen der Konfliktauflösung separat behandelt werden.

In Abbildung {@fig:singlestate} sind die nacheinander eingehenden Nachrichten $N_1$ bis $N_4$ dargestellt. Nachricht $N_2$ sowie $N_3$ referenzieren auf den Status $S_2$. Die Anwendung der Mutations-Funktion von $N_2$ auf $S_2$ resultiert im gültigen Status $S_3$.
Die Anwenung der später eingegangene Nachricht $N_3$ auf $S_2$ führt zum ungültigen Status $S_3'$ und löst damit einen Synchronisationskonflikt aus.

![Singlestate](img/singlestate.jpg) {#fig:singlestate}

Die Konlfiktauflösung hat direkt bei der Anwendung der Mutations-Funktion zu erfolgen und kann nicht korrigiert werden. Die Konfliktauflösung muss also garantieren, dass immer die richtige Entscheidung getroffen wird.


### Multistate
Ein Multi-State System erlaubt zu jedem Zeitpunkt beliebig viele gültige Zustände. Zu jedem Zeitpunkt ist jedoch immer nur ein Zustand gültig.

Dieses Verhalten wird dadurch erreicht, dass Zustände rückwirkend eingefügt werden können. Wenn zum Zeitpunkt $t_1$ und $t_2$ der gültige Zustand des Systems zum Zeitpunkt $t_0$ erfragt wird, muss nicht notwendigerweise der identische Zustand zurückgegeben werden. 

In der Abbildung {@fig:multistate} sind die nacheinander eingehenden Nachrichten $N_1$ bis $N_5$ dargestellt. Nachricht $N_2$ sowie $N_4$ referenzieren auf den Status $S_2$. Die Anwendung der Mutations-Funktion von $N_2$ auf $S_2$ resultiert im gültigen Status $S_{3.0}$. 
Die Anwendung der Nachricht $N_3$ ergibt folglich den für den Zeitpunkt $t_5$ gültigen Status $S_{3.1}$.

![Multistate](img/mulstistate.jpg) {#fig:multistate}

Der Zeitpunkt an welchem die Nachricht $N_4$ verarbeitet ist, wird mit hier $t_A$ bezeichnet. Die Anwendung der Nachricht $N_4$ resultiert im neuen, für den Zeitpunkt $t_3$, gültigen Status $S_4$.
Vor dem Zeitpunkt $t_A$ ist für den Zeitpunkt $t_3$ der Status $S_{3.0}$ gültig. Danach ist der Status $S_4$ gültig.

Die Mutations-Funktion der Nachricht $N_3$ ist in keinem Konflikt mit der Nachricht $N_4$ oder $N_2$ und wird folglich auf den Status $S_4$ und $S_{3.0}$ angewendet. $N_5$ steht ebenfalls weder im Konflikt mit $N_2$ noch mit $N_4$ und kann desshalb auf $S_5$ und $S_{3.1} angewendet werden.

Die beiden zum Zeitpunkt $t_5$ gültigen Stati beinhalten das Maximum an Information. Der Status $S_6$ beinhaltet alle Informationen ausser der Nachricht $N_2$ und Status $S_{3.2}$ alle Informationen ausser der Nachricht $N_4$.

Zu einem späteren Zeitpunkt $t_6$ wird eine Konfliktauflösung $M_1$ durchgeführt und somit der Konflikt aufgelöst.

Welcher der Zweige bei einer Vergabelung als gültig zu definiert ist, wird über eine Vergabelungs-Funktion beurteilt. Diese gehört zur Konfliktauflösung und ist abhängig von der Datenbeschaffenheit und Struktur der Daten (Kapitel [Datenanalyse]).

Die Konfliktauflösung kann direkt bei der Anwendung der Mutations-Funktion, oder zu einem beliebigen späteren Zeitpunkt durchgeführt werden. Die Konfliktauflösung darf sehr greedy entscheiden, da Fehlentscheide korrigiert werden können.

<!--
Z.B. das Resultat der Abfrage des Status gestern um 10:00 muss nicht dem Resultat der Abfrage von heute, wie der Status gestern um 10:00 war.

Jeder Status ist also Rückwirkend veränderbar. Entsprechende Systeme müssen dafür ausgelegt sein.

Die Konfliktauflösung funktioniert genau gleich wie bei den Singlestate Systemen. Wir dürfen jedoch sehr fiel mehr "greedy" sein.

Statt das wahrscheinlichsten oder des erste eingehenden Attribut zu verwenden wird die Kausalität sichergestellt. So wird für jede Mutation ein "quasi" Timestamp generiert (auch auf den mobilen Endgeräten) um so den Zeitpunkt der Synchronisierung zu egalisieren. Mutationen die echt zu erst durchgeführt wurden, gelten.


sehr greedy. Wir dürfen alles annehmen, und kümmern uns erst später um auftretende Fehler.

-->

## Konfliktvermeidung
Das Konzept der Konfliktvermeidung verhindert das Auftreten von möglichen Konflikten durch die Definition von Einschränkungen im Funktionsumfang der Datenbanktransaktionen. So sind Objekt aktualisierende Operationen nicht möglich und werden stattdessen, Client seitig, über hinzufügende Operationen ersetzt.

### Update Transformation
<!-- Überfürung von Update in Insert -->
Damit Mutationen für eines oder mehrere Attribute gleichzeitig konfliktfrei synchronisiert werden können, wird für jedes einzelne Attribut eine Mutations-Funktion erstellt. Die einzelnen Funktionen können in einer Nachricht zusammengefasst werden.

Wie die Abbildung {@fig:updatetransform} zeigt, muss nicht das gesamte Objekt aktualisiert werden und es wird so ermöglicht die Konfliktauflösung granularer durch zu führen.

![Update Transformation](img/update-transformation.jpg)  {#fig:updatetransform}

### Wiederholbare Transaktion
Leseoperationen auf Stati des Clients, welche noch nicht mit dem Server synchronisiert sind, liefern möglicherweise falsche Resultate.
Alle Schreiboperationen, welche Resultate der Leseoperationen mit falschem Resultat, verwenden, dürfen ebenfalls nicht synchronisiert werden, oder müssen mit der korrekten Datenbasis erneut durchgeführt werden.
Dies führt zur Vermeidung von logischen Synchronisationskonflikten.




## Konfliktauflösung
Das Konzept der Konfliktauflösung beschäftigt sich mit der Auflösung von Konflikten, die im Rahmen der Synchronisation aufgetreten sind. 
Da die Beschaffenheit und Struktur der Daten, bei dieser Problemstellung eine entscheidende Rolle einnehmen, ist im folgendn für jede Klassifikations-Gruppe ein geeigneter Konfliktauflösungs-Algorithmus aufgeführt.


### Zusammenführung (Merge)
<!-- Manueller Merge -->
Einzelne Attribute oder Attributsgruppen innerhalb eines Objekts werden als eigenständige Objekte betrachtet. So kann ein Konflikt, der auftritt wenn zwei Objekte mit Mutationen in unterschiedlichen Attributsgruppen synchronisiert werden , aufgelöst werden, indem nur die jeweils mutierten Attributgrupen als synchronisationswürdig betrachtet werden.

Kontextbezogene Attribute sind in der selben Attributgruppe wie der Kontext.

![Merge](./img/merge.jpg)

Diese Operation ist unabhängig von Datentyp, Struktur und Art.
Der (automatisierte) Merge kann nur durchgeführt werden, wenn nur eine einzige Version eines Attributs existiert. -> nie konkurrierende Versionen entstehen.

Darüber hinaus versieht der Server jede Attribut-Version mit einer Versions-Nummer. So kann verhindert werden, dass ein Attribut mit einer niederen Versions-Nummer über ein neueres Attribut synchronisiert wird.

### Kontext bezogene Zusammenführung

### normalisierte Zusammenführung (Normalized Merge)
<!-- Maschineller Merge (wahrscheinlichste Lösung) -->
Wenn bei einer Synchronisierung mit zwei Objekten die selben Attribute mutiert wurden, kann im Falle von numerischen Attributen, das Objekt mit den geringsten Abweichungen vom Meridian über alle verfügbaren Datensätze verwendet werden. Es wird also das normalisierteste Attribut verwendet.
Bei Attributsgruppen wird die Gruppe mit der insgesamt geringsten Abweichung verwendet.
Es muss eine Abstandsfunktion für jedes Attribut oder jede Attributgruppe erstellt werden.

Es kann so die warscheinlichste Version verwendet werden. Wenn zu $t_1$ $A_1$ und zu $t_2$ $A_2$, also das selbe Attribut synchronisiert wird, wird es beide male angenommen. Beide Versionen basieren auf der gleichen Ursprungsversion. $A_2$ besitzt aber die kleinere Abweichung und gewinnt deshalb. 
Hätte es die grössere Abweichung, würde es nicht synchronisiert werden.

![Merge](./img/merge.jpg)


### manuelle Zusammenführung
Wenn keine Auflösung des Konflikts möglich ist, muss dieser manuell aufgelöst werden.


### Vergabelungs-Funktion
Bei der Entscheidung welcher Teilbaum aktiv wird können unterschiedliche Vorgehensweisen angewendet werden. Die verwendete Lösung muss auf die Datenbeschaffenheit und Struktur angepasst werden.
Nachfolgende sind sechs Ansätze ausgeführt.

#### Wichtigste Information
Die Attribute eines Objekts können in aufsteigenden Wichtigkeits-Klassen gruppiert werden. Die Wichtigkeit einer Nachricht entspricht der höchsten Wichtigkeits-Klasse die mutiert wird.
Die Nachricht mit der grössten Wichtigkeit markiert den aktiven Teilbaum.

#### Maximale Information
Den Attributen eines Objekts werden nummerische Informationsgehalts-Indikator zugewiesen. Der Informationsgehalt einer Nachricht entspricht der Summe aller Informationsgehalts-Indikatoren der mutierten Attribute.
Die Nachricht mit dem höheren Informationsgehalt markiert den aktiven Teilbaum.

#### Geringste Kindsbäume
Für jeden Teilbaum werden die der darin vorkommenden Vergabelungen gezählt. Die Nachricht, die den Teilbaum mit den wenigsten darin vorkommenden Vergabelungen markiert den aktiven Teilbaum.

#### Online-First
Zusätzlich zur Mutations-Funktion und der Status-Referenz wird einer Nachricht die Information mitgegeben, ob der Client diese online sendet.
Die Nachrichten, welche online gesendet wurden, werden immer den offline synchronisierten Nachrichten vorgezogen.

#### Echte Kausalität
Der Zeitstempel der Generierung wird der Nachricht beigefügt. Die Nachricht, welche echt zu erst erstellt wurde, markiert den aktiven Teilbaum.

#### Timeboxing
Periodisch wird ein Status manuell validiert und als "Grenze" gesetzt. Nachrichten, welche auf ältere Stati, oder auf Stati in anderen Zweigen referenzieren, markieren nie einen aktiven Teilbaum.






