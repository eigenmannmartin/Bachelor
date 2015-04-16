

# Analyse

## Datenanalyse
<!-- 
Typen von Daten:
- Numerische (int, float)
- Binäre (binary)
- Textuelle (char, string)
- Logische (boolean)

Beschaffenheit von Daten
- eigene Daten (eigener Post eines Blogs)
- geteilte Daten (geteilter Post eines Blogs (mehrere Autoren))
- kontextuell abhängige Daten (Kommentar eines Posts)
- logisch abhängige Daten (Alter eines Posts (seit Publizierung))
-->

## Diskussion bekannter Verfahren
<!-- (und Erklährung) in Bezug auf Ergebnisse der Datenanalyse -->


## Anforderungsanalyse

## Vorgehensweise

### Use-Cases
<!-- UC1: Lesen eines Elements (online) -->
<!-- UC2: Einfügen eines neuen Elements (online) -->
<!-- UC3: Ändern eines Elements (online) -->
<!-- UC4: Löschen eines Elements (online) -->
<!-- UC5: Lesen eines Elements (offline) -->
<!-- UC6: Einfügen eines neuen Elements (offline) -->
<!-- UC7: Ändern eines Elements (offline) -->
<!-- UC8: Löschen eines Elements (offline) -->


### Anforderungen
<!-- FREQ01.01 Abfragen eines Elementverzeichnis -->
<!-- FREQ01.02 Abfragen eines bekannten Elements vom Server -->

<!-- FREQ02.01 Senden eines neuen Elements -->
<!-- FREQ02.02 Abfragen eines neu hinzugefügten Elements -->

<!-- FREQ03.01 Senden eines Element-Updates -->

<!-- FREQ04.01 Senden eines Löschauftrags -->

<!-- FREQ05.01 Lokale Kopie gelesener Elemente -->

<!-- FREQ06.01 Lokale Datenbankstruktur -->
<!-- FREQ06.02 Aufzeichnung der Einfügeoperationen -->
<!-- FREQ06.03 Synchronisation der aufgezeichneten Einfügeoperationen -->

<!-- FREQ07.01 Aufzeichnung der Mutationen von Elementen -->
<!-- FREQ07.02 Synchronisation der aufgezeichneten Mutationen -->

<!-- FREQ08.01 Aufzeichnen der Löschaufträge -->
<!-- FREQ08.02 Synchronisation der aufgezeichneten Löschaufträge -->


<!-- NFREQ01 Mutationen die nicht vom Server wegen fehlender Berechtigungen abgelehnt werden, gehen nicht verloren -->
<!-- NFREQ02 Mutationen können nach einer beliebigen Zeit mit dem Server synchronisiert werden -->

<!-- NFREQ03 Fehler werden aufgezeichnet -->


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