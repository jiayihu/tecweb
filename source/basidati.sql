/**
  * L'ordine è importante a causa delle chiavi esterne. Non si può droppare una
  * tabella se prima non si droppano quelle relazionate come FOREIGN KEY
 */
DROP TABLE IF EXISTS amministratore, etichettamento, ispettore, lavoro, risoluzione, scena_investigazione, tag;
DROP TABLE IF EXISTS criminale, investigatore, investigazione;
DROP TABLE IF EXISTS caso, cliente, tariffa;

CREATE TABLE amministratore (
  codice_fiscale VARCHAR(16) PRIMARY KEY,
  password_hash VARCHAR(256) NOT NULL,
  nome VARCHAR(100) NOT NULL,
  cognome VARCHAR(100) NOT NULL
);

CREATE TABLE tariffa (
  tipologia_caso VARCHAR(50) PRIMARY KEY,
  prezzo FLOAT(12,2) NOT NULL
);

CREATE TABLE tag (
  slug VARCHAR(50) PRIMARY KEY,
  nome VARCHAR(50) NOT NULL UNIQUE,
  descrizione VARCHAR(100)
);

CREATE TABLE cliente (
  codice_fiscale VARCHAR(16) PRIMARY KEY,
	password_hash VARCHAR(256),
  nome VARCHAR(100) NOT NULL,
  cognome VARCHAR(100) NOT NULL,
  citta VARCHAR(100),
  indirizzo VARCHAR(100)
);

