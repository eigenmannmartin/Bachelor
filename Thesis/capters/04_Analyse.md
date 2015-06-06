\part[Konzept]{Konzeption und Konzeptüberprüfung}

Analyse
=======

Bekannte Synchronisationsverfahren betrachten Daten als eine homogene Masse und unterscheiden nicht bezüglich ihrer Beschaffenheit. Konfliktlösungen werden erst auf der Applikationsebene vorgenommen und dann spezifisch auf die Applikationsdaten angewandt. Dieses Kapitel klärt ob eine generelle Unterteilung der Daten möglich ist, und ob dies einen Nutzen mit sich bringt. 
Die Analyse ist auf einer abstrahierten Stufe durchgeführt und blendet bewusst alle technischen Aspekte aus. Daten sind nur aus der Sicht eines Benutzers betrachtet. Alle für den Benutzer nicht sichtbaren Daten werden nicht zu Analyse herangezogen.


Synchronisationsproblem
-----------------------

Generell liegt ein Synchronisationskonflikt vor, sobald Daten über einen Kommunikationskanal übertragen werden müssen und für die Zeit der Übertragung kein "Lock" gesetzt werden kann. Also immer dann, wenn sich Daten während einer Transaktion, durch eine andere parallel laufende Transaktion, ändern können.

Um ein Konzept zur Verhinderung und Lösung Synchronisationskonflikten zu erarbeiten, muss zuerst eine Analyse der zu synchronisierenden Daten durchgeführt werden.
Die Datenanalyse wird mit Bezug auf die zwei im Folgenden aufgeführten Problemstellungen durchgeführt. Beide Problemstellungen sind so gewählt, dass sie kombiniert einen möglichst allgemeinen Fall abdecken können und so die Überprüfung aussagekräftig wird.

### Synchronisation von Kontakten
In vielen Anwendungsszenarien müssen Kontaktdaten zwischen verschiedenen Systemen und Plattformen synchronisiert werden. In diesem Beispiel wird ein verallgemeinerte Verwendungszweck in einer Unternehmung beleuchtet.

Eine Firma "VIP Customer Care" betreibt eine zentrale Kontaktdatenbank an ihrem Hauptsitz. Darin sind alle Kunden mit Namen, Adresse, Telefonnummern und Email-Adressen erfasst. Zusätzlich ist es für jeden Anwender möglich persönliche Notizen zu einem Kontakt zu erfassen.
Die Anwender müssen jederzeit Kontaktdaten abfragen, anpassen oder neu erfassen können, ohne dafür mit dem zentralen Kontaktdatenbank verbunden zu sein. Gerade in wenig entwickelten oder repressiven Ländern ist eine Verbindung nicht immer voraussetzbar und somit eine Off-Line Funktionalität notwendig.
Die Anpassungen werden dann zu einem späteren Zeitpunkt abgeglichen und somit in die zentrale Kontaktdatenbank synchronisiert.

Ein Kontakt selbst umfasst die in der Tabelle "Attribute Firmen-Kontakt" aufgeführten Attribute.

-------------------------------------------------------------------------------
__Attribut__                __Beschreibung__
--------------------------- --------------------------------------------------
__Name__                    Der gesamte Name (Vor-, Nach,- ,Mittelname und Titel)
                            der Kontakt-Person.

__Adresse__                 Die vollständige Postadresse der Firma oder Person.

__Email__                   Alle aktiven und inaktiven Email-Adressen des
                            Kontakts. Jeweils nur eine Email kann als primäre
                            Email-Adresse definiert sein.

__Telefon__                 Alle aktiven und inaktiven Telefonnummern des
                            Kontakts. Jeweils nur eine Telefonnummer ist die primäre Nummer.

__pNotes__                  Persönliche Bemerkungen zum Kontakt. Nur der Autor 
                            einer Notiz, kann diese bearbeiten oder lesen.
-------------------------------------------------------------------------------
Table: Attribute Firmen-Kontakt 


### Syncrhonisation eines Service Desks
Ein anderes Anwendungsszenario bezieht sich auf die Synchronisation von Ablaufdaten in einem definierten Umfeld. So werden in vielen  Fällen auch Daten von Abläufen und Vorgängen synchronisiert. Abhängigkeiten (zeitlich sowie inhaltlich) zwischen den Daten sind stark ausgeprägt und müssen von der Business-Logik überprüft werden.

In vielen IT-Organisationen kommt irgend eine Form eines Service-Desks zum Einsatz. Typischerweise werden Arbeitszeiten, Aufwendungen und Tätigkeiten direkt auf einen Support-Fall gebucht. Auch die Kommunikation mit dem Kunden wird hauptsächlich über den Service-Desk geführt. Das Erfassen dieser Einträge soll jederzeit möglich sein, auch ohne Verbindung zum Service-Desk. 

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


Datenanalyse
------------

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

__Kontextunabhängige Daten__ gewinnen selbst durch andere Daten nicht mehr an Informationsgehalt. Gemeint ist damit, dass durch das zusätzliche Betrachten anderer Informationen nicht mehr Wissen bezüglich des einen Attributs entsteht.

