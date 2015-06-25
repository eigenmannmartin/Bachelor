---
title:  Evaluation von Synchronisations- und Konfliktlösungsverfahren im Web-Umfeld 
author: Martin Eigenmann
date: 1.3.2015
...

<!-- Nutzwertanalyse? -->
\pagenumbering{roman}


\chapter*{Zusammenfassung}
<!-- Ziel -->
Das Abgleichen von Daten zwischen Server- und Client-Applikation (Synchronisation) stellt eine spezielle Herausforderung, gerade dann dar, wenn mehre Clients gleichzeitig Daten mutieren. Durch das gleichzeitige Mutieren von Daten kann es so zu Inkonsistenzen kommen. Speziell mobile Applikationen für Smartphones oder Tablets dürfen nicht von einem ständigen Kommunikationskanal mit dem Server ausgehen uns müssen deshalb mit potentiellen Konflikten umgehen können. Diese Arbeit handelt von der Analyse und Erstellung von Konzepten und Lösungsansätzen zur Abschwächung des schweren Dantensynchronisationsproblems im Web-Umfeld. 

<!-- Grundlagen -->
Bekannte Synchronisationsverfahren verlangen entweder eine andauernde Verbindung zwischen dem Server und allen Clients, schränken den Funktionsumfang (Client kann nur lesend auf die Daten zugreifen) ein, oder garantieren keine zeitliche Aktualität der Daten auf den Clients. 

<!-- Vorgehensweise -->
Anhand einer umfassenden Analyse der Beschaffenheit und Struktur der Daten unter Zuhilfenahme von Fallbeispielen, welche den allgemeinen Anwendungsfall repräsentativ wiedergeben, werden Konzepte zur Synchronisation, Datenhaltung, Konfliktvermeidung und Konfliktauflösung erarbeitet, bewertet und überprüft. Basierend auf den erarbeiteten Lösungsansätze ist eine Überprüfung der Umsetzbarkeit jedes einzelnen Konzepts durchgeführt, um so allfällige Schwächen und bis dahin unentdeckte Probleme festzustellen.
Aufgrund der gewonnenen Erkenntnissen wird ein Leitfaden zur Abschwächung des Synchronisationsproblem erarbeitet, welcher die wichtigsten zu beachtenden Punkte wieder gibt.
Eine Anforderungsanalyse an das Fallbeispiel "Synchronisation einer Kontaktdatenbank" mit Use Cases und funktionalen sowie nicht funktionalen Anforderungen setzen die funktionsbezogenen Leitplanken für den Prototypen.
Unter Betrachtung der Vor- und Nachteile jedes einzelnen Konzepts und unter Berücksichtigung des Leitfadens, wird für die Entwicklung des Prototyps die geeignetsten Konzepte ausgewählt. 

Über die gesamte Arbeit hinweg stehen dabei Techniken zur Erstellung guter Software, wie Test Driven Development, im Mittelpunkt.


<!-- Ergebnisse -->








\setcounter{tocdepth}{1}

\chapter*{Inhaltsverzeichnis}


\renewcommand{\contentsname}{} \begingroup\let\clearpage\relax

\tableofcontents

\endgroup


\microtypesetup{protrusion=true}

\newpage

\pagenumbering{arabic}

