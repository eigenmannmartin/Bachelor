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

## Single State

![](img/singlestate.jpg)

## Multi State

![](img/multistate.jpg)

# Sync Verfahren

## Konfliktvermeidung
- Update Transformation
- Wiederholbare Transaktion

## Konfliktauflösung
- Zusammenführung
- normalisierte Zusammenführung
- gewichtete Zusammenführung

## Stand
- Recherche [<span class="ok">ok</span>]
- Diskussion & Analyse [<span class="ok">ok</span>]
- Lösungsansätze suchen [<span class="ok">ok</span>]
- Prototyp Implementieren [<span class="pending">pending</span>]
- Dokumentation [<span class="pending">pending</span>]

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

# 

##Aufgabenstellung
- A/R1
    + Glossar [<span class="pending">pending</span>]
    + Bestehendes [<span class="nc">nc</span>]
- A/R2: 
    + Sync MySQL,MonboDB [<span class="nc">nc</span>]
    + BackboneJS, MeteorJS [<span class="nc">nc</span>]
    + Anforderungsanalyse [<span class="nc">nc</span>]
- A/R3
    + Erstellen Konzept Software [<span class="fail">nok</span>]
    + Erstellen Konzept Sync [<span class="fail">nok</span>]
- A/R4
    + Konzeption Prototyp [<span class="ok">ok</span>]
    + Entwickeln Prototyp [<span class="ok">ok</span>]
- A/R5
    + Test des Prototypen [<span class="fail">nok</span>]

##Anpassungen
- Ziel der Arbeit: "Konzeption und __beispielhafte Implementierung__ eines __!__ Software-Prototypen, welcher ... "

- Aufgabenstellung A3:
    + Erstellen des Konzepts zur __Synchronisation__
- Erwartete Resultate R3_
    + Dokumentation des Konzepts zur __Synchronisation__



## Fragen