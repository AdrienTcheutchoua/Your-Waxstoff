
CREATE SCHEMA IF NOT EXISTS bwi520_yourwaxstoff;
SET search_path TO bwi520_yourwaxstoff;


-- ============================================================
-- 1. TABELLEN
-- ============================================================

CREATE TABLE groesse (
    groesse_id      SERIAL PRIMARY KEY,
    bezeichnung     VARCHAR(5) NOT NULL UNIQUE,
    reihenfolge     INT NOT NULL
);

CREATE TABLE waxstoff (
    waxstoff_id     SERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    beschreibung    TEXT,
    ist_fertig      BOOLEAN NOT NULL DEFAULT false,
    geschlecht      VARCHAR(10) NOT NULL DEFAULT 'Unisex'
                        CHECK (geschlecht IN ('Herren','Damen','Unisex')),
    groesse_id      INT REFERENCES groesse(groesse_id),
    preis           NUMERIC(10,2) NOT NULL,
    bild_pfad       VARCHAR(255) NOT NULL,
    material        VARCHAR(100),
    pflegehinweis   VARCHAR(255),
    herkunft        VARCHAR(150)
);

CREATE TABLE modell (
    modell_id       SERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    beschreibung    TEXT,
    bild_pfad       VARCHAR(255),
    preis           NUMERIC(10,2) NOT NULL
);

