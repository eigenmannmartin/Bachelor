<!--

Beispiel:

Kontakte Synchronisieren
Single- und Multistate möglich
Implementation möglich

"Grosses" Problem - jeder kennt das



-->
\part[Präambel]{Einleitung und Abgrenzung}



# Einleitung

## Motivation und Fragestellung
<!-- rewrite this sentence - might be better now -->
Der Zugriff auf Services und Medien mittels mobiler Geräte steigt beständig an. So ist im Mai 2014, 60% der Zeit, die online verbracht wird, über Handy und Tablet zugegriffen worden - davon 51% mittels mobiler Applikationen. [@comescore-mobiletrends]

![Verteilung der online verbrachten Zeit nach Platform (Grafik erstellt gemäss der Daten von [@comescore-mobiletrends])](img/Share-of-US-Digital-Media-Time-Spent-by-Platform.pdf)

Angesichts der grossen Verbreitung und Nutzung von Services und Medien im Internet, wird eine unterbruchsfreie Benutzbarkeit, auch ohne Internetverbindung, immer selbstverständlicher und somit auch immer wichtiger.

>"It's clear that the mobile industry has finally given up on the fantasy that an Internet connection is available to all users at all times. Reality has set in. And in the past month, we've seen a new wave of products and services that help us go offline and still function." @cw-mobiletrends

<!-- mehr Begründung - Netzabdekung -->

Es stellt sich nun die Frage, wie Informationen, über Verbindungsunterbrüche hinweg, integer gehalten werden können. Und wie Daten im mobilen Umfeld synchronisiert, aktualisiert und verwaltet werden könne, so dass, für den Endbenutzer schlussendlich kein Unterschied zwischen Online- und Offline-Betrieb mehr wahrnehmbar ist.

<!-- eventuell Beispiele? 
Google-Offline Calendar
Facebook Offline App (IOS) <- https://developers.facebook.com/docs/facebook-login/access-tokens
20-Min Offline App
-->

Während der Bearbeitung meiner Semesterarbeit hatte ich mich bereits mit der Synchronisation von Daten zwischen Backend und Frontend beschäftigt, wobei aber der Fokus klar auf der Logik des Backends lag. Die erarbeitet Lösung setzte eine ständige Verbindung zwischen Client und Server voraus, was bei der praktischen Umsetzung zu erheblichen Einschränkungen für die Benutzer führte.

Mein starkes persönliches Interesse zur Analyse und Verbesserung dieser Prozesse treibt mich an, diese Arbeit durch zu führen.


<!-- Fragestellungen formulieren? - eventuell auch durch Aufgabenstellung erläutert - eventuell auch aufbröseln der Aufgabenstellung erwünscht? möglicherweise auch Titel "Motivation und Fragestellung" anpassen - Zuordnung zu den Punkten der Aufgabenstellung -->

## Aufgabenstellung

Die von der Studiengangsleitung für Informatik freigegebene Aufgabenstellung ist im Appendix unter "[Aufgabenstellung](#appendix_aufgabenstellung)" aufgeführt.

## Abgrenzung der Arbeit
Grosse Anbieter von Web-Software wie Google und Facebook arbeiten intensiv an spezifischen Lösungen für ihre Produkte. Zwar werden in Talks Techniken und Lösungsansätze erläutert (Facebook stellt Flux und Message-Driven Architecture vor[^fb-flux]), wissenschaftliche Arbeiten darüber, sind jedoch nicht publiziert.

[^fb-flux]:https://www.youtube.com/watch?v=KtmjkCuV-EU

Ich möchte in dieser Arbeit einen allgemeinen Ansatz erarbeiten und die Grenzen ausloten, um so zu zeigen, wo die Limitationen der Synchronisation liegen.


Die Arbeit eröffnet mit ihrer Fragestellung ein riesiges Gebiet und wirft neue Fragestellungen auf. Die ursprüngliche Fragestellung wird vertieft behandelt, ohne auf Neue in gleichem Masse einzugehen.
Die zu synchronisierenden "Real World" Fälle sind sehr unterschiedlich und nicht generalisierbar. Es sind zwei exemplarische Anwendungsfälle erarbeitet, auf welchen die Untersuchungen durchgeführt werden.

Zusätzlich wird die Arbeit durch folgende Punkte klar abgegrenzt:

- Die Informationsbeschaffung findet ausschliesslich in öffentlich zugänglichen Bereichen statt. (Internet/Bibliothek)
- Grundsätzliches Wissen zu Prozessen und Frameworks wird vorausgesetzt und nur an Schlüsselstellen näher erklärt.


## Sprache

## Richtlinien




# Aufbau der Arbeit

_Teil i - __Präambel__ - Einleitung und Abgrenzung_

_Teil ii - __Grundlagen__ - Technische Grundlagen und Architekturen_
Das Kapitel [Recherche] setzt sich mit den Grundlagen, Fachbegriffen und bekannten Verfahren zur Synchronisation und Replikation auseinander.
Im Kapitel [Analyse] werden die Grundlagen geschaffen um darauf Konzepte zu erstellen. Es wird eine Analyse der zu synchronisierenden Daten erstellt und überprüft ob eine sinnvolle Klassifikation durchführbar ist.

_Teil iii - __Konzept__ - Konzeption und Konzeptüberprüfung_
In diesem Teil der Thesis...
Ich überprüfe die erarbeiten Konzepte auch auf deren Wirksamkeit...

_Teil iv - __Implementation__ - Implementierung und Testing_
Dieser Teil beschäftigt sich mit der Entwicklung des Prototypen. Obwohl Testing und Implementation immer zusammen umgesetzt werden, ist in dieser Arbeit eine Aufteilung in die beiden Kapitel [Prototyp] und [Testing] gewählt, um dem Leser...

_Teil v - __Ausklang__ - Abschluss und Ausblick_
In diesem Teil wird evaluiert, ob die erarbeiten und implementierten Konzepte der Aufgabenstellung genügen...

