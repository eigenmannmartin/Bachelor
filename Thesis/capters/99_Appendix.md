

\appendix


Anhang {#appendixA}
===================

Glossar
-------
ORM
Node
RPC

jasmine
karma



Aufgabenstellung {#appendix_aufgabenstellung}
---------------------------------------------

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

- Erstellen eines Konzepts der Synchronisation
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

- Dokumentation des Konzepts der Synchronisation
- Dokumentation der Umsetzung der ausgewählten Synchronisations-Verfahren

**R4 Prototyp:**

- Dokumentation des Prototypen
- Implementation des Prototypen gemäss Konzept und Anforderungsanalyse
- Implementation zweier ausgewählter Synchronisations- und Konfliktlösungsverfahren

**R5 Review:**

- Protokoll der Tests des Software Prototypen




Detailanalyse der Aufgabenstellung
----------------------------------

Die Detailanalyse der Aufgabenstellung...

### Aufgabenstellung und erwartete Resultate
**Recherche:**
Es sollen die technischen Grundlagen zur Bearbeitung dieser Thesis zusammengetragen werden. Für das Verständnis wichtige Sachverhalte erläutert und Fachbegriffe erklärt werden.

Erwartet wird ein Glossar, sowie eine Zusammenfassung der bekannten Synchronisations und Konfliktlösungsverfahren, sowie deren Einsatzgebiet.

**Analyse:**
Eine genauere Betrachtung der ausgewählten Systeme (MySQL, MongoDB, Backbone.js und Meteor.js) zeigt auf, wo die aktuelle Systeme an ihre Grenzen stossen.
Weiter muss eine Anforderungsanalyse für eine Beispielapplikation durchgeführt werden.

Erwartet wird Sowohl die Dokumentation der Synchronisationsverfahren als auch das Ergebnis der Anforderungsanalyse.

**Konzept:**
Die Erarbeitung und Überprüfung der Umsetzbarkeit neuer Synchronisationskonzepte wird in der Konzeptionsphase gefordert.

Sowohl eine Darstellung der erarbeitete Konzepte, als auch eine Umsetzungsplanung derer ist gefordert.

**Prototyp:**
Der Prototyp soll anhand eines Beispiels aufzeigen, wo die Stärken und Schwächen eines der Konzepte liegt.

Erwartet wird ein Prototyp der zwei Synchronisations- und Konfliktauflösungsverfahren implementiert.

**Review:**
Das Review soll eine Retrospektive auf die Erarbeiteten Resultate werfen und kritisch hinterfragen.

Erwartet wird ein Protokoll der durchgeführten Tests.


### Aufwandschätzung

Die aus der Projektplanung hervorgehenden Arbeitsschritte müssen geschätzt werden, um eine realistische Terminplanung durchzuführen.

-------------------------------------------------------------------------------
__Arbeitsschritt__           Aufwand in Stunden
--------------------------- ---------------------------------------------------
Initialisierung             10
Recherche                   45
Analyse                     20
Konzeption                  80
Prototyp                    60
Dokumentation               135
Abgabe                      20

__Total__                   __370__
-------------------------------------------------------------------------------

Projektmanagement
=================

Projektplanung
--------------


Der vollständige Projektplan ist in der Grafik {@fig:projektplan} dargestellt.

![Projektplan](img/Projektplan.png) {#fig:projektplan}

<!-- zu erwähnen
-beschlüsse auf Kock-Off und Designreview
-Ferien etc.
 -->

Termine
-------

-------------------------------------------------------------------------------
__Termin__                  __Datum__      __Bemerkungen__
--------------------------- ------------- -------------------------------------
Kick-Off                    18.03.2015    

Design Review               20.05.2015

Abgabe-Entscheid            06.06.2015

Abgabe Bachelorthesis       ???

Abschlusspräsentation       ??
-------------------------------------------------------------------------------


Dokumentation
-------------

Da die Nachvollziehbarkeit von Änderungen in MS Word sehr umständlich ist, habe ich in Betracht gezogen, die Arbeit mit \LaTeX zu schreiben.
Da ich jedoch dieses Format sehr unübersichtlich finde habe ich mich stattdessen für Markdown entschieden. Markdown kann mit dem Tool pandoc in ein PDF Dokument konvertiert werden. Darüber hinaus versteht pandoc die Latex-Syntax.


Versionsverwaltung
------------------

Damit einerseits die Daten gesichert und andererseits die Nachvollziehbarkeit von Änderungen gewährleistet ist, verwende ich git.



# Anforderungsanalyse

<!-- Definition Offline und Online Modus -->
## Vorgehensweise
Um eine möglichst allgemein gültige Anforderungsanalyse zu erhalten, werden nur die Anforderungen an den Synchronisationsprozess gestellt, welche für alle beide Fallbeispiele gültig sind.

### Use-Cases
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


### Anforderungen
In diesem Kapitel sind alle funktionalen und nicht-funktionalen Anforderungen die aus den UseCases resultieren ausgeführt.

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

#### FREQ03.02 Senden einer Objektmutation

-------------------------------------------------------------------------------
__Anforderung__
--------------------------- --------------------------------------------------
__UC-Referenz__             UC-03

__Beschreibung__            
                            Ein mehrere Attribute eines existierendes Objekt kann mutiert werden.
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
#### FREQ04.01  Lokale Kopie gelesener Objekte

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


### Akzeptanzkriterien
<!-- AC01 Initiale Synchronisation -->
<!-- AC02 Einfügen/Ändern/Löschen Lokal -->
<!-- AC03 Einfügen/Ändern/Löschen Synchronisieren -->
<!-- AC04 Synchronisieren von beidseits geänderten Elementen -->
<!-- AC05  -->
<!-- AC06  -->
<!-- AC07  -->
<!-- AC08  -->

### Bewertung der Anforderungen
<!-- Zuordnung AC->(REQ,UC,Aufgabenstellung) -->

## Risiken














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
Heimatord & Waldkirch \\
\end{tabular}



# Bestätigung
Hiermit versichere ich, die vorliegende Bachelorthesis eigenständig und ausschliesslich unter Verwendung der angegebenen Hilfsmittel angefertigt zu haben.
Alle öffentlichen Quellen sind als solche kenntlich gemacht. Die vorliegende Arbeit ist in dieser oder anderer Form zuvor nicht als Semesterarbeit zur Begutachtung vorgelegt worden.

St.Gallen 1.05.2015

Martin Eigenmann


\newpage