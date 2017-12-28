/**
  * L'ordine è importante a causa delle chiavi esterne. Non si può droppare una
  * tabella se prima non si droppano quelle relazionate come FOREIGN KEY
 */
DROP TABLE IF EXISTS amministratore, amministratore_aziendale, cittadino, etichettamento, ispettore, lavoro, prova, risoluzione, scena_investigazione, tag;
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

CREATE TABLE prova (
  codice INTEGER(10) auto_increment PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descrizione TEXT NOT NULL,
  locazione VARCHAR(100) NOT NULL,
  investigazione TINYINT NOT NULL,
  caso INTEGER(10) NOT NULL,
  FOREIGN KEY (investigazione, caso) REFERENCES investigazione(numero, caso) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ispettore (
  codice_fiscale VARCHAR(16) PRIMARY KEY,
  codice_distretto VARCHAR(30) NOT NULL,
  codice_fiscale_direttore VARCHAR(16) NOT NULL,
  FOREIGN KEY (codice_fiscale) REFERENCES cliente(codice_fiscale) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE amministratore_aziendale (
  codice_fiscale VARCHAR(16) PRIMARY KEY,
  vat VARCHAR(16) NOT NULL UNIQUE,
  settore VARCHAR(50) NOT NULL,
  nome_azienda VARCHAR(50) NOT NULL UNIQUE,
  FOREIGN KEY (codice_fiscale) REFERENCES cliente(codice_fiscale) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE cittadino (
  codice_fiscale VARCHAR(16) PRIMARY KEY,
  data_nascita DATE NOT NULL,
  professione VARCHAR(50),
  codice_fiscale_compagno VARCHAR(16),
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
INSERT INTO tag(slug, nome, descrizione)
VALUES 
('perla-dei-borgia', 'Perla dei Borgia', 'Perla dei Boargia del Royal Regent Museum'),
('annegamento', 'Annegamento', NULL),
('sparatoia', 'Sparatoia', NULL),
('rosa', 'Rosa', 'Il colpevole sembra amare il colore rosa'),
('stanza-senza-scasso', 'Stanza senza scasso', 'Il crimine è avvuto in una stanza chiusa dall\'interno senza apparente segno di scasso'),
('servizi-segreti', 'Servizi segreti', NULL),
('esplosione', 'esplosione', 'Il caso riguardo l\'esplosione di qualcosa'),
('foto', 'Foto', NULL),
('cellulare', 'Cellulare', NULL),
('terrorismo', 'Terrorismo', NULL);
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

INSERT INTO `caso` (`codice`, `descrizione`, `nome`, `passato`, `risolto`, `tipologia`, `cliente`)
VALUES
	(1, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.', 'Il grande gioco	', 1, 1, 'ricerca', 'AMGSOU02T42U148D'),
	(2, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', 'Uno studio in rosa', 0, 0, 'ricatto', 'EPRTQI78Y89U201V'),
	(6, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Un caso di identita', 1, 1, 'ricerca', 'CYDTFN83D62O801H'),
	(8, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', 'I cinque semi d\'arancio', 1, 1, 'omicidio', 'CYDTFN83D62O801H'),
	(11, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', 'L\'avventura della banda maculata', 0, 0, 'omicidio', 'BKWTGV11X72P857I'),
	(13, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', 'L\'avventura del pollice dell\'ingegnere', 1, 1, 'ricerca', 'GYWIJZ29Y78P151J'),
	(24, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', 'L\'avventura del carbonchio azzurro 2', 1, 1, 'furto', 'EPRTQI78Y89U201V'),
	(28, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', 'I mastini di Baskerville	', 0, 0, 'omicidio', 'BSCAXW18H42R366I'),
	(38, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', 'Il segno dei tre	2', 0, 0, 'ricatto', 'AMGSOU02T42U148D'),
	(51, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', 'Il caso di San Valentino', 1, 1, 'omicidio', 'EBZPSK96V72C394W'),
	(53, 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', 'Mistero al museo', 0, 0, 'ricerca', 'DMTSUP71S31A293U'),
	(54, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', 'Il festival di primavera', 1, 1, 'ricatto', 'BKWTGV11X72P857I'),
	(55, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.', 'Il calciatore ricattato', 1, 1, 'omicidio', 'GMWBVD23K54N412F'),
	(57, 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', 'Una bambina da salvare', 1, 1, 'spionaggio', 'EMCRAJ52W88I906Y'),
	(61, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', 'Rapina ai grandi magazzini', 0, 0, 'ricerca', 'BARTCQ79P64W004H'),
	(62, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.', 'Oggi sposi', 0, 0, 'spionaggio', 'CYDTFN83D62O801H'),
	(65, 'Aenean sit amet justo. Morbi ut odio.', 'La casa del mistero', 1, 1, 'furto', 'GMWBVD23K54N412F'),
	(66, 'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', 'Terrore sul set', 0, 0, 'furto', 'AMGSOU02T42U148D'),
	(70, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', 'Gita nel mistero', 0, 0, 'ricerca', 'AOTFCB94S88D323S'),
	(72, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Un avvocato nel mistero', 1, 1, 'ricatto', 'GYWIJZ29Y78P151J'),
	(76, 'Ut at dolor quis odio consequat varius. Integer ac leo.', 'L\'uomo bendato', 1, 1, 'furto', 'DIWQEL90U14W018A'),
	(77, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', 'Chi ha paura del dentista', 1, 1, 'omicidio', 'GMWBVD23K54N412F'),
	(81, 'Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', 'Il mistero della bandiera', 0, 0, 'omicidio', 'HBORAL34C91E401W'),
	(85, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', 'La maschera di bellezza', 0, 0, 'spionaggio', 'HIUBWC48S11W075N'),
	(86, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', 'L\'ultimo messaggio', 1, 1, 'ricerca', 'EMCRAJ52W88I906Y'),
	(88, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Il diplomatico', 1, 1, 'spionaggio', 'DMTSUP71S31A293U');

INSERT INTO `investigazione` (`numero`, `caso`, `data_inizio`, `data_termine`, `rapporto`, `ore_totali`)
VALUES
	(1, 1, '1937-04-30', '1937-05-30', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 0),
	(1, 2, '1977-12-07', '1978-01-07', 'In congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.', 281),
	(1, 6, '1987-03-05', '1987-04-05', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 409),
	(1, 8, '1972-09-26', '1972-10-26', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.', 0),
	(1, 11, '1936-09-07', '1936-10-07', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.\n\nVestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.\n\nDuis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 0),
	(1, 13, '1922-02-13', '1922-03-13', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 0),
	(1, 24, '1936-04-17', '1936-05-17', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 51),
	(1, 28, '1895-04-07', '1895-05-07', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.', 276),
	(1, 38, '1929-10-16', '1929-11-16', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 0),
	(1, 57, '1996-08-23', '1996-09-23', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 157),
	(1, 61, '2016-03-17', '2016-04-17', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 263),
	(1, 62, '1896-11-14', '1896-12-14', 'In congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.\n\nNam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 0),
	(1, 65, '1890-10-15', '1890-11-15', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 109),
	(1, 81, '1905-11-18', '1905-12-18', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 191),
	(1, 86, '1950-12-09', '1951-01-09', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 0),
	(1, 88, '1903-06-08', '1903-07-08', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 61),
	(2, 2, '1923-03-08', '1923-04-08', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 21),
	(2, 11, '2017-01-03', '2017-02-27', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 426),
	(2, 28, '1994-04-10', '1994-05-10', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.', 655),
	(2, 65, '1992-10-27', '1992-11-27', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 0),
	(2, 81, '1996-05-29', '1996-06-29', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 411),
	(2, 88, '1961-12-09', '1962-01-09', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 609),
	(3, 2, '2002-04-18', '2002-05-18', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 0),
	(3, 28, '1957-04-18', '1957-05-18', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 664),
	(3, 65, '1891-02-18', '1891-03-18', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 194),
	(4, 28, '2017-01-01', '2017-01-30', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 221);

INSERT INTO `scena_investigazione` (`slug`, `nome`, `descrizione`, `citta`, `indirizzo`, `investigazione`, `caso`)
VALUES
	('ac', 'ac', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'Soweto', '64640 Prairie Rose Plaza', 1, 8),
	('accumsan', 'accumsan', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.\n\nDuis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Baizhang', '40467 Luster Road', 1, 62),
	('cras', 'cras', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Paris 01', '3 Ronald Regan Terrace', 2, 65),
	('enim', 'enim', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Atbasar', '3 Sullivan Center', 4, 28),
	('et', 'et', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Kunting', '6 Schurz Pass', 1, 38),
	('iaculis', 'iaculis', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Libertad', '91 Chive Point', 1, 65),
	('in', 'in', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Leeuwarden', '4 Morrow Trail', 1, 88),
	('ipsum', 'ipsum', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Cigemlong', '54024 Bonner Center', 2, 65),
	('maecenas', 'maecenas', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Cepões', '04 Rutledge Trail', 1, 1),
	('mi', 'mi', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Astypálaia', '2309 Hooker Drive', 1, 13),
	('nec', 'nec', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'Sarongan', '235 Dunning Parkway', 1, 2),
	('non', 'non', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Bloemhof', '104 Graedel Way', 1, 38),
	('nullam', 'nullam', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'San Miguel', '382 Charing Cross Trail', 2, 11),
	('odio', 'odio', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Cachí', '420 Vernon Junction', 1, 88),
	('ornare', 'ornare', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'Ōmuta', '6 Springs Point', 1, 61),
	('pede', 'pede', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Cepões', '04 Rutledge Trail', 1, 1),
	('pellentesque', 'pellentesque', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 'Charleston', '7 Bartelt Way', 1, 81),
	('porta', 'porta', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'Veřovice', '8435 Ronald Regan Lane', 1, 28),
	('pretium', 'pretium', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Oruro', '12 Gateway Place', 1, 62),
	('scelerisque', 'scelerisque', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Louisville', '42 Harbort Court', 1, 65),
	('sed', 'sed', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Marsaxlokk', '319 Elka Terrace', 1, 88),
	('tincidunt', 'tincidunt', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Březová nad Svitavou', '9 Evergreen Road', 1, 61),
	('vulputate', 'vulputate', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'Juan de Acosta', '87538 Tennessee Park', 1, 24);

INSERT INTO `etichettamento` (`caso`, `tag`)
VALUES
	(11, 'annegamento'),
	(13, 'annegamento'),
	(70, 'annegamento'),
	(70, 'cellulare'),
	(1, 'esplosione'),
	(70, 'esplosione'),
	(85, 'esplosione'),
	(6, 'foto'),
	(61, 'foto'),
	(62, 'foto'),
	(70, 'foto'),
	(28, 'perla-dei-borgia'),
	(81, 'perla-dei-borgia'),
	(53, 'rosa'),
	(55, 'rosa'),
	(51, 'servizi-segreti'),
	(55, 'servizi-segreti'),
	(85, 'servizi-segreti'),
	(2, 'sparatoia'),
	(8, 'sparatoia'),
	(51, 'sparatoia'),
	(11, 'stanza-senza-scasso'),
	(24, 'stanza-senza-scasso'),
	(81, 'stanza-senza-scasso'),
	(2, 'terrorismo'),
	(51, 'terrorismo'),
	(57, 'terrorismo');

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

INSERT INTO `prova` (`codice`, `nome`, `descrizione`, `locazione`, `investigazione`, `caso`)
VALUES
	(13, 'project', 'Fusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'magazzino2', 1, 86),
	(17, 'Enterprise-wide', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'deposito_polizia', 3, 2),
	(19, 'encoding', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'magazzino2', 1, 65),
	(20, 'Compatible', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'magazzino2', 2, 65),
	(25, 'discrete', 'Fusce consequat. Nulla nisl. Nunc nisl.', 'magazzino1', 2, 81),
	(27, 'Multi-channelled', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'deposito_polizia', 1, 81),
	(28, 'static', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'magazzino2', 2, 88),
	(34, 'emulation', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'magazzino2', 1, 13),
	(38, 'system engine', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'magazzino1', 1, 65),
	(39, 'ability', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'deposito_polizia', 1, 28),
	(43, 'optimizing', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.\n\nVestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'magazzino2', 1, 28),
	(45, 'Switchable', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'magazzino2', 1, 38),
	(48, 'coherent', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'magazzino1', 1, 62),
	(64, 'solution', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'deposito_polizia', 1, 65),
	(67, 'multi-tasking', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'magazzino2', 1, 62),
	(72, 'Re-engineered', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'magazzino1', 1, 8),
	(75, 'Multi-layered', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'magazzino1', 2, 65),
	(76, 'Cloned', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'magazzino1', 2, 28),
	(78, 'algorithm', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'deposito_polizia', 1, 1),
	(84, 'real-time', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 'deposito_polizia', 1, 57),
	(89, 'executive', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'magazzino1', 1, 81),
	(96, 'upward-trending', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'deposito_polizia', 2, 28),
	(100, 'secondary', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.\n\nDuis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'magazzino1', 4, 28);

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

INSERT INTO `amministratore_aziendale` (`codice_fiscale`, `vat`, `settore`, `nome_azienda`)
VALUES
	('AMGSOU02T42U148D', 'MB845621236', 'gaming', 'Flashset'),
	('AOTFCB94S88D323S', 'MB845621232', 'automotive', 'Jaxbean');

INSERT INTO `cittadino` (`codice_fiscale`, `data_nascita`, `professione`, `codice_fiscale_compagno`)
VALUES
	('BARTCQ79P64W004H', '1944-05-02', 'Teacher', 'LOPWFY44D01A812F');

INSERT INTO `risoluzione` (`criminale`, `caso`)
VALUES
	('AKGZBM25T22L754P', 51),
	('CUTYLZ95T47N989E', 62),
	('AKGZBM25T22L754P', 72),
	('ADFHZU44F80D493Y', 76);

INSERT INTO `lavoro` (`investigatore`, `investigazione`, `caso`, `ore_lavoro`)
VALUES
	('WMEPSF32N04Y001I', 1, 65, 109),
	('XILADC61X36M430P', 3, 28, 295),
	('XYBJLN62N21X682T', 2, 88, 347),
	('YRWNCB73I96G468M', 1, 6, 109);

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
