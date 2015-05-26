<!--

Beispiel:

Kontakte Synchronisieren
Single- und Multistate möglich
Implementation möglich

"Grosses" Problem - jeder kennt das



-->

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

Mein starkes persönliches Interesse zur Analyse und Verbesserung dieses Systems treibt mich an, diese Arbeit zu starten.


<!-- Fragestellungen formulieren? - eventuell auch durch Aufgabenstellung erläutert - eventuell auch aufbröseln der Aufgabenstellung erwünscht? möglicherweise auch Titel "Motivation und Fragestellung" anpassen - Zuordnung zu den Punkten der Aufgabenstellung -->

## Aufgabenstellung

Die von der Leitung des Studiengangs Informatik freigegebene Aufgabenstellung ist im Appendix unter "[Aufgabenstellung](#appendix_aufgabenstellung)" aufgeführt.

## Abgrenzung der Arbeit
Grosse Anbieter von Web-Software wie Google und Facebook arbeiten intensiv an der spezifischen Lösungen für ihre Produkte. Zwar werden in Talks Techniken und Lösungsansätze erläutert (Facebook stellt Flux und Message-Driven Architecture vor[^fb-flux]), wissenschaftliche Arbeiten darüber, sind jedoch nicht vorhanden.

Ich möchte in dieser Arbeit einen allgemeinen Ansatz erarbeiten und die Grenzen dessen ausloten, um so zu zeigen, wo die Grenzen der Synchronisation liegen.
<!-- Gibt es andere Arbeiten? Was macht Google/Facebook? Bis wohin gehe ich? -->

[^fb-flux]:https://www.youtube.com/watch?v=KtmjkCuV-EU


# Dokumentationsstruktur und Beitrag zum Forschungsgebiet
<!-- Anpassen des Titels -->

<!-- Zusammenfassung der Teile - Zuteilung zur Fragestellung. -->
_Teil i - Einleitung und Abgrenzung_

_Teil ii - Technische Grundlagen und Architekturen_

Erarbeitung bekannter Verfahren, etc.

_Konzeption - Konzept_

Analyse der Daten
Erarbeitung des Konzepts

_Implementation - Implementierung und Testing_

Erstellen des Prototypen etc.

_Teil iv - Abschluss und Ausblick_

