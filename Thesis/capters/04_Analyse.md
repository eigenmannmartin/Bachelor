

# Analyse
<!--Dieses Kapitel setzt sich mit der Klassifikation und Typisierung von Daten auseinander. Es wird eine Klassifikation erarbeitet und anhand von Beispielen gezeigt, dass diese auch anwendbar ist.-->

## Synchronisationsproblem
Generell liegt ein Synchronisationskonflikt vor, sobald Daten über einen Kommunikationskanal übertragen werden müssen und für die Zeit der Übertragung kein "Lock" gesetzt werden kann. Also immer dann, wenn sich Daten während einer Transaktion ändern können.

Um ein Konzept zur Verhinderung und Lösung Synchronisationskonflikten  zu erarbeiten, muss zuerst eine Analyse der zu synchronisierenden Daten erstellt werden.
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
<!-- Eventuell ausführlichere Szenarien -->
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

Daten können bezüglich ihrer Beschaffenheit, Geltungsbereich und Gültigkeitsdauer unterschieden werden. Im Weiteren wird dies als die Klassifikation beschrieben. Die Datentypisierung hingegen, unterscheidet nach dem äusseren Erscheinungsbild der Daten.

Zur Klassifikation werden nur die in den Daten enthaltenen Informationen herangezogen. Der Datentyp selbst ist dabei unerheblich.
Weiter kann die Klassifikation zwischen Struktur und Art der Daten unterscheiden.

### Klassifikation nach Art
Um Daten nach ihrer Art zu Klassifizieren reicht es zu untersuchen wie die Lese- und Schreibrechte sowie deren Gültigkeitsdauer aussehen.

__Exklusive Daten__ können nur von einem Benutzer bearbeitet, aber von diesem oder vielen Benutzern gelesen werden.

__Gemeinsame Daten__ können von vielen Benutzern gleichzeitig gelesen und bearbeitet werden.

__Dynamische Daten__ werden automatisch von System generiert. Benutzer greifen nur lesend darauf zu.

__Statische Daten__ bleiben über einen grossen Zeitraum hinweg unverändert. Viele Benutzer können diese Daten verändern und lesen.

__Temporäre Daten__ werden von System oder Benutzer generiert und sind nur sehr kurz gültig. Nur der Autor der Daten kann diese lesen.


### Klassifikation nach Struktur
Bei der Unterscheidung der Daten nach ihrer Struktur, kann zwischen Kontextbezogenen und Kontextunabhängigen Daten differenziert werden. Die Entscheidung welcher Strukturklasse die Daten angehören ist abhängig vom Verständnis der Daten uns liegt somit im Entscheidungsbereich des Datendesigners. 

__Kontextbezogene Daten__ weisen nur bezüglich eines bestimmten Kontext einen signifikanten Informationsgehalt auf.

__Kontextunabhängige Daten__ gewinnen selbst durch andere Daten nicht mehr an Informationsgehalt.

### Datentypisierung
Die Unterscheidung der Daten nach Datentyp differenziert zwischen __numerischen__, __binären__, __logischen__ und __textuellen__ Daten. Zur Typisierung wird immer die für den Benutzer sichtbare Darstellung verwendet, also jene Darstellung, in welcher die Daten erfasst wurden.


## Datenanalyse der Synchronisationsprobleme
Nachfolgend sind die Attribute der beiden Beispiele "Synchronisation von Kontakten" sowie "Synchronisation eines Service Desks" entsprechend der erarbeiteten Klassifikation und Typisierung zugeordnet.

__Synchronisation von Kontakten__
Der Name eines Kontakts ist der primäre Identifikator eines Kontakts. Ändert sich dieser, ist es sehr wahrscheinlich, dass sich auch andere Attribute ändern.
Die Attribute Adresse, Email und Telefon sind deshalb abhängig vom Namensattribut. Diese Attribute sind also Kontextuell abhängig vom Identifikator.
Das Attribut pNotes hingegen ist völlig unabhängig, da es nur vom Verfasser gelesen und geschrieben werden kann.

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

<!-- might need some more explanation -->


__Synchronisation eines Service Desks__
Die beiden Attribute Titel und Beschreibung können nur beim Erfassen eines Support-Falls gesetzt werden. Danach bilden sie zusammen den eindeutigen Identifikator. Anmerkungen werden spezifisch für einen Support-Fall erfasst, und sind deshalb nur im Kontext desselben bedeutungsvoll.
Die Totale Arbeitszeit (tArbeitszeit) wird in Abhängigkeit vom Attribut Arbeitszeit vom System errechnet und kann nicht geändert werden.

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
<!-- not so sure if I really want these cases -->
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
Die Klassifikation der Daten nach Struktur zeigt sich in allen Beispielen als nachvollziehbar. Auch kann klar zwischen der Typisierung exklusiv, gemeinsam und dynamisch unterschieden werden.

Die weiteren gefundenen Typen statisch und temporär sind wenig sinnvoll, da beide durch exklusiv oder gemeinsam ersetzt werden könne.
Temporäre Daten sind exklusiv, während statische Daten auch als gemeinsam klassifiziert werden können.

Es kann auch festgestellt werden, dass Daten meist vom Typ text oder binär sind.


<!-- what is the main point in doing this? -->




<!--## Diskussion bekannter Verfahren
 (und Erklährung) in Bezug auf Ergebnisse der Datenanalyse -->
