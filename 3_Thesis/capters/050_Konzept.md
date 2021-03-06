

Konzeptansätze
==============



Synchronisation
---------------

Die grundlegende Idee bei der Synchronisation liegt darin, den Zustand des Servers und des Clients, bezüglich der Daten, identisch zu halten. Der Zustand der Daten kann dabei als Status betrachtet werden. So repräsentiert der Zustand der gesamten Datensammlung zu einem bestimmten Zeitpunkt, einen Status. Aber auch der Zustand eines darin enthaltenen Objekts (z.B. eines Kontakts) wird als eigenständiger Status betrachtet.

Der Begriff der Synchronisation wird also im folgenden als Vorgang betrachtet, welcher Mutationen des Status des Clients, auch am Status des Servers durchführt. Dabei kann zwischen den beiden Vorgehensweisen unterschiedsbasierte und objektbasierte Synchronisation unterschieden werden. Beide Ansätze sind im Folgenden beschrieben.

### Unterschiedsbasierte Synchronisation
Zur Durchführung einer unterschiedsbasierten Synchronisation muss sowohl die Mutations-Funktion als auch der Status, auf welchen sie angewendet wird, bekannt sein. Beide Informationen zusammen werden als eine Einheit betrachtet und als Nachricht bezeichnet.
Eine Status-Mutation wird auf dem Server nur auf den selben Status angewendet werden, auf welchen sie auch auf dem Client angewendet wurde. Eine Mutation bezieht sich also immer auf einen bereits existierenden Status. Jede einzelne Änderung am Datenbestand wird durch eine einzige Nachricht repräsentiert. Die Nachricht wird direkt bei der Änderung generiert und dem Server übermittelt, sobald eine Verbindung hergestellt wird.

### Objektbasierte Synchronisation
Der Abgleich der Datenbestände wird durchgeführt sobald eine Verbindung mit dem Server besteht. Dann werden alle Objekte, die geändert und noch nicht synchronisiert wurden, vollständig dem Server übermittelt. Jedes Objekt wird in einer Nachricht zusammen mit der Referenz, des zuletzt vom Server erhaltenen Objekts, übermittelt.



Datenhaltung
------------

Die Datenhaltung beschäftigt sich mit der Frage, wie Daten verwaltet, wann und wie Mutationen darauf angewendet werden. Die beiden erarbeiteten Konzepte Singlestate und Multistate werden im Folgenden genauer erläutert.


### Singlestate
Ein Singlestate System erlaubt, nach dem Vorbild traditioneller Datenhaltungssysteme, zu jedem Zeitpunkt nur einen einzigen gültigen Zustand. 

Eingehende Nachrichten $N$ enthalten sowohl die Mutations-funktion als auch eine Referenz auf welchen Status, diese Mutation angewendet werden soll. Resultiert aus der Anwendung einer Nachricht, ein ungültiger Status, wird diese nicht übernommen. Nachrichten, welche nicht übernommen wurden, müssen im Rahmen der Konfliktauflösung separat behandelt werden.

In Abbildung {@fig:singlestate} sind die nacheinander eingehenden Nachrichten $N_1$ bis $N_4$ dargestellt. Nachricht $N_2$ sowie $N_3$ referenzieren auf den Status $S_2$. Die Anwendung der Mutations-Funktion von $N_2$ auf $S_2$ resultiert im gültigen Status $S_3$.
Die Anwenung der später eingegangene Nachricht $N_3$ auf $S_2$ führt zum ungültigen Status $S_3'$ und löst damit einen Synchronisationskonflikt aus.

