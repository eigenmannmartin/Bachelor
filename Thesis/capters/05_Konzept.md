
\part[Teil iii]{Konzept und Implementierung}

# Konzept

<!-- redo -->
Im Rahmen dieser Bachelorarbeit werden zwei grundsätzliche Umgangsmethodiken mit Synchronisationen bzw. Synchronisationskonflikten betrachtet.
Synchronisationen können so gestaltet werden, dass keine Synchronisationskonflikte auftreten, oder es können auftretende Konflikte gelöst werden.
<!-- 
Verhinderung: beschneidung Funktionsumfang

Auflösung: möglicher Datenverlust
-->

\newpage

## Singlestate
Ein Single-State System lässt zu jedem Zeitpunkt $t$ nur einen einzigen gültigen Zustand zu. 
Eingehende Nachrichten $N$ enthalten sowohl die Änderungsfunktion als auch eine Referenz auf welchen Status $S$ diese Mutation angewendet werden soll.

In Abbildung {@fig:singlestate} sind die nacheinander eingehenden Nachrichten $N_1$ bis $N_4$ dargestellt. Nachricht $N_2$ sowie $N_3$ referenzieren auf den Status $S_2$. Die Anwendung der Änderungsfunktion von $N_2$ auf $S_2$ resultiert im gültigen Status $S_3$.
Die Anwenung der später eingegangene Nachricht $N_3$ auf $S_2$ führt zum ungültigen Status $S_3'$.