__Kontextbezogene Daten__ weisen nur bezüglich eines bestimmten Kontext einen signifikanten Informationsgehalt auf. 

Die Adresse eines Kontakts spezifiziert üblicherweise den Ort und das Haus. Zusammen mit dem Namen wird auch die Wohnung eindeutig identifiziert. Die Adresse besitzt also zusammen mit dem Name einen grösseren Informationsgehalt.
Wohingegen die Adresse den Namen nicht weiter spezifiziert.

### Datentypisierung
Die Unterscheidung der Daten nach Datentyp differenziert zwischen __numerischen__, __binären__, __logischen__ und __textuellen__ Daten. Zur Typisierung wird immer die für den Benutzer sichtbare Darstellung verwendet, also jene Darstellung, in welcher die Daten erfasst wurden.


## Datenanalyse der Synchronisationsprobleme
Nachfolgend sind die Attribute der beiden Beispiele "Synchronisation von Kontakten" sowie "Synchronisation eines Service-Desks" entsprechend der erarbeiteten Klassifikation und Typisierung zugeordnet.

### Synchronisation von Kontakten
Der Name eines Kontakts ist der primäre Identifikator eines Kontakts. Er alleine zeigt dem Benutzer an, um welchen Kontakt es sich handelt. Der Name ändert sich nur in Extremfällen und gibt somit den Kontext des Kontaktes an.
Die Attribute Adresse, Email und Telefon sind deshalb allesamt abhängig vom Namensattribut. Diese Attribute sind also kontextuell abhängig vom Identifikator. Nur solange der Name nicht geändert wurde, ist die Übernahme von Anpassungen an den Attributen Adresse, Email und Telefon sinnvoll.
Das Attribut pNotes hingegen ist völlig unabhängig, da es nur vom Verfasser gelesen und geschrieben werden kann. Ob die darin enthaltenen Informationen also zum Kontext passen, liegt alleine in der Verantwortung des Autors und muss vom System nicht weiter beachtet werden.
Die Attribute Name, Adresse, Email und Telefon können von allen Benutzern des Systems jederzeit verändert werden. Jeder Benutzer ist gleichberechtigt, niemand wird bevorzugt. Aus diesem Grund sind diese Attribute als gemeinsame Daten klassifiziert. Das Attribut pNotes hingegen ist für jeden Benutzer exklusiv editierbar und einsehbar. Jeder Benutzer sieht und bearbeitet also nur seine eigene Version des Attributs.
Obwohl alle Attribute ein sehr unterschiedliches Erscheinungsbild aufweisen, sind sie Textfelder. Zwar können diesen Textfeldern Formate wie Telefonnummer oder Adresse hinterlegt werden, sie sind aber auf der Ebene der Daten trotzdem nur Text-Felder. 

Alle im Fallbeispiel gezeigten Attribute lassen sich klassifizieren und einem Datentyp zuordnen. Die Klassifikation repräsentiert die Struktur sowie die Art des Zugriffs auf die Daten auf einem hohen Abstraktionslevel. Es gibt keine nicht klar klassifizierbaren Attribute.

-------------------------------------------------------------------------------
__Attribut__    __Struktur__        __Art__         __Typ__
--------------- ------------------- --------------- ---------------------------
Name            Unabhängig          gemeinsam       textuell
Adresse         Abhängig (Name)     gemeinsam       textuell
Email           Abhängig (Name)     gemeinsam       textuell
Telefon         Abhängig (Name)     gemeinsam       textuell
pNotes          Unabhängig          exklusiv        textuell
-------------------------------------------------------------------------------
Table: Klassifikation Attribute Kontakt


### Synchronisation eines Service-Desks
<!-- Erweitern -->
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


## Überprüfung der Klassifikation
Die durchgeführte [Datenanalyse der Synchronisationsprobleme] der beiden Fallbeispiele zeigt, dass sowohl die Klassifikation nach Struktur, als auch die Klassifikation nach Art durchführbar und repräsentativ ist. Es kann klar zwischen der Klassifikation exklusiv, gemeinsam und dynamisch unterschieden werden. Auch sind die beiden Struktur-Klassen kontextbezogen und kontextunabhängig sind allgemeingültig und ermöglichen eine Repräsentation der Abhängigkeiten zwischen den verschiedenen Attributen. 

Die beiden weiteren vorgeschlagenen Arten-Klassen, statisch und temporär, sind nicht eindeutig genug, um eingesetzt werden zu können. Daten die mit der Art temporär klassifiziert werden könnten, können auch durch die Klasse exklusiv klassifiziert werden. Die Klasse exklusiv ist sogar noch genereller und eine Unterscheidung der Klassen nach der Gültigkeitsdauer der klassifizierten Daten bieten keinen Mehrwert. Die zweite Arten-Klasse statisch ist ebenso repräsentativer durch der Klasse gemeinsam abgedeckt.

Die gefundenen Klassen können also auf Daten angewendet werden und repräsentieren diese auch auf dem gewünschten Abstraktionslevel.