CREATE TABLE kunde (
    kunde_id        SERIAL PRIMARY KEY,
    vorname         VARCHAR(50) NOT NULL,
    nachname        VARCHAR(50) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    passwort        VARCHAR(100) NOT NULL,
    adresse         VARCHAR(255) NOT NULL,
    erstellt_am     TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE bestellung (
    bestellung_id     SERIAL PRIMARY KEY,
    kunde_id          INT NOT NULL REFERENCES kunde(kunde_id),
    vorname           VARCHAR(50) NOT NULL,
    nachname          VARCHAR(50) NOT NULL,
    email             VARCHAR(150) NOT NULL,
    adresse           VARCHAR(255) NOT NULL,
    zahlungsmethode   VARCHAR(20) NOT NULL
                          CHECK (zahlungsmethode IN ('Karte','PayPal')),
    gesamtpreis       NUMERIC(10,2) NOT NULL DEFAULT 0,
    erstellt_am       TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE position (
    position_id     SERIAL PRIMARY KEY,
    bestellung_id   INT NOT NULL REFERENCES bestellung(bestellung_id),
    typ             VARCHAR(20) NOT NULL
                        CHECK (typ IN ('waxstoff','fertig','schneiderei')),
    waxstoff_id     INT REFERENCES waxstoff(waxstoff_id),
    modell_id       INT REFERENCES modell(modell_id),
    groesse_id      INT REFERENCES groesse(groesse_id),
    menge           NUMERIC(5,2) NOT NULL DEFAULT 1,
    einzelpreis     NUMERIC(10,2) NOT NULL
);

CREATE TABLE bewertung (
    bewertung_id                SERIAL PRIMARY KEY,
    position_id                  INT NOT NULL REFERENCES position(position_id),
    artikel_bewertung             INT NOT NULL CHECK (artikel_bewertung BETWEEN 1 AND 5),
    bestellprozess_bewertung       INT NOT NULL CHECK (bestellprozess_bewertung BETWEEN 1 AND 5),
    kommentar                       TEXT,
    erstellt_am                     TIMESTAMP NOT NULL DEFAULT now()
);


-- ============================================================
-- 2. TESTDATEN
-- ============================================================

-- Größen
INSERT INTO groesse (bezeichnung, reihenfolge) VALUES
('XS',1), ('S',2), ('M',3), ('L',4), ('XL',5), ('XXL',6);

-- Die 8 festen Schneiderei-Modelle (Preis = Nähpreis, anpassbar)
INSERT INTO modell (name, bild_pfad, preis) VALUES
('Herren Oberteil langärmlig', 'img/model-figur/herren-oberteil-lang.jpg', 40.00),
('Damen Oberteil langärmlig', 'img/model-figur/damen-oberteil-lang.jpg', 40.00),
('Herren Oberteil kurzärmlig', 'img/model-figur/herren-oberteil-kurz.jpg', 32.00),
('Damen Oberteil kurzärmlig', 'img/model-figur/damen-oberteil-kurz.jpg', 32.00),
('Damenkleid lang', 'img/model-figur/damenkleid-lang.jpg', 55.00),
('Damenkleid kurz (Mini)', 'img/model-figur/damenkleid-kurz.jpg', 45.00),
('Herrenhose lang', 'img/model-figur/herrenhose-lang.jpg', 38.00),
('Herrenhose kurz', 'img/model-figur/herrenhose-kurz.jpg', 30.00);

-- ============================================================
-- Echter Produktkatalog (40 Artikel — komplett)
-- ============================================================

-- 20 normale Waxstoffe (Meterware) — W1 bis W20
INSERT INTO waxstoff (name, beschreibung, ist_fertig, geschlecht, preis, bild_pfad) VALUES
('Ankara Indigo Welle', 'Tiefblauer Wax-Stoff mit fließendem Wellenmuster.', false, 'Unisex', 12.50, 'img/normale-waxstoffe/W1.jpg'),
('Adire Zickzack Schwarz-Weiß', 'Grafisches Zickzack-Muster in klassischem Schwarz-Weiß.', false, 'Unisex', 10.90, 'img/normale-waxstoffe/W2.jpg'),
('Bogolan Ebenholz', 'Traditionelles Bogolan-Muster in dunklen Erdtönen.', false, 'Unisex', 11.50, 'img/normale-waxstoffe/W3.jpg'),
('Sahara Sonnenwirbel', 'Warmes Rot-Orange mit organischem Wirbelmuster in Grün.', false, 'Unisex', 13.90, 'img/normale-waxstoffe/W4.jpg'),
('Korallenriff Dreieck', 'Zartes Lachsrosa mit geometrischem Dreiecksmuster.', false, 'Unisex', 12.90, 'img/normale-waxstoffe/W5.jpg'),
('Amethyst Dreiecksstern', 'Violett-blauer Stoff mit goldenen Dreiecksformen.', false, 'Unisex', 14.50, 'img/normale-waxstoffe/W6.jpg'),
('Türkis Medaillon', 'Petrolfarbener Stoff mit runden Medaillon-Motiven in Gold.', false, 'Unisex', 13.50, 'img/normale-waxstoffe/W7.jpg'),
('Goldene Sonnenscheibe', 'Cremefarbener Wax-Stoff mit strahlenden roten Kreismotiven.', false, 'Unisex', 11.90, 'img/normale-waxstoffe/W8.jpg'),
('Veilchen Kreisrausch', 'Violetter Stoff mit verschlungenen grünen Kreisformen.', false, 'Unisex', 12.90, 'img/normale-waxstoffe/W9.jpg'),
('Kardinal Federmuster', 'Kräftiges Rot mit filigranem weißen Federmotiv.', false, 'Unisex', 13.90, 'img/normale-waxstoffe/W10.jpg'),
('Elfenbein Blütenwirbel', 'Heller Stoff mit rot-blauem floralem Wirbelmuster.', false, 'Unisex', 12.50, 'img/normale-waxstoffe/W11.jpg'),
('Ozean Dreieckskaskade', 'Blauer Stoff mit kaskadenartigem Dreiecksmuster in Orange.', false, 'Unisex', 14.90, 'img/normale-waxstoffe/W12.jpg'),
('Lavendel Kaleidoskop', 'Zartlila Stoff mit kaleidoskopartigem Muster.', false, 'Unisex', 13.50, 'img/normale-waxstoffe/W13.jpg'),
('Olivgrün Sonnenrad', 'Olivgrüner Stoff mit runden Sonnenrad-Motiven in Rot.', false, 'Unisex', 11.90, 'img/normale-waxstoffe/W14.jpg'),
('Rubin Medaillon', 'Dunkelrotes Wax mit goldenen Medaillon-Verzierungen.', false, 'Unisex', 14.90, 'img/normale-waxstoffe/W15.jpg'),
('Waldgrün Klassik', 'Schlichter, klassischer Wax-Stoff in sattem Grün.', false, 'Unisex', 9.90, 'img/normale-waxstoffe/W16.jpg'),
('Petrol Diamantraute', 'Petrolfarbener Stoff mit orangen Diamantrauten.', false, 'Unisex', 13.90, 'img/normale-waxstoffe/W17.jpg'),
('Regenbogen Mosaik', 'Bunter Mix aus Türkis, Violett und Orange im Mosaikstil.', false, 'Unisex', 15.90, 'img/normale-waxstoffe/W18.jpg'),
('Bunte Symphonie', 'Lebendiger Mix aus Grün, Blau und Rot in abstraktem Muster.', false, 'Unisex', 14.50, 'img/normale-waxstoffe/W19.jpg'),
('Feuerrad Terrakotta', 'Terrakottafarbener Stoff mit dunklen Kreismotiven.', false, 'Unisex', 12.90, 'img/normale-waxstoffe/W20.jpg');

-- 10 fertige Damen-Kleidungsstücke — FW1 bis FW10
INSERT INTO waxstoff (name, beschreibung, ist_fertig, geschlecht, groesse_id, preis, bild_pfad) VALUES
('Sonnenkönigin Wickelkleid', 'Ärmelloses Wickelkleid mit Medaillon-Print in Gold, Blau und Rot, gebunden mit Taillenschärpe.', true, 'Damen', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'M'), 89.00, 'img/fertige-waxstoffe/FW1.jpg'),
('Himmelsblüte Zweiteiler', 'Cut-out Crop-Top mit passendem langen Rock, Blüten-Print in Blau und Gelb, seitlicher Schlitz.', true, 'Damen', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'S'), 65.00, 'img/fertige-waxstoffe/FW2.jpg'),
('Smaragd Meerjungfrau-Abendkleid', 'Elegantes One-Shoulder-Abendkleid in Meerjungfrau-Silhouette, Grün-Gold mit floraler Applikation.', true, 'Damen', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'M'), 149.00, 'img/fertige-waxstoffe/FW3.jpg'),
('Herzogin Mantel-Set', 'Langer Mantel mit kontrastierendem Kragen und weiter Hose, Bordeaux-Gold-Muster.', true, 'Damen', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'L'), 119.00, 'img/fertige-waxstoffe/FW4.jpg'),
('Ebenholz Batik-Kaftan', 'Fließender Wickel-Kaftan in Schwarz-Weiß mit grafischem X-O-Muster.', true, 'Damen', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'M'), 79.00, 'img/fertige-waxstoffe/FW5.jpg'),
('Königsblau Ballkleid', 'Aufwändiges Ballkleid mit Cape-Ärmeln, Patchwork-Print in Blau, Gold und Schwarz.', true, 'Damen', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'M'), 159.00, 'img/fertige-waxstoffe/FW6.jpg'),
('Rubinrot Spitzenkleid', 'Figurbetontes Kleid mit Puffärmeln und Spitzenkragen in kräftigem Rot.', true, 'Damen', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'S'), 99.00, 'img/fertige-waxstoffe/FW7.jpg'),
('Kente Sommerkleid mit Kopftuch', 'Ausgestelltes Midikleid im Patchwork-Look mit passendem Kopftuch, Rot-Gelb-Blau.', true, 'Damen', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'M'), 69.00, 'img/fertige-waxstoffe/FW8.jpg'),
('Geometrie Zweiteiler Blau-Gold', 'Lässiges Crop-Top mit weiter Hose, geometrisches Muster in Blau, Rot und Gold.', true, 'Damen', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'S'), 59.00, 'img/fertige-waxstoffe/FW9.jpg'),
('Blattmuster Mini-Rock Set', 'Weißes Spitzen-Top kombiniert mit ausgestelltem Mini-Rock im Blattmuster, Rot-Gold.', true, 'Damen', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'XS'), 45.00, 'img/fertige-waxstoffe/FW10.jpg');

