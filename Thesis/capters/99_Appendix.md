

\appendix


# Appendix {#appendixA}


## Glossar


## Aufgabenstellung {#appendix_aufgabenstellung}

### Thema

Zeil der Arbeit ist es verschiedene Konfliktlösungsverfahren bei Multi-Master Datenbanksystemen zu untersuchen.

### Ausgangslage

Mobile Applikationen (Ressourcen-Planung, Ausleihlisten, etc.) gleichen lokale Daten mit dem Server ab. Manchmal werden von mehreren Applikationen, gleichzeitig, dieselben Datensätze mutiert. Dies kann zu Konflikten führen. Welche Techniken und Lösungswege können angewendet werden, damit Konflikte gelöst werden können oder gar nicht erst auftreten?

### Ziele der Arbeit

Das Ziel der Bachelorthesis besteht in der in der Konzeption und der Entwicklung eines lauffähigen Software-Prototypen, welcher mögliche Synchronisations- und Konfliktlösungsverfahren von Clientseitiger und Serverseitiger Datenbank demonstriert. Im Speziellen, soll gezeigt werden, welche Möglichkeiten der Synchronisation beim Einsatz von mobilen Datenbanken (Web-Anwendungen) bestehen, so dass die Clientseitige Datenbank auch ohne Verbindung zum Server mutiert und erst zu einem späteren Zeitpunkt synchronisiert werden kann, ohne dass Inkonsistenzen auftreten. Die Art und Funktionsweise des Software-Prototyp soll in einer geeigneten Form gewählt werden, so dass verschiedene Synchronisations- und Konfliktlösungsverfahren an ihm gezeigt werden können. Der Software-Prototyp soll nach denen, im Unterricht behandelten Vorgehensweisen des Test Driven Development (TDD) entwickelt werden.

### Aufgabenstellung

**A1 Recherche:**

- Definition der Fachbegriffe
- Erarbeitung der technischen Grundlagen zur Synchronisation von Datenbanken und Datenspeichern

**A2 Analyse:**

- Analyse der Synchronisationsverfahren und deren Umgang mit Konflikten
- Analyse der Synchronisationsverfahren im Bereich der Web-Anwendungen
- Durchführen einer Anforderungsanalyse an die Software

**A3 Konzept:**

- Erstellen eines Konzepts der Software
- Erstellen eines Konzepts der Implementierung zweier ausgewählten Synchronisations-Verfahren

**A4 Prototyp:**

- Konzeption des Prototypen der die gestellten Anforderungen erfüllt
- Entwickeln des Software-Prototyps
- Implementation zweier ausgewählter Synchronisations- und Konfliktlösungsverfahren

**A5 Review:**

- Test des Prototyps und Protokollierung der Ergebnisse


### Erwartete Resultate

**R1 Recherche:**

- Glossar mit Fachbegriffen
- Erläuterung der bereits bekannten Synchronisation- und Konfliktlösungs-Verfahren, sowie deren mögliches Einsatzgebiet

**R2 Analyse:**

- Dokumentation der Verfahren und deren Umgang mit Synchronisation-Konflikten (Betrachtet werden nur MySQL, MongoDB)
- Dokumentation der Verfahren zur Synchronisation im Bereich von Web-Anwendungen (Betrachtet werden nur die Frameworks Backbone.js und Meteor.js)
- Anforderungsanalyse der Software

**R3 Konzept:**

- Dokumentation des Konzepts der Software
- Dokumentation der Umsetzung der ausgewählten Synchronisations-Verfahren

**R4 Prototyp:**

- Dokumentation des Prototypen
- Implementation des Prototypen gemäss Konzept und Anforderungsanalyse
- Implementation zweier ausgewählter Synchronisations- und Konfliktlösungsverfahren

**R5 Review:**

- Protokoll der Tests des Software Prototypen



# Verzeichnisse

## Quellenverzeichnis

\vspace*{-2.5cm}
\renewcommand{\bibname}{}\begingroup \let\clearpage\relax
\printbibliography
\endgroup

## Tabellenverzeichnis
\renewcommand{\listtablename}{} \begingroup \let\clearpage\relax
\listoftables
\endgroup

## Abbildungsverzeichnis
\renewcommand{\listfigurename}{} \begingroup\let\clearpage\relax
\listoffigures
\endgroup
