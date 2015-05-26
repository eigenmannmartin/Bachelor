\part[Implementation]{Implementierung und Testing}

# Prototyp
Dieses Kapitel adressiert die Implementation des Prototypen gemäss den Anroderungen aus Kapitel [Analyse].

## Umsetzung
<!-- Konkrete Implementations-Streategie/Algorythmen --> 

## Technologie Stack

-------------------------------------------------------------
Software            Beschreibung/Auswahlgrund
------------------- ------------------------------------------------
__Grunt__           
                    Grunt ermöglicht es dem Benutzer vordefinierte Tasks von der Kommandozeile aus durchzuführen. So sind Build- und Test-Prozesse für alle Benutzer ohne detaillierte Kenntnisse durchführbar.
                    Da Grunt eine sehr grosse Community besitzt und viele Plugins sowie hervorragende Dokumentationen verfügbar, wurde Grunt eingesetzt.

__Karma__

__CoffeeScript__

__RequireJS__       
                    RequireJS ermöglicht die Implementierung des AMD Pattern.Dadurch können auch in JavaScript Code-Abhängigkeiten definiert werden. Zusammen mit r.js kann dies bereits zur Compilierzeit geprüft werden.
                    Da weder Backbone noch Django über eine Depencency-Control für JavaScript verfügen, setze ich RequireJS ein.

__ReactJS__

__FluxifyJS__

__SequelizeJS__

__Express__

__Socket.io__

-------------------------------------------------------------

## Entwicklungsumgebung
Grunt + Karma = All you need

## Entwicklung
Verwendung vom Socket io (Namespaces etc)
Tricks mit API & Message Routing, binding to io.on 'message' -> flux.doAction

Express Server: 
Statisches Daten -> Frontend /
Socket.io -> /socket.io
Message-Bus -> Fluxify also in the backend


RequireJS Modules testable in the Browser :-D

Stores in the Frontend
Models in the Backend


## Grafische Umsetzung Fallbeispiel


# Testing

## Unit-Testing

## Integration-Testing

## Test der Akzeptanzkriterien

## Überprüfung der Aufgabenstellung