-- 10 fertige Herren-Kleidungsstücke — MW1 bis MW10
INSERT INTO waxstoff (name, beschreibung, ist_fertig, geschlecht, groesse_id, preis, bild_pfad) VALUES
('Mitternachtsblau Agbada-Set', 'Traditionelles Agbada-Gewand mit bestickten Ärmeln, passender Hose und Kappe, in Dunkelblau.', true, 'Herren', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'L'), 129.00, 'img/fertige-waxstoffe/MW1.jpg'),
('Königlicher Kente-Wickel', 'Klassisch gewickeltes Kente-Tuch in Gelb, Rot und Grün, im traditionellen Toga-Stil.', true, 'Herren', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'M'), 89.00, 'img/fertige-waxstoffe/MW2.jpg'),
('Purpur Häuptlingsgewand', 'Weit geschnittenes Cape-Gewand mit Stickerei und passender Hose, in edlem Violett.', true, 'Herren', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'XL'), 139.00, 'img/fertige-waxstoffe/MW3.jpg'),
('Ahnen-Masken Tunika', 'Lange Tunika mit afrikanischem Masken- und Tänzer-Print, kombiniert mit dunkler Baumwolle.', true, 'Herren', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'L'), 79.00, 'img/fertige-waxstoffe/MW4.jpg'),
('Bogolan Kurzarm-Set', 'Kurzarmhemd mit passender Shorts im grafischen Bogolan-Muster, Schwarz-Gold.', true, 'Herren', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'M'), 55.00, 'img/fertige-waxstoffe/MW5.jpg'),
('Sahara Patchwork-Kurta', 'Beige Kurta mit auffälligem Patchwork-Streifen in Rot, Schwarz und Gold.', true, 'Herren', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'L'), 69.00, 'img/fertige-waxstoffe/MW6.jpg'),
('Kente Festanzug Orange', 'Eleganter Anzug mit Weste in Kente-Muster, kontrastierendem orangen Revers und Fliege.', true, 'Herren', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'L'), 149.00, 'img/fertige-waxstoffe/MW7.jpg'),
('Diamant Gala-Sakko', 'Zweireihiges Sakko mit goldenem Diamantmuster und dunkelgrünem Kontrastrevers, für festliche Anlässe.', true, 'Herren', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'L'), 169.00, 'img/fertige-waxstoffe/MW8.jpg'),
('Wirbelwind Raglan-Hemd', 'Marineblaues Langarmhemd mit kontrastierenden Raglan-Ärmeln im Orange-Blau-Wirbelmuster.', true, 'Herren', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'M'), 55.00, 'img/fertige-waxstoffe/MW9.jpg'),
('Diamant Batik-Hemd Marine', 'Langarmhemd mit durchgehendem geometrischem Diamant-Muster in Marineblau, Orange und Beige.', true, 'Herren', (SELECT groesse_id FROM groesse WHERE bezeichnung = 'M'), 59.00, 'img/fertige-waxstoffe/MW10.jpg');

