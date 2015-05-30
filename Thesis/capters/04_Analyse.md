

# Analyse
<!--Dieses Kapitel setzt sich mit der Klassifikation und Typisierung von Daten auseinander. Es wird eine Klassifikation erarbeitet und anhand von Beispielen gezeigt, dass diese auch anwendbar ist.-->

## Synchronisationsproblem
Generell liegt ein Synchronisationsproblem vor, sobald Daten über einen Kommunikationskanal übertragen werden müssen und für die Zeit der Übertragung kein "Lock" gesetzt werden kann.

Die Datenanalyse wird mit Bezug auf die zwei im Folgenden aufgeführten Problemstellungen durchgeführt. Beide Problemstellungen sind so gewählt, dass sie zusammen einen möglichst allgemeinen Fall abdecken und so die Überprüfung aussagekräftig bleibt.

### Synchronisation von Kontakten
In vielen Anwendungsszenarien müssen Kontaktdaten abgeglichen werden. 

Eine Firma X betreibt eine zentrale Kontaktdatenbank an ihrem Hauptsitz. 
Verkaufsmitarbeiter müssen jederzeit Kontaktdaten abfragen, neu erfassen und anpassen können, ohne dafür mit dem zentralen Server verbunden zu sein. Gerade in wenig entwickelten oder repressiven Ländern ist eine ständige Verbindung nicht immer gegeben und somit ein Off-Line Modus notwendig.
Die Anpassungen können zu einem späteren Zeitpunkt abgeglichen werden.

Ein Kontakt selbst umfasst die in der Tabelle "Attribute Firmen-Kontakt" beschriebenen Attribute.

-------------------------------------------------------------------------------
__Attribut__                __Beschreibung__
--------------------------- --------------------------------------------------
__Name__                    Der gesamte Name (Vor-, Nach,- und Mittelname)
                            der (Kontakt-)Person.

__Adresse__                 Die vollständige Postadresse der Firma oder Person.

__Email__                   Alle aktiven und inaktiven Email-Adressen des
                            Kontakts. Jeweils nur eine Email ist die primäre
                            Email-Adresse.

__Telefon__                 Alle aktiven und inaktiven Telefonnummern des
                            Kontakts. Jeweils nur eine Telefonnummer ist die primäre Nummer.

__pNotes__                  Persönliche Bemerkungen zum Kontakt. Nur der Autor 
                            einer Notiz, kann diese bearbeiten oder lesen.
-------------------------------------------------------------------------------
Table: Attribute Firmen-Kontakt 

Im Folgenden sind vier typische Szenarien beschrieben.

__1. Szenario__
Erfassen einer neuen Telefonnummer zu einem bestehenden Kontakt.

__2. Szenario__
Ändern der primären Telefonnummer eines bestehenden Kontakts.

__3. Szenario__
Ändern des Namens eines bestehenden Kontakts.

__4. Szenario__
Hinzufügen/Ändern der (persönlichen) Zusatzinformationen eines bestehenden Kontakts.


### Syncrhonisation eines Service Desks
In vielen IT-Organisationen kommt ein Service-Deskt zum Einsatzt. Das Bearbeiten der Support-Fälle und erfassen von Arbeitszeiten muss online, direkt im System erfolgen. Dies kann vor allem fürs Arbeiten ausser Haus, zum Beispiel auf Reisen oder direkt beim Kunden, eine grosse Einschränkung sein.

Ein Support-Fall selbst umfasst die in der Tabelle "Attribute Support-Fall" beschriebenen Attribute. Es sind nur die für die aufgeführten Szenarien nötigen Attribute erfasst.

-------------------------------------------------------------------------------
__Attribut__                __Beschreibung__
--------------------------- --------------------------------------------------
__Titel__                   Titel des Support-Falls.

__Beschreibung__            Fehler/Problembeschreibung des Tickets.

__Anmerkungen__             Alle Antworten von Technikern und Kunden. Eine
                            Antwort des Technikers kann als FAQ-Eintrag markiert werden.

__Arbeitszeit__             Alle erfassten und aufgewendeten Stunden für den
                            Support-Fall.

__tArbeitszeit__            Das Total der erfassten Arbeitszeit.

__pNotes__                  Persönliche Bemerkungen zum Support-Fall. Nur der 
                            Autor einer Notiz, kann diese bearbeiten oder lesen.
-------------------------------------------------------------------------------
Table: Attribute Support-Fall


Die vier typischsten Aufgabenszenarien sind hier aufgeführt.

__1. Szenario__
Erfassen eines neuen Support-Falls.

__2. Szenario__
Einem Support-Fall eine neuen Anmerkung hinzufügen.

__3. Szenario__
Erfassen von Arbeitszeit auf ein Ticket.

__4. Szenario__
Zu einem Supportfall eine Lösung (FAQ-Eintrag) erfassen.

<!-- 
### Syncrhonisation von Stücklisten und Fertigungsaufträgen 
1. Szenario: Austauschen eines Bauteils -> Anpassung aller Stücklisten
2. Szenario: Anpassen der Fertigungsart (z.B. Menge des Lötzinns/Klebers)
3. Szenario: Priorisierung von Aufträgen (!!! nicht möglich - da Produktion läuft !!!)
4. Szenario: Lagerbestände/Lagerorte anpassen/ändern
-->



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
Nachfolgend sind die Attribute eines Kontakts aus dem ersten Beispiel "Synchronisation von Kontakten" sowie "Synchronisation eines Service Desks" entsprechend der erarbeiteten Klassifikation und Typisierung aufgeführt.