CREATE TABLE caso (
  codice INTEGER(10) auto_increment PRIMARY KEY,
  descrizione TEXT NOT NULL,
  nome VARCHAR(100) UNIQUE,
  passato BOOLEAN NOT NULL DEFAULT 0,
  risolto BOOLEAN NOT NULL DEFAULT 0,
  tipologia VARCHAR(50) NOT NULL,
  cliente VARCHAR(16) NOT NULL,
  FOREIGN KEY (tipologia) REFERENCES tariffa(tipologia_caso) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (cliente) REFERENCES cliente(codice_fiscale) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE investigazione (
  numero TINYINT,
  caso INTEGER(10),
  data_inizio DATE NOT NULL,
  data_termine DATE,
  rapporto TEXT,
  ore_totali SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (numero, caso),
  FOREIGN KEY (caso) REFERENCES caso(codice) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE scena_investigazione (
  slug VARCHAR(50) PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  descrizione TEXT NOT NULL,
  citta VARCHAR(100),
  indirizzo VARCHAR(100),
  investigazione TINYINT,
  caso INTEGER(10),
  FOREIGN KEY (investigazione, caso) REFERENCES investigazione(numero, caso) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE etichettamento (
  caso INTEGER(10),
  tag VARCHAR(50),
  PRIMARY KEY (caso, tag),
  FOREIGN KEY (caso) REFERENCES caso(codice) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (tag) REFERENCES tag(slug) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE criminale (
  codice_fiscale VARCHAR(16) PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  cognome VARCHAR(100) NOT NULL,
  descrizione TEXT NOT NULL
);

CREATE TABLE investigatore (
  codice_fiscale VARCHAR(16) PRIMARY KEY,
  password_hash VARCHAR(256) NOT NULL,
  nome VARCHAR(100) NOT NULL,
  cognome VARCHAR(100) NOT NULL
);

CREATE TABLE ispettore (
  codice_fiscale VARCHAR(16) PRIMARY KEY,
  codice_distretto VARCHAR(30),
  codice_fiscale_direttore VARCHAR(16),
  FOREIGN KEY (codice_fiscale) REFERENCES cliente(codice_fiscale) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE risoluzione (
  criminale VARCHAR(16),
  caso INTEGER(10),
  PRIMARY KEY (criminale, caso),
  FOREIGN KEY (criminale) REFERENCES criminale(codice_fiscale) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (caso) REFERENCES caso(codice) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE lavoro (
  investigatore VARCHAR(16),
  investigazione TINYINT,
  caso INTEGER(10),
  ore_lavoro SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (investigatore, investigazione, caso),
  FOREIGN KEY (investigatore) REFERENCES investigatore(codice_fiscale) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (investigazione, caso) REFERENCES investigazione(numero, caso) ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO `amministratore` (`codice_fiscale`, `password_hash`, `nome`, `cognome`)
VALUES
	('SQDMIH91E22G439U', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jeremy', 'Brooks'),
	('TIQYOM49D23J164Q', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Samuel', 'Nelson'),
	('TKINRX34C13C023K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jose', 'Olson'),
	('YRWNCB73I96G468M', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Patrick', 'Gonzalez'),
	('ZJPRNW27Q98E957V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Antonio', 'Palmer');

INSERT INTO tariffa(tipologia_caso, prezzo)
VALUES 
	('ricerca', 40),
	('furto', 30),
	('spionaggio', 50),
	('omicidio', 40),
	('ricatto', 50);

INSERT INTO `tag` (`slug`, `nome`, `descrizione`) VALUES
	('annegamento', 'Annegamento', NULL),
	('attore', 'Attore', NULL),
	('azienda', 'Azienda', NULL),
	('bambini', 'Bambini', NULL),
	('cane', 'Cane', NULL),
	('carne', 'Carne', NULL),
	('cellulare', 'Cellulare', NULL),
	('cinema', 'Cinema', NULL),
	('donna', 'Donna', NULL),
	('droga', 'Droga', 'Casi in cui è coinvolta la droga'),
	('esplosione', 'Esplosione', 'Il caso riguardo l\'esplosione di qualcosa'),
	('famiglia', 'Famiglia', NULL),
	('farmaci', 'Farmaci', NULL),
	('foto', 'Foto', NULL),
	('furto', 'Furto', NULL),
	('gang', 'Gang', NULL),
	('narcotraffico', 'Narcotraffico', 'Casi in cui si verifica un narcotraffico'),
	('omicidio', 'Omicidio', NULL),
	('perla-dei-borgia', 'Perla dei Borgia', 'Perla dei Boargia del Royal Regent Museum'),
	('rapina', 'Rapina', NULL),
	('ricatto', 'Ricatto', NULL),
	('rosa', 'Rosa', 'Il colpevole sembra amare il colore rosa'),
	('servizi-segreti', 'Servizi segreti', NULL),
	('soldi', 'Soldi', NULL),
	('sparatoia', 'Sparatoia', NULL),
	('spionaggio', 'Spionaggio', NULL),
	('sport', 'Sport', NULL),
	('stanza-senza-scasso', 'Stanza senza scasso', 'Il crimine è avvuto in una stanza chiusa dall\'interno senza apparente segno di scasso'),
	('terrorismo', 'Terrorismo', NULL),
	('terrorista', 'Terrorista', NULL),
	('video', 'Video', NULL);

INSERT INTO `cliente` (`codice_fiscale`, `password_hash`, `nome`, `cognome`, `citta`, `indirizzo`)
VALUES
	('AMGSOU02T42U148D', '', 'Julia', 'Little', 'Cristóbal', '37660 Corscot Lane'),
	('AOTFCB94S88D323S', '', 'James', 'Watson', 'Boulogne-sur-Mer', '2796 American Lane'),
	('BARTCQ79P64W004H', '', 'Raymond', 'Cooper', 'Bielice', '44 Dexter Pass'),
	('BDLNUQ87A74N842Q', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Betty', 'Owens', 'Senhor do Bonfim', '3526 Ohio Place'),
	('BKWTGV11X72P857I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Terry', 'Cruz', 'Huitán', '9932 Golf Course Road'),
	('BOUGHZ41R27X483Z', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Johnny', 'Bryant', 'Castleblayney', '74 Lake View Terrace'),
	('BSCAXW18H42R366I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jimmy', 'Dixon', 'Sarae', '9 Butternut Park'),
	('CGVBXZ84F14Q859X', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Howard', 'Baker', 'Novoorsk', '6773 Shelley Plaza'),
	('CYDTFN83D62O801H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Andrew', 'Marshall', 'Albi', '446 Forest Dale Parkway'),
	('DIWQEL90U14W018A', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Mark', 'Long', 'São José de Mipibu', '9760 Forest Run Terrace'),
	('DMTSUP71S31A293U', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Lillian', 'Carroll', 'Kissónerga', '64 Bellgrove Lane'),
	('EBZPSK96V72C394W', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ann', 'Jenkins', 'Lushan', '40444 7th Plaza'),
	('EGWYML53H52V479I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Anna', 'Kim', 'Täby', '4 Paget Drive'),
	('EGZTYL91X92S437X', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Sharon', 'Weaver', 'Bielice', '44 Dexter Pass'),
	('EMCRAJ52W88I906Y', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ryan', 'Moreno', 'Zi?bice', '08931 Reinke Way'),
	('EPRTQI78Y89U201V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Lillian', 'Dunn', 'Zhengdun', '60 Stang Court'),
	('GDPXQF93J29D590I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Irene', 'Jordan', 'Dankama', '4 Londonderry Trail'),
	('GKXSOF27U19Y632J', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Denise', 'Peterson', 'Provins', '517 Everett Pass'),
	('GMWBVD23K54N412F', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Annie', 'Gutierrez', 'Fátima', '2455 Morningstar Parkway'),
	('GYWIJZ29Y78P151J', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'John', 'Harrison', 'Matias Olímpio', '53226 Lindbergh Pass'),
	('HBORAL34C91E401W', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Theresa', 'Bailey', 'Lushan', '40444 7th Plaza'),
	('HIUBWC48S11W075N', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Lois', 'Kim', 'Changshou', '4908 Hermina Lane'),
	('HKYQIE50Y39F640D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Gary', 'Warren', 'Cilangkap', '1 Mayfield Circle'),
	('HLPRKC83I35V546H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Sara', 'Allen', 'Ve?ovice', '8435 Ronald Regan Lane'),
	('HMXYNS02J87C389K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Eric', 'Gomez', 'Dondo', '295 Declaration Circle'),
	('HYIMIH55E30G439K', '$2y$10$Zy5k.c6wSkV.Go/HpePsK.pvSYZHJE1UQjp5CX5pMCOjBpAQ5QrF2', 'Lestrade', 'Micheal', NULL, NULL);

INSERT INTO `caso` (`codice`, `descrizione`, `nome`, `passato`, `risolto`, `tipologia`, `cliente`) VALUES
	(1, 'Sono state perse le tracce di una donna di nome Nicole Hitmer.', 'Il grande gioco', 1, 0, 'ricerca', 'AMGSOU02T42U148D'),
	(2, 'Donna di circa 40 anni trovata morta nella stazione di Torino.', 'Uno studio in rosa', 0, 0, 'omicidio', 'BDLNUQ87A74N842Q'),
	(6, 'Un uomo si trova con la sua identit&agrave; rubata: lavoro, casa, carte di credito. Tutto.', 'Un caso di identita', 1, 0, 'ricerca', 'CYDTFN83D62O801H'),
	(8, 'Degli alberi di arance si sono ammalati. E\' stato anche ritrovato un cadavere.', 'I cinque semi d\'arancio', 1, 0, 'omicidio', 'CYDTFN83D62O801H'),
	(11, 'Un direttore di un\'importante azienda farmaceutica si accorge che alcuni suoi segreti aziendali su alcuni farmaci sperimentali sono trapelati.', 'L\'avventura della banda maculata', 0, 0, 'spionaggio', 'BKWTGV11X72P857I'),
	(24, 'Nuova avventura per l\'artista di talento Cecile De La Mor, che ha perso un altro dei suoi dipinti.', 'L\'avventura del carbonchio azzurro 2', 1, 0, 'furto', 'EPRTQI78Y89U201V'),
	(28, 'Un laboratorio produce degli esseri mostruosi e mutanti.', 'I mastini di Baskerville', 1, 1, 'omicidio', 'BSCAXW18H42R366I'),
	(51, '- Che bello San Valentino, il giorno degli innamorati. Tutti sono felici, allegri....e se il rosso non fosse solo il colore dell\'amore ma anche quello del sangue? - Ecco come viene decritto questo caso dalla stampa locale. Una giovane coppia &egrave; stata trovata morta appena fuori Rovigo, la sera di San Valentino.', 'Il caso di San Valentino', 1, 1, 'omicidio', 'EBZPSK96V72C394W'),
	(54, 'Durante un festival di primavera di una tranquilla cittadina nei colli Euganei, un giostraio che offre divertimento ai bambini, viene ricattato da una persona misteriosa.', 'Il festival di primavera', 1, 0, 'ricatto', 'BKWTGV11X72P857I'),
	(55, 'Giovane calciatore viene ricattato per delle foto molto compromettenti insieme ad una prostituta.', 'Il calciatore ricattato', 1, 1, 'ricatto', 'GMWBVD23K54N412F'),
	(57, 'La figlia di un direttore aziendale sparisce nel nulla.', 'Una bambina da salvare', 1, 0, 'spionaggio', 'EMCRAJ52W88I906Y'),
	(61, 'Sono stati rubati gli incassi di tutti i negozi del centro commerciale &quot;Il Gande Sole&quot; a Brescia', 'Rapina ai grandi magazzini', 0, 0, 'furto', 'BARTCQ79P64W004H'),
	(65, 'Casa malvagia che attira i bambini.', 'La casa del mistero', 1, 0, 'omicidio', 'GMWBVD23K54N412F'),
	(66, 'E\' stata trovata morta nella sua cabina di trucco una stella del cina, Anita Lopez.', 'Terrore sul set', 0, 0, 'omicidio', 'AMGSOU02T42U148D'),
	(70, 'Durante la gita di una famiglia in campeggio, il figlio minore viene rapito da un lontano parente in cerca di soldi.', 'Gita nel mistero', 1, 1, 'ricerca', 'AOTFCB94S88D323S'),
	(72, 'Un avvocato coinvolto in un giro di droga viene ricattato da uno sconoscito.', 'Un avvocato nel mistero', 1, 1, 'ricatto', 'GYWIJZ29Y78P151J'),
	(76, 'Un uomo si aggira per un capeggio di notte terrorizzando i campeggiatori.', 'L\'uomo bendato', 1, 1, 'ricatto', 'DIWQEL90U14W018A'),
	(77, 'Dentista rapina dei bambini per usarli come cavie dei suoi esperimenti.', 'Chi ha paura del dentista', 1, 1, 'omicidio', 'BDLNUQ87A74N842Q'),
	(81, 'E\' stata rubata la bandiera dell\'Universit&agrave; di Padova appesa a Palazzo Bo in onore della visita del presidente della repubblica.', 'Il mistero della bandiera', 1, 1, 'furto', 'HBORAL34C91E401W'),
	(86, 'Un uomo riceve degli strani messaggi da parte di un numero sconosciuto.', 'L\'ultimo messaggio', 1, 0, 'ricerca', 'EMCRAJ52W88I906Y'),
	(89, 'Una famiglia mentre &egrave; in vacanza viene derubata di tutti i beni preziosi in casa. L\'abitazione &egrave; collocata nelle campagne padove.', 'Grosso furto in campagna', 0, 0, 'furto', 'EGWYML53H52V479I'),
	(91, 'Mary, una bambina figlia di un\'importante e ricca famiglia di Roma &egrave; stata rapita da una banda di delinquenti in cerca di un riscatto.', 'La piccola Mary', 0, 0, 'ricatto', 'EGWYML53H52V479I'),
	(93, 'E\' sparito il cane di un famoso avvocato milanese che amava saltellare per la campagna. Le ricerche si concetrerrano l&agrave;.', 'Il cane salterino', 1, 1, 'ricerca', 'CYDTFN83D62O801H'),
	(98, 'Dei cani randagi si aggirano per la citt&agrave; spaventando i bambini e rubando cibo dalle macellerie.', 'La banda dei cani randagi', 0, 0, 'furto', 'DMTSUP71S31A293U'),
	(99, 'Investigando, Conan scopre che il colpevole &egrave; Timothy, compagno di squadra del calciatore, invidioso del successo del suo rivale.', 'Pesca sulla casa galleggiante', 1, 1, 'ricatto', 'DMTSUP71S31A293U');

INSERT INTO `investigazione` (`numero`, `caso`, `data_inizio`, `data_termine`, `rapporto`, `ore_totali`) VALUES
	(1, 1, '2018-02-10', '2018-02-16', 'Sono state trovate delle tracce di esplosivo vicino al caminetto. Il caso viene archiviato e passato ai servizi segreti militari.', 25),
	(1, 2, '2018-02-07', '2018-02-16', 'Nuovo caso simile a quello verificatosi anni fa. La vittima &egrave; una signora di circa 40 anni, vestita di rosa. Un fantasma che ritorna dal passato o una semplice messa in scena?', 25),
	(1, 6, '2018-02-10', '2018-02-18', 'La Polizia ha perso le traccie l\'uomo. Pensiamo possa essere fuggito in Svizzera. Il caso viene archiviato per mancanza di prove.', 19),
	(1, 11, '2018-02-07', '2018-02-14', 'E\' stata svolta un\'investigazione preliminare nel luogo del crimine. Anche altre aziende farmaceutiche hanno denunciato un simile comportamento. Si pensa che ci sia una banda di criminali coinvolti in tutti ci&ograve;.', 26),
	(1, 24, '2018-02-07', '2018-03-15', 'Il caso &egrave; stato archiviato per prove insufficienti.', 5),
	(1, 28, '2018-01-03', NULL, '', 5),
	(1, 51, '2018-02-07', '2018-02-15', 'Andrew Bailey, l\'ex fidanzato della ragazza morta &egrave; stato trovato in possesso dell\'arma del delitto - una Magnum 44 - e ha confessato l\'omicidio.', 5),
	(1, 54, '2018-02-09', '2018-02-15', 'Il festival e\' terminato e non si ha ancora nessuna traccia del criminale. Siccome il giostraio deve andare in un altra citta\' per un altro festival, le indagini terminano qua.', 10),
	(1, 55, '2018-02-07', '2018-02-20', 'Tramite i video della videosorveglianza dell\'appartamento si &egrave; riusciti ad incastrare il ricattatore, Robin Black, un ex amico d\'infanzia della vittima e invidioso della carriera del vecchio amico.', 15),
	(1, 57, '2018-02-10', '2018-02-19', 'Il caso viene passato alla Polizia.', 36),
	(1, 61, '2018-02-07', '2018-02-13', 'Sono stati interrogati tutti i proprietari del negozi all\'interno del centro commerciale. In tutti, l\'allarme di sicurezza era fuori uso durante l\'orario della rapina (secondo la polizia tra le 22:55 e le 2:13). Si cercano dei possibili criminali con possibili conoscenze informatiche.', 25),
	(1, 65, '2018-02-07', '2018-02-20', 'Caso archiviato per prove insufficienti.', 12),
	(1, 66, '2018-02-07', '2018-02-08', 'La vittima &egrave; stata trovata all\'interno del suo camerino. Mancano il cellulare, e attorno a cadere sono state torvate delle foto private della vittima.', 5),
	(1, 70, '2018-01-03', '2018-01-10', 'Il bimbo &egrave; stato ritrovato a casa degli zii.', 5),
	(1, 72, '2018-02-09', '2018-02-20', 'E\' stata anilizzata l\'abitazione delle vittima e le email di ricatto.', 10),
	(1, 76, '2018-02-07', '2018-02-15', 'Dalle testimonianze &egrave; emerso che luno in questione si aggira per il campeggio filmando con il cellulare quello che accade dentro camper e tende di notte, per poter poi ricattare le persone riprese.', 13),
	(1, 77, '2018-02-07', '2018-02-26', 'Il dentista &egrave; stato preso dopo una lunga fuga attraverso tutte le Alpi.', 39),
	(1, 81, '2018-02-07', '2018-02-08', 'La bandiera &egrave; stata subito ritrovata l&agrave; vicino. Jessica Foster, la studentessa che ha commesso il reato l\'ha fatto solo come gesto goliardico e per una scommessa con il suo ragazzo, Luca Poilo.', 5),
	(1, 86, '2018-02-10', '2018-02-13', 'La vittima ha iniziato a ricevere questi messaggi da quando ha aperto questa sua nuova agenzia immobiliare.', 5),
	(1, 89, '2018-01-03', '2018-01-20', 'E\' stato trovato un gioiello rubato.', 6),
	(1, 91, '2018-02-06', '2018-02-10', 'Analizziamo la stanza della piccola Mary, scena del crimine. Notiamo che le finestre hanno subito un tentativo di scasso. All\'appello manca anche il pupazzo di peluche preferito di Mary.', 7),
	(1, 98, '2018-01-06', NULL, 'Prima macelleria derubata dai cani. Sono stati trovati dei resti del bestiame che hanno mangiato: 4 polli, 2 tacchini e 3 conigli. Presumiamo che i cani possano essere almeno 5, visto che sono stati trovati 5 diverse pelurie animali sulla scena del crimine.', 3),
	(1, 99, '2018-01-06', '2018-01-10', 'Mancano dei pesci pescati da Carroll, famoso calciatore di serie A, dalla sua casa sul lago Azzurro.', 15),
	(2, 28, '2018-01-03', NULL, '', 20),
	(2, 66, '2018-02-07', '2018-02-15', 'Sono state trovate delle pastiglie di droga. Si indaga su di chi possano essere.', 8),
	(2, 72, '2018-02-09', '2018-02-26', 'Dopo delle investigazioni informatiche, si e\' riusciti a risale All\'IP da cui sono state inviate le email, corrispondente all\'abitazione del signor Bailey. L\'uomo e\' poi stato interrogato e ha confessato il crimine.', 26),
	(2, 76, '2018-02-07', '2018-02-25', 'L\'uomo &egrave; stato catturato durante un\'imboscata fatta proprio dai campeggiatori stessi, stanchi di questo comportamento. Bruce Mccoy, il guardone il questione, &egrave; stato denunciato alla Polizia.', 26),
	(2, 89, '2018-01-03', '2018-01-05', 'Trovati nuovi indizi sui ladri nella dependance in giardino.', 15),
	(2, 91, '2018-02-06', '2018-02-15', 'In questo magazzino &egrave; stata trattenuta la piccola Mary fino a pochi giorni fa. Sono stati trovati degli avanzi di cibo, un lettino e il peluche preferito della piccola.', 11),
	(2, 98, '2018-02-06', NULL, 'I cani hanno mangiato di pi&ugrave;: 3 anatre, 5 tacchini, 8 polli e 4 conigli. Forse il branco &egrave; aumentato.', 6),
	(2, 99, '2018-01-06', '2018-01-20', 'Non sono stati trovati segni di scasso, forse il responsabile conosce la vittima. E\' arrivato un messaggio alla vittima con la foto dei pesci, e una manaccia: per riaverli indietro avrebbe dovuto pagare 100.000 euro.', 29),
	(3, 28, '2018-01-03', NULL, '', 18),
	(3, 98, '2018-02-06', '2018-02-08', 'Questa volta un passante al momento del furto ha avvistato un furgoncino giallo con una scritta rossa vicino al luogo del crimine. Pensiamo che possa essere coinvolto.', 4),
	(3, 99, '2018-01-06', '2018-01-25', 'Sono stati interrogati tutti i compagni di squadra della vittima e nel cellulare di George sono state trovate le foto dei pesci.', 18);

INSERT INTO `scena_investigazione` (`slug`, `nome`, `descrizione`, `citta`, `indirizzo`, `investigazione`, `caso`)
VALUES
	('Abitazione-dell-avvocato-72-1', 'Abitazione dell\'avvocato', 'Casa molto ampia', 'via Porticino 59', 'Brenta (TV)', 1, 72),
	('Abitazione-della-famiglia-89-2', 'Abitazione della famiglia', 'Casa di campagna con grande portico fuori citt&agrave;', 'via Agripolis 35', 'Padova (PD)', 2, 89),
	('Abitazione-della-vittima-66-2', 'Abitazione della vittima', 'Appartamento in centro citt&agrave;', 'via Venezia 78', 'Milano', 2, 66),
	('Appartamento-del-calciatore-55-1', 'Appartamento del calciatore', 'Appartamento molto grande e spazioso', 'via Martiri 58', 'Verona', 1, 55),
	('Azienda-Happy-Hip-11-1', 'Azienda Happy Hip', 'Azienda farmaceutica', 'via Borgo 98', 'Triste', 1, 11),
	('Azienda-Minus-More-57-1', 'Azienda Minus More', 'Azienda industriare', 'via Liop 65', 'Arcore (RO)', 1, 57),
	('Campeggio-San-Fracesco-76-1', 'Campeggio San Fracesco', 'Campeggio con posto per tende e camper', 'via Costiera 36', 'Jesolo (VE)', 1, 76),
	('Campeggio-San-Francesco-76-2', 'Campeggio San Francesco', 'Campeggio con posto per tende e camper', 'Jesolo (VE)', 'via Costiera 36', 2, 76),
	('Casa-della-famiglia-70-1', 'Casa della famiglia', 'Casa bella', 'via Sile 57', 'Treviso', 1, 70),
	('Casa-di-Andrew-Bailey-72-2', 'Casa di Andrew Bailey', 'Abitazione piccola', 'via Roma 48', 'Ponte di Piave (TV)', 2, 72),
	('Casa-di-Carroll-99-2', 'Casa di Carroll', 'Casa galleggiante al centro del lago Azzurro', 'via Fiume 88', 'Asiago', 2, 99),
	('Casa-di-Cecili-De-La-Mor-24-1', 'Casa di Cecili De La Mor', 'Villino a due piani', 'via Gatti 55', 'Vicenza', 1, 24),
	('Casa-di-George-99-3', 'Casa di George', 'Appartamento a Vicenza', 'via Fragola 56', 'Vicenza (VI)', 3, 99),
	('Casa-di-Nicole-Hitmer-1-1', 'Casa di Nicole Hitmer', 'Casa di campagna', 'via Desper 26', 'Verona (VE)', 1, 1),
	('Casa-stregata-65-1', 'Casa stregata', 'Casa vecchia e sporca', 'via Abete 48', 'Trento', 1, 65),
	('Confine-con-la-Francia-77-1', 'Confine con la Francia', 'Casello di confine', 'via Confine 89', 'Argenterea (CU)', 1, 77),
	('Lago-Azzurro-99-1', 'Lago Azzurro', 'Lago molto bello per la pesca', 'via Fiume 88', 'Asiago', 1, 99),
	('Macelleria-Centrale-98-2', 'Macelleria Centrale', 'Macelleria fondata nel 1820', 'via Corte 23', 'Padova', 2, 98),
	('Macelleria-Ricc-98-3', 'Macelleria Ricc', 'Macelleria molto bella', 'via Eros 58', 'Vigonza (PD)', 3, 98),
	('Macelleria-Santa-Carne-98-1', 'Macelleria Santa Carne', 'Macelleria molto rinomata per la variet&agrave; di carne che offre', 'via Torino 4', 'Ponte di Brenta (PD)', 1, 98),
	('Magazzino-89-1', 'Magazzino', 'Magazzino di merce rubata', 'via Ladri 666', 'Padova (PD)', 1, 89),
	('Magazzino-fuori-Roma-91-2', 'Magazzino fuori Roma', 'Magazzino vecchio', 'via dell\'Industria 16', 'Roma', 2, 91),
	('Negozi-del-centro-commerciale-Il-Grande-Sole-61-1', 'Negozi del centro commerciale Il Grande Sole', 'Il centro commerciale &egrave; composto da 30 negozi', 'via Sole 99', 'Brescia', 1, 61),
	('Palazzo-Bo-81-1', 'Palazzo Bo', 'Sede storica dell\'Universit&agrave; di Padova', 'piazza Bo 1', 'Padova', 1, 81),
	('Parco-Grande-6-1', 'Parco Grande', 'Parco naturalistico', 'via Parco 44', 'Roma', 1, 6),
	('Parco-San-Giustino-54-1', 'Parco San Giustino', 'Parco molto grande che una volta all\'anno ospita il festival di privamera', 'via Porto 59', 'Cianna (PD)', 1, 54),
	('Ponte-Santo-Sesto-51-1', 'Ponte Santo Sesto', 'Ponte molto bello e frequentato da molte coppie il giorno di San Valentino', 'via Ponte Bello 47', 'Rovigo', 1, 51),
	('Set-serie-tv-El-Mi-Corazon-66-1', 'Set serie tv El Mi Corazon', 'Set situato nella periferia di Milano', 'via Star 9', 'Milano', 1, 66),
	('Stazione-centrale-torino-2-1', 'Stazione centrale torino', 'Stazione ferroviaria', 'via Stazione 44', 'Torino', 1, 2),
	('Ufficio-di-un-agenzia-immobilare-86-1', 'Ufficio di un\'agenzia immobilare', 'Agenzia fondata da poco', 'via Loeo 89', 'Milano', 1, 86),
	('Villa-Kim-91-1', 'Villa Kim', 'Imponente villa di propriet&agrave; della famiglia Kim.', 'via Money 55', 'Roma', 1, 91);

INSERT INTO `etichettamento` (`caso`, `tag`) VALUES
	(1, 'esplosione'),
	(1, 'servizi-segreti'),
	(2, 'donna'),
	(2, 'foto'),
	(2, 'omicidio'),
	(2, 'rosa'),
	(2, 'terrorismo'),
	(6, 'cellulare'),
	(6, 'donna'),
	(6, 'foto'),
	(6, 'soldi'),
	(6, 'video'),
	(8, 'omicidio'),
	(11, 'azienda'),
	(11, 'esplosione'),
	(11, 'farmaci'),
	(11, 'spionaggio'),
	(11, 'stanza-senza-scasso'),
	(24, 'donna'),
	(24, 'furto'),
	(24, 'stanza-senza-scasso'),
	(28, 'cane'),
	(28, 'carne'),
	(28, 'famiglia'),
	(28, 'soldi'),
	(28, 'sparatoia'),
	(51, 'donna'),
	(51, 'droga'),
	(51, 'servizi-segreti'),
	(51, 'sparatoia'),
	(51, 'terrorismo'),
	(54, 'bambini'),
	(54, 'ricatto'),
	(55, 'donna'),
	(55, 'foto'),
	(55, 'soldi'),
	(55, 'sport'),
	(55, 'video'),
	(57, 'bambini'),
	(57, 'famiglia'),
	(57, 'ricatto'),
	(57, 'sport'),
	(57, 'terrorismo'),
	(61, 'furto'),
	(61, 'soldi'),
	(65, 'bambini'),
	(65, 'esplosione'),
	(65, 'foto'),
	(65, 'omicidio'),
	(66, 'cellulare'),
	(66, 'cinema'),
	(66, 'donna'),
	(66, 'droga'),
	(66, 'foto'),
	(66, 'omicidio'),
	(66, 'soldi'),
	(70, 'esplosione'),
	(70, 'foto'),
	(72, 'cellulare'),
	(72, 'droga'),
	(72, 'narcotraffico'),
	(72, 'ricatto'),
	(72, 'soldi'),
	(76, 'bambini'),
	(76, 'cellulare'),
	(76, 'foto'),
	(76, 'ricatto'),
	(81, 'furto'),
	(86, 'famiglia'),
	(86, 'foto'),
	(86, 'video'),
	(91, 'bambini'),
	(91, 'ricatto'),
	(91, 'soldi'),
	(98, 'bambini'),
	(98, 'cane'),
	(98, 'carne'),
	(98, 'furto'),
	(99, 'carne'),
	(99, 'foto'),
	(99, 'sport'),
	(99, 'video');

INSERT INTO `criminale` (`codice_fiscale`, `nome`, `cognome`, `descrizione`)
VALUES
	('ADFHZU44F80D493Y', 'Bruce', 'Mccoy', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.'),
	('AIOQFT77Z44U137U', 'Timothy', 'George', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.'),
	('AKGZBM25T22L754P', 'Andrew', 'Bailey', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.'),
	('BQKGPR94U93S152F', 'Adam', 'Gomez', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.'),
	('CPNBTG50G79H396V', 'Jessica', 'Foster', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.\n\nNam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.'),
	('CUTYLZ95T47N989E', 'Janice', 'Lawson', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.'),
	('DBMYUG98X62Z079K', 'Eric', 'Johnston', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.'),
	('DBTHIY33B97G579W', 'Johnny', 'Johnston', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.'),
	('DESHZT72V96Y669T', 'Robin', 'Black', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.'),
	('DIRFPJ03O04U807P', 'Roy', 'Johnston', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.\n\nNam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.'),
	('DKCEOV07N51B968H', 'Adam', 'Phillips', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.'),
	('DNZTQS09G31N173A', 'Patricia', 'Cole', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.'),
	('DZPCYM08R80B545N', 'Diana', 'Torres', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.'),
	('ECKRBY21S24X489O', 'Brandon', 'Baker', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.\n\nCurabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.'),
	('ECVJAF43V43V115X', 'Henry', 'Rogers', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.');

INSERT INTO `investigatore` (`codice_fiscale`, `password_hash`, `nome`, `cognome`)
VALUES
	('AQPMIH96E20G439Y', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Sherlock', 'Holmes'),
	('CCPOIH89E20H440P', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'John', 'Watson'),
	('WMEPSF32N04Y001I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Daniel', 'Medina'),
	('XILADC61X36M430P', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Paul', 'Adams'),
	('XLSOIZ80T94C609C', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jennifer', 'Cunningham'),
	('XMOSRQ07C92E931O', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Roy', 'Reed'),
	('XMZWID05F95C731S', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Judith', 'Freeman'),
	('XYBJLN62N21X682T', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Catherine', 'Bowman'),
	('YRWNCB73I96G468M', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Patrick', 'Gonzalez'),
	('YVUQIG95X28I478V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Steve', 'Price'),
	('YWHFEQ10X22R265R', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Cheryl', 'Bailey'),
	('ZJPRNW27Q98E957V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Antonio', 'Palmer'),
	('ZWRTNC56U87C479G', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'David', 'Davis');


INSERT INTO `ispettore` (`codice_fiscale`, `codice_distretto`, `codice_fiscale_direttore`)
VALUES
	('BDLNUQ87A74N842Q', '9023', 'RZNXVT35J22W134I'),
	('BKWTGV11X72P857I', '0113', 'ENTKVJ31S89G460X'),
	('BOUGHZ41R27X483Z', '0832', 'JRTKUP94V19H145S'),
	('BSCAXW18H42R366I', '8231', 'YREGXQ07A43D019H'),
	('CGVBXZ84F14Q859X', '3813', 'OVSJGA03W66M195O'),
	('CYDTFN83D62O801H', '3923', 'GDJZXN52U01W640G'),
	('DIWQEL90U14W018A', '8142', 'FTRMOH05Y67Q034G'),
	('DMTSUP71S31A293U', '8464', 'GSCREL55D99N291V'),
	('EBZPSK96V72C394W', '8664', 'DJBVRA55N52N822V'),
	('EGWYML53H52V479I', '7789', 'PBEXKH82W52J747K'),
	('EGZTYL91X92S437X', '7593', 'QHYZUB35F01X358S'),
	('EMCRAJ52W88I906Y', '4697', 'JWYACP01R47E698F'),
	('EPRTQI78Y89U201V', '8302', 'YUOJST06T32Q434K'),
	('GDPXQF93J29D590I', '7985', 'GNREYT27R78A128E'),
	('GKXSOF27U19Y632J', '4859', 'CVUBXO91H06G269O'),
	('GMWBVD23K54N412F', '8827', 'GSTKLH27I34C933O'),
	('GYWIJZ29Y78P151J', '4400', 'QUSJYX48G41C574V'),
	('HBORAL34C91E401W', '8201', 'LHRPIX78X40Q622L'),
	('HIUBWC48S11W075N', '2021', 'GXVCNU78O48I079A'),
	('HKYQIE50Y39F640D', '5419', 'PSAIKZ45M35H218M'),
	('HLPRKC83I35V546H', '285', 'WRCEZA76Z72M948V'),
	('HMXYNS02J87C389K', '3850', 'CSGXUL75K55F717I'),
	('HYIMIH55E30G439K', NULL, NULL);

INSERT INTO `risoluzione` (`criminale`, `caso`)
VALUES
	('ADFHZU44F80D493Y', 76),
	('AIOQFT77Z44U137U', 99),
	('AKGZBM25T22L754P', 51),
	('AKGZBM25T22L754P', 70),
	('AKGZBM25T22L754P', 72),
	('BQKGPR94U93S152F', 77),
	('CPNBTG50G79H396V', 81),
	('CUTYLZ95T47N989E', 93),
	('DESHZT72V96Y669T', 55),
	('DNZTQS09G31N173A', 28);

INSERT INTO `lavoro` (`investigatore`, `investigazione`, `caso`, `ore_lavoro`)
VALUES
	('AQPMIH96E20G439Y', 1, 2, 25),
	('AQPMIH96E20G439Y', 1, 24, 5),
	('AQPMIH96E20G439Y', 1, 51, 5),
	('AQPMIH96E20G439Y', 1, 65, 12),
	('AQPMIH96E20G439Y', 1, 76, 13),
	('AQPMIH96E20G439Y', 1, 77, 39),
	('CCPOIH89E20H440P', 1, 6, 19),
	('CCPOIH89E20H440P', 2, 76, 26),
	('WMEPSF32N04Y001I', 1, 28, 5),
	('WMEPSF32N04Y001I', 1, 70, 5),
	('WMEPSF32N04Y001I', 1, 91, 7),
	('WMEPSF32N04Y001I', 1, 98, 3),
	('WMEPSF32N04Y001I', 2, 28, 20),
	('WMEPSF32N04Y001I', 2, 91, 11),
	('WMEPSF32N04Y001I', 2, 98, 6),
	('WMEPSF32N04Y001I', 3, 98, 4),
	('XILADC61X36M430P', 1, 55, 15),
	('XILADC61X36M430P', 3, 28, 18),
	('XLSOIZ80T94C609C', 1, 1, 25),
	('XLSOIZ80T94C609C', 2, 72, 26),
	('XMOSRQ07C92E931O', 1, 61, 25),
	('XMOSRQ07C92E931O', 1, 66, 5),
	('XMZWID05F95C731S', 1, 57, 36),
	('XYBJLN62N21X682T', 1, 99, 15),
	('XYBJLN62N21X682T', 2, 99, 29),
	('YRWNCB73I96G468M', 2, 89, 15),
	('YVUQIG95X28I478V', 1, 81, 5),
	('YVUQIG95X28I478V', 1, 86, 5),
	('YVUQIG95X28I478V', 3, 99, 18),
	('YWHFEQ10X22R265R', 1, 54, 10),
	('YWHFEQ10X22R265R', 1, 72, 10),
	('YWHFEQ10X22R265R', 1, 89, 6),
	('YWHFEQ10X22R265R', 2, 66, 8),
	('ZJPRNW27Q98E957V', 1, 11, 26);

DROP TRIGGER IF EXISTS CasoRisolto_ins;

DELIMITER //
CREATE TRIGGER CasoRisolto_ins
AFTER INSERT ON caso
FOR EACH ROW
BEGIN
	IF NEW.risolto = 1 AND NEW.passato = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Un caso risolto deve essere passato';
	END IF;
END//
DELIMITER ;


DROP TRIGGER IF EXISTS CasoRisolto_upd;

DELIMITER //
CREATE TRIGGER CasoRisolto_upd
AFTER UPDATE ON caso
FOR EACH ROW
BEGIN
	IF NEW.risolto = 1 AND NEW.passato = 0 THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Un caso risolto deve essere passato';
	END IF;
END//
DELIMITER ;

/* Esempi di query per testare trigger */

-- INSERT INTO caso(codice, descrizione, passato, risolto, tipologia, cliente)
-- VALUES (101, 'Test trigger inserimento', 0, 1, 'furto', 'AMGSOU02T42U148D');

-- UPDATE caso
-- SET passato = 0
-- WHERE codice = 100
DROP TRIGGER IF EXISTS DataTermineInvestigazione_ins;

DELIMITER //
CREATE TRIGGER DataTermineInvestigazione_ins
AFTER INSERT ON investigazione
FOR EACH ROW 
BEGIN
	IF NEW.data_termine <= NEW.data_inizio THEN 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'La data di termine deve essere maggiore della data di inizio';
	END IF;
END//
DELIMITER ;


DROP TRIGGER IF EXISTS DataTermineInvestigazione_upd;

DELIMITER //
CREATE TRIGGER DataTermineInvestigazione_upd
AFTER UPDATE ON investigazione
FOR EACH ROW 
BEGIN
	IF NEW.data_termine <= NEW.data_inizio THEN 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'La data di termine deve essere maggiore della data di inizio';
	END IF;
END//
DELIMITER ;

/* Esempi di query per testare trigger */

-- INSERT INTO investigazione(numero, caso, data_inizio, data_termine, rapporto)
-- VALUES (3, 2, '1977-12-07', '1977-11-07', NULL);

-- UPDATE investigazione
-- SET data_termine = '1977-01-06'
-- WHERE numero = 1 AND caso = 2;


DROP TRIGGER IF EXISTS OreLavoroTotali_ins;

DELIMITER //
CREATE TRIGGER OreLavoroTotali_ins
AFTER INSERT ON lavoro
FOR EACH ROW 
BEGIN
	DECLARE sommaOreTotali integer;
	DECLARE oreInvestigazione integer;
  
	SELECT 	SUM(lavoro.ore_lavoro) INTO sommaOreTotali
	FROM	lavoro
	WHERE 	lavoro.caso=NEW.caso AND lavoro.investigazione=NEW.investigazione
	GROUP BY lavoro.investigazione;
	
	SELECT 	ore_totali INTO oreInvestigazione
	FROM 	investigazione
	WHERE	investigazione.caso=NEW.caso AND investigazione.numero=NEW.investigazione;

	IF oreInvestigazione <> sommaOreTotali THEN
		UPDATE 	investigazione 
		SET 	ore_totali = sommaOreTotali
		WHERE 	investigazione.caso=NEW.caso AND investigazione.numero=NEW.investigazione;
	END IF;
END //
DELIMITER ;


DROP TRIGGER IF EXISTS OreLavoroTotali_upd;

DELIMITER //
CREATE TRIGGER OreLavoroTotali_upd
AFTER UPDATE ON lavoro
FOR EACH ROW 
BEGIN
	DECLARE sommaOreTotali integer;
	DECLARE oreInvestigazione integer;
  
	SELECT 	SUM(lavoro.ore_lavoro) INTO sommaOreTotali
	FROM	lavoro
	WHERE 	lavoro.caso=NEW.caso AND lavoro.investigazione=NEW.investigazione
	GROUP BY lavoro.investigazione;
	
	SELECT 	ore_totali INTO oreInvestigazione
	FROM 	investigazione
	WHERE	investigazione.caso=NEW.caso AND investigazione.numero=NEW.investigazione;

	IF oreInvestigazione <> sommaOreTotali THEN
		UPDATE 	investigazione 
		SET 	ore_totali = sommaOreTotali
		WHERE 	investigazione.caso=NEW.caso AND investigazione.numero=NEW.investigazione;
	END IF;
END //
DELIMITER ;
DROP TRIGGER IF EXISTS OreLavoro_ins;

DELIMITER //
CREATE TRIGGER OreLavoro_ins
BEFORE INSERT ON lavoro
FOR EACH ROW 
BEGIN
	IF NEW.ore_lavoro < 0 THEN SET NEW.ore_lavoro = 0;
	END IF;
END//
DELIMITER ;


DROP TRIGGER IF EXISTS OreLavoro_upd;

DELIMITER //
CREATE TRIGGER OreLavoro_upd
BEFORE UPDATE ON lavoro
FOR EACH ROW 
BEGIN
	IF NEW.ore_lavoro < 0 THEN SET NEW.ore_lavoro = 0;
	END IF;
END//
DELIMITER ;


/* Esempi di query per trigger */

-- INSERT INTO lavoro(investigatore, investigazione, caso, ore_lavoro)
-- VALUES ('AMSPQJ77U39J885B', 52, 73, -1);

-- UPDATE lavoro
-- SET ore_lavoro = -10
-- WHERE investigatore = 'AMSPQJ77U39J885B' AND investigazione = 52 AND caso = 73;
