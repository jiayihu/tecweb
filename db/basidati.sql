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
	password_hash VARCHAR(256) NOT NULL,
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
  nome VARCHAR(50) NOT NULL UNIQUE,
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
	('bambini', 'Bambini', NULL),
	('cellulare', 'Cellulare', NULL),
	('donna', 'Donna', NULL),
	('droga', 'Droga', 'Casi in cui è coinvolta la droga'),
	('esplosione', 'Esplosione', 'Il caso riguardo l\'esplosione di qualcosa'),
	('foto', 'Foto', NULL),
	('narcotraffico', 'Narcotraffico', 'Casi in cui si verifica un narcotraffico'),
	('omicidio', 'Omicidio', NULL),
	('perla-dei-borgia', 'Perla dei Borgia', 'Perla dei Boargia del Royal Regent Museum'),
	('rapina', 'Rapina', NULL),
	('rosa', 'Rosa', 'Il colpevole sembra amare il colore rosa'),
	('servizi-segreti', 'Servizi segreti', NULL),
	('sparatoia', 'Sparatoia', NULL),
	('stanza-senza-scasso', 'Stanza senza scasso', 'Il crimine è avvuto in una stanza chiusa dall\'interno senza apparente segno di scasso'),
	('terrorismo', 'Terrorismo', NULL),
	('terrorista', 'Terrorista', NULL);

