

# Analyse
Dieses Kapitel setzt sich mit der Klassifikation und Typisierung von Daten auseinander. 

## Synchronisationsproblem
Die Analyse der Problemstellung wird anhand der folgenden drei exemplarischen Aufgabenstellungen durchgeführt.

### Synchronisation von Kontakten
In vielen Anwendungsszenarien müssen Kontaktdaten abgeglichen werden. Dieses Beispiel beleuchtet die Synchronisation einer fiktiven Firmen-Kontaktdatenbank mit mobilen Clients der Mitarbeiter.

Ein Kontakt selbst umfasst die in der Tabelle "Daten-Attribute Firmen-Kontakt" beschriebenen Attribute.

-------------------------------------------------------------------------------
__Attribut__                __Beschreibung__
--------------------------- --------------------------------------------------
__Name__                    Der gesamte Name (Vor-, Nach,- und Mittelname)
                            der (Kontakt-)Person.

__Firma__                   Der eingetragene Firmenname oder falls 
                            Privatperson lehr.

__Adresse__                 Die vollständige Postadresse der Firma oder Person.

__Email__                   Alle aktiven und inaktiven Email-Adressen des
                            Kontakts. Jeweils nur eine Email ist die primäre
                            Email-Adresse.

__Telefon__                 Alle aktiven und inaktiven Telefonnummern des
                            Kontakts. Jeweils nur eine Telefonnummer ist die primäre Nummer.

__VIP-Stufe__               Wichtigkeit-Stufe des Kontakts.

__pNotes__                  Persönliche Bemerkungen zum Kontakt. Nur der Autor 
                            einer Notiz, kann diese bearbeiten.

__Aktiver Auftrag__         Aktive und mit dem Kontakt verknüpfte Aufträge.

__Erfassungsdatum__         Datum der ersten Erfassung des Kontakts.

__Änderungsdatum__          Datum der letzten Änderung des Kontakts.
-------------------------------------------------------------------------------
Table: Attribute Daten-Attribute Firmen-Kontakt 


Im Folgenden sind vier typische Szenarien beschrieben.

__1. Szenario__
Erfassen einer neuen Telefonnummer zu einem bestehenden Kontakt.

__2. Szenario__
Ändern der primären Telefonnummer eines bestehenden Kontakts.

__3. Szenario__
Ändern des Namens einer Kontaktperson eines bestehenden Kontakts.

__4. Szenario__
Hinzufügen/Ändern der (persönlichen) Zusatzinformationen eines bestehenden Kontakts.


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
Die Datentypisierung hingegen, unterscheidet nach dem äusseren Erscheinungsbild der Daten.
Zu beachten gilt dass eine Attributsgruppe, also eine logische Aufteilung der Informationen in mehrere einzelne Attribute, eine zusammenhängende Informationseinheit ist.

<!-- 
Begriff der Klassifikation einführen
Begriff der Attribute und Attributgruppen, Bildung von Gruppen durch Dateningenieur

Klassifikation... aber nicht nötigerweise Datentyp (num, bin, text, logical)

Diskussion Auftreten von Daten
 -->

Zur Klassifikation werden nur die in den Daten enthaltenen Informationen herangezogen. Die Form der Daten, also der Datentyp selbst ist für die Klassifikation unerheblich.
Weiter kann die Klassifikation zwischen Struktur und Art der Daten unterscheiden.

### Klassifikation nach Art
Die Art der Daten wird entweder explizit durch die Art der Implementation (temp, static, dynamic) oder implizit durch die Zugriffsstruktur (excl, publ) definiert. Es ist keine Kenntnis über die Daten nötig, eine Statische Analyse der Zugriffe auf die Daten reicht aus, um die Daten-Art zu bestimmen.
<!-- !!!!!!!!!!!!! Statische Analyse -->

__Exklusive Daten__ können nur von einem Benutzer bearbeitet, aber von diesem oder vielen Benutzern gelesen werden.

__Gemeinsame Daten__ können von vielen Benutzern gleichzeitig gelesen und bearbeitet werden.

