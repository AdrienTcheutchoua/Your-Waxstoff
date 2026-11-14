# Your Waxstoff

Webanwendung für afrikanische Wax-Stoffe und Schneiderei-Service.
Entwickelt im Rahmen des Praktikums Anwendungssysteme (BWI 520).

## Technologien

- Java (Beans, JDBC)
- JSP auf Apache Tomcat 9
- PostgreSQL
- HTML, CSS, JavaScript

## Team

- Ange Teufa
- Divine Dogmo
- Adrien Tcheutchoua

## Datenbank einrichten

1. Das Datenbankschema und die Testdaten mit `datenbank_setup_hochschule.sql` anlegen.
2. Die Hochschul-Datenbank ist nur über das eduVPN erreichbar. Wer eine eigene PostgreSQL-Datenbank nutzt, führt die Datei dort aus.
3. Im Ordner `src/main/java/` die Datei `db.properties.example` kopieren und in `db.properties` umbenennen.
4. Die Werte in `db.properties` eintragen: Server, Port, Datenbankname, Benutzer, Passwort und Schema.

Die Datei `db.properties` ist nicht im Repository enthalten, da sie Zugangsdaten enthält.

## Starten

1. Projekt in Eclipse importieren (*File → Import → Existing Projects into Workspace*).
2. Den PostgreSQL-JDBC-Treiber (`postgresql-42.7.2.jar`) nach `WEB-INF/lib` legen, falls er fehlt.
3. Auf Tomcat 9 oder eine höhere Version deployen.
4. Im Browser `http://localhost:8080/yourwaxstoff/jsp/StartseiteView.jsp` öffnen. Bitte passen sie auf die passenden Port auf.

Geschrieben von Adrien Tcheutchoua