INSERT INTO `cliente` (`codice_fiscale`, `password_hash`, `nome`, `cognome`, `citta`, `indirizzo`)
VALUES
	('AMGSOU02T42U148D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Julia', 'Little', 'Cristóbal', '37660 Corscot Lane'),
	('AOTFCB94S88D323S', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'James', 'Watson', 'Boulogne-sur-Mer', '2796 American Lane'),
	('BARTCQ79P64W004H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Raymond', 'Cooper', 'Bielice', '44 Dexter Pass'),
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
	('EMCRAJ52W88I906Y', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ryan', 'Moreno', 'Ziębice', '08931 Reinke Way'),
	('EPRTQI78Y89U201V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Lillian', 'Dunn', 'Zhengdun', '60 Stang Court'),
	('GDPXQF93J29D590I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Irene', 'Jordan', 'Dankama', '4 Londonderry Trail'),
	('GKXSOF27U19Y632J', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Denise', 'Peterson', 'Provins', '517 Everett Pass'),
	('GMWBVD23K54N412F', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Annie', 'Gutierrez', 'Fátima', '2455 Morningstar Parkway'),
	('GYWIJZ29Y78P151J', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'John', 'Harrison', 'Matias Olímpio', '53226 Lindbergh Pass'),
	('HBORAL34C91E401W', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Theresa', 'Bailey', 'Lushan', '40444 7th Plaza'),
	('HIUBWC48S11W075N', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Lois', 'Kim', 'Changshou', '4908 Hermina Lane'),
	('HKYQIE50Y39F640D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Gary', 'Warren', 'Cilangkap', '1 Mayfield Circle'),
	('HLPRKC83I35V546H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Sara', 'Allen', 'Veřovice', '8435 Ronald Regan Lane'),
	('HMXYNS02J87C389K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Eric', 'Gomez', 'Dondo', '295 Declaration Circle');

INSERT INTO `caso` (`codice`, `descrizione`, `nome`, `passato`, `risolto`, `tipologia`, `cliente`) VALUES
(1, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.', 'Il grande gioco	', 1, 0, 'ricerca', 'AMGSOU02T42U148D'),
(2, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', 'Uno studio in rosa', 0, 0, 'ricatto', 'BDLNUQ87A74N842Q'),
(6, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Un caso di identita', 1, 0, 'ricerca', 'CYDTFN83D62O801H'),
(8, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', 'I cinque semi d\'arancio', 1, 0, 'omicidio', 'CYDTFN83D62O801H'),
(11, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', 'L\'avventura della banda maculata', 0, 0, 'omicidio', 'BKWTGV11X72P857I'),
(13, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', 'L\'avventura del pollice dell\'ingegnere', 1, 0, 'ricerca', 'GYWIJZ29Y78P151J'),
(24, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', 'L\'avventura del carbonchio azzurro 2', 1, 0, 'furto', 'EPRTQI78Y89U201V'),
(28, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', 'I mastini di Baskerville	', 1, 1, 'omicidio', 'BSCAXW18H42R366I'),
(51, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', 'Il caso di San Valentino', 1, 1, 'omicidio', 'EBZPSK96V72C394W'),
(53, 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', 'Mistero al museo', 1, 0, 'ricerca', 'DMTSUP71S31A293U'),
(54, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', 'Il festival di primavera', 1, 0, 'ricatto', 'BKWTGV11X72P857I'),
(55, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.', 'Il calciatore ricattato', 1, 1, 'omicidio', 'GMWBVD23K54N412F'),
(57, 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', 'Una bambina da salvare', 1, 0, 'spionaggio', 'EMCRAJ52W88I906Y'),
(61, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', 'Rapina ai grandi magazzini', 0, 0, 'ricerca', 'BARTCQ79P64W004H'),
(62, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.', 'Oggi sposi', 1, 1, 'spionaggio', 'CYDTFN83D62O801H'),
(65, 'Aenean sit amet justo. Morbi ut odio.', 'La casa del mistero', 1, 0, 'furto', 'GMWBVD23K54N412F'),
(66, 'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', 'Terrore sul set', 0, 0, 'furto', 'AMGSOU02T42U148D'),
(70, 'Durante la gita di una famiglia in campeggio, il figlio minore viene rapito da un lontano parente in cerca di soldiii.', 'Gita nel mistero', 1, 1, 'ricerca', 'AOTFCB94S88D323S'),
(72, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Un avvocato nel mistero', 1, 1, 'ricatto', 'GYWIJZ29Y78P151J'),
(76, 'Ut at dolor quis odio consequat varius. Integer ac leo.', 'L\'uomo bendato', 1, 1, 'furto', 'DIWQEL90U14W018A'),
(77, 'Dentista rapina dei bambini per usarli come cavie dei suoi esperimenti.', 'Chi ha paura del dentista', 1, 1, 'omicidio', 'BDLNUQ87A74N842Q'),
(81, 'Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', 'Il mistero della bandiera', 1, 1, 'omicidio', 'HBORAL34C91E401W'),
(85, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', 'La maschera di bellezza', 1, 1, 'spionaggio', 'HIUBWC48S11W075N'),
(86, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', 'L\'ultimo messaggio', 1, 0, 'ricerca', 'EMCRAJ52W88I906Y'),
(88, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Il diplomatico', 1, 0, 'spionaggio', 'DMTSUP71S31A293U'),
(89, 'Una famiglia mentre &egrave; in vacanza viene derubata di tutti i beni preziosi in casa. L\'abitazione &egrave; collocata nelle campagne padove.', 'Grosso furto in campagna', 0, 0, 'furto', 'EGWYML53H52V479I'),
(91, 'Marrry, una bimba di soli 3 anni di una riccaaaa famiglia romana, &egrave; stataa rapiiita ddda una famosa bandaaa in cerrrcaaa di soldiiii.', 'La piccola Mary', 0, 0, 'ricatto', 'EGWYML53H52V479I'),
(93, 'E\' sparito il cane di un famoso avvocato milanese che amava saltellare per la campagna. Le ricerche si concetrerrano l&agrave;.', 'Il cane salterino', 1, 1, 'ricerca', 'CYDTFN83D62O801H'),
(98, 'Dei cani randagi si aggirano per la citt&agrave; spaventando i bambini e rubando cibo dalle macellerie.', 'La banda dei cani randagi', 0, 0, 'furto', 'DMTSUP71S31A293U'),
(99, 'Investigando, Conan scopre che il colpevole è Naoki, compagno di squadra del calciatore, invidioso del successo del suo rivale.', 'Pesca sulla casa galleggiante', 1, 1, 'ricatto', 'DMTSUP71S31A293U');

INSERT INTO `investigazione` (`numero`, `caso`, `data_inizio`, `data_termine`, `rapporto`, `ore_totali`) VALUES
(1, 28, '2018-01-03', NULL, '', 5),
(1, 62, '2018-01-04', NULL, '', 0),
(1, 70, '2018-01-03', NULL, '', 0),
(1, 89, '2018-01-03', NULL, 'E\' stato trovato un gioiello rubato.', 6),
(1, 98, '2018-01-06', NULL, '', 0),
(1, 99, '2018-01-06', NULL, '', 0),
(2, 28, '2018-01-03', NULL, '', 20),
(2, 62, '2018-01-04', NULL, '', 0),
(2, 70, '2018-01-03', NULL, '', 0),
(2, 89, '2018-01-03', '2018-01-05', 'Investigazione molto bella', 8),
(2, 99, '2018-01-06', NULL, '', 0),
(3, 28, '2018-01-03', NULL, '', 18),
(3, 62, '2018-01-04', NULL, '', 0),
(3, 70, '2018-01-03', NULL, '', 0),
(3, 99, '2018-01-06', NULL, '', 0),
(4, 70, '2018-01-03', NULL, '', 0),
(5, 70, '2018-01-03', NULL, '', 0),
(6, 70, '2018-01-03', NULL, '', 0),
(7, 70, '2018-01-03', NULL, '', 0),
(8, 70, '2018-01-03', NULL, '', 0),
(9, 70, '2018-01-04', '2018-01-05', 'Non &egrave; stata trovata alcuna traccia del bambino.', 5);

INSERT INTO `scena_investigazione` (`slug`, `nome`, `descrizione`, `citta`, `indirizzo`, `investigazione`, `caso`)
VALUES
	('Abitazione-della-famiglia-89-2', 'Abitazione della famiglia', 'Casa di campagna con grande portico fuori citt&agrave;', 'via Agripolis 35', 'Padova (PD)', 2, 89),
	('campeggio-70-9', 'campeggio', 'campeggio Santa Maria', 'via Pascoli 11', 'Padova (PD)', 9, 70),
	('Magazzino-89-1', 'Magazzino', 'Magazzino di merce rubata', 'via Ladri 666', 'Padova (PD)', 1, 89);

INSERT INTO `etichettamento` (`caso`, `tag`) VALUES
	(1, 'esplosione'),
	(2, 'rosa'),
	(2, 'sparatoia'),
	(2, 'terrorismo'),
	(6, 'foto'),
	(8, 'sparatoia'),
	(11, 'annegamento'),
	(11, 'stanza-senza-scasso'),
	(13, 'annegamento'),
	(24, 'stanza-senza-scasso'),
	(28, 'perla-dei-borgia'),
	(51, 'servizi-segreti'),
	(51, 'sparatoia'),
	(51, 'terrorismo'),
	(53, 'rosa'),
	(55, 'rosa'),
	(55, 'servizi-segreti'),
	(57, 'terrorismo'),
	(61, 'foto'),
	(62, 'foto'),
	(70, 'esplosione'),
	(70, 'foto'),
	(81, 'perla-dei-borgia'),
	(81, 'stanza-senza-scasso'),
	(85, 'esplosione'),
	(85, 'servizi-segreti');

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
	('HMXYNS02J87C389K', '3850', 'CSGXUL75K55F717I');

INSERT INTO `risoluzione` (`criminale`, `caso`)
VALUES
	('ADFHZU44F80D493Y', 76),
	('AIOQFT77Z44U137U', 99),
	('AKGZBM25T22L754P', 51),
	('AKGZBM25T22L754P', 70),
	('AKGZBM25T22L754P', 72),
	('BQKGPR94U93S152F', 77),
	('CPNBTG50G79H396V', 81),
	('CUTYLZ95T47N989E', 62),
	('CUTYLZ95T47N989E', 93),
	('DESHZT72V96Y669T', 55),
	('DNZTQS09G31N173A', 28),
	('DNZTQS09G31N173A', 85);

INSERT INTO `lavoro` (`investigatore`, `investigazione`, `caso`, `ore_lavoro`)
VALUES
	('WMEPSF32N04Y001I', 1, 28, 5),
	('WMEPSF32N04Y001I', 1, 62, 0),
	('WMEPSF32N04Y001I', 1, 70, 0),
	('WMEPSF32N04Y001I', 1, 89, 6),
	('WMEPSF32N04Y001I', 1, 98, 0),
	('WMEPSF32N04Y001I', 1, 99, 0),
	('WMEPSF32N04Y001I', 2, 28, 20),
	('WMEPSF32N04Y001I', 2, 62, 0),
	('WMEPSF32N04Y001I', 2, 70, 0),
	('WMEPSF32N04Y001I', 2, 89, 8),
	('WMEPSF32N04Y001I', 2, 99, 0),
	('WMEPSF32N04Y001I', 3, 62, 0),
	('WMEPSF32N04Y001I', 3, 70, 0),
	('WMEPSF32N04Y001I', 3, 99, 0),
	('WMEPSF32N04Y001I', 4, 70, 0),
	('WMEPSF32N04Y001I', 5, 70, 0),
	('WMEPSF32N04Y001I', 6, 70, 0),
	('WMEPSF32N04Y001I', 7, 70, 0),
	('WMEPSF32N04Y001I', 8, 70, 0),
	('WMEPSF32N04Y001I', 9, 70, 5),
	('XILADC61X36M430P', 3, 28, 18);

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
