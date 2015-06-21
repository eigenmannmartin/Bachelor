
\part[Anhang]{Anhang}

\appendix


Glossar
================

__ORM__
ORM steht für object-relational mapping und ist eine Technik mit der Objekte einer Anwendung in einem relationalen Datenbanksystem abgelegt werden kann.
\
__Node__
Node oder Node.js ist eine Plattform welche es erlaubt JavaScript serverseitig auszuführen.
[https://nodejs.org/](https://nodejs.org/)
\
__RPC__
Remote Procedure Call ist eine Technologie um Funktionsbausteine in einem anderen Prozess aufzurufen.
\
__Jasmine__
Jasmine ist ein verhaltensbasiertes Testframework für JavaScript.
[http://jasmine.github.io](http://jasmine.github.io)
\
__Karma__
Karma ist ein Testrunner-Framework zur kontinuierlichen Ausführung von UnitTests.
[http://karma-runner.github.io](http://karma-runner.github.io)
\
__Mocks__
Mocks sind Code-Attrappen, die es ermöglichen, noch nicht vorhandene oder nicht verfügbare, Funktionalitäten und Objekte zu simulieren.
[http://de.wikipedia.org/wiki/Mock-Objekt](http://de.wikipedia.org/wiki/Mock-Objekt)
\
__Github__
Github ist ein Cloud basierter SourceCode Verwaltungsdienst für Git.
[https://github.com](https://github.com)


Aufgabenstellung {#appendix_aufgabenstellung}
=============================================

### Thema

Zeil der Arbeit ist es verschiedene Konfliktlösungsverfahren bei Multi-Master Datenbanksystemen zu untersuchen.

### Ausgangslage

Mobile Applikationen (Ressourcen-Planung, Ausleihlisten, etc.) gleichen lokale Daten mit dem Server ab. Manchmal werden von mehreren Applikationen, gleichzeitig, dieselben Datensätze mutiert. Dies kann zu Konflikten führen. Welche Techniken und Lösungswege können angewendet werden, damit Konflikte gelöst werden können oder gar nicht erst auftreten?

### Ziele der Arbeit

Das Ziel der Bachelorthesis besteht in der in der Konzeption und der Entwicklung eines lauffähigen Software-Prototypen, welcher mögliche Synchronisations- und Konfliktlösungsverfahren von Clientseitiger und Serverseitiger Datenbank demonstriert. Im Speziellen, soll gezeigt werden, welche Möglichkeiten der Synchronisation beim Einsatz von mobilen Datenbanken (Web-Anwendungen) bestehen, so dass die Clientseitige Datenbank auch ohne Verbindung zum Server mutiert und erst zu einem späteren Zeitpunkt synchronisiert werden kann, ohne dass Inkonsistenzen auftreten. Die Art und Funktionsweise des Software-Prototyp soll in einer geeigneten Form gewählt werden, so dass verschiedene Synchronisations- und Konfliktlösungsverfahren an ihm gezeigt werden können. Der Software-Prototyp soll nach denen, im Unterricht behandelten Vorgehensweisen des Test Driven Development (TDD) entwickelt werden.

### Aufgabenstellung

- _A1 Recherche:_
       - Definition der Fachbegriffe
       - Erarbeitung der technischen Grundlagen zur Synchronisation von Datenbanken und Datenspeichern

- _A2 Analyse:_
       - Analyse der Synchronisationsverfahren und deren Umgang mit Konflikten
       - Analyse der Synchronisationsverfahren im Bereich der Web-Anwendungen
       - Durchführen einer Anforderungsanalyse an die Software

- _A3 Konzept:_
       - Erstellen eines Konzepts der Synchronisation
       - Erstellen eines Konzepts der Implementierung zweier ausgewählten Synchronisations-Verfahren

- _A4 Prototyp:_
       - Konzeption des Prototypen der die gestellten Anforderungen erfüllt
       - Entwickeln des Software-Prototyps
       - Implementation zweier ausgewählter Synchronisations- und Konfliktlösungsverfahren

- _A5 Review:_
       - Test des Prototyps und Protokollierung der Ergebnisse


### Erwartete Resultate

- _R1 Recherche:_
       - Glossar mit Fachbegriffen
       - Erläuterung der bereits bekannten Synchronisation- und Konfliktlösungs-Verfahren, sowie deren mögliches Einsatzgebiet

- _R2 Analyse:_
       - Dokumentation der Verfahren und deren Umgang mit Synchronisation-Konflikten (Betrachtet werden nur MySQL, MongoDB)
       - Dokumentation der Verfahren zur Synchronisation im Bereich von Web-Anwendungen (Betrachtet werden nur die Frameworks Backbone.js und Meteor.js)
       - Anforderungsanalyse der Software

- _R3 Konzept:_
       - Dokumentation des Konzepts der Synchronisation
       - Dokumentation der Umsetzung der ausgewählten Synchronisations-Verfahren

- _R4 Prototyp:_
       - Dokumentation des Prototypen
       - Implementation des Prototypen gemäss Konzept und Anforderungsanalyse
       - Implementation zweier ausgewählter Synchronisations- und Konfliktlösungsverfahren

- _R5 Review:_
       - Protokoll der Tests des Software Prototypen




Detailanalyse der Aufgabenstellung
----------------------------------

Die Detailanalyse der Aufgabenstellung formuliert die zu erbringenden Aufgaben aus und unterteilt diese in Deliveries _D1_ bis _D8_.

#### Recherche
Es sollen die technischen Grundlagen zur Bearbeitung dieser Thesis zusammengetragen werden. Für das Verständnis wichtige Sachverhalte erläutert und Fachbegriffe erklärt werden.

Erwartet wird ein Glossar (_D1_), sowie eine Zusammenfassung (_D2_) der bekannten Synchronisations und Konfliktlösungsverfahren, sowie deren Einsatzgebiet.

#### Analyse
Eine genauere Betrachtung der ausgewählten Systeme (MySQL, MongoDB, Backbone.js und Meteor.js) zeigt auf, wo die aktuellen Systeme an ihre Grenzen stossen.
Weiter muss eine Anforderungsanalyse für eine Beispielapplikation durchgeführt werden.

Erwartet wird sowohl die Dokumentation der Synchronisationsverfahren (_D3_) als auch das Ergebnis der Anforderungsanalyse (_D4_).

#### Konzept
Die Erarbeitung und Überprüfung der Umsetzbarkeit neuer Synchronisationskonzepte wird in der Konzeptionsphase gefordert.

Erwartet wird eine Darstellung der erarbeiteten Konzepte (_D5_) und eine Konzeption zur Umsetzung (_D6_) derer gefordert.

#### Prototyp
Der Prototyp soll anhand eines Beispiels aufzeigen, wo die Stärken und Schwächen eines der Konzepte liegt.

Erwartet wird ein Prototyp der zwei Synchronisations- und Konfliktauflösungsverfahren (_D7_) implementiert.

#### Review
Das Review soll eine Retrospektive auf die erarbeiteten Resultate werfen und kritisch hinterfragen.

Erwartet wird ein Test des Prototyps sowie ein Protokoll der durchgeführten Tests (_D8_).

Projektmanagement
=================

Projektplanung
--------------

Der Projektplan ({@fig:projektplan}) illustriert die Strukturierung des Projekts über die gut 6 Monate lange Projektzeit.


![Projektplan](img/Projektplan.png) {#fig:projektplan}


### Aufwandschätzung

Die aus der Projektplanung hervorgehenden Arbeitsschritte müssen geschätzt werden, um eine realistische Terminplanung durchzuführen.

-------------------------------------------------------------------------------
__Arbeitsschritt__           Aufwand in Stunden
--------------------------- ---------------------------------------------------
Initialisierung             10
Recherche (_D2_,_D3_)       45
Analyse (_D2_,_D3_,_D4_)    20
Konzeption (_D5_,_D6_)      80
Prototyp (_D7_,_D8_)        60
Dokumentation (_D1_)        135
Abgabe                      20

__Total__                   __370__
-------------------------------------------------------------------------------


Rahmenbedingungen
-----------------
Der offizielle Projektstart ist der 18. März 2015. Das Projekt muss bis spätestens 11.08.2015 abgegeben werden.

Während der Kalenderwochen 14, 19, 20, 21, und 22 hat der Student Urlaub und kann deshalb während dieser Zeit intensiv der Bearbeitung der Thesis widmen.

-------------------------------------------------------------------------------
__Termin__                  __Datum__     __Bemerkungen__
--------------------------- ------------- -------------------------------------
Kick-Off                    18.03.2015    -

Design Review               20.05.2015    
                                          Der Entscheid über das Abgabedatum muss am 06.06.2015 gefällt werden.

Abgabe-Entscheid            06.06.2015    
                                          Die Thesis wird am 30.06.2015 abgegeben.

Abgabe Bachelorthesis       30.06.2015    -

Abschlusspräsentation       02.06.2015    -
-------------------------------------------------------------------------------

Soll/Ist Analyse
----------------

-------------------------------------------------------------------------------
__Arbeitsschritt__           __Soll__            __Ist__
--------------------------- -------------------- ------------------------------
Initialisierung             10                   5
Recherche                   45                   47
Analyse                     20                   41
Konzeption                  80                   78
Prototyp                    60                   65
Dokumentation               135                  157
Abgabe                      20                   5

__Total__                   __370__              __412__
-------------------------------------------------------------------------------
Der Mehraufwand von ~10% beruht vornehmlich darauf, dass das Sammeln und Verstehen von Informationen über bestehende Synchronisationsverfahren (Analyse) und das Verfassen der Arbeit selbst, sich als deutlich zeitintensiver als geplant herausgestellt hat.

Dokumentation
-------------

Da die Nachvollziehbarkeit von Änderungen in MS Word sehr umständlich ist, habe ich in Betracht gezogen, die Arbeit mit Latex zu schreiben.
Da ich jedoch dieses Format sehr unübersichtlich finde habe ich mich stattdessen für Markdown entschieden. Markdown kann mit dem Tool pandoc in ein PDF Dokument konvertiert werden. Darüber hinaus versteht pandoc auch die Latex-Syntax.


Versionsverwaltung
------------------

Damit einerseits die Daten gesichert und andererseits die Nachvollziehbarkeit von Änderungen gewährleistet ist, verwende ich git. Das Repository [^repo] ist für den Betreuer und Experten jederzeit einsehbar.

[^repo]:[https://github.com/eigenmannmartin/Bachelor](https://github.com/eigenmannmartin/Bachelor)


Anforderungsanalyse
===================


Vorgehensweise
--------------

Um eine möglichst allgemein gültige Anforderungsanalyse zu erhalten, werden nur die Anforderungen an den Synchronisationsprozess gestellt, welche für alle beide Fallbeispiele gültig sind.

Die Schlüsselwörter „muss“, „muss nicht“, „erforderlich“, „empfohlen“, „sollte“, „sollte nicht“, „kann“ und „optional“ in allen folgenden Abschnitten sind gemäss RFC 2119 zu interpretieren. [@rfc2119]



Use-Cases
---------
Im Nachfolgenden werden alle UseCases aufgelistet die im Rahmen dieser Thesis gefunden wurden.


#### UC-01 Lesen eines Elements

-------------------------------------------------------------------------------
__UseCase__
--------------------------- --------------------------------------------------
__Ziel__                    Ein existierendes Objekt wird gelesen.

__Beschreibung__            
                            Der Benutzer kann jedes Objekt anfordern. Das System liefert das angeforderte Objekt zurück.

__Akteure__                 Benutzer, System

__Vorbedingung__            
                            Der Benutzer ist im Online-Modus oder Offline-Modus.

__Ergebnis__                Der Benutzer hat das angeforderte Objekt gelesen.

__Hauptszenario__           Der Benutzer möchte eine Objekt lesen.

__Alternativszenario__      -
-------------------------------------------------------------------------------

#### UC-02 Einfügen eines neuen Elements 

-------------------------------------------------------------------------------
__UseCase__
--------------------------- --------------------------------------------------
__Ziel__                    Ein neues Objekt wird hinzugefügt. 

__Beschreibung__            
                            Der Benutzer kann neue Objekte hinzufügen. Das System liefert das hinzugefügte Objekt zurück.

__Akteure__                 Benutzer, System

__Vorbedingung__            
                            Der Benutzer ist im Online-Modus oder Offline-Modus.

__Ergebnis__                Der Benutzer hat ein neues Objekt erfasst.

__Hauptszenario__           Der Benutzer möchte eine Objekt hinzufügen.

__Alternativszenario__      -
-------------------------------------------------------------------------------

#### UC-03 Ändern eines Elements

-------------------------------------------------------------------------------
__UseCase__
--------------------------- --------------------------------------------------
__Ziel__                    Ein bestehendes Objekt wird mutiert. 

__Beschreibung__            
                            Der Benutzer kann bestehendes Objekte mutieren. Das System liefert das mutierte Objekt zurück.

__Akteure__                 Benutzer, System

__Vorbedingung__            
                            Der Benutzer ist im Online-Modus oder Offline-Modus.

__Ergebnis__                Der Benutzer hat ein bestehendes Objekt mutiert.

__Hauptszenario__           Der Benutzer möchte eine Objekt mutieren.

__Alternativszenario__      -
-------------------------------------------------------------------------------

#### UC-04 Löschen eines Elements

-------------------------------------------------------------------------------
__UseCase__
--------------------------- --------------------------------------------------
__Ziel__                    Ein bestehendes Objekt wird gelöscht. 

__Beschreibung__            
                            Der Benutzer kann bestehendes Objekte löschen.

__Akteure__                 Benutzer, System

__Vorbedingung__            
                            Der Benutzer ist im Online-Modus oder Offline-Modus.

__Ergebnis__                Der Benutzer hat ein bestehendes Objekt löschen.

__Hauptszenario__           Der Benutzer möchte eine Objekt löschen.

__Alternativszenario__      -
-------------------------------------------------------------------------------


Anforderungen
-------------

In diesem Kapitel sind alle funktionalen und nicht-funktionalen Anforderungen aufgeführt die aus den UseCases resultieren. Der entsprechende UseCase ist dabei jeweils referenziert.

<!-- FREQ01.01 Abfragen eines Elementverzeichnis -->
#### FREQ01.01 Abfragen eines Objektverzeichnis

-------------------------------------------------------------------------------
__Anforderung__
--------------------------- --------------------------------------------------
__UC-Referenz__             UC-01

__Beschreibung__            
                            Ein Verzeichnis aller Elemente kann abgefragt werden.
-------------------------------------------------------------------------------



<!-- FREQ01.02 Abfragen eines bekannten Elements vom Server -->
#### FREQ01.02 Abfragen eines bekannten Objekt vom Server

-------------------------------------------------------------------------------
__Anforderung__
--------------------------- --------------------------------------------------
__UC-Referenz__             UC-01

__Beschreibung__            
                            Ein einzelnes Objekt kann von Server abgerufen werden.
-------------------------------------------------------------------------------

<!-- FREQ02.01 Senden eines neuen Elements -->
#### FREQ02.01 Senden eines neuen Objekt

-------------------------------------------------------------------------------
__Anforderung__
--------------------------- --------------------------------------------------
__UC-Referenz__             UC-02

__Beschreibung__            
                            Ein einzelnes neues Element kann dem Server zur Anlage zugesendet werden.
-------------------------------------------------------------------------------
<!-- FREQ02.02 Abfragen eines neu hinzugefügten Elements -->
#### FREQ02.02 Abfragen eines neu hinzugefügten Objekt

-------------------------------------------------------------------------------
__Anforderung__
--------------------------- --------------------------------------------------
__UC-Referenz__             UC-02

__Beschreibung__            
                            Das neue angelegte Element wird dem Client automatisch zurückgesendet.
-------------------------------------------------------------------------------

<!-- FREQ03.01 Senden eines Element-Updates -->
#### FREQ03.01 Senden einer Objektmutation

-------------------------------------------------------------------------------
__Anforderung__
--------------------------- --------------------------------------------------
__UC-Referenz__             UC-03

__Beschreibung__            
                            Ein Attribut eines existierendes Objekt kann mutiert werden.
-------------------------------------------------------------------------------

<!-- FREQ04.01 Senden eines Löschauftrags -->
#### FREQ04.01 Löschen eines Objekts

-------------------------------------------------------------------------------
__Anforderung__
--------------------------- --------------------------------------------------
__UC-Referenz__             UC-04

__Beschreibung__            
                            Eine existierendes Objekt kann gelöscht werden.
-------------------------------------------------------------------------------

<!-- FREQ05.01 Lokale Kopie gelesener Elemente -->
#### FREQ04.02  Lokale Kopie gelesener Objekte

-------------------------------------------------------------------------------
__Anforderung__
--------------------------- --------------------------------------------------
__UC-Referenz__             UC-01

__Beschreibung__            
                            Ein bereits gelesenes Objekt, wird lokal auf dem Client gespeichert.
-------------------------------------------------------------------------------

<!-- FREQ06.01 Lokale Datenbankstruktur -->
<!-- FREQ06.02 Aufzeichnung der Einfügeoperationen -->
#### FREQ05.01 Aufzeichnen der Mutationen

-------------------------------------------------------------------------------
__Anforderung__
--------------------------- --------------------------------------------------
__UC-Referenz__             UC-01, UC-02, UC-03, UC-04

__Beschreibung__            
                            Mutationen werden aufgezeichnet.
-------------------------------------------------------------------------------
<!-- FREQ06.03 Synchronisation der aufgezeichneten Einfügeoperationen -->
#### FREQ05.02 Übermitteln der Mutationen

-------------------------------------------------------------------------------
__Anforderung__
--------------------------- --------------------------------------------------
__UC-Referenz__             UC-01, UC-02, UC-03, UC-04

__Beschreibung__            
                            Sobald eine Verbindung mit dem Server hergestellt ist, werden die aufgezeichneten Mutationen dem Server übermittelt.
-------------------------------------------------------------------------------

<!-- NFREQ01 Mutationen die nicht vom Server wegen fehlender Berechtigungen abgelehnt werden, gehen nicht verloren -->
<!-- NFREQ02 Mutationen können nach einer beliebigen Zeit mit dem Server synchronisiert werden -->
#### NFREQ01 Übermittlung der Mutationen

-------------------------------------------------------------------------------
__Anforderung__
--------------------------- --------------------------------------------------
__UC-Referenz__             UC-01, UC-02, UC-03, UC-04

__Beschreibung__            
                            Die Übermittlung der Mutationen zum Server darf eine beliebig lange Zeit in Anspruch nehmen.
-------------------------------------------------------------------------------

<!-- NFREQ03 Fehler werden aufgezeichnet -->
#### NFREQ02 Abgelehnte Mutationen

-------------------------------------------------------------------------------
__Anforderung__
--------------------------- --------------------------------------------------
__UC-Referenz__             UC-01, UC-02, UC-03, UC-04

__Beschreibung__            
                            Wenn eine Mutation vom Server abgelehnt wird, wird dem Client die aktuell gültige Version des entsprechenden Objekts übermittelt.
-------------------------------------------------------------------------------


Akzeptanzkriterien
------------------

In den nachfolgenden Tabellen findet sich eine Aufführung der Akzeptanzkriterien, basierend auf den bereits erarbeitete Anforderungen.

<!-- AC01 Initiale Synchronisation -->
#### AC01 Initiale Synchronisation

-------------------------------------------------------------------------------
__Akzeptanzkriterium__
--------------------------- --------------------------------------------------
__REQ-Referenz__            FREQ01.01, FREQ01.02, FREQ04.02

__Vorbedingung__            
                            Der Client hat eine Verbindung zum Server aufgebaut.

__Kriterium__               
                            Beim Starten des Clients wird der gesamte Datenbestand des Servers an den Client übermittelt.
-------------------------------------------------------------------------------

<!-- AC02 Einfügen/Ändern/Löschen Lokal -->
#### AC02 Lokale Mutationen

-------------------------------------------------------------------------------
__Akzeptanzkriterium__
--------------------------- --------------------------------------------------
__REQ-Referenz__            FREQ04.01, FREQ04.02

__Vorbedingung__            
                            Der Client hat bereits eine initiale Synchronisation durchgeführt.

__Kriterium__               
                            Jedes Element des lokalen Datenbestand des Clients kann gelesen, mutiert und gelöscht werden. Neue Elementen können dem Datenbestand hinzugefügt werden. 
-------------------------------------------------------------------------------


<!-- AC03 Einfügen/Ändern/Löschen Synchronisieren -->
#### AC03 Synchronisation

-------------------------------------------------------------------------------
__Akzeptanzkriterium__
--------------------------- --------------------------------------------------
__REQ-Referenz__            
                            FREQ02.01, FREQ02.02, FREQ03.01, FREQ05.01, FREQ05.02, NFREQ01, NFREQ02

__Vorbedingung__            
                            Der lokale Datenbestand des Clients wurde mutiert und noch nicht synchronisiert. Der Client hat eine Verbindung zum Server aufgebaut.

__Kriterium__               
                            Jede auf dem Client durchgeführte Mutation wurde aufgezeichnet und wird dem Server in der aufgezeichneten Reihenfolge übermittelt.
-------------------------------------------------------------------------------


<!-- AC04 Synchronisieren von beidseits geänderten Elementen -->
#### AC04 Konfliktbehandlung

-------------------------------------------------------------------------------
__Akzeptanzkriterium__
--------------------------- --------------------------------------------------
__REQ-Referenz__            NFREQ02

__Vorbedingung__            
                            Der Client hat eine Verbindung zum Server aufgebaut. Eine Synchronisation wurde durchgeführt.

__Kriterium__              
                            Das Ergebnis der Konfliktauflösung wird dem Client übermittelt.
-------------------------------------------------------------------------------





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


# Danksagungen
Zunächst möchte ich an all diejenigen meinen Dank richten, die mich während der Durchführung der Thesis unterstützt und motiviert haben. Auch ist allen, die während des Studiums mehr Geduld und Verständnis für mich aufbrachten ein ganz spezieller Dank geschuldet.

Ganz besonders möchte ich mich bei meinem Betreuer Philip Stanik bedanken, der immer vollstes Vertrauen in meine Fähigkeiten besass, mich durch kritisches Hinterfragen und Anregungen zum richtigen Zeitpunkt bestens unterstützt hat.

Auch meinem Arbeitgeber ist an diesem Punkt ein grosses Dankeschön für die gute und freundschaftliche Unterstützung geschuldet. Ohne die Flexibilität des Vorgesetzten und der Mitarbeiter wäre diese Arbeit nicht durchführbar gewesen.

Nicht zuletzt gebührt auch meinen Eltern Dank, ohne die ich das Studium nicht durchgestanden hätte.


# Personalienblatt

\begin{tabular}{ll}
Name, Vorname & Eigenmann, Martin \\
Adresse & Harfenbergstrasse 5 \\
Wohnort & 9000 St.Gallen \\
& \\
Geboren & 4. Juli 1990 \\
Heimatort & Waldkirch \\
\end{tabular}



# Bestätigung
Hiermit bestätigt der Unterzeichnende, dass die Bachelorarbeit mit dem Thema "Evaluation von Synchronisations- und Konfliktlösungsverfahren im Web-Umfeld" gemäss freigegebener Aufgabenstellung mit Freigabe vom 09.02.2015 ohne jede fremde Hilfe im Rahmen der gültigen Reglements selbständig ausgeführt wurde. 

Alle öffentlichen Quellen sind als solche kenntlich gemacht. Die vorliegende Arbeit ist in dieser oder anderer Form zuvor nicht zur Begutachtung vorgelegt worden.\
\
St.Gallen den 30.06.2015
\
\
Martin Eigenmann


\newpage