---
title: Design Review
author: Martin Eigenmann
date: 20.Mai 2015
stylesheet: "./reveal.js/css/theme/moon.css"
---


<style type="text/css">
    strong {
        background: #FF5E99 none repeat scroll 0% 0%;
        color: white;
    }

    img {
        background-color: white !important;
    }

    .ok {
        color: green;
    }
    .nc {
        color: purple; 
    }
    .pending {
        color: yellow;
    }
    .fail {
        color: red;
    }
</style>

<!--
-Stand, wesentliche Aspekte
-Diskussion des gewählten Konzepts
-Offene Punkte
-Anpassung Aufgabenstellung
-Restplanung
-->

#

## Aufgabenstellung
_Mobile Applikationen (Ressourcen-Planung, Ausleihlisten, etc.) gleichen lokale Daten mit dem Server ab. Manchmal werden von mehreren Applikationen, gleichzeitig, dieselben Datensätze mutiert. Dies kann zu Konflikten führen. Welche **Techniken und Lösungswege** können angewendet werden, **damit Konflikte** gelöst werden können oder gar **nicht** erst **auftreten**?_

<aside class="notes">
</aside>

## server not found!
![](img/noinet.gif)

<aside class="notes">
Gewöhnung an den Zustand des "immer online seins" - was passiert wenn mal kein Empfang?
</aside>


# Konzepte

## 

![](img/singlestate.jpg)

##

![](img/multistate.jpg)

# Sync Verfahren

## Konfliktvermeidung
- Update Transformation
- Wiederholbare Transaktion

## Konfliktauflösung
- Zusammenführung
- normalisierte Zusammenführung
- gewichtete Zusammenführung

#

## Stand 1
- Recherche [<span class="ok">ok</span>]
- Diskussion & Analyse [<span class="ok">ok</span>]
- Lösungsansätze suchen [<span class="ok">ok</span>]
- Prototyp Implementieren [<span class="nc">nc</span>]
- Dokumentation [<span class="nc">nc</span>]

## Architektur
- nur Clients
- Server - dumme Clients
- Clients - Server <span class="ok"><--</span>

## Architektur 

![](img/flux-diagram.png)

## Stack
- fluxifyJS
- reactJS
- nodeJS
- RequireJS
- express
- socket.io
- sequelize
- karma
- CoffeeScript

## TDD

![](img/tdd.png)

## TDD

![](img/coverage.png)


## persönliche Ziele
- Ist-Zustand verstehen [<span class="ok">ok</span>]
- Verbesserungsmöglichkeiten aufzeigen [<span class="pending">pending</span>]

## Planung

![](img/Projektplan.png)

## Nächste Schritte
- Dokumentation vervollständigen
- Prototyp Präsentations-fertig


## Termine
- Endscheid über Abschluss: 6. Juni
- Abschluss: Ende Juni oder Mitte August

## Es gibt noch Luft

![](img/ok.gif)

# 

##Aufgabenstellung 1/2
- A/R1
    + Glossar [<span class="pending">pending</span>]
    + Bestehendes [<span class="ok">ok</span>]
- A/R2: 
    + Sync MySQL,MonboDB [<span class="ok">ok</span>]
    + BackboneJS, MeteorJS [<span class="ok">ok</span>]
    + Anforderungsanalyse [<span class="nc">nc</span>]
- A/R3
    + Erstellen Konzept Software [<span class="fail">nok</span>]
    + Erstellen Konzept Sync [<span class="fail">nok</span>]

##Aufgabenstellung 2/2
- A/R4
    + Konzeption Prototyp [<span class="ok">ok</span>]
    + Entwickeln Prototyp [<span class="ok">ok</span>]
- A/R5
    + Test des Prototypen [<span class="fail">nok</span>]

##Anpassungen
- Ziel der Arbeit: "Konzeption und __beispielhafte Implementierung__ eines __!__ Software-Prototypen, welcher ... "

- Aufgabenstellung A3:
    + Erstellen des Konzepts zur __Synchronisation__
- Erwartete Resultate R3:
    + Dokumentation des Konzepts zur __Synchronisation__


## Offene Punkte
- Experte?

## Fragen

