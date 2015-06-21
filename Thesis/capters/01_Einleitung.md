

\pagestyle{scrheadings}

\part[Präambel]{Einleitung und Abgrenzung}



Einleitung
==========

Motivation und Fragestellung
----------------------------

Der Zugriff auf Services und Medien mittels mobiler Geräte steigt beständig an. So ist im Mai 2014, 60% der Zeit, die online verbracht wird, über Handy und Tablet zugegriffen worden - davon 51% mittels mobiler Applikationen. [@comescore-mobiletrends]

![Verteilung der online verbrachten Zeit nach Platform (Grafik erstellt gemäss der Daten aus [@comescore-mobiletrends])](img/Share-of-US-Digital-Media-Time-Spent-by-Platform.pdf)

Angesichts der grossen Verbreitung und Nutzung von Services und Medien im Internet, wird eine unterbrechungsfreie Benutzbarkeit, auch ohne Internetverbindung, immer selbstverständlicher und somit auch immer wichtiger.

>"It's clear that the mobile industry has finally given up on the fantasy that an Internet connection is available to all users at all times. Reality has set in. And in the past month, we've seen a new wave of products and services that help us go offline and still function." @cw-mobiletrends

<!-- mehr Begründung - Netzabdekung -->

Es stellt sich nun die Frage, wie Informationen, über Verbindungsunterbrüche hinweg, integer gehalten werden können. Und wie Daten im mobilen Umfeld synchronisiert, aktualisiert und verwaltet werden können, so dass, für den Endbenutzer schlussendlich kein Unterschied zwischen Online- und Offline-Betrieb mehr wahrnehmbar ist.

Während der Bearbeitung meiner Semesterarbeit, hatte ich mich bereits mit der Synchronisation von Daten zwischen Backend und Frontend beschäftigt, wobei aber der Fokus klar auf der Logik des Backends lag. Die erarbeitete Lösung setzte eine ständige Verbindung zwischen Client und Server voraus, was bei der praktischen Umsetzung zu erheblichen Einschränkungen für die Benutzer führte.

Mein starkes persönliches Interesse zur Analyse und Verbesserung dieser Prozesse treibt mich an, diese Arbeit durchzuführen.


<!-- Fragestellungen formulieren? - eventuell auch durch Aufgabenstellung erläutert - eventuell auch aufbröseln der Aufgabenstellung erwünscht? möglicherweise auch Titel "Motivation und Fragestellung" anpassen - Zuordnung zu den Punkten der Aufgabenstellung -->


Aufgabenstellung
----------------

Die von der Studiengangsleitung für Informatik freigegebene Aufgabenstellung sowie eine Detailanalyse derer ist im Appendix unter "[Aufgabenstellung](#appendix_aufgabenstellung)" aufgeführt.


Abgrenzung der Arbeit
---------------------

Grosse Anbieter von Web-Software wie Google und Facebook arbeiten intensiv an spezifischen Lösungen für ihre Produkte. Zwar werden in Vorträgen, Techniken und Lösungsansätze erläutert (Facebook stellt Flux und Message-Driven Architecture vor[^fb-flux]), wissenschaftliche Arbeiten darüber, sind jedoch nicht publiziert.

[^fb-flux]:[https://www.youtube.com/watch?v=KtmjkCuV-EU](https://www.youtube.com/watch?v=KtmjkCuV-EU)

Ich möchte in dieser Arbeit einen allgemeinen Ansatz erarbeiten und die Grenzen ausloten, um so zu zeigen, wo die Limitationen der Synchronisation liegen.


Die Arbeit eröffnet mit ihrer Fragestellung ein riesiges Gebiet und wirft neue Fragestellungen auf. Die ursprüngliche Fragestellung wird vertieft behandelt, ohne auf Neue in gleichem Masse einzugehen.
Die zu synchronisierenden "Real World" Fälle sind sehr unterschiedlich und nicht generalisierbar. Es werden zwei exemplarische Anwendungsfälle erarbeitet, auf welchen die Untersuchungen durchgeführt werden.

Zusätzlich wird die Arbeit durch folgende Punkte klar abgegrenzt:

- Die Informationsbeschaffung findet ausschliesslich in öffentlich zugänglichen Bereichen statt. (Internet/Bibliothek)
- Grundsätzliches Wissen zu Prozessen und Frameworks wird vorausgesetzt und nur an Schlüsselstellen näher erklärt.



Aufbau der Arbeit
=================

#### _Teil i - Präambel_
Im ersten Kapitel [Einleitung] werden die Daten-Synchronisations-Probleme mit mobilen Endgeräten angedeutet und die daraus resultierende Motivation für diese Arbeit dargelegt. Weiter wird die Abgrenzung dieser Arbeit erörtert.
Schliesslich wird im Kapitel [Aufbau der Arbeit] die Struktur sowie die Eigenleistungen betont.

#### _Teil ii - Grundlagen_
Das Kapitel [Recherche] setzt sich mit den Grundlagen, Fachbegriffen und bekannten Verfahren zur Synchronisation und Replikation auseinander. Bekannte Verfahren zur verteilten Ausführung von Programmen, synchronen und asynchronen Replikation von Datenbanken sowie Synchronisationsverfahren werden umrissen.


#### _Teil iii - Konzept_
In diesem Teil der Thesis werden die Grundlagen geschaffen um darauf basierend Konzepte zu erstellen. Zwei Fallbeispiele für die Synchronisation von Daten werden eingeführt. Es wird darauf basierend eine [Analyse] der zu synchronisierenden Daten erstellt und überprüft ob eine sinnvolle Klassifikation der Daten durchführbar ist um so das Synchronisationsproblem abzuschwächen. 
Basierend auf der Analyse der Daten, werden [Konzeptansätze] erarbeitet und anschliessend auf ihre Anwendbarkeit hin überprüft. Die sich daraus ergebenen Erkenntnisse werden im [Leitfaden] übersichtlich dargestellt. Die Ansätze des Leitfadens berücksichtigend wird der Aufbau des Prototypen ([Design des Prototypen]) konzipiert.   

#### _Teil iv - Implementation_
Dieser Teil beschäftigt sich mit der Implementierung des Prototypen unter Verwendung der TDD Methode. Ein spezielles Augenmerk wird dem Testing und der verwendeten Frameworks gewidmet.

#### _Teil v - Ausklang_
In diesem Teil der Thesis wird evaluiert, ob die erarbeiten und implementierten Konzepte der Aufgabenstellung genügen, welche Limitationen sie aufweisen und welche Fragestellungen offen geblieben sind.