__Dynamische Daten__ werden automatisch von System generiert. Benutzer greifen nur lesend darauf zu.

__Statische Daten__ bleiben über einen grossen Zeitraum hinweg unverändert. Viele Benutzer können diese Daten verändern und lesen.

__Temporäre Daten__ werden von System oder Benutzer generiert und sind nur sehr kurz gültig. Nur der Autor der Daten kann diese lesen.


### Klassifikation nach Struktur
Bei der Unterscheidung der Daten nach ihrer Struktur, kann zwischen Kontextbezogenen und unabhängigen Daten differenziert werden. Die Entscheidung welcher Strukturklasse die Daten angehören ist abhängig vom Verständnis der Daten uns liegt somit im Entscheidungsbereich des Datendesigners. 

__Kontextbezogene Daten__ weisen nur bezüglich eines bestimmten Kontext einen signifikanten Informationsgehalt auf.

__Unabhängige Daten__ sind selbst beinhaltend und gewinnen durch andere Daten selbst nicht mehr an Informationsgehalt.

### Datentypisierung
Die Unterscheidung der Daten nach Datentyp differenziert zwischen __numerischen__, __binären__, __logischen__ und __textuellen__ Daten. Zur Typisierung wird immer die für den Benutzer sichtbare Darstellung verwendet, also jene Darstellung, in welcher die Daten erfasst wurden.


## Datenanalyse der Synchronisationsprobleme
Nachfolgend sind die Attribute eines Kontakts aus dem ersten Beispiel "Synchronisation von Kontakten" entsprechend der erarbeiteten Klassifikation und Typisierung zugeteilt.

__Synchronisation von Kontakten__
- Name:         Unabhängig,         gemeinsam,      textuell
- Firma:        Unabhängig,         gemeinsam,      textuell
- Adresse:      Abhängig (Name),    gemeinsam,      textuell
- Email:        Abhängig (Name),    gemeinsam,      textuell
- Telefon:      Abhängig (Name),    gemeinsam,      textuell
- VIP-Stufe:    Unabhängig,         gemeinsam,      numerisch
- pNotes:       Unabhängig,         exklusiv,       textuell
- Erfdat:       Unabhängig,         statisch,       numerisch
- Änddat:       Unabhängig,         dynamisch,      numerisch
- Akt Auf:      Unabhängig,         temp,           numerisch


## Datenanalyse von Facebook

__Benutzer Daten__
- Name:         Unabhängig,         exklusiv,       textuell
- Geburtsdatum: Unabhängig,         exklusiv,       textuell

__Post__
- Text:         Unabhängig,         exklusiv,       textuell
- ang. Bild:    Abhängig (Text),    exklusiv,       binär
- mark, Pers.:  Abhängig (Bild),    exklusiv,       binär
- Aktion/Gefühl:Abhängig (Text),    exklusiv,       textuell
- Standort:     Abhängig (Text),    exklusiv,       binär

__Kommentar__
- Text:         Abhängig (Post),    exklusiv,       textuell
- ang. Bild:    Abhängig (Text),    exklusiv,       textuell
(Ob ein Kommentar angezeigt wird, entscheidet der Autor des dazugehörenden Posts)

Alle Daten werden nur von einer Person bearbeitet. -> Synchronisationsprobleme können entstehen, jede Person ist selbst verantwortlich dass Änderungen nicht überschrieben werden. (real newest Entry wins) 

## Datenanalyse von GoogleCalendar

__Termin__
- Titel:        Unabhängig,         exklusiv,       textuell
- Datum:        Unabhängig,         exklusiv,       binär
- Zeit:         Unabhängig,         exklusiv,       binär
- Gäste:        Unabhängig,         exklusiv,       binär

Es können mehrere Termine zur selben Zeit stattfinden. Der Benutzer wird dann entsprechend gewarnt. -> Synchronisationsprobleme können entstehen, jede Person ist selbst verantwortlich dass Änderungen nicht überschrieben werden. (real newest Entry wins) 

<!--## Diskussion bekannter Verfahren
 (und Erklährung) in Bezug auf Ergebnisse der Datenanalyse -->
