
\part[Konzeption]{Konzeption}

# Konzept

<!-- redo -->
Im Rahmen dieser Bachelorarbeit werden zwei grundsätzliche Umgangsmethodiken mit Synchronisationen bzw. Synchronisationskonflikten betrachtet.


Synchronisationen können so gestaltet werden, dass keine Synchronisationskonflikte auftreten, oder es können auftretende Konflikte gelöst werden.
<!-- 
Verhinderung: beschneidung Funktionsumfang

Auflösung: möglicher Datenverlust
-->

## Synchronisation (allgemein)
Das grundlegende Idee bei der Synchronisation liegt darin, den Zustand der Servers und des Clients, bezüglich der Daten, identisch zu halten. 
Der Zustand der Daten können dabei als Status betrachtet werden. So repräsentiert der Zustand der gesamten Datensammlung zu einem bestimmten Zeitpunkt, einen Status. Aber auch der Zustand eines darin enthaltenen Objekts (z.B. ein Kontakt) wird als eigenständiger Status betrachtet.

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

Zu einem späteren Zeitpunkt $t_6$ wird eine Zusammenführung $M_1$ durchgeführt und somit der Konflikt aufgelöst.

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

#### Echte Kausalität
Zusätzlich wird der Nachricht auch die Generierungszeit auf dem Client beigefügt.



#### Früheste Nachricht









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