

# Analyse
Dieses Kapitel setzt sich mit der Klassifikation und Typisierung von Daten auseinander. 

## Datensynchronisations-Problem
Die Analyse der Problemstellung wird anhand der folgenden drei exemplarischen Aufgabenstellungen durchgeführt.

### Synchronisation von Kontakten
1. Szenario: Hinzufügen einer Neuen Tel-Nummer (Firmenkontakt oder Geschäftshandy etc.)
2. Szenario: Ändern der Primären Telefon-nummer
3. Szenario: Ändern des Namens/Adresse
4. Szenario: Zusatzinformationen anpassen/hinzufügen

### Syncrhonisation eines Service Desks
1. Szenario: Erfassen eines Support-Falls
2. Szenario: Followup (Antwort auf einen Supportfall) / Anpassen der Dringklichkeit/Priorität
3. Szenario: Zuweisen zu einem Techniker/Technikergruppe
4. Szenario: Erfassen einer Lösung/FAQ Eintrags

### Syncrhonisation von Stücklisten und Fertigungsaufträgen 
1. Szenario: Austauschen eines Bauteils -> Anpassung aller Stücklisten
2. Szenario: Anpassen der Fertigungsart (z.B. Menge des Lötzinns/Klebers)
3. Szenario: Priorisierung von Aufträgen (!!! nicht möglich - da Produktion läuft !!!)
4. Szenario: Lagerbestände/Lagerorte anpassen/ändern

## Datenanalyse
<!-- 
Typen von Daten:
- Numerische (int, float)
- Binäre (binary)
- Textuelle (char, string)
- Logische (boolean)

Beschaffenheit von Daten
- eigene Daten (eigener Post eines Blogs) (exclusive Daten)
- geteilte Daten (geteilter Post eines Blogs (mehrere Autoren)) (gemeinsame Daten)
- kontextuell abhängige Daten (Kommentar eines Posts) (Kontextbezogene Daten)
- logisch abhängige Daten (Alter eines Posts (seit Publizierung)) (Logisch abhängige Daten)
-->

Um eine klares Verständnis der Daten zu erhalten, wird analysiert, bezüglich welcher Eigenschaften, Daten unterschieden werden können. 

Daten können bezüglich ihrer Beschaffenheit, Geltungsbereich und Gültigkeitsdauer unterschieden werden. Dabei spricht man von der Klassifikation. 
Die Datentypisierung unterscheidet zwischen numerischen (num), binären (bin), logischen (bool) und textuellen (text) Daten.
Zu beachten gilt dass eine Attributsgruppe, also eine logische Aufteilung der Informationen in mehrere einzelne Attribute, eine zusammenhängende Informationseinheit ist.

<!-- 
Begriff der Klassifikation einführen
Begriff der Attribute und Attributgruppen, Bildung von Gruppen durch Dateningenieur

Klassifikation... aber nicht nötigerweise Datentyp (num, bin, text, logical)

Diskussion Auftreten von Daten
 -->

### Klassifikation
Zur Klassifikation werden nur die in den Daten enthaltenen Informationen herangezogen. Die Form der Daten, also der Datentyp selbst ist für die Klassifikation unerheblich.
Weiter kann die Klassifikation zwischen Struktur und Art der Daten unterscheiden.



#### Art
Die Art der Daten wird entweder explizit durch die Art der Implementation (temp, static, dynamic) oder implizit durch die Zugriffsstruktur (excl, publ) definiert. Es ist keine Kenntnis über die Daten nötig, eine Statische Analyse der Zugriffe auf die Daten reicht aus, um die Daten-Art zu bestimmen.
<!-- !!!!!!!!!!!!! Statische Analyse -->

##### Exklusive Daten
können nur von einem Benutzer bearbeitet, aber von diesem oder vielen Benutzern gelesen werden.

##### Gemeinsame Daten
können von vielen Benutzern gleichzeitig gelesen und bearbeitet werden.

##### Dynamische Daten
werden automatisch von System generiert. Benutzer greifen nur lesend darauf zu.

##### Statische Daten
bleiben über einen grossen Zeitraum hinweg unverändert. Viele Benutzer können diese Daten verändern und lesen.

##### Temporäre Daten
werden von System oder Benutzer generiert und sind nur sehr kurz gültig. Nur der Autor der Daten kann diese lesen.


#### Struktur
Bei der Unterscheidung der Daten nach ihrer Struktur, kann zwischen Kontextbezogenen und unabhängigen Daten differenziert werden. Die Entscheidung welcher Strukturklasse die Daten angehören ist abhängig vom Verständnis der Daten uns liegt somit im Entscheidungsbereich des Datendesigners. 

##### Kontextbezogene Daten
weisen nur bezüglich eines bestimmten Kontext einen signifikanten Informationsgehalt auf.

<!-- Ref. Beispiel -->

##### Unabhängige Daten 
sind selbst beinhaltend und gewinnen durch andere Daten selbst nicht mehr an Informationsgehalt.

<!-- Ref. Beispiel -->


## Diskussion Synchronisationsproblem
- Bearbeitung gemeinsamer Daten, wer gewinnt? (letzter Veränderer, erster Synchronisierer, Berechtigungshierarchie)
- Bearbeiten von eigenen Daten auf unterschiedlichen Geräten
- 

## Diskussion bekannter Verfahren
<!-- (und Erklährung) in Bezug auf Ergebnisse der Datenanalyse -->