-- Material, Pflege und Herkunft für alle 40 Artikel ergänzen
-- (identisch pro Kategorie, deshalb per UPDATE statt in jeder INSERT-Zeile)
UPDATE waxstoff SET
    material = '100% Baumwolle',
    pflegehinweis = 'Handwäsche empfohlen, nicht bleichen',
    herkunft = 'Handbedruckt in Westafrika'
WHERE ist_fertig = false;

UPDATE waxstoff SET
    material = '100% Baumwolle',
    pflegehinweis = 'Schonwaschgang 30°C, nicht bleichen, liegend trocknen',
    herkunft = 'Handgefertigt nach traditioneller Schneiderkunst'
WHERE ist_fertig = true;


-- ============================================================
-- Ein Beispiel-Kunde (zum Testen der Login-Funktion:
-- E-Mail amina@example.com / Passwort test1234)
-- ============================================================
INSERT INTO kunde (vorname, nachname, email, passwort, adresse) VALUES
('Amina', 'Diallo', 'amina@example.com', 'test1234', 'Musterstraße 1, 68159 Mannheim');

INSERT INTO bestellung (kunde_id, vorname, nachname, email, adresse, zahlungsmethode, gesamtpreis) VALUES
(1, 'Amina', 'Diallo', 'amina@example.com', 'Musterstraße 1, 68159 Mannheim', 'PayPal', 129.00);

INSERT INTO position (bestellung_id, typ, waxstoff_id, modell_id, groesse_id, menge, einzelpreis) VALUES
(1, 'schneiderei', 1, 1, (SELECT groesse_id FROM groesse WHERE bezeichnung = 'L'), 1, 40.00),
(1, 'fertig', 21, NULL, (SELECT groesse_id FROM groesse WHERE bezeichnung = 'M'), 1, 89.00);


-- ============================================================