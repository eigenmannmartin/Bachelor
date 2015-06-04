
\part[Konzept]{Konzeption und Konzeptüberprüfung}

Konzeptansätze
==============



Synchronisation
---------------

Das grundlegende Idee bei der Synchronisation liegt darin, den Zustand der Servers und des Clients, bezüglich der Daten, identisch zu halten. 
Der Zustand der Daten können dabei als Status betrachtet werden. So repräsentiert der Zustand der gesamten Datensammlung zu einem bestimmten Zeitpunkt, einen Status. Aber auch der Zustand eines darin enthaltenen Objekts (z.B. eines Kontakts) wird als eigenständiger Status betrachtet.

Der Begriff der Synchronisation wird also im folgenden als Vorgang betrachtet, welcher Mutationen des Status des Clients, auch am Status des Servers durchführt.

Eine Status-Mutation kann dabei auf dem Server nur auf den selben Status angewendet werden, auf welchen sie auch auf dem Client angewendet wurde. Eine Mutation bezieht sich also immer auf einen bereits existierenden Status.

Zur Durchführung einer Syncrhonisation muss sowohl die Mutations-Funktion, sowie der Status auf welchen sie angewendet wird, gekannt sein. Beide Informationen zusammen werden als eine Einheit betrachtet und als __Nachricht__ bezeichnet.


### Nachrichten Basiert
Übertragen jeder einzelnen Änderung, Delta

### Objektbasiert
Übertragen des aktuellsten gesamten Objekts.



Datenhaltung
------------

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


Konfliktvermeidung
------------------

Das Konzept der Konfliktvermeidung verhindert das Auftreten von möglichen Konflikten durch die Definition von Einschränkungen im Funktionsumfang der Datenbanktransaktionen. So sind Objekt aktualisierende Operationen nicht möglich und werden stattdessen, Client seitig, über hinzufügende Operationen ersetzt.

### Update Transformation
Damit Mutationen für eines oder mehrere Attribute gleichzeitig konfliktfrei synchronisiert werden können, wird für jedes einzelne Attribut eine Mutations-Funktion erstellt. Die einzelnen Funktionen können in einer Nachricht zusammengefasst werden.

Wie die Abbildung {@fig:updatetransform} zeigt, muss nicht das gesamte Objekt aktualisiert werden und es wird so ermöglicht die Konfliktauflösung granularer durch zu führen.

![Update Transformation](img/update-transformation.jpg)  {#fig:updatetransform}

### Wiederholbare Transaktion
Leseoperationen auf Stati des Clients, welche noch nicht mit dem Server synchronisiert sind, liefern möglicherweise falsche Resultate.
Alle Schreiboperationen, welche Resultate der Leseoperationen mit falschem Resultat, verwenden, dürfen ebenfalls nicht synchronisiert werden, oder müssen mit der korrekten Datenbasis erneut durchgeführt werden.
Dies führt zur Vermeidung von logischen Synchronisationskonflikten.



Konfliktauflösun
----------------

Das Konzept der Konfliktauflösung beschäftigt sich mit der Auflösung von Konflikten, die im Rahmen der Synchronisation aufgetreten sind. 
Da die Beschaffenheit und Struktur der Daten, bei dieser Problemstellung eine entscheidende Rolle einnehmen, ist im folgendn für jede Klassifikations-Gruppe ein geeigneter Konfliktauflösungs-Algorithmus aufgeführt.


### Zusammenführung
Die Attribute eines Objekts werden einzeln behandelt und auftretende Konflikte separat aufgelöst. So wird nur überprüft ob sich das entsprechende Attribut oder dessen Kontext, falls vorhanden, zwischen dem referenzierten und dem aktuellen Status verändert hat. Falls dies nicht der Fall ist, kann die Mutation konfliktfrei angewendet werden.
![Merge](./img/merge.jpg)

### geschätze Zusammenführung
Die geschätzte Zusammenführung verwendet einen Algorithmus, welcher das beste Resultat schätzt. Dabei werden alle auf den Status angewendeten Nachrichten analysiert, und das vermutlich beste Resultat verwendet.
Diese Schätzung kann über zum Beispiel mit neuronalen Netzen umgesetzt werden

### kontextbezogene Zusammenführung
Attribute, welche kontextbezogen sind, werden nur übernommen, wenn der Kontext nicht sowie das zu mutierende Attribut nicht geändert wurde.

### manuelle Zusammenführung
Wenn keine Auflösung des Konflikts möglich ist, muss dieser manuell aufgelöst werden. Dabei muss das System angehalten werden, oder die Nachricht zurückgehalten werden.

### Vergabelungs-Funktion
Bei der Entscheidung welcher Teilbaum aktiv wird können unterschiedliche Vorgehensweisen angewendet werden. Die verwendete Lösung muss auf die Datenbeschaffenheit und Struktur angepasst werden.
Nachfolgende sind fünf Ansätze ausgeführt.

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

#### Timeboxing
Periodisch wird ein Status manuell validiert und als "Grenze" gesetzt. Nachrichten, welche auf ältere Stati, oder auf Stati in anderen Zweigen referenzieren, markieren nie einen aktiven Teilbaum.