__Synchronisation von Kontakten__
Die Attribute Adresse, Email und Telefon sind abhängig vom Namensattribut. Dies kommt deshalb, weil der Name der primäre Identifikator ist. Adresse, Email und Telefon sind also Kontextuell abhängig vom Identifikator.
Das Attribut pNotes hingegen ist völlig unabhängig, da es nur vom Verfasser gelesen und geschrieben werden kann und liegt daher in der Verantwortung des Dessen.

-------------------------------------------------------------------------------
__Attribut__    __Struktur__          __Art__         __Typ__
--------------- ------------------- --------------- ---------------------------
Name            Unabhängig          gemeinsam       textuell
Adresse         Abhängig (Name)     gemeinsam       textuell
Email           Abhängig (Name)     gemeinsam       textuell
Telefon         Abhängig (Name)     gemeinsam       textuell
pNotes          Unabhängig          exklusiv        textuell
-------------------------------------------------------------------------------
Table: Klassifikation Attribute Kontakt


__Synchronisation eines Service Desks__
Die beiden Attribute Titel und Beschreibung können nur beim Erfassen eines Support-Falls gesetzt werden. Danach bilden sie zusammen den Identifikator.
Anmerkungen können von allen Mitarbeitern erfasst und geändert werden.
Die Totale Arbeitszeit (tArbeitszeit) wird vom System errechnet und kann nicht geändert werden.

-------------------------------------------------------------------------------
__Attribut__    __Struktur__          __Art__         __Typ__
--------------- ------------------- --------------- ---------------------------
Titel           Unabhängig          statisch        textuell
Beschreibung    Abhängig (Titel)    statisch        textuell
Anmerkungen     Abhängig (Titel)    gemeinsam       textuell
Arbeitszeit     Unabhängig          exklusiv        numerisch
tArbeitszeit    Unabhängig          dynamisch       numerisch
pNotes          Unabhängig          exklusiv        textuell
-------------------------------------------------------------------------------
Table: Klassifikation Attribute Kontakt


## Datenanalyse von "echten" Fällen

__Facebook__

__Benutzer Daten__

-------------------------------------------------------------------------------
__Attribut__    __Struktur__          __Art__         __Typ__
--------------- ------------------- --------------- ---------------------------
Name            Unabhängig          gemeinsam       textuell
Email           Abhängig (Name)     gemeinsam       textuell
Geburtsdatum    Unabhängig          exklusiv        textuell
-------------------------------------------------------------------------------
Table: Klassifikation Attribute Facebook Benutzerdaten

__Post__

-------------------------------------------------------------------------------
__Attribut__    __Struktur__          __Art__         __Typ__
--------------- ------------------- --------------- ---------------------------
Text            Unabhängig          exklusiv        textuell
Bild            Abhängig (Text)     exklusiv        binär
Personen        Abhängig (Bild)     exklusiv        binär
Aktion/Gefühl   Abhängig (Text)     exklusiv        textuell
Standort        Abhängig (Text)     exklusiv        binär
Likes           Abhängig (Text)     dynamisch       numerisch
-------------------------------------------------------------------------------
Table: Klassifikation Attribute Facebook Post

__Kommentar__

-------------------------------------------------------------------------------
__Attribut__    __Struktur__          __Art__         __Typ__
--------------- ------------------- --------------- ---------------------------
Text            Abhängig (Post)     exklusiv        textuell
Bild            Abhängig (Text)     exklusiv        textuell
-------------------------------------------------------------------------------
Table: Klassifikation Attribute Facebook Kommentar

(Ob ein Kommentar angezeigt wird, entscheidet der Autor des dazugehörenden Posts)

Alle Daten werden nur von einer Person bearbeitet. -> Synchronisationsprobleme können entstehen, jede Person ist selbst verantwortlich dass Änderungen nicht überschrieben werden. (real newest Entry wins) 

__Google Kalender__

__Termin__

------------------------------------------------------------------------------
__Attribut__    __Struktur__          __Art__         __Typ__
--------------- ------------------- --------------- ---------------------------
Titel           Unabhängig          exklusiv        textuell
Datum           Unabhängig          exklusiv        binär
Zeit            Unabhängig          exklusiv        binär
Gäste           Unabhängig          exklusiv        binär
-------------------------------------------------------------------------------
Table: Klassifikation Attribute Google Kalendereintrag

Es können mehrere Termine zur selben Zeit stattfinden. Der Benutzer wird dann entsprechend gewarnt. -> Synchronisationsprobleme können entstehen, jede Person ist selbst verantwortlich dass Änderungen nicht überschrieben werden. (real newest Entry wins) 




## Überprüfung der Klassifikation
Beide Klassen, unabhängig und abhängig werden verwendet

Es wird hauptsächlich der Typ exklusiv, und gemeinsam verwendet


==> Der Typ ist meist irrelevant und nur für die Konfliktauflösung Relevant. Dies ist aber so wie so Datenspezifisch und im Einfelfall zu begutachten.

Sinnvoll sind also noch:

Struktur: unabhängig und abhängig
Art: exklusiv, gemeinsam und dynamisch. (statisch (wil sie trotzdem geändert werden können => gemeinsam) und temp. (weil persönlich => exklusiv) sind irrelevant)






<!--## Diskussion bekannter Verfahren
 (und Erklährung) in Bezug auf Ergebnisse der Datenanalyse -->