![Singlestate](img/singlestate.jpg) {#fig:singlestate}

Sobald eine Nachricht vom Server verarbeitet wurde die Transaktion abgeschlossen. Entweder ergab sich daraus ein neuer gültiger, oder aber ein ungültiger Status. In diesem Fall konnten die Mutationen nicht übernommen werden und wurden abgelehnt.


\newpage

## Multistate
Der Zustand des Systems wird durch eine Message-Queue repräsentiert.

1. Message gets sent
2. Message gets enqueued
3. If message conflicts with an other message -> next else -> end
4. message gets moved bevore conflicts
5. Fork is generated
6. It is decided with fork is the main fork (master)


Zu jedem Zeitpunkt sind beliebig viele gültige Stati erlaubt.
Es gibt zu jedem echten Zeitpunkt nur einen einzigen gültigen Status (main fork), bei Konflikten kann aber ein anderer Zweig nachträglich als Master definiert werden.

In Abbildung {@fig:multistate} sind die nacheinander erstellten Nachrichten $N_1$ bis $N_5$ und ihre Interaktion mit den Stati $S_1$ bis $S_7$ aufgeführt.
Die Nachrichten sind entsprechend ihrem Eingang beim Server geordnet.

Die echte Kausalität verhält sich jedoch wie folgt: $N_1 < N_2 < N_4 < N_5 < N_3$
Die Nachricht $N_2$ löst einen Konflikt mit der Nachricht $N_4$ aus. Alle übrigen Nachrichten sind konfliktfrei.

Mit $M_1$ wird das manuelle Zusammenführen zweier Stati bezeichnet.

Nach dem Eingang der Nachricht $N_2$ wird vom System der Status $S_{3.0}$ als aktuell gültiger Status für den Zeitpunkt $t_3$ geführt.
Sobald die Nachricht $N_4$ verarbeitet wurde, wird für den Zeitpunkt $t_3$ jedoch der Status $S_4$ als gültig gesetzt.

Zwischen $t_3$ und $t_5$ gehen die Nachrichten 3 und 5 ein. Beide Nachrichten werden auf den Status $S_3$ sowie auf die entsprechenden Stati $S_4$ und $S_5$ angewendet.

Zum Zeitpunkt $t_5$ existieren also der Status $S_6$ mit allen Mutationen ausser denen von $N_2$ und der Status $S_{3.1}$ mit allen Mutationen, ausser denen von $N_4$.

Entweder wird nun ein Teilbaum abgeschnitten oder wie gezeigt eine manuelle Zusammenführung $M_1$ durchgeführt.

![Multistate](img/mulstistate.jpg) {#fig:multistate}





Jedem Benutzer/Session werden gegebenenfalls eigene Zweige zugewiesen. Das integrieren der Zweite in den Master-Zweig muss manuell vorgenommen werden.

Weiter werden alle neu eingehende Nachrichten für alle Zweige verarbeitet, ausser es entstünden dadurch weitere Konflikte.

Es können also immer alle Änderungen synchronisiert werden. Keine Mutationen gehen verloren. 
Die Konfliktauflösung kann nachträglich durchgeführt werden.

Wenn Nachrichten eingespielt werden, die Konflikte auflösen, kann ein anderer Zweig als Master markiert werden, dadurch können nachträglich andere Konflikte ausgelöst werden etc.

Z.B. das Resultat der Abfrage des Status gestern um 10:00 muss nicht dem Resultat der Abfrage von heute, wie der Status gestern um 10:00 war.

Jeder Status ist also Rückwirkend veränderbar. Entsprechende Systeme müssen dafür ausgelegt sein.

Die Konfliktauflösung funktioniert genau gleich wie bei den Singlestate Systemen. Wir dürfen jedoch sehr fiel mehr "greedy" sein.

Statt das wahrscheinlichsten oder des erste eingehenden Attribut zu verwenden wird die Kausalität sichergestellt. So wird für jede Mutation ein "quasi" Timestamp generiert (auch auf den mobilen Endgeräten) um so den Zeitpunkt der Synchronisierung zu egalisieren. Mutationen die echt zu erst durchgeführt wurden, gelten.


sehr greedy. Wir dürfen alles annehmen, und kümmern uns erst später um auftretende Fehler.




\newpage

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

#### Kontextbezogene Daten
können in einer Transaktion, nur aktualisiert werden, wenn der Kontext sich nicht geändert hat.

#### Unabhängige Daten
können ohne Abhängigkeit des Zustandes anderer Daten aktualisiert werden.
Zu beachten ist, dass nur numerische, boolsche und binäre Werte und nur die beiden Grundoperationen + und - immer funktionieren.

#### Exklusive Daten
Für den Fall dass von 2 Geräten ein Update ausgeführt wird, müssen beide Versionen gespeichert werden, und der User muss entscheiden welche Version verwendet werden soll

#### Gemeinsame Daten
Im Falle von Text-Daten kann diese Art der Synchronisation nur für den tatsächlichen Add verwendet werden. 



\newpage

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

### normalisierte Zusammenführung (Normalized Merge)
<!-- Maschineller Merge (wahrscheinlichste Lösung) -->
Wenn bei einer Synchronisierung mit zwei Objekten die selben Attribute mutiert wurden, kann im Falle von numerischen Attributen, das Objekt mit den geringsten Abweichungen vom Meridian über alle verfügbaren Datensätze verwendet werden. Es wird also das normalisierteste Attribut verwendet.
Bei Attributsgruppen wird die Gruppe mit der insgesamt geringsten Abweichung verwendet.
Es muss eine Abstandsfunktion für jedes Attribut oder jede Attributgruppe erstellt werden.

Es kann so die warscheinlichste Version verwendet werden. Wenn zu $t_1$ $A_1$ und zu $t_2$ $A_2$, also das selbe Attribut synchronisiert wird, wird es beide male angenommen. Beide Versionen basieren auf der gleichen Ursprungsversion. $A_2$ besitzt aber die kleinere Abweichung und gewinnt deshalb. 
Hätte es die grössere Abweichung, würde es nicht synchronisiert werden.

![Merge](./img/merge.jpg)


### gewichtete Zusammenführung ()
nach Menge oder Wichtigkeit der Attribute





\newpage

## Gesamtkonzept

Das Gesamtkonzept besteht in einer Zusammenführung aller bereits erwähnter Konzepte. Je nach zu synchronisierendem Datenbestand müssend entsprechend Passende Lösungsverfahren angewendet werden.


# Design des Prototypen
In diesem Kapitel werden die aus dem Kapitel [Konzept] gewonnenen Erkenntnisse umgesetzt.

## Design-Ansätze
Zur Lösung der Aufgabenstellung wurden drei Design-Ansätze erarbeitet. Diese werden folgend kurz erläutert.

### Server zentrierte Architektur
Der Server führt alle Berechnungen o.ä. durch. Nur mit einer aktiven Verbindung zum Server können Manipulationen am Datenbestand durchgeführt werden.

### Client zentrierte Architektur
Der Client trifft Entscheidungen und führt die Berechtigungsprüfung durch. Die Resultate werden dann dem Server übermittelt.

### Client zentrierte, Server basierte Architektur
Der Client simuliert alle Manipulationen. Der Server entscheidet über das Resultat.

## Entscheid
Anforderung UC 5-8 => {Client zentrierte, Server basierte Architektur, Message Oriented}


## Design
Der Prototyp besteht aus 3 Bausteinen; Server, API und Client.

![Bausteinübersicht](img/design_components.jpg) {#fig:bausteinübersicht}

Die Bausteine werden in den folgenden Kapitel erläutert.

### Backend
Alle Daten müssen zur Aufbereitung in das Backend transferiert werden.
Im Backend wird zwischen Persistenz- und Logik-Schicht unterschieden.

#### Logik
Die Logik-Schicht nimmt alle Nachrichten entgegen und führt, sofern aufgetreten Konfliktauflösungen vor.
Die Kommunikation mit der API findet nur über Nachrichten statt.
Die Kommunikation mit der darunter liegenden Persistenz-Schicht findet über eine Asynchrone API statt.

S_LOGIC_SM_get
S_LOGIC_SM_create
S_LOGIC_SM_update
S_LOGIC_SM_delete

#### Persistenz
Die Persistenz soll Modell-Basiert sein.


### API
Message Queuing & Message Passing - nothing else

Umsetzung mit REST-Like Verhalten (get,put,update,delete)

__Client-Side__
S_API_WEB_get
S_API_WEB_put
S_API_WEB_update
S_API_WEB_delete

__Server-Side__
S_API_WEB_send

### Frontend
Der Client bietet keine Persistenz über einen Neustart hinweg.

![Flux Diagramm](img/flux-diagram.png)

C_PRES_STORE_update
C_PRES_STORE_delete

### Message Flow

Frontend    <->  API    <->     Backend

Frontend: ActionCreator -> Dispatcher -> Store -> API -> ActionCreator

API: Queue -> Transporter

Backend: API -> Logiclayer -> API 


### AMD Pattern
Asyncronous module definition (AMD) ist eine JavaScript API um Module zu definieren und diese zur Laufzeit zu laden. Dadurch können Javascript-lastige Webseiten beschleunigt werden, da Module erst geladen werden, wenn sie gebraucht werden. Weiter werden durch den Loader die Module gleichzeitig geladen, dadurch kann die Bandbreite voll ausgenutzt werden. 
Da die Module durch die Vorgabe des Patterns in einzelnen Dateien abgelegt sind, wird eine Kapselung ähnlich wie bei Java erreicht. Das erleichtert die Fehlersuche und erhöht die Verständlichkeit des Programmes drastisch. Auch die Wiederverwendbarkeit der Module wird dadurch erhöht.
Da in jedem Modul die Abhängigkeiten definiert werden müssen, kann während dem Build-Prozess die Abhängigkeiten geprüft werden, um so die Verfügbarkeit aller benötigten Module sicher zu stellen.


## Beispielapplikation
Gem. Aufgabenstellung soll der Prototyp anhand eines passenden Fallbeispiel die Funktionsfähigkeit Zeigen.

Die Beispielapplikation soll eine Ressourcenplan-Software sein. Folgendes soll möglich sein:

1. einen neuen Raum erfassen (Name, Grösse, Anzahl Sitze)
2. einen bestehenden Raum anpassen/löschen
3. einen Termin auf einem Raum Buchen (Name, Zeit&Datum, Kurzbeschreibung, Besucherliste, persönliche Notizen)
4. einen Bestehenden Termin anpassen/absagen