![Singlestate](img/singlestate.jpg) {#fig:singlestate}

Die Konlfiktauflösung hat direkt bei der Anwendung der Mutations-Funktion zu erfolgen und kann nicht korrigiert werden. Die Konfliktauflösung muss also garantieren, dass immer die richtige Entscheidung getroffen wird.


### Multistate
Dieses Konzept arbeitet genau so wie ein Singlestate System mit eingehenden Nachrichten. Ein Multistate System erlaubt jedoch zu jedem Zeitpunkt beliebig viele gültige Zustände. Zu jedem Zeitpunkt ist jedoch immer nur ein Zustand aktiv.

Dieses Verhalten wird dadurch erreicht, dass Zustände rückwirkend eingefügt werden können. Wenn zum Zeitpunkt $t_4$ und $t_6$ der gültige Zustand des Systems zum Zeitpunkt $t_3$ erfragt wird, muss nicht notwendigerweise der identische Zustand zurückgegeben werden. 

In der Abbildung {@fig:multistate} sind die nacheinander eingehenden Nachrichten $N_1$ bis $N_5$ dargestellt. Nachricht $N_2$ sowie $N_4$ referenzieren auf den Status $S_2$. Die Anwendung der Mutations-Funktion von $N_2$ auf $S_2$ resultiert im gültigen Status $S_{3.0}$. 
Die Anwendung der Nachricht $N_3$ ergibt folglich den für den Zeitpunkt $t_5$ gültigen Status $S_{3.1}$.

![Multistate](img/mulstistate.jpg) {#fig:multistate}

Der Zeitpunkt an welchem die Nachricht $N_4$ verarbeitet ist, wird nun mit $t_A$ bezeichnet. Die Anwendung der Nachricht $N_4$ resultiert im neuen, für den Zeitpunkt $t_3$, gültigen Status $S_4$.
Vor dem Zeitpunkt $t_A$ ist für den Zeitpunkt $t_3$ der Status $S_{3.0}$ aktiv. Danach ist der Status $S_4$ aktiv.

Die Mutations-Funktion der Nachricht $N_3$ ist in keinem Konflikt mit der Nachricht $N_4$ oder $N_2$ und wird folglich auf den Status $S_4$ und $S_{3.0}$ angewendet obwohl der Referenzstatus nicht identisch ist. Eine Mutations-Funktion kann also auf jeden, vom referenzierten Status abstammenden Status angewendet werden, solange sie in keinem Konflikt damit steht. $N_5$ steht ebenfalls weder im Konflikt mit $N_2$ noch mit $N_4$ und kann desshalb auf $S_5$ und $S_{3.1}$ angewendet werden.

Die beiden zum Zeitpunkt $t_5$ gültigen Stati beinhalten das Maximum an Information. Der Status $S_6$ beinhaltet alle Informationen ausser die, der Nachricht $N_2$ und Status $S_{3.2}$ alle Informationen ausser die, der Nachricht $N_4$.

Zu einem späteren Zeitpunkt $t_6$ wird eine Konfliktauflösung $M_1$ durchgeführt und somit der Konflikt aufgelöst.

Welcher der Zweige bei einer Vergabelung als aktiv zu definieren ist, wird mit einer Vergabelungs-Funktion beurteilt. Diese gehört zur Konfliktauflösung und ist abhängig von der Datenbeschaffenheit und Struktur der Daten (Kapitel [Datenanalyse]).

Die Konfliktauflösung kann direkt bei der Anwendung der Mutations-Funktion, oder zu einem beliebigen späteren Zeitpunkt durchgeführt werden. Die Konfliktauflösung darf sehr greedy entscheiden, da Fehlentscheide zu einem anderen Zeitpunkt korrigiert werden können.


Konfliktvermeidung
------------------

Das Konzept der Konfliktvermeidung verhindert das Auftreten von möglichen Konflikten durch die Definition von Einschränkungen im Funktionsumfang der Transaktionen.

### Update Transformation
Damit Mutationen für eines oder mehrere Attribute gleichzeitig konfliktfrei synchronisiert werden können, wird für jedes einzelne Attribut eine Mutations-Funktion erstellt. Die einzelnen Funktionen können in einer Nachricht zusammengefasst werden.

Wie die Abbildung {@fig:updatetransform} zeigt, muss nicht das gesamte Objekt aktualisiert werden und es wird so ermöglicht die Konfliktauflösung granularer durchzuführen.

![Update Transformation](img/update-transformation.jpg)  {#fig:updatetransform}

### Wiederholbare Transaktion
Leseoperationen auf Stati des Clients, welche noch nicht mit dem Server synchronisiert sind, liefern möglicherweise falsche Resultate.
Alle Schreiboperationen, welche Resultate einer Leseoperationen mit einem falschem Resultat, verwenden, dürfen ebenfalls nicht synchronisiert werden, oder müssen mit der korrekten Datenbasis erneut durchgeführt werden.
Dies führt zur Vermeidung von logischen Synchronisationskonflikten.


### Serverfunktionen
Funktionen werden nur auf dem Server ausgeführt. Diese Serverfunktionen sind auf dem Client nicht verfügbar und können deshalb nur ausgeführt werden, sobald eine Verbindung zum Server besteht. Dieses Konzept entspringt dem Konzept von Remote Procedure Call und garantiert Konfliktfreiheit zur Ausführungszeit.



Konfliktauflösung
----------------

Das Konzept der Konfliktauflösung beschäftigt sich mit der Auflösung von Konflikten, die im Rahmen der Synchronisation aufgetreten sind. 
Da die Beschaffenheit und Struktur der Daten, bei der Konfliktauflösung eine entscheidende Rolle einnehmen, muss diese Beschaffenheit mit einbezogen werden.


### Zusammenführung
Die Attribute eines Objekts werden einzeln behandelt und auftretende Konflikte separat aufgelöst. So wird nur überprüft ob sich das entsprechende Attribut oder dessen Kontext, falls vorhanden, zwischen dem referenzierten und dem aktuellen Status verändert hat. Falls dies nicht der Fall ist, kann die Mutation konfliktfrei angewendet werden.
![Merge](./img/merge.jpg)

### geschätzte Zusammenführung
Wenn zwei oder mehr Mutationen auf einen Status angewendet werden sollen, wird die wahrscheinlich beste Mutation verwendet. Dazu wird die Richtigkeit jeder einzelnen Mutation geschätzt. Diese Schätzungen kann entweder mit statischen Analyse oder mit neuronalen Netzen umgesetzt werden.


### Kontextbezogene Zusammenführung
Für jedes als kontextbezogen klassifiziertes Attribut, muss ein Kontextattribut, also ein anderes Attribut des selben Objekts, definiert werden. Bei der Konfliktauflösung wird das Attribut nur dann übernommen, wenn sich das Kontextattribut nicht geändert hat. 


### Vergabelungs-Funktion
Die Vergabelungs-Funktion kann nur zusammen mit dem Datenhaltungskonzept Multistate eingesetzt werden. 
Bei der Entscheidung welcher Teilbaum aktiv wird können unterschiedliche Vorgehensweisen angewendet werden. Die verwendete Lösung muss auf die Datenbeschaffenheit und Struktur angepasst werden.
Nachfolgend sind fünf Ansätze dafür ausgeführt.

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






