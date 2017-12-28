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
  FOREIGN KEY (tipologia) REFERENCES tariffa(tipologia_caso) ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (cliente) REFERENCES cliente(codice_fiscale) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE investigazione (
  numero TINYINT,
  caso INTEGER(10),
  data_inizio DATE NOT NULL,
  data_termine DATE,
  rapporto TEXT,
  ore_totali SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (numero, caso),
  FOREIGN KEY (caso) REFERENCES caso(codice) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE scena_investigazione (
  slug VARCHAR(50) PRIMARY KEY,
  nome VARCHAR(50) NOT NULL UNIQUE,
  descrizione TEXT NOT NULL,
  citta VARCHAR(100),
  indirizzo VARCHAR(100),
  investigazione TINYINT,
  caso INTEGER(10),
  FOREIGN KEY (investigazione, caso) REFERENCES investigazione(numero, caso) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE etichettamento (
  caso INTEGER(10),
  tag VARCHAR(50),
  PRIMARY KEY (caso, tag),
  FOREIGN KEY (caso) REFERENCES caso(codice) ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (tag) REFERENCES tag(slug) ON DELETE NO ACTION ON UPDATE CASCADE
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
  FOREIGN KEY (investigazione, caso) REFERENCES investigazione(numero, caso) ON DELETE NO ACTION ON UPDATE CASCADE
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
  FOREIGN KEY (criminale) REFERENCES criminale(codice_fiscale) ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (caso) REFERENCES caso(codice) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE lavoro (
  investigatore VARCHAR(16),
  investigazione TINYINT,
  caso INTEGER(10),
  ore_lavoro SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (investigatore, investigazione, caso),
  FOREIGN KEY (investigatore) REFERENCES investigatore(codice_fiscale) ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (investigazione, caso) REFERENCES investigazione(numero, caso) ON DELETE NO ACTION ON UPDATE CASCADE
);

insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('YRWNCB73I96G468M', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Patrick', 'Gonzalez');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('QYOFKD67M46O619X', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Mildred', 'Arnold');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('SQDMIH91E22G439U', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jeremy', 'Brooks');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('EACOSZ97O58M305T', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Edward', 'Walker');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('ZJPRNW27Q98E957V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Antonio', 'Palmer');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('HLAKWZ42Y64H379U', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ruth', 'Banks');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('ONPXJH44H09A891B', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Diane', 'Frazier');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('IPOCLN85C04P396D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Gregory', 'Murray');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('QDTBJN76I47W472G', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Patricia', 'Evans');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('TKINRX34C13C023K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jose', 'Olson');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('HCISDQ80Q69W849I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'George', 'Griffin');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('BQDMRS64X79K409E', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Harold', 'Reed');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('JQHNFZ56A46J754B', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jeremy', 'Sanchez');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('CKVRDJ25B52N184K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jimmy', 'Edwards');
insert into amministratore (codice_fiscale, password_hash, nome, cognome) values ('TIQYOM49D23J164Q', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Samuel', 'Nelson');

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
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('CYDTFN83D62O801H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Andrew', 'Marshall', 'Albi', '446 Forest Dale Parkway');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('RMSVPJ12E06P994U', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Matthew', 'Wheeler', 'Sukaraja', '9 Eastlawn Terrace');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('KNMRLP43R96Y949J', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Judy', 'Rose', 'Riangkroko', '0955 Farragut Place');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('AOTFCB94S88D323S', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'James', 'Watson', 'Boulogne-sur-Mer', '2796 American Lane');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('VMQEJZ38Y13H905B', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Eric', 'Alexander', 'Wentai', '4 Pearson Court');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('TFUDBC18W30V753E', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Elizabeth', 'Riley', 'Jacksonville', '2 Lakewood Lane');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('HQRVFL93R01P879Y', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Deborah', 'Edwards', 'Zhengdun', '60 Stang Court');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('TIHJUC06C68R524A', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Eric', 'Cook', 'Vogar', '7305 Lillian Avenue');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('XAQWPB74E93I993E', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Mark', 'Garza', 'Oke Mesi', '56 Amoth Parkway');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('QNOJES83S53W988H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Earl', 'Mills', 'Al Lagowa', '86 Veith Junction');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('HBORAL34C91E401W', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Theresa', 'Bailey', 'Lushan', '40444 7th Plaza');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('HLPRKC83I35V546H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Sara', 'Allen', 'Veřovice', '8435 Ronald Regan Lane');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('NJMEYH03M57C669D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Matthew', 'King', 'Balrothery', '13 Vahlen Parkway');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('HXULSE22E51S717I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Steven', 'Alvarez', 'Cergy-Pontoise', '9 Thierer Terrace');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('TFJLPA10Y55S860J', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Angela', 'Reynolds', 'Madrid', '096 Melody Junction');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('YKSOUC25C67E930A', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Harold', 'Long', 'Iset’', '857 Norway Maple Park');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('UDHIKT82U77V282R', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jane', 'Thompson', 'Entre Rios', '85050 Maple Wood Circle');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('UODTQV22N12S229K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Teresa', 'Hunter', 'Vogar', '7305 Lillian Avenue');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('HXAEBT11F92L476K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Willie', 'Banks', 'Kozhva', '659 Dexter Way');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('RHSCJF35F27T566D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Doris', 'Woods', 'Huitán', '9932 Golf Course Road');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('VTHXKA28Y42K903I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Steve', 'Hawkins', 'Caxias', '411 Warbler Place');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('KXFLRG41V44C012N', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Michael', 'Webb', 'Arlington', '2113 Dovetail Parkway');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('HMXYNS02J87C389K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Eric', 'Gomez', 'Dondo', '295 Declaration Circle');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('ODEGLR69G25P179Z', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Rose', 'Henderson', 'Drenova', '78 Coleman Center');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('ZWJKVL29V84W243U', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Patricia', 'Lynch', 'Jiubao', '77929 Sutteridge Hill');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('THCIQS63Z21D234V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jeffrey', 'Medina', 'Huanfeng', '25 Golf View Place');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('AMGSOU02T42U148D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Julia', 'Little', 'Cristóbal', '37660 Corscot Lane');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('QYIATG69M29F648O', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Michelle', 'Payne', 'Guocun', '02154 Bluestem Road');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('EGWYML53H52V479I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Anna', 'Kim', 'Täby', '4 Paget Drive');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('TNOUCX84P89Z484F', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Daniel', 'Butler', 'Puyo', '71496 Bayside Way');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('YTOJSV02M26W769S', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Stephanie', 'Mccoy', 'Rila', '0 Delaware Hill');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('VUMTIS85O67U302B', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Wayne', 'Cook', 'Tamansari', '6 Crest Line Circle');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('HNQSZY85V83W309H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Diane', 'Barnes', 'Cilangkap', '1 Mayfield Circle');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('ZUOCTK93Q57W512K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Amanda', 'Andrews', 'Hetang', '9758 Hazelcrest Place');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('LMAZQD65D94N338U', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Anna', 'Austin', 'Shangxian', '207 Stuart Street');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('NKFAQS92P26L797N', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Cheryl', 'Lee', 'Dankama', '4 Londonderry Trail');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('CGVBXZ84F14Q859X', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Howard', 'Baker', 'Novoorsk', '6773 Shelley Plaza');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('BDLNUQ87A74N842Q', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Betty', 'Owens', 'Senhor do Bonfim', '3526 Ohio Place');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('OPSJXQ88J70X471H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jonathan', 'Ross', 'Tiecun', '7483 Myrtle Center');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('BSCAXW18H42R366I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jimmy', 'Dixon', 'Sarae', '9 Butternut Park');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('SGPVYC54K37Y614E', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jerry', 'Bennett', 'Boston', '769 Sundown Lane');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('EMCRAJ52W88I906Y', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ryan', 'Moreno', 'Ziębice', '08931 Reinke Way');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('WCUSXA52S95N012G', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Charles', 'Sanders', 'Moguqi', '136 Dennis Terrace');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('GKXSOF27U19Y632J', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Denise', 'Peterson', 'Provins', '517 Everett Pass');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('NZURQW07V26W613Y', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Stephanie', 'Taylor', 'Hongguang', '42855 Manufacturers Court');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('NWRYLK01G00Q732N', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ruby', 'Cruz', 'Capão da Canoa', '95 Bonner Way');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('KZIBJF78Z54T297D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jennifer', 'Frazier', 'Gajiram', '79067 West Point');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('UFNEQV92N24W661C', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Sharon', 'Myers', 'Dutsin Ma', '3663 Dexter Place');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('MEUGSC51Y39J574X', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Howard', 'Myers', 'Weiwangzhuang', '04 Wayridge Street');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('SLWRXP97P00K363V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Bruce', 'Williamson', 'Ndélé', '1 Merry Alley');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('DIWQEL90U14W018A', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Mark', 'Long', 'São José de Mipibu', '9760 Forest Run Terrace');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('HKYQIE50Y39F640D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Gary', 'Warren', 'Cilangkap', '1 Mayfield Circle');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('NPQVRH26L99O487X', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Gerald', 'Miller', 'Palpalá', '359 Buhler Street');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('KGICND54Y87D287H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jason', 'Ward', 'Dijon', '08197 Alpine Avenue');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('BOUGHZ41R27X483Z', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Johnny', 'Bryant', 'Castleblayney', '74 Lake View Terrace');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('RBFELH44P82Q132O', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jeremy', 'Black', 'Areeiro', '90 Larry Alley');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('GYWIJZ29Y78P151J', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'John', 'Harrison', 'Matias Olímpio', '53226 Lindbergh Pass');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('UXCTMI91A28B223O', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Anthony', 'Jones', 'Jiyizhuang', '77060 Veith Lane');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('QKVRSB10K24S736H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Sean', 'Sims', 'Sanlanbahai', '500 Hazelcrest Hill');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('PKMNSJ13A54Y926P', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Norma', 'Morales', 'Weiwangzhuang', '04 Wayridge Street');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('GMWBVD23K54N412F', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Annie', 'Gutierrez', 'Fátima', '2455 Morningstar Parkway');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('OKBQMX01V32Z767H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Donald', 'Anderson', 'Swedru', '5 Merchant Crossing');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('IRZAJM89I68C301T', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Philip', 'Fisher', 'Aeka', '96 Kinsman Avenue');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('DMTSUP71S31A293U', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Lillian', 'Carroll', 'Kissónerga', '64 Bellgrove Lane');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('JDFCYQ74B58S276E', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Andrea', 'Jenkins', 'Tuwa', '13633 Canary Place');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('HNTBFL70J16W581N', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Martin', 'Graham', 'Gaoqiao', '61412 Eagle Crest Place');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('LWGEOX97W88F725Q', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Lillian', 'Morales', 'Wujingfu', '821 Commercial Terrace');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('WJRXVO39T77P821G', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Shirley', 'Washington', 'Klimontów', '3608 Myrtle Court');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('LKYCTP73V98J114E', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Donna', 'Kelley', 'Ferreira do Zêzere', '42 Holmberg Point');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('MJXUBS60T73U000G', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Lois', 'Rice', 'Rennes', '53 Northridge Avenue');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('ISKUAE91Y92T572K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Marie', 'Berry', 'Wiang Chiang Rung', '3 Magdeline Crossing');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('KZFVWL47Q21T073C', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Barbara', 'Castillo', 'Cheongsong gun', '51643 Forest Dale Junction');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('EGZTYL91X92S437X', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Sharon', 'Weaver', 'Bielice', '44 Dexter Pass');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('TRZQDY44I41H385D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Emily', 'Carpenter', 'Göteborg', '027 Hoepker Court');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('WSTVXH36G23E853Z', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Larry', 'Cooper', 'Paranapanema', '7197 Grayhawk Center');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('HNKIOQ68X17J011N', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Bonnie', 'Clark', 'Gazimurskiy Zavod', '9 Corben Crossing');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('WUBTSM78X70C518U', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Juan', 'Ortiz', 'Selizharovo', '168 Rutledge Terrace');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('PDMQGO08G81P115R', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Tammy', 'Kim', 'Himaya', '2288 Laurel Parkway');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('EPRTQI78Y89U201V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Lillian', 'Dunn', 'Zhengdun', '60 Stang Court');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('XUYFEV81T94F087T', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Larry', 'Jones', 'Casal da Anja', '9035 Myrtle Park');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('LKHFMC28J43D552S', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Margaret', 'Watson', 'Caluquembe', '2 Del Sol Place');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('ZLGYAQ73C19V347E', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'George', 'Wright', 'Paris 07', '38627 Becker Parkway');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('IWOGRM32I54V417G', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jean', 'Larson', 'Hägersten', '06323 Anthes Drive');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('UFCLNM80G61L837A', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Brandon', 'Morrison', 'Grujugan', '63 Moulton Crossing');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('QSUPOL93H30M238B', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Lois', 'Alvarez', 'Dupnitsa', '7471 Barby Street');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('KAIVWL36Z49Y360J', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Scott', 'Elliott', 'Sendafa', '55 Hudson Place');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('HIUBWC48S11W075N', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Lois', 'Kim', 'Changshou', '4908 Hermina Lane');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('BKWTGV11X72P857I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Terry', 'Cruz', 'Huitán', '9932 Golf Course Road');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('UJCFRT85K88S107L', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Karen', 'Gordon', 'Da’an', '05 Schmedeman Circle');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('GDPXQF93J29D590I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Irene', 'Jordan', 'Dankama', '4 Londonderry Trail');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('ZUELVH09T10O307C', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Tina', 'Freeman', 'Marathon', '09019 Ohio Pass');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('MRWGLN45Y12N351R', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Kathleen', 'Jenkins', 'Tamansari', '6 Crest Line Circle');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('YINTFQ59R04V058R', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Catherine', 'Warren', 'Shangxian', '207 Stuart Street');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('QYWZSD26L71N133I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Antonio', 'Mcdonald', 'Göteborg', '027 Hoepker Court');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('EBZPSK96V72C394W', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ann', 'Jenkins', 'Lushan', '40444 7th Plaza');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('BARTCQ79P64W004H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Raymond', 'Cooper', 'Bielice', '44 Dexter Pass');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('PUXKTN70V66W017O', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Elizabeth', 'Moreno', 'Bugis', '80 Luster Court');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('VRJECZ43M60R161Y', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ruth', 'Medina', 'Melipilla', '7 Manley Court');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('NWHYQK28Q80W469K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Anne', 'Hansen', 'Oshawa', '011 Oriole Hill');
insert into cliente (codice_fiscale, password_hash, nome, cognome, citta, indirizzo) values ('BCOTMU96P27J118X', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Elizabeth', 'Hanson', 'Oshawa', '011 Oriole Hill');
INSERT INTO `caso` (`codice`, `descrizione`, `nome`, `passato`, `risolto`, `tipologia`, `cliente`)
VALUES
	(1, 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.', 'Il grande gioco	', 1, 1, 'ricerca', 'AMGSOU02T42U148D'),
	(2, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', 'Uno studio in rosa', 0, 0, 'ricatto', 'EPRTQI78Y89U201V'),
	(3, 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'Uno scandalo in Boemia', 0, 0, 'omicidio', 'ODEGLR69G25P179Z'),
	(4, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.', 'Il banchiere cieco', 0, 0, 'ricerca', 'HXAEBT11F92L476K'),
	(5, 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'La Lega dei Capelli Rossi', 0, 0, 'spionaggio', 'PKMNSJ13A54Y926P'),
	(6, 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Un caso di identita', 1, 1, 'ricerca', 'CYDTFN83D62O801H'),
	(7, 'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Il mistero di Boscombe Valley', 1, 1, 'furto', 'ISKUAE91Y92T572K'),
	(8, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', 'I cinque semi d\'arancio', 1, 1, 'omicidio', 'CYDTFN83D62O801H'),
	(9, 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.', 'L\'uomo dal labbro spaccato', 1, 1, 'ricerca', 'THCIQS63Z21D234V'),
	(10, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', 'L\'avventura del carbonchio azzurro', 0, 0, 'ricerca', 'UJCFRT85K88S107L'),
	(11, 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', 'L\'avventura della banda maculata', 0, 0, 'omicidio', 'BKWTGV11X72P857I'),
	(12, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.', 'eget massa tempor convallis nulla', 1, 1, 'furto', 'QNOJES83S53W988H'),
	(13, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.', 'L\'avventura del pollice dell\'ingegnere', 1, 1, 'ricerca', 'GYWIJZ29Y78P151J'),
	(14, 'Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', 'L\'avventura del nobile scapolo', 1, 1, 'ricerca', 'RHSCJF35F27T566D'),
	(15, 'Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', 'L\'avventura del diadema di berilli', 1, 1, 'ricatto', 'NPQVRH26L99O487X'),
	(16, 'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'L\'avventura dei Faggi Rossi', 1, 1, 'spionaggio', 'HNTBFL70J16W581N'),
	(17, 'Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'Scandalo a Belgravia	', 1, 1, 'spionaggio', 'OPSJXQ88J70X471H'),
	(18, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', 'Uno scandalo in Boemia 2', 0, 0, 'ricatto', 'WJRXVO39T77P821G'),
	(19, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'La Lega dei Capelli Rossi 2', 0, 0, 'spionaggio', 'QSUPOL93H30M238B'),
	(20, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.', 'Un caso di identita 2', 1, 0, 'ricerca', 'WCUSXA52S95N012G'),
	(21, 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.', 'Il mistero di Boscombe Valley 2', 0, 0, 'omicidio', 'WSTVXH36G23E853Z'),
	(22, 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'I cinque semi d\'arancio 2', 0, 0, 'spionaggio', 'QSUPOL93H30M238B'),
	(23, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'L\'uomo dal labbro spaccato 2', 0, 0, 'spionaggio', 'QSUPOL93H30M238B'),
	(24, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', 'L\'avventura del carbonchio azzurro 2', 1, 1, 'furto', 'EPRTQI78Y89U201V'),
	(25, 'Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', 'L\'avventura della banda maculata 2', 0, 0, 'spionaggio', 'XUYFEV81T94F087T'),
	(26, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.', 'L\'avventura del pollice dell\'ingegnere 2', 0, 0, 'furto', 'UFCLNM80G61L837A'),
	(27, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', 'L\'avventura del nobile scapolo 2', 1, 1, 'ricerca', 'IWOGRM32I54V417G'),
	(28, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', 'I mastini di Baskerville	', 0, 0, 'omicidio', 'BSCAXW18H42R366I'),
	(29, 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', 'L\'avventura del diadema di berilli 2', 0, 0, 'ricerca', 'LWGEOX97W88F725Q'),
	(30, 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', 'L\'avventura dei Faggi Rossi 2', 0, 0, 'ricerca', 'KZIBJF78Z54T297D'),
	(31, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.', 'Uno studio in rosa 2', 1, 1, 'spionaggio', 'NWRYLK01G00Q732N'),
	(32, 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', 'Il banchiere cieco 2', 0, 0, 'furto', 'WSTVXH36G23E853Z'),
	(33, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Il grande gioco 2', 0, 0, 'ricerca', 'MEUGSC51Y39J574X'),
	(34, 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.', 'Scandalo a Belgravia 2', 1, 1, 'furto', 'HNKIOQ68X17J011N'),
	(35, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', 'I mastini di Baskerville 2', 1, 1, 'furto', 'SGPVYC54K37Y614E'),
	(36, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', 'Le cascate di Reichenbach	 2', 1, 1, 'furto', 'NZURQW07V26W613Y'),
	(37, 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'La casa vuota 2', 1, 1, 'spionaggio', 'QYWZSD26L71N133I'),
	(38, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', 'Il segno dei tre	2', 0, 0, 'ricatto', 'AMGSOU02T42U148D'),
	(39, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'L\'ultimo giuramento	2', 1, 1, 'omicidio', 'UODTQV22N12S229K'),
	(40, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.', 'L\'abominevole sposa	2', 0, 0, 'ricatto', 'THCIQS63Z21D234V'),
	(41, 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl.', 'Le sei Thatcher	', 0, 0, 'ricerca', 'TRZQDY44I41H385D'),
	(42, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque.', 'Il detective morente	', 0, 0, 'spionaggio', 'VTHXKA28Y42K903I'),
	(43, 'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.', 'Il problema finale	', 1, 1, 'ricatto', 'QNOJES83S53W988H'),
	(44, 'Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.', 'Uno studio in rosa 3', 1, 1, 'ricatto', 'IRZAJM89I68C301T'),
	(45, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Il banchiere cieco 3', 1, 1, 'omicidio', 'OKBQMX01V32Z767H'),
	(46, 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', 'Un piccolo grande detective\n', 0, 0, 'ricerca', 'XUYFEV81T94F087T'),
	(47, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', 'Una nuova vita\n', 0, 0, 'spionaggio', 'MJXUBS60T73U000G'),
	(48, 'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Avventura sul set', 1, 1, 'furto', 'JDFCYQ74B58S276E'),
	(49, 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.', 'Codice segreto: il pesce che brilla', 1, 1, 'omicidio', 'HNKIOQ68X17J011N'),
	(50, 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 'L\'esplosione del treno super rapido', 0, 0, 'ricatto', 'NZURQW07V26W613Y'),
	(51, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', 'Il caso di San Valentino', 1, 1, 'omicidio', 'EBZPSK96V72C394W'),
	(52, 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.', 'Un regalo al mese', 1, 1, 'ricerca', 'ZUOCTK93Q57W512K'),
	(53, 'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', 'Mistero al museo', 0, 0, 'ricerca', 'DMTSUP71S31A293U'),
	(54, 'Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', 'Il festival di primavera', 1, 1, 'ricatto', 'BKWTGV11X72P857I'),
	(55, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.', 'Il calciatore ricattato', 1, 1, 'omicidio', 'GMWBVD23K54N412F'),
	(56, 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', 'Il caso della sonata al chiaro di luna', 1, 1, 'ricatto', 'HXAEBT11F92L476K'),
	(57, 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', 'Una bambina da salvare', 1, 1, 'spionaggio', 'EMCRAJ52W88I906Y'),
	(58, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', 'Il messaggio misterioso', 1, 1, 'ricatto', 'XAQWPB74E93I993E'),
	(59, 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', 'Nessuna traccia', 0, 0, 'furto', 'PUXKTN70V66W017O'),
	(60, 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'I duellanti', 0, 0, 'ricatto', 'VUMTIS85O67U302B'),
	(61, 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', 'Rapina ai grandi magazzini', 0, 0, 'ricerca', 'BARTCQ79P64W004H'),
	(62, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.', 'Oggi sposi', 0, 0, 'spionaggio', 'CYDTFN83D62O801H'),
	(63, 'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', 'L\'abominevole sposa	', 0, 0, 'ricerca', 'QYIATG69M29F648O'),
	(64, 'Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh.', 'Paura in ascensore', 1, 1, 'ricatto', 'ZUOCTK93Q57W512K'),
	(65, 'Aenean sit amet justo. Morbi ut odio.', 'La casa del mistero', 1, 1, 'furto', 'GMWBVD23K54N412F'),
	(66, 'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.', 'Terrore sul set', 0, 0, 'furto', 'AMGSOU02T42U148D'),
	(67, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', 'Una crociera da brivido', 1, 0, 'ricerca', 'QSUPOL93H30M238B'),
	(68, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.', 'Il mistero della bella smemorata', 0, 0, 'ricerca', 'BCOTMU96P27J118X'),
	(69, 'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci.', 'Il rapimento', 1, 1, 'ricatto', 'KXFLRG41V44C012N'),
	(70, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante.', 'Gita nel mistero', 0, 0, 'ricerca', 'AOTFCB94S88D323S'),
	(71, 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', 'Misteri al computer', 0, 0, 'ricatto', 'IWOGRM32I54V417G'),
	(72, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Un avvocato nel mistero', 1, 1, 'ricatto', 'GYWIJZ29Y78P151J'),
	(73, 'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.', 'Giallo in diretta', 1, 1, 'ricerca', 'NWHYQK28Q80W469K'),
	(74, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst.', 'L\'appuntamento di Ran', 0, 0, 'furto', 'WJRXVO39T77P821G'),
	(75, 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'La caccia al tesoro', 1, 1, 'ricatto', 'QSUPOL93H30M238B'),
	(76, 'Ut at dolor quis odio consequat varius. Integer ac leo.', 'L\'uomo bendato', 1, 1, 'furto', 'DIWQEL90U14W018A'),
	(77, 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', 'Chi ha paura del dentista', 1, 1, 'omicidio', 'GMWBVD23K54N412F'),
	(78, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus.', 'Mistero a tutta velocita', 0, 0, 'ricatto', 'BCOTMU96P27J118X'),
	(79, 'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', 'L\'amico del cuore', 0, 0, 'ricerca', 'NKFAQS92P26L797N'),
	(80, 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'La giovane ereditiera', 1, 1, 'ricerca', 'HXULSE22E51S717I'),
	(81, 'Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', 'Il mistero della bandiera', 0, 0, 'omicidio', 'HBORAL34C91E401W'),
	(82, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis.', 'La grande festa', 1, 1, 'furto', 'LKYCTP73V98J114E'),
	(83, 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.', 'Il rapimento di Conan', 1, 1, 'ricatto', 'TFUDBC18W30V753E'),
	(84, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'Un compleanno esplosivo', 1, 0, 'spionaggio', 'YTOJSV02M26W769S'),
	(85, 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', 'La maschera di bellezza', 0, 0, 'spionaggio', 'HIUBWC48S11W075N'),
	(86, 'Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', 'L\'ultimo messaggio', 1, 1, 'ricerca', 'EMCRAJ52W88I906Y'),
	(87, 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.', 'Un tuffo nel giallo', 1, 1, 'ricatto', 'TRZQDY44I41H385D'),
	(88, 'Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Il diplomatico', 1, 1, 'spionaggio', 'DMTSUP71S31A293U'),
	(89, 'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio.', 'Una biblioteca di misteri', 0, 0, 'omicidio', 'IRZAJM89I68C301T'),
	(90, 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', 'Indagando sul campo da golf', 1, 1, 'omicidio', 'ZLGYAQ73C19V347E'),
	(91, 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', 'Il mistero del tempio', 1, 1, 'spionaggio', 'UJCFRT85K88S107L'),
	(92, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 'Chi è il colpevole?', 1, 1, 'furto', 'LKYCTP73V98J114E'),
	(93, 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Mistero sul treno', 1, 1, 'spionaggio', 'UFNEQV92N24W661C'),
	(94, 'In quis justo. Maecenas rhoncus aliquam lacus.', 'L\'impresa di pulizia', 0, 0, 'furto', 'VRJECZ43M60R161Y'),
	(95, 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Il club di Sherlock Holmes', 1, 1, 'ricerca', 'VRJECZ43M60R161Y'),
	(96, 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'Tra i disegni di un\'avventura', 0, 0, 'omicidio', 'TFUDBC18W30V753E'),
	(97, 'Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.', 'Il battello fantasma', 1, 0, 'spionaggio', 'NJMEYH03M57C669D'),
	(98, 'Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Ciak, si indaga', 0, 0, 'omicidio', 'MRWGLN45Y12N351R'),
	(99, 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.', 'Impronte digitali', 1, 1, 'ricerca', 'IRZAJM89I68C301T'),
	(100, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', 'Indagando nel buio', 1, 0, 'omicidio', 'YKSOUC25C67E930A');
INSERT INTO `investigazione` (`numero`, `caso`, `data_inizio`, `data_termine`, `rapporto`, `ore_totali`)
VALUES
	(1, 1, '1937-04-30', '1937-05-30', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 0),
	(1, 2, '1977-12-07', '1978-01-07', 'In congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.', 281),
	(2, 2, '1923-03-08', '1923-04-08', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 21),
	(3, 2, '2002-04-18', '2002-05-18', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 0),
	(1, 4, '1919-05-28', '1919-06-28', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 0),
	(2, 4, '1917-09-16', '1917-10-16', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 68),
	(3, 4, '1943-09-16', '1943-10-16', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 607),
	(1, 5, '1900-10-30', '1900-11-30', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 687),
	(1, 6, '1987-03-05', '1987-04-05', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 409),
	(1, 7, '1972-12-01', '1973-01-01', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 388),
	(2, 7, '1977-09-22', '1977-10-22', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.\n\nVestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.\n\nDuis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 366),
	(1, 8, '1972-09-26', '1972-10-26', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.', 0),
	(1, 9, '1892-05-03', '1892-06-03', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 182),
	(2, 9, '1909-08-07', '1909-09-07', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 518),
	(1, 11, '1936-09-07', '1936-10-07', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.\n\nVestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.\n\nDuis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 0),
	(2, 11, '2017-01-03', '2017-02-27', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 426),
	(1, 12, '1987-10-11', '1987-11-11', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 26),
	(1, 13, '1922-02-13', '1922-03-13', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 0),
	(1, 15, '1986-02-08', '1986-03-08', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.\n\nNam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 349),
	(1, 16, '1926-04-01', '1926-05-01', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 0),
	(1, 17, '1931-04-02', '1931-05-02', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 103),
	(2, 17, '1959-12-23', '1960-01-23', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 0),
	(3, 17, '1922-01-17', '1922-02-17', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 0),
	(4, 17, '1954-12-03', '1955-01-03', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.\n\nNam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 59),
	(1, 18, '1916-01-11', '1916-02-11', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 0),
	(1, 20, '1895-04-22', '1895-05-22', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.\n\nDuis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 276),
	(1, 21, '1998-02-10', '1998-03-10', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 0),
	(1, 24, '1936-04-17', '1936-05-17', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 51),
	(1, 25, '1923-09-24', '1923-10-24', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 95),
	(1, 26, '2001-03-03', '2001-04-03', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 251),
	(1, 27, '1932-10-20', '1932-11-20', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 358),
	(2, 27, '1968-03-22', '1968-04-22', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 0),
	(1, 28, '1895-04-07', '1895-05-07', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.', 276),
	(2, 28, '1994-04-10', '1994-05-10', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.', 655),
	(3, 28, '1957-04-18', '1957-05-18', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 664),
	(4, 28, '2017-01-01', '2017-01-30', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 221),
	(1, 31, '2001-05-26', '2001-06-26', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.\n\nNam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 0),
	(1, 32, '1897-11-28', '1897-12-28', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.\n\nVestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.\n\nDuis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 523),
	(1, 33, '1928-01-23', '1928-02-23', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.', 89),
	(2, 33, '1948-04-10', '1948-05-10', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 356),
	(1, 34, '1891-06-01', '1891-07-01', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 348),
	(1, 35, '1927-06-20', '1927-07-20', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 438),
	(1, 37, '1943-01-05', '1943-02-05', 'Fusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 443),
	(1, 38, '1929-10-16', '1929-11-16', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 0),
	(1, 39, '1967-01-24', '1967-02-24', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 0),
	(1, 40, '1988-10-15', '1988-11-15', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 246),
	(2, 40, '1903-12-13', '1904-01-13', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 211),
	(1, 42, '1929-05-30', '1929-06-30', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 0),
	(2, 42, '2015-05-22', '2015-06-22', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 549),
	(1, 44, '1955-03-22', '1955-04-22', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 157),
	(1, 45, '1960-06-17', '1960-07-17', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 285),
	(2, 45, '1964-05-22', '1964-06-22', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 312),
	(1, 48, '1970-04-23', '1970-05-23', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 331),
	(2, 48, '1894-06-17', '1894-07-17', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 0),
	(1, 50, '1954-10-23', '1954-11-23', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 0),
	(1, 57, '1996-08-23', '1996-09-23', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 157),
	(1, 59, '1913-11-12', '1913-12-12', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 9),
	(1, 61, '2016-03-17', '2016-04-17', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 263),
	(1, 62, '1896-11-14', '1896-12-14', 'In congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.\n\nNam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 0),
	(1, 63, '1901-11-11', '1901-12-11', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 323),
	(2, 63, '1900-04-23', '1900-05-23', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 0),
	(1, 65, '1890-10-15', '1890-11-15', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 109),
	(2, 65, '1992-10-27', '1992-11-27', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 0),
	(3, 65, '1891-02-18', '1891-03-18', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 194),
	(1, 69, '2001-05-24', '2001-06-24', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 0),
	(2, 69, '1915-05-31', '1915-06-30', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 339),
	(1, 73, '1971-03-17', '1971-04-17', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 808),
	(2, 73, '1923-01-23', '1923-02-23', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.\n\nNam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.\n\nCurabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 248),
	(1, 74, '1937-10-05', '1937-11-05', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 173),
	(1, 78, '1994-05-16', '1994-06-16', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 854),
	(2, 78, '1945-05-29', '1945-06-29', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 367),
	(3, 78, '1958-05-18', '1958-06-18', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 234),
	(1, 79, '1920-07-02', '1920-08-02', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 552),
	(2, 79, '1977-06-21', '1977-07-21', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 297),
	(3, 79, '1922-08-25', '1922-09-25', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 0),
	(1, 81, '1905-11-18', '1905-12-18', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 191),
	(2, 81, '1996-05-29', '1996-06-29', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 411),
	(1, 82, '2010-05-15', '2010-06-15', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 175),
	(2, 82, '1991-07-03', '1991-08-03', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.', 0),
	(3, 82, '2016-10-13', '2016-11-13', 'In congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 0),
	(1, 83, '1925-04-13', '1925-05-13', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 78),
	(1, 84, '1912-02-29', '1912-03-29', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 0),
	(1, 86, '1950-12-09', '1951-01-09', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 0),
	(1, 87, '1928-12-11', '1929-01-11', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 0),
	(1, 88, '1903-06-08', '1903-07-08', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 61),
	(2, 88, '1961-12-09', '1962-01-09', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 609),
	(1, 91, '1988-02-01', '1988-03-01', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 0),
	(1, 92, '1936-04-12', '1936-05-12', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.\n\nDuis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 356),
	(2, 92, '1922-04-23', '1922-05-23', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 0),
	(1, 93, '2012-05-29', '2012-06-29', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 228),
	(1, 94, '1892-03-17', '1892-04-17', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.', 160),
	(1, 95, '1999-10-18', '1999-11-18', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.\n\nNam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 0),
	(1, 96, '1985-11-23', '1985-12-23', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 0),
	(2, 96, '1994-08-06', '1994-09-06', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 0),
	(3, 96, '1954-05-16', '1954-06-16', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 304),
	(1, 98, '1931-01-17', '1931-02-17', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 0),
	(2, 98, '1967-11-25', '1967-12-25', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 143),
	(3, 98, '1927-10-14', '1927-11-14', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 475),
	(4, 98, '1907-03-16', '1907-04-16', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 0),
	(1, 99, '1908-03-21', '1908-04-21', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 0);
INSERT INTO `scena_investigazione` (`slug`, `nome`, `descrizione`, `citta`, `indirizzo`, `investigazione`, `caso`)
VALUES
	('ac', 'ac', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'Soweto', '64640 Prairie Rose Plaza', 1, 8),
	('accumsan', 'accumsan', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.\n\nDuis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Baizhang', '40467 Luster Road', 1, 62),
	('aenean', 'aenean', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'São Domingos do Maranhão', '3547 Hollow Ridge Lane', 1, 45),
	('aliquam', 'aliquam', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 'København', '791 Old Shore Place', 2, 96),
	('amet', 'amet', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Tungor', '787 Dixon Street', 2, 98),
	('ante', 'ante', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Jakubowice Murowane', '1904 Schlimgen Plaza', 1, 26),
	('commodo', 'commodo', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'São Domingos do Maranhão', '3547 Hollow Ridge Lane', 1, 48),
	('congue', 'congue', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.\n\nCurabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'Balrothery', '13 Vahlen Parkway', 1, 12),
	('consequat', 'consequat', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Jiubao', '77929 Sutteridge Hill', 1, 99),
	('convallis', 'convallis', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Lukou', '56588 Logan Drive', 1, 20),
	('cras', 'cras', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Paris 01', '3 Ronald Regan Terrace', 2, 65),
	('cum', 'cum', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.\n\nNam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.\n\nCurabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'Khrebtovaya', '04 Dixon Place', 2, 33),
	('curabitur', 'curabitur', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Sanlanbahai', '500 Hazelcrest Hill', 2, 40),
	('cursus', 'cursus', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'Hudson Bay', '2 Crownhardt Street', 1, 39),
	('dapibus', 'dapibus', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.', 'Caxias', '411 Warbler Place', 3, 4),
	('donec', 'donec', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'Kulia Village', '16315 Autumn Leaf Center', 2, 48),
	('egestas', 'egestas', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Grujugan', '63 Moulton Crossing', 1, 37),
	('eleifend', 'eleifend', 'Fusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'Novohrad-Volyns’kyy', '7 Golden Leaf Way', 1, 87),
	('elementum', 'elementum', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'Casal da Anja', '9035 Myrtle Park', 1, 37),
	('enim', 'enim', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'Atbasar', '3 Sullivan Center', 4, 28),
	('et', 'et', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Kunting', '6 Schurz Pass', 1, 38),
	('eu', 'eu', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Balrothery', '13 Vahlen Parkway', 2, 96),
	('euismod', 'euismod', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Palamadu', '628 Forest Dale Place', 2, 79),
	('felis', 'felis', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Verkhnyaya Belka', '752 Vernon Plaza', 3, 4),
	('iaculis', 'iaculis', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Libertad', '91 Chive Point', 1, 65),
	('in', 'in', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Leeuwarden', '4 Morrow Trail', 1, 88),
	('integer', 'integer', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'Areeiro', '90 Larry Alley', 2, 63),
	('ipsum', 'ipsum', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Cigemlong', '54024 Bonner Center', 2, 65),
	('justo', 'justo', 'In congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.\n\nCras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 'Kabac', '57686 Shelley Alley', 4, 98),
	('lectus', 'lectus', 'Fusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.', 'Biting', '576 Rutledge Drive', 1, 5),
	('leo', 'leo', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Portmore', '87 Novick Street', 1, 78),
	('libero', 'libero', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'Beiwucha', '520 Pearson Alley', 1, 83),
	('luctus', 'luctus', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 'Bacong', '3844 Daystar Point', 2, 82),
	('maecenas', 'maecenas', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Cepões', '04 Rutledge Trail', 1, 1),
	('mauris', 'mauris', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.', 'Jiazhuang', '2 Reindahl Terrace', 1, 74),
	('mi', 'mi', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'Astypálaia', '2309 Hooker Drive', 1, 13),
	('molestie', 'molestie', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'Sŭedinenie', '17 Sheridan Trail', 2, 63),
	('morbi', 'morbi', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'Hetang', '9758 Hazelcrest Place', 1, 4),
	('nam', 'nam', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'Ruzayevka', '8632 Jackson Drive', 1, 16),
	('nec', 'nec', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'Sarongan', '235 Dunning Parkway', 1, 2),
	('nisl', 'nisl', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'Klimontów', '72673 Hauk Center', 2, 4),
	('non', 'non', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'Bloemhof', '104 Graedel Way', 1, 38),
	('nulla', 'nulla', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.\n\nQuisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.\n\nIn congue. Etiam justo. Etiam pretium iaculis justo.', 'Kuala Lumpur', '88 Springs Center', 4, 98),
	('nullam', 'nullam', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'San Miguel', '382 Charing Cross Trail', 2, 11),
	('odio', 'odio', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Cachí', '420 Vernon Junction', 1, 88),
	('ornare', 'ornare', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'Ōmuta', '6 Springs Point', 1, 61),
	('pede', 'pede', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Cepões', '04 Rutledge Trail', 1, 1),
	('pellentesque', 'pellentesque', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nEtiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 'Charleston', '7 Bartelt Way', 1, 81),
	('porta', 'porta', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'Veřovice', '8435 Ronald Regan Lane', 1, 28),
	('porttitor', 'porttitor', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'Washington', '005 Scott Center', 1, 84),
	('potenti', 'potenti', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'Neftçala', '484 Bluestem Park', 2, 27),
	('pretium', 'pretium', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Oruro', '12 Gateway Place', 1, 62),
	('primis', 'primis', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'Iset’', '857 Norway Maple Park', 2, 73),
	('proin', 'proin', 'In congue. Etiam justo. Etiam pretium iaculis justo.\n\nIn hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 'Lagoa', '9 Welch Parkway', 1, 73),
	('quam', 'quam', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Lafia', '1580 Goodland Point', 1, 82),
	('quis', 'quis', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.\n\nAenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'Głogówek', '4450 Bluejay Point', 1, 31),
	('sapien', 'sapien', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.\n\nInteger ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 'Linhares', '88703 Mifflin Avenue', 1, 79),
	('scelerisque', 'scelerisque', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Louisville', '42 Harbort Court', 1, 65),
	('sed', 'sed', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.\n\nSed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 'Marsaxlokk', '319 Elka Terrace', 1, 88),
	('sit', 'sit', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'Louisville', '42 Harbort Court', 1, 34),
	('suspendisse', 'suspendisse', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.\n\nSed ante. Vivamus tortor. Duis mattis egestas metus.\n\nAenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'Tungor', '787 Dixon Street', 1, 39),
	('tellus', 'tellus', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'Casal da Anja', '9035 Myrtle Park', 1, 12),
	('tincidunt', 'tincidunt', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.\n\nIn quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.\n\nMaecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 'Březová nad Svitavou', '9 Evergreen Road', 1, 61),
	('ullamcorper', 'ullamcorper', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.\n\nNullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 'Hepingyizu', '8 Delladonna Terrace', 3, 4),
	('ut', 'ut', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.\n\nFusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'Jiyizhuang', '77060 Veith Lane', 1, 99),
	('vestibulum', 'vestibulum', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.', 'Kataba', '2 Butternut Lane', 1, 87),
	('vivamus', 'vivamus', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'Rubirizi', '8 Prairie Rose Point', 2, 33),
	('vulputate', 'vulputate', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'Juan de Acosta', '87538 Tennessee Park', 1, 24);
INSERT INTO `etichettamento` (`caso`, `tag`)
VALUES
	(9, 'annegamento'),
	(10, 'annegamento'),
	(11, 'annegamento'),
	(13, 'annegamento'),
	(17, 'annegamento'),
	(30, 'annegamento'),
	(39, 'annegamento'),
	(60, 'annegamento'),
	(70, 'annegamento'),
	(4, 'cellulare'),
	(16, 'cellulare'),
	(22, 'cellulare'),
	(35, 'cellulare'),
	(49, 'cellulare'),
	(50, 'cellulare'),
	(70, 'cellulare'),
	(74, 'cellulare'),
	(75, 'cellulare'),
	(79, 'cellulare'),
	(89, 'cellulare'),
	(1, 'esplosione'),
	(4, 'esplosione'),
	(10, 'esplosione'),
	(14, 'esplosione'),
	(30, 'esplosione'),
	(34, 'esplosione'),
	(50, 'esplosione'),
	(70, 'esplosione'),
	(85, 'esplosione'),
	(6, 'foto'),
	(9, 'foto'),
	(16, 'foto'),
	(32, 'foto'),
	(50, 'foto'),
	(61, 'foto'),
	(62, 'foto'),
	(70, 'foto'),
	(82, 'foto'),
	(87, 'foto'),
	(94, 'foto'),
	(95, 'foto'),
	(99, 'foto'),
	(18, 'perla-dei-borgia'),
	(26, 'perla-dei-borgia'),
	(28, 'perla-dei-borgia'),
	(81, 'perla-dei-borgia'),
	(99, 'perla-dei-borgia'),
	(31, 'rosa'),
	(43, 'rosa'),
	(52, 'rosa'),
	(53, 'rosa'),
	(55, 'rosa'),
	(87, 'rosa'),
	(90, 'rosa'),
	(31, 'servizi-segreti'),
	(33, 'servizi-segreti'),
	(44, 'servizi-segreti'),
	(51, 'servizi-segreti'),
	(55, 'servizi-segreti'),
	(58, 'servizi-segreti'),
	(67, 'servizi-segreti'),
	(74, 'servizi-segreti'),
	(85, 'servizi-segreti'),
	(90, 'servizi-segreti'),
	(95, 'servizi-segreti'),
	(2, 'sparatoia'),
	(8, 'sparatoia'),
	(36, 'sparatoia'),
	(45, 'sparatoia'),
	(51, 'sparatoia'),
	(69, 'sparatoia'),
	(79, 'sparatoia'),
	(83, 'sparatoia'),
	(95, 'sparatoia'),
	(98, 'sparatoia'),
	(11, 'stanza-senza-scasso'),
	(24, 'stanza-senza-scasso'),
	(46, 'stanza-senza-scasso'),
	(49, 'stanza-senza-scasso'),
	(56, 'stanza-senza-scasso'),
	(81, 'stanza-senza-scasso'),
	(82, 'stanza-senza-scasso'),
	(90, 'stanza-senza-scasso'),
	(2, 'terrorismo'),
	(14, 'terrorismo'),
	(21, 'terrorismo'),
	(31, 'terrorismo'),
	(51, 'terrorismo'),
	(57, 'terrorismo'),
	(64, 'terrorismo'),
	(69, 'terrorismo'),
	(75, 'terrorismo'),
	(80, 'terrorismo'),
	(95, 'terrorismo'),
	(96, 'terrorismo'),
	(99, 'terrorismo');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('KIBQHW49E63Y771G', 'Jesse', 'Greene', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('DKCEOV07N51B968H', 'Adam', 'Phillips', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('VLRFXZ56Z13E307E', 'Sharon', 'Snyder', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('FHJWRG19K95H884H', 'Janice', 'Adams', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('HKQNMJ69K47K193R', 'Ernest', 'Gonzales', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('VRLMHA58U07H702D', 'Paul', 'Harrison', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('VJYENO74V72D991Z', 'Bobby', 'Dunn', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('XHOTPL24F33L675C', 'Julie', 'Rice', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('XPEWUJ89K96T687G', 'Eric', 'Matthews', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('UTLRBJ71E98C709E', 'Virginia', 'Shaw', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('OGRCZY25R91G635S', 'Carolyn', 'Willis', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.

Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('TAOSEU29M47S506W', 'Matthew', 'Castillo', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('JAUFKN77V11S152G', 'Anne', 'Spencer', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('OKEAUH71E39E914S', 'Jean', 'Gordon', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('RWXEUD05R09O312Q', 'Cheryl', 'Gomez', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('NWTQUF39D75L100V', 'Stephanie', 'Henry', 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('PTCUBX86C40M981N', 'Donna', 'Baker', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('NKVUFM65E47J945G', 'Laura', 'Hamilton', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('JOZEPW93Z33M587J', 'Lillian', 'Hall', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('JTKSWG07Q10Y932S', 'Shirley', 'Nguyen', 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('EFBJHY22M21G285H', 'Kathy', 'Ford', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('NGZYOU28Y68X165N', 'Jack', 'Fuller', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('WVMQON69F15H728Q', 'Jose', 'Baker', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('GHRWFD33J29D693W', 'Adam', 'Reed', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('YSJQVF36A09Q995F', 'Laura', 'Bryant', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.

Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('FLVDUR79C22V796W', 'Lori', 'Hudson', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('QCZWAG67T92J524G', 'Frances', 'Garrett', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('ADFHZU44F80D493Y', 'Bruce', 'Mccoy', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('OEHXYP46Z95O825G', 'Wanda', 'Collins', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('JDUKQF72U07P980B', 'Shawn', 'Gonzales', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('AIOQFT77Z44U137U', 'Timothy', 'George', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.

Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('RJLTAO58U12U282F', 'Virginia', 'Welch', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('ECKRBY21S24X489O', 'Brandon', 'Baker', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('BQKGPR94U93S152F', 'Adam', 'Gomez', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('EKNVHF88X18V945P', 'Victor', 'Cox', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('SZPITJ00I62N884Y', 'Paul', 'Williams', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('AKGZBM25T22L754P', 'Andrew', 'Bailey', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.

Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.

Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('DBTHIY33B97G579W', 'Johnny', 'Johnston', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.

In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('TGUKXQ93V59H441E', 'Dorothy', 'Hall', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.

Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('KXUCHN80S65E085X', 'Albert', 'Lawrence', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.

Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('JUVXHP66M47I136J', 'Jeffrey', 'Wheeler', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('GCOYDF71C90B898E', 'Sara', 'Reynolds', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.

Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('HQOTFZ68P32L446S', 'William', 'Reynolds', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('PXKHLS99A95H178N', 'Martin', 'Edwards', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.

Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('FRXPBI45V29X153V', 'Elizabeth', 'Gutierrez', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('LJKHVF15N38B630A', 'Patricia', 'Price', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('HZOMQR48T00M502A', 'Theresa', 'Lawrence', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.

Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('ICWVBP06D89Q659M', 'Eric', 'Kelly', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('KSYUON91B09X399I', 'Matthew', 'Reed', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('HLPYOX41N98S979Q', 'Jerry', 'Freeman', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('FGYBDM98M46Z853Y', 'Kathryn', 'Hicks', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('ZLDTGJ37F55U932F', 'Victor', 'Hill', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.

In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('DNZTQS09G31N173A', 'Patricia', 'Cole', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.

Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.

Fusce consequat. Nulla nisl. Nunc nisl.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('DESHZT72V96Y669T', 'Robin', 'Black', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('VGJICL53N77L769B', 'Michelle', 'Vasquez', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('YBSZAO18N62E454G', 'Christina', 'Robinson', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('DBMYUG98X62Z079K', 'Eric', 'Johnston', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('VPLJFT33J66R967T', 'Debra', 'Dunn', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('PEOVJK12W98U891Z', 'Jacqueline', 'Harrison', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.

Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('UIQZGC28D53D729I', 'William', 'Powell', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.

Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('CUTYLZ95T47N989E', 'Janice', 'Lawson', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('SUGFBA83L81R771F', 'Doris', 'Robertson', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('ECVJAF43V43V115X', 'Henry', 'Rogers', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('DIRFPJ03O04U807P', 'Roy', 'Johnston', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('DZPCYM08R80B545N', 'Diana', 'Torres', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.

Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('SCUVKN87S52D749G', 'Terry', 'Fox', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('ZITPRY99H06T881K', 'Thomas', 'Powell', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('JKATEF00X71Z015X', 'Jeffrey', 'Jordan', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('MKNDEA19Q06M317D', 'Barbara', 'Stewart', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.

Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('CPNBTG50G79H396V', 'Jessica', 'Foster', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.

Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('ZBONAR16P65C779L', 'Laura', 'Perez', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('HBNOQI14X98X614F', 'Craig', 'Sullivan', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('YAFHEZ75J28J436B', 'Ryan', 'Hunter', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.

Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('MAFQTW81V21H976M', 'Terry', 'Adams', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.

Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('LKNRDU85W30U794C', 'Jimmy', 'Hanson', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.

In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('FXLVOK82G06U523O', 'Willie', 'Cox', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('XHNLPD42G24I711V', 'Ronald', 'Hamilton', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.

Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('LEMDCH34Z10E924Z', 'Amanda', 'Lawson', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.

Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('FEVULI04P45C881G', 'Todd', 'Nichols', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('FDGBON66S53L245T', 'Evelyn', 'James', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.

Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('YGRAUB67I29P572Y', 'Bobby', 'Kennedy', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.

Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('JOPDET22P02M699N', 'Scott', 'Pierce', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.

Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('YPKTHM75V41H763R', 'Jeremy', 'Cruz', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.

Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('FBRTID79O21O198U', 'Steve', 'Nelson', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.

Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('WGFNAJ33N62E572C', 'Diane', 'Dunn', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.

Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('TKSJLD13V84Z190E', 'Robert', 'Garcia', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.

Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('IDVQFZ10O41H862F', 'Adam', 'Davis', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('GKBMYJ09R52J996Y', 'Jack', 'Dixon', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.

Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('HOGCSB72P59I639R', 'Kelly', 'Hamilton', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.

Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('VHXTUQ97O53Q035Z', 'Sandra', 'Rice', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.

Sed ante. Vivamus tortor. Duis mattis egestas metus.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('VPQEUY63D12Y265X', 'Jonathan', 'Martinez', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.

Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('ZMGUNT19M15V577U', 'Paula', 'Lawson', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.

Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.

Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('IEKBAT73J25U994Z', 'Bonnie', 'Bennett', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.

Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.

Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('VNULYS11Z95T936P', 'Teresa', 'Arnold', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.

Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('MLJAXU22E66W211U', 'Barbara', 'Tucker', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('XPUYHI91Z33U816W', 'Douglas', 'Dunn', 'Fusce consequat. Nulla nisl. Nunc nisl.

Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('EWZPYU23J79X981R', 'Wayne', 'Shaw', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.

In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.

Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('SCIZWE42R51F313D', 'Aaron', 'Rivera', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.

In congue. Etiam justo. Etiam pretium iaculis justo.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('IKNBUP02N34X322V', 'Chris', 'Young', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.

Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.');
insert into criminale (codice_fiscale, nome, cognome, descrizione) values ('IWVURB78D87F019F', 'Robert', 'Johnson', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.

Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('YRWNCB73I96G468M', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Patrick', 'Gonzalez');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('QYOFKD67M46O619X', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Mildred', 'Arnold');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('SQDMIH91E22G439U', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jeremy', 'Brooks');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('EACOSZ97O58M305T', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Edward', 'Walker');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('ZJPRNW27Q98E957V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Antonio', 'Palmer');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('HLAKWZ42Y64H379U', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ruth', 'Banks');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('ONPXJH44H09A891B', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Diane', 'Frazier');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('IPOCLN85C04P396D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Gregory', 'Murray');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('QDTBJN76I47W472G', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Patricia', 'Evans');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('TKINRX34C13C023K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jose', 'Olson');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('HCISDQ80Q69W849I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'George', 'Griffin');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('BQDMRS64X79K409E', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Harold', 'Reed');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('JQHNFZ56A46J754B', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jeremy', 'Sanchez');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('CKVRDJ25B52N184K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jimmy', 'Edwards');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('TIQYOM49D23J164Q', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Samuel', 'Nelson');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('XMOSRQ07C92E931O', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Roy', 'Reed');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('GBLUIP56O19V175G', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Walter', 'Larson');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('JWTXGK76U04Y475N', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Gloria', 'Crawford');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('HKVLQC80T24F840W', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Judy', 'Castillo');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('XMZWID05F95C731S', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Judith', 'Freeman');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('WMEPSF32N04Y001I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Daniel', 'Medina');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('VIGUCO81C89W582I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Aaron', 'Bell');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('UJTOCR76H81S160S', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Roger', 'White');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('TDABRI67H98A258Z', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Robin', 'Mendoza');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('FGDBYE74A79H701M', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Mildred', 'King');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('KAUFRY16A02Q274L', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Laura', 'Harris');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('ECGPUQ66E30M779T', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Joseph', 'Coleman');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('HKUFYX18D60K305J', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Gary', 'Jacobs');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('OCTWAP15D79K090B', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Gary', 'Lawson');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('QGYXEF36T31X936W', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Marilyn', 'Perkins');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('VCMNOY15J91W546T', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Pamela', 'Thompson');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('DFYCOG23Q29R987Q', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Andrew', 'Duncan');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('TVADLY02V46A711M', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Pamela', 'Snyder');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('MQWVYH57U36S659Q', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ruth', 'Burton');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('ABQOLU62W54J888Q', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Lisa', 'Lawrence');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('UJHSNR13Y48J646O', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ashley', 'Gomez');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('SIGALV68K67Q110P', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Kathleen', 'Lee');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('BMNHWK80E60S609R', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Joyce', 'Payne');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('SUWKGL75C43X557G', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Annie', 'Schmidt');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('MKPSGU04D69P360V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Theresa', 'White');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('DUBWXY83X76G287K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Bobby', 'Marshall');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('JMEWSR33W68M299I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Denise', 'Cunningham');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('YVUQIG95X28I478V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Steve', 'Price');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('UAJHGE95C70J432H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Kathryn', 'Duncan');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('HWNJPY21Z60Y312F', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ann', 'Lynch');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('DFVMYE01O18J072D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Patricia', 'Marshall');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('TERCUN98Y11Z427W', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Marilyn', 'Fields');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('EVYXQZ91F52Q044S', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Tammy', 'Montgomery');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('BSFLKM81E90L609D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Sarah', 'Reynolds');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('HUTREA81W45G703Y', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ryan', 'Ford');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('GIWLHV47A46M406J', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Aaron', 'Little');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('XYBJLN62N21X682T', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Catherine', 'Bowman');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('GCHNKM89S16S988K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Joe', 'Foster');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('AHPKSZ91W29E376R', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Thomas', 'Porter');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('SZTRCY98J54I287S', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Annie', 'Collins');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('GRFKBN45G78Q351Y', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Joshua', 'Powell');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('TYVSZO24Z61A406E', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Emily', 'Wheeler');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('ZWRTNC56U87C479G', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'David', 'Davis');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('BWSXGU11J32N000T', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Maria', 'Spencer');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('XLSOIZ80T94C609C', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jennifer', 'Cunningham');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('AMSPQJ77U39J885B', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Billy', 'Richards');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('QOWHBM33D59B765E', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Timothy', 'Dean');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('ADJBYW11C13D832V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Frances', 'Hanson');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('JXRPAD27B88G708L', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Antonio', 'Dean');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('DCUHVM57H34R822L', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Kathy', 'Harvey');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('BYRVOG58O03S506W', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Ashley', 'Riley');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('GWHCIJ68W13K796S', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Michael', 'Ford');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('HPDUAJ43W90R130T', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Joan', 'Hunter');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('OIHXBN65C56K590B', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Anthony', 'Holmes');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('LQVFZK78B06V398S', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Harry', 'Cox');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('BDCJKO65M74E532G', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Richard', 'Marshall');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('FQEMKC84K53B858W', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Sean', 'Robertson');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('SLGVYU34K56X805Q', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Anthony', 'Coleman');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('USMPTR19N92Q443S', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Benjamin', 'Reyes');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('ISWDJV18E85Z555I', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Donna', 'Willis');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('QEPJKT46K45E935D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Earl', 'Reynolds');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('CLHMXT95K53J510P', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Betty', 'Grant');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('RAVTSJ50O89D003E', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'John', 'Franklin');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('YWHFEQ10X22R265R', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Cheryl', 'Bailey');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('DFQZTJ15R99P183X', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'David', 'Medina');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('MCZLAG42R29S183A', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Mildred', 'Richards');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('NTHABG94O30H959U', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Carl', 'Hunter');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('RPYWFQ78R57M454M', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Susan', 'Anderson');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('OBDMKL65E14N872H', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Christina', 'Morgan');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('RWODUK55V77R196Z', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Wayne', 'Alvarez');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('FZHXAO56O31U785X', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Gerald', 'Clark');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('RPCVNF44U52E935R', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Karen', 'Fernandez');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('VUGYHT17E97X370K', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Stephen', 'Stephens');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('KRMXYQ75D28V206U', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Lillian', 'Turner');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('WFRBMO64J00T602P', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Harry', 'Roberts');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('LMJCTI36E79P399G', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Robert', 'Gray');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('SKIMRB41I54V011R', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Jeremy', 'Palmer');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('WGYNCK65W29E742V', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Sandra', 'Ray');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('GETUML31V19G561F', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Anna', 'Ruiz');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('MYXLTC36B29M000X', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Karen', 'Burke');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('TNDBMY03G41G911D', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Richard', 'Lawson');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('CHLXOW63N14W831B', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Benjamin', 'Riley');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('XILADC61X36M430P', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Paul', 'Adams');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('RQIEKN53P28L104F', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Matthew', 'Clark');
insert into investigatore (codice_fiscale, password_hash, nome, cognome) values ('FBPSWQ99L35K802J', '$2y$10$WfvaQEzKMydIr2g3OIXpO.pjDDFXidnkVxWhqOTB6wmRe4ILIQGqe', 'Elizabeth', 'Romero');
INSERT INTO `prova` (`codice`, `nome`, `descrizione`, `locazione`, `investigazione`, `caso`)
VALUES
	(1, 'neural-net', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'deposito_polizia', 1, 42),
	(2, 'multi-tasking', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'deposito_polizia', 2, 73),
	(3, 'utilisation', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'magazzino2', 1, 21),
	(4, 'core', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'magazzino1', 1, 32),
	(5, 'Down-sized', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'deposito_polizia', 1, 94),
	(6, 'implementation', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'magazzino2', 1, 99),
	(7, 'motivating', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'magazzino2', 1, 12),
	(8, 'Adaptive', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'magazzino2', 2, 79),
	(9, 'policy', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'deposito_polizia', 1, 26),
	(10, 'middleware', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'magazzino1', 1, 87),
	(11, 'Cross-group', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'magazzino1', 2, 96),
	(12, 'Monitored', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'magazzino1', 2, 92),
	(13, 'project', 'Fusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'magazzino2', 1, 86),
	(14, 'frame', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.\n\nSuspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'magazzino1', 1, 12),
	(15, 'Advanced', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 'magazzino2', 1, 7),
	(16, 'Business-focused', 'Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.\n\nDuis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'magazzino1', 2, 79),
	(17, 'Enterprise-wide', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'deposito_polizia', 3, 2),
	(18, 'contingency', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'magazzino1', 2, 33),
	(19, 'encoding', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'magazzino2', 1, 65),
	(20, 'Compatible', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.\n\nMorbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 'magazzino2', 2, 65),
	(21, 'Vision-oriented', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.\n\nQuisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'magazzino1', 2, 9),
	(22, 'Grass-roots', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.\n\nPhasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'magazzino2', 2, 33),
	(23, 'Organic', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.\n\nPellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'deposito_polizia', 1, 40),
	(24, 'Implemented', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'magazzino2', 1, 32),
	(25, 'discrete', 'Fusce consequat. Nulla nisl. Nunc nisl.', 'magazzino1', 2, 81),
	(26, 'success', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 'magazzino1', 2, 73),
	(27, 'Multi-channelled', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'deposito_polizia', 1, 81),
	(28, 'static', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.\n\nMorbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 'magazzino2', 2, 88),
	(29, 'Synergized', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.\n\nVestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'deposito_polizia', 1, 78),
	(30, 'Monitored', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.\n\nVestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'deposito_polizia', 1, 79),
	(31, 'De-engineered', 'Fusce consequat. Nulla nisl. Nunc nisl.', 'magazzino2', 2, 42),
	(32, 'throughput', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'magazzino2', 3, 96),
	(33, 'client-driven', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'deposito_polizia', 2, 98),
	(34, 'emulation', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'magazzino2', 1, 13),
	(35, 'heuristic', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'magazzino1', 2, 45),
	(36, 'maximized', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'magazzino1', 1, 82),
	(37, 'transitional', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.\n\nAliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'deposito_polizia', 2, 45),
	(38, 'system engine', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'magazzino1', 1, 65),
	(39, 'ability', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'deposito_polizia', 1, 28),
	(40, 'matrix', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.\n\nIn sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'magazzino2', 3, 78),
	(41, 'Monitored', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'magazzino2', 3, 98),
	(42, 'coherent', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'magazzino1', 1, 96),
	(43, 'optimizing', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.\n\nVestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'magazzino2', 1, 28),
	(44, 'pricing structure', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 'deposito_polizia', 1, 84),
	(45, 'Switchable', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'magazzino2', 1, 38),
	(46, 'static', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.\n\nCurabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'deposito_polizia', 3, 17),
	(47, 'Fully-configurable', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.\n\nNullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 'magazzino1', 1, 35),
	(48, 'coherent', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'magazzino1', 1, 62),
	(49, 'multi-tasking', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 'deposito_polizia', 3, 79),
	(50, 'well-modulated', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'magazzino2', 2, 96),
	(51, 'product', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'magazzino2', 2, 78),
	(52, 'context-sensitive', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 'magazzino1', 3, 78),
	(53, 'national', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.\n\nInteger tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'magazzino2', 1, 50),
	(54, 'Up-sized', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'magazzino2', 3, 17),
	(55, 'knowledge user', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'magazzino1', 2, 45),
	(56, 'Configurable', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.\n\nCurabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 'deposito_polizia', 1, 37),
	(57, 'concept', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 'deposito_polizia', 2, 79),
	(58, 'circuit', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'deposito_polizia', 1, 40),
	(59, 'optimizing', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'magazzino1', 1, 37),
	(60, 'customer loyalty', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'magazzino1', 1, 99),
	(61, 'task-force', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'magazzino2', 1, 35),
	(62, 'executive', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', 'deposito_polizia', 1, 82),
	(63, 'modular', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.\n\nPraesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.', 'magazzino1', 3, 98),
	(64, 'solution', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'deposito_polizia', 1, 65),
	(65, 'interactive', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 'deposito_polizia', 2, 42),
	(66, 'content-based', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'magazzino1', 1, 93),
	(67, 'multi-tasking', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 'magazzino2', 1, 62),
	(68, 'radical', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.\n\nMaecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'deposito_polizia', 1, 82),
	(69, 'toolset', 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.\n\nCras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 'magazzino1', 1, 17),
	(70, 'scalable', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.', 'magazzino1', 1, 9),
	(71, 'Realigned', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'magazzino1', 1, 33),
	(72, 'Re-engineered', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.\n\nDonec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'magazzino1', 1, 8),
	(73, 'Operative', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'magazzino2', 2, 4),
	(74, '3rd generation', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'magazzino2', 1, 25),
	(75, 'Multi-layered', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.\n\nIn hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 'magazzino1', 2, 65),
	(76, 'Cloned', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'magazzino1', 2, 28),
	(77, 'scalable', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'magazzino1', 1, 20),
	(78, 'algorithm', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.\n\nPraesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 'deposito_polizia', 1, 1),
	(79, 'dedicated', 'Fusce consequat. Nulla nisl. Nunc nisl.\n\nDuis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 'magazzino2', 2, 4),
	(80, 'Proactive', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.', 'deposito_polizia', 2, 17),
	(81, 'solution-oriented', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.\n\nVestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 'deposito_polizia', 2, 9),
	(82, 'grid-enabled', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'magazzino2', 2, 96),
	(83, 'projection', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.\n\nMauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 'magazzino1', 1, 18),
	(84, 'real-time', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 'deposito_polizia', 1, 57),
	(85, 'local area network', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.\n\nMaecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'deposito_polizia', 2, 9),
	(86, 'Persistent', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.\n\nProin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', 'deposito_polizia', 1, 74),
	(87, 'tertiary', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.\n\nFusce consequat. Nulla nisl. Nunc nisl.', 'magazzino1', 1, 79),
	(88, 'Advanced', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'magazzino1', 1, 45),
	(89, 'executive', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 'magazzino1', 1, 81),
	(90, 'asynchronous', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.\n\nProin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'magazzino1', 1, 92),
	(91, 'Fully-configurable', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'magazzino2', 1, 94),
	(92, 'Implemented', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'magazzino1', 1, 32),
	(93, 'Cloned', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.\n\nDuis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 'deposito_polizia', 2, 63),
	(94, 'Switchable', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.\n\nPhasellus in felis. Donec semper sapien a libero. Nam dui.', 'magazzino2', 1, 92),
	(95, 'middleware', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.\n\nProin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 'deposito_polizia', 1, 16),
	(96, 'upward-trending', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.\n\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 'deposito_polizia', 2, 28),
	(97, 'archive', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 'magazzino2', 2, 92),
	(98, 'national', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 'magazzino2', 2, 92),
	(99, 'product', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.\n\nNulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 'magazzino2', 2, 69),
	(100, 'secondary', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.\n\nDuis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', 'magazzino1', 4, 28);
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('AMGSOU02T42U148D', '4829', 'NGKCXR77P68C162A');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('AOTFCB94S88D323S', '9754', 'RWGDUN52Y32N318D');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('BARTCQ79P64W004H', '4442', 'IEWHMV04K70G569Q');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('BCOTMU96P27J118X', '0715', 'LVIZRM42Y43C549V');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('BDLNUQ87A74N842Q', '9023', 'RZNXVT35J22W134I');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('BKWTGV11X72P857I', '0113', 'ENTKVJ31S89G460X');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('BOUGHZ41R27X483Z', '0832', 'JRTKUP94V19H145S');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('BSCAXW18H42R366I', '8231', 'YREGXQ07A43D019H');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('CGVBXZ84F14Q859X', '3813', 'OVSJGA03W66M195O');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('CYDTFN83D62O801H', '3923', 'GDJZXN52U01W640G');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('DIWQEL90U14W018A', '8142', 'FTRMOH05Y67Q034G');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('DMTSUP71S31A293U', '8464', 'GSCREL55D99N291V');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('EBZPSK96V72C394W', '8664', 'DJBVRA55N52N822V');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('EGWYML53H52V479I', '7789', 'PBEXKH82W52J747K');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('EGZTYL91X92S437X', '7593', 'QHYZUB35F01X358S');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('EMCRAJ52W88I906Y', '4697', 'JWYACP01R47E698F');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('EPRTQI78Y89U201V', '8302', 'YUOJST06T32Q434K');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('GDPXQF93J29D590I', '7985', 'GNREYT27R78A128E');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('GKXSOF27U19Y632J', '4859', 'CVUBXO91H06G269O');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('GMWBVD23K54N412F', '8827', 'GSTKLH27I34C933O');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('GYWIJZ29Y78P151J', '4400', 'QUSJYX48G41C574V');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('HBORAL34C91E401W', '8201', 'LHRPIX78X40Q622L');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('HIUBWC48S11W075N', '2021', 'GXVCNU78O48I079A');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('HKYQIE50Y39F640D', '5419', 'PSAIKZ45M35H218M');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('HLPRKC83I35V546H', '285', 'WRCEZA76Z72M948V');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('HMXYNS02J87C389K', '3850', 'CSGXUL75K55F717I');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('HNKIOQ68X17J011N', '5196', 'IWBPVJ43F26I393M');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('HNQSZY85V83W309H', '0524', 'JAMEXR10V23N245G');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('HNTBFL70J16W581N', '3483', 'HFZTGC81V36Y179D');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('HQRVFL93R01P879Y', '1662', 'IORGWA75X47K298N');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('HXAEBT11F92L476K', '1044', 'XMOJTV21U06T252O');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('HXULSE22E51S717I', '4341', 'JIBAQX73H39M878F');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('IRZAJM89I68C301T', '9761', 'KSZROB96A79X788W');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('ISKUAE91Y92T572K', '9971', 'UMRCKF64A95K187L');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('IWOGRM32I54V417G', '4191', 'FLSGIZ84M97I933N');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('JDFCYQ74B58S276E', '0784', 'VAZUFC41D67K212N');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('KAIVWL36Z49Y360J', '7764', 'CDOWXQ47X21U799K');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('KGICND54Y87D287H', '4641', 'IPLHGR29O76J780Y');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('KNMRLP43R96Y949J', '4929', 'TFXYAH78H87S721Q');
insert into ispettore (codice_fiscale, codice_distretto, codice_fiscale_direttore) values ('KXFLRG41V44C012N', '6993', 'OUSRAD93F59Q413S');
INSERT INTO `amministratore_aziendale` (`codice_fiscale`, `vat`, `settore`, `nome_azienda`)
VALUES
	('KZFVWL47Q21T073C', 'MB845621236', 'Games', 'Flashset'),
	('KZIBJF78Z54T297D', 'VJ645954628', 'Automotive', 'Jaxbean'),
	('LKHFMC28J43D552S', 'NV685873662', 'Games', 'InnoZ'),
	('LKYCTP73V98J114E', 'XF469925972', 'Computers', 'Thoughtsphere'),
	('LMAZQD65D94N338U', 'LC889386026', 'Baby', 'Voolia'),
	('LWGEOX97W88F725Q', 'OK181019528', 'Home', 'Gigashots'),
	('MEUGSC51Y39J574X', 'VC644889786', 'Outdoors', 'Wordware'),
	('MJXUBS60T73U000G', 'NA994422329', 'Tools', 'Blogpad'),
	('MRWGLN45Y12N351R', 'LE001752617', 'Clothing', 'Fivebridge'),
	('NJMEYH03M57C669D', 'OK233224490', 'Health', 'Brainlounge'),
	('NKFAQS92P26L797N', 'BR086041212', 'Automotive', 'Rhynyx'),
	('NPQVRH26L99O487X', 'SJ004532084', 'Electronics', 'Yacero'),
	('NWHYQK28Q80W469K', 'BI888342825', 'Computers', 'Kwilith'),
	('NWRYLK01G00Q732N', 'IE764293369', 'Music', 'Zoomcast'),
	('NZURQW07V26W613Y', 'WP101885816', 'Computers', 'Skiba'),
	('ODEGLR69G25P179Z', 'HJ529976242', 'Tools', 'Feedfire'),
	('OKBQMX01V32Z767H', 'FL031568023', 'Computers', 'Rhyloo'),
	('OPSJXQ88J70X471H', 'KW019935917', 'Music', 'Mycat'),
	('PDMQGO08G81P115R', 'DF858018424', 'Electronics', 'Fliptune'),
	('PKMNSJ13A54Y926P', 'BH446147915', 'Toys', 'Katz'),
	('PUXKTN70V66W017O', 'RN533660129', 'Clothing', 'Brainsphere'),
	('QKVRSB10K24S736H', 'DH788978993', 'Home', 'Layo'),
	('QSUPOL93H30M238B', 'GR293863704', 'Grocery', 'Skippad'),
	('QYIATG69M29F648O', 'AE898774294', 'Baby', 'Izio'),
	('QYWZSD26L71N133I', 'NX181308980', 'Computers', 'Fiveclub'),
	('RBFELH44P82Q132O', 'OP295498711', 'Shoes', 'LiveZ'),
	('RMSVPJ12E06P994U', 'UX560979885', 'Automotive', 'Mydo'),
	('SGPVYC54K37Y614E', 'BZ535504688', 'Home', 'Quatz');
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('SLWRXP97P00K363V', '1944-05-02', 'Desktop Support Technician', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('TFJLPA10Y55S860J', '1901-11-15', 'Programmer Analyst III', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('TFUDBC18W30V753E', '1944-04-23', 'Assistant Manager', 'QDXIGK48L10J906C');
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('THCIQS63Z21D234V', '1890-05-04', 'Internal Auditor', 'PQNLUY59V07J388P');
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('TIHJUC06C68R524A', '1892-03-02', null, null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('TNOUCX84P89Z484F', '1956-01-16', 'Teacher', 'LOPWFY44D01A812F');
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('TRZQDY44I41H385D', '1991-03-17', 'Business Systems Development Analyst', 'GWAVEY70X21B861K');
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('UDHIKT82U77V282R', '1954-11-18', 'Tax Accountant', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('UFCLNM80G61L837A', '1925-11-22', 'Environmental Specialist', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('UFNEQV92N24W661C', '1934-03-01', 'Product Engineer', 'VWNFDY54A59V173N');
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('UJCFRT85K88S107L', '1995-01-30', 'Recruiter', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('UODTQV22N12S229K', '1902-06-23', 'Associate Professor', 'BJAMDL66K57Z078N');
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('UXCTMI91A28B223O', '2008-03-14', 'Office Assistant IV', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('VMQEJZ38Y13H905B', '1959-09-14', null, 'GNDUOJ23W71U720H');
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('VRJECZ43M60R161Y', '1971-08-18', 'Associate Professor', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('VTHXKA28Y42K903I', '1901-07-04', 'Director of Sales', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('VUMTIS85O67U302B', '1958-05-13', 'Environmental Tech', 'UCRYSI04A02G133G');
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('WCUSXA52S95N012G', '1972-11-27', 'Professor', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('WJRXVO39T77P821G', '1910-05-14', 'Senior Quality Engineer', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('WSTVXH36G23E853Z', '1920-07-04', 'Accounting Assistant IV', 'AEQGYZ49F96H141J');
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('WUBTSM78X70C518U', '1997-12-19', null, null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('XAQWPB74E93I993E', '1999-07-25', 'Senior Financial Analyst', 'UCVBWZ59U19L764R');
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('XUYFEV81T94F087T', '1943-02-26', 'Nurse Practicioner', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('YINTFQ59R04V058R', '1911-06-01', 'Programmer Analyst IV', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('YKSOUC25C67E930A', '1933-02-22', 'Mechanical Systems Engineer', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('YTOJSV02M26W769S', '1962-10-16', 'Database Administrator II', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('ZLGYAQ73C19V347E', '2009-01-30', null, null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('ZUELVH09T10O307C', '1974-01-13', 'Database Administrator IV', null);
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('ZUOCTK93Q57W512K', '1956-09-30', 'Programmer III', 'XKYVLM87W32F628X');
insert into cittadino (codice_fiscale, data_nascita, professione, codice_fiscale_compagno) values ('ZWJKVL29V84W243U', '1996-09-07', 'Tax Accountant', 'DMQHJE17N43I184U');
insert into risoluzione (criminale, caso) values ('YAFHEZ75J28J436B', 63);
insert into risoluzione (criminale, caso) values ('ECVJAF43V43V115X', 9);
insert into risoluzione (criminale, caso) values ('DIRFPJ03O04U807P', 42);
insert into risoluzione (criminale, caso) values ('SZPITJ00I62N884Y', 56);
insert into risoluzione (criminale, caso) values ('VLRFXZ56Z13E307E', 66);
insert into risoluzione (criminale, caso) values ('SCUVKN87S52D749G', 47);
insert into risoluzione (criminale, caso) values ('JAUFKN77V11S152G', 74);
insert into risoluzione (criminale, caso) values ('WVMQON69F15H728Q', 35);
insert into risoluzione (criminale, caso) values ('PXKHLS99A95H178N', 66);
insert into risoluzione (criminale, caso) values ('JDUKQF72U07P980B', 84);
insert into risoluzione (criminale, caso) values ('EKNVHF88X18V945P', 91);
insert into risoluzione (criminale, caso) values ('BQKGPR94U93S152F', 45);
insert into risoluzione (criminale, caso) values ('GHRWFD33J29D693W', 3);
insert into risoluzione (criminale, caso) values ('DKCEOV07N51B968H', 30);
insert into risoluzione (criminale, caso) values ('SCUVKN87S52D749G', 17);
insert into risoluzione (criminale, caso) values ('AIOQFT77Z44U137U', 3);
insert into risoluzione (criminale, caso) values ('YBSZAO18N62E454G', 47);
insert into risoluzione (criminale, caso) values ('ADFHZU44F80D493Y', 92);
insert into risoluzione (criminale, caso) values ('MKNDEA19Q06M317D', 69);
insert into risoluzione (criminale, caso) values ('XPUYHI91Z33U816W', 4);
insert into risoluzione (criminale, caso) values ('UTLRBJ71E98C709E', 89);
insert into risoluzione (criminale, caso) values ('HZOMQR48T00M502A', 66);
insert into risoluzione (criminale, caso) values ('YBSZAO18N62E454G', 60);
insert into risoluzione (criminale, caso) values ('IWVURB78D87F019F', 61);
insert into risoluzione (criminale, caso) values ('ADFHZU44F80D493Y', 76);
insert into risoluzione (criminale, caso) values ('FGYBDM98M46Z853Y', 26);
insert into risoluzione (criminale, caso) values ('XPUYHI91Z33U816W', 75);
insert into risoluzione (criminale, caso) values ('HKQNMJ69K47K193R', 29);
insert into risoluzione (criminale, caso) values ('VRLMHA58U07H702D', 83);
insert into risoluzione (criminale, caso) values ('VHXTUQ97O53Q035Z', 55);
insert into risoluzione (criminale, caso) values ('DNZTQS09G31N173A', 73);
insert into risoluzione (criminale, caso) values ('GKBMYJ09R52J996Y', 100);
insert into risoluzione (criminale, caso) values ('OKEAUH71E39E914S', 9);
insert into risoluzione (criminale, caso) values ('CUTYLZ95T47N989E', 62);
insert into risoluzione (criminale, caso) values ('VHXTUQ97O53Q035Z', 3);
insert into risoluzione (criminale, caso) values ('GHRWFD33J29D693W', 75);
insert into risoluzione (criminale, caso) values ('YAFHEZ75J28J436B', 29);
insert into risoluzione (criminale, caso) values ('HKQNMJ69K47K193R', 11);
insert into risoluzione (criminale, caso) values ('KXUCHN80S65E085X', 8);
insert into risoluzione (criminale, caso) values ('NGZYOU28Y68X165N', 31);
insert into risoluzione (criminale, caso) values ('VGJICL53N77L769B', 88);
insert into risoluzione (criminale, caso) values ('AKGZBM25T22L754P', 51);
insert into risoluzione (criminale, caso) values ('GKBMYJ09R52J996Y', 31);
insert into risoluzione (criminale, caso) values ('UTLRBJ71E98C709E', 93);
insert into risoluzione (criminale, caso) values ('WGFNAJ33N62E572C', 7);
insert into risoluzione (criminale, caso) values ('DZPCYM08R80B545N', 3);
insert into risoluzione (criminale, caso) values ('DZPCYM08R80B545N', 78);
insert into risoluzione (criminale, caso) values ('EFBJHY22M21G285H', 66);
insert into risoluzione (criminale, caso) values ('OEHXYP46Z95O825G', 70);
insert into risoluzione (criminale, caso) values ('XPUYHI91Z33U816W', 52);
insert into risoluzione (criminale, caso) values ('HZOMQR48T00M502A', 68);
insert into risoluzione (criminale, caso) values ('ADFHZU44F80D493Y', 14);
insert into risoluzione (criminale, caso) values ('AKGZBM25T22L754P', 3);
insert into risoluzione (criminale, caso) values ('VPLJFT33J66R967T', 50);
insert into risoluzione (criminale, caso) values ('LKNRDU85W30U794C', 76);
insert into risoluzione (criminale, caso) values ('YBSZAO18N62E454G', 77);
insert into risoluzione (criminale, caso) values ('JDUKQF72U07P980B', 68);
insert into risoluzione (criminale, caso) values ('DESHZT72V96Y669T', 23);
insert into risoluzione (criminale, caso) values ('MKNDEA19Q06M317D', 86);
insert into risoluzione (criminale, caso) values ('NKVUFM65E47J945G', 38);
insert into risoluzione (criminale, caso) values ('DKCEOV07N51B968H', 4);
insert into risoluzione (criminale, caso) values ('RJLTAO58U12U282F', 40);
insert into risoluzione (criminale, caso) values ('IKNBUP02N34X322V', 39);
insert into risoluzione (criminale, caso) values ('OEHXYP46Z95O825G', 73);
insert into risoluzione (criminale, caso) values ('YBSZAO18N62E454G', 50);
insert into risoluzione (criminale, caso) values ('NWTQUF39D75L100V', 22);
insert into risoluzione (criminale, caso) values ('JTKSWG07Q10Y932S', 35);
insert into risoluzione (criminale, caso) values ('RWXEUD05R09O312Q', 39);
insert into risoluzione (criminale, caso) values ('GHRWFD33J29D693W', 90);
insert into risoluzione (criminale, caso) values ('VNULYS11Z95T936P', 51);
insert into risoluzione (criminale, caso) values ('HZOMQR48T00M502A', 36);
insert into risoluzione (criminale, caso) values ('JAUFKN77V11S152G', 36);
insert into risoluzione (criminale, caso) values ('DKCEOV07N51B968H', 100);
insert into risoluzione (criminale, caso) values ('YSJQVF36A09Q995F', 31);
insert into risoluzione (criminale, caso) values ('CPNBTG50G79H396V', 35);
insert into risoluzione (criminale, caso) values ('FDGBON66S53L245T', 100);
insert into risoluzione (criminale, caso) values ('PEOVJK12W98U891Z', 50);
insert into risoluzione (criminale, caso) values ('ECVJAF43V43V115X', 39);
insert into risoluzione (criminale, caso) values ('JDUKQF72U07P980B', 52);
insert into risoluzione (criminale, caso) values ('PEOVJK12W98U891Z', 90);
insert into risoluzione (criminale, caso) values ('AKGZBM25T22L754P', 72);
insert into risoluzione (criminale, caso) values ('ADFHZU44F80D493Y', 58);
insert into risoluzione (criminale, caso) values ('IDVQFZ10O41H862F', 78);
insert into risoluzione (criminale, caso) values ('ECVJAF43V43V115X', 74);
insert into risoluzione (criminale, caso) values ('FXLVOK82G06U523O', 18);
insert into risoluzione (criminale, caso) values ('XHNLPD42G24I711V', 5);
insert into risoluzione (criminale, caso) values ('SCIZWE42R51F313D', 64);
insert into risoluzione (criminale, caso) values ('IEKBAT73J25U994Z', 92);
insert into risoluzione (criminale, caso) values ('FXLVOK82G06U523O', 99);
insert into risoluzione (criminale, caso) values ('JTKSWG07Q10Y932S', 23);
insert into risoluzione (criminale, caso) values ('MAFQTW81V21H976M', 35);
insert into risoluzione (criminale, caso) values ('IWVURB78D87F019F', 73);
insert into risoluzione (criminale, caso) values ('HQOTFZ68P32L446S', 20);
insert into risoluzione (criminale, caso) values ('PXKHLS99A95H178N', 14);
insert into risoluzione (criminale, caso) values ('VLRFXZ56Z13E307E', 15);
insert into risoluzione (criminale, caso) values ('FDGBON66S53L245T', 50);
insert into risoluzione (criminale, caso) values ('GKBMYJ09R52J996Y', 25);
insert into risoluzione (criminale, caso) values ('IEKBAT73J25U994Z', 60);
insert into risoluzione (criminale, caso) values ('VPLJFT33J66R967T', 51);
insert into risoluzione (criminale, caso) values ('MAFQTW81V21H976M', 96);
INSERT INTO `lavoro` (`investigatore`, `investigazione`, `caso`, `ore_lavoro`)
VALUES
	('ABQOLU62W54J888Q', 1, 73, 62),
	('AMSPQJ77U39J885B', 3, 78, 234),
	('BDCJKO65M74E532G', 2, 45, 31),
	('BQDMRS64X79K409E', 1, 37, 319),
	('BQDMRS64X79K409E', 1, 81, 191),
	('BQDMRS64X79K409E', 2, 28, 3),
	('BSFLKM81E90L609D', 2, 45, 269),
	('BWSXGU11J32N000T', 1, 88, 61),
	('BWSXGU11J32N000T', 2, 79, 112),
	('CHLXOW63N14W831B', 1, 32, 325),
	('CHLXOW63N14W831B', 3, 28, 192),
	('CKVRDJ25B52N184K', 1, 20, 276),
	('CKVRDJ25B52N184K', 1, 24, 51),
	('DCUHVM57H34R822L', 1, 2, 281),
	('DFYCOG23Q29R987Q', 1, 48, 59),
	('DUBWXY83X76G287K', 2, 4, 68),
	('EACOSZ97O58M305T', 1, 37, 43),
	('ECGPUQ66E30M779T', 1, 27, 358),
	('ECGPUQ66E30M779T', 2, 9, 328),
	('EVYXQZ91F52Q044S', 1, 61, 263),
	('FQEMKC84K53B858W', 1, 34, 5),
	('FQEMKC84K53B858W', 1, 48, 272),
	('FQEMKC84K53B858W', 2, 78, 367),
	('FQEMKC84K53B858W', 4, 28, 221),
	('FZHXAO56O31U785X', 2, 7, 366),
	('GCHNKM89S16S988K', 1, 82, 175),
	('GCHNKM89S16S988K', 3, 28, 177),
	('GETUML31V19G561F', 2, 2, 21),
	('GETUML31V19G561F', 3, 4, 265),
	('GIWLHV47A46M406J', 1, 5, 241),
	('GRFKBN45G78Q351Y', 1, 83, 78),
	('GWHCIJ68W13K796S', 1, 34, 209),
	('GWHCIJ68W13K796S', 3, 98, 152),
	('HKUFYX18D60K305J', 2, 11, 197),
	('HKUFYX18D60K305J', 2, 81, 200),
	('HLAKWZ42Y64H379U', 2, 42, 304),
	('HPDUAJ43W90R130T', 1, 93, 62),
	('HPDUAJ43W90R130T', 3, 96, 304),
	('ISWDJV18E85Z555I', 1, 59, 9),
	('JMEWSR33W68M299I', 1, 35, 130),
	('JQHNFZ56A46J754B', 1, 26, 188),
	('JQHNFZ56A46J754B', 1, 78, 141),
	('JWTXGK76U04Y475N', 2, 11, 229),
	('JXRPAD27B88G708L', 3, 65, 194),
	('KRMXYQ75D28V206U', 1, 12, 26),
	('LMJCTI36E79P399G', 1, 7, 388),
	('LQVFZK78B06V398S', 2, 28, 397),
	('MKPSGU04D69P360V', 1, 28, 276),
	('MKPSGU04D69P360V', 4, 17, 59),
	('NTHABG94O30H959U', 2, 69, 339),
	('NTHABG94O30H959U', 3, 4, 315),
	('OCTWAP15D79K090B', 2, 33, 356),
	('ONPXJH44H09A891B', 1, 74, 173),
	('QDTBJN76I47W472G', 1, 94, 160),
	('QEPJKT46K45E935D', 1, 34, 134),
	('QEPJKT46K45E935D', 1, 35, 308),
	('QGYXEF36T31X936W', 1, 57, 75),
	('QGYXEF36T31X936W', 2, 81, 211),
	('QOWHBM33D59B765E', 1, 63, 323),
	('QOWHBM33D59B765E', 1, 73, 248),
	('QOWHBM33D59B765E', 1, 79, 289),
	('QOWHBM33D59B765E', 2, 79, 185),
	('QOWHBM33D59B765E', 2, 88, 262),
	('QYOFKD67M46O619X', 1, 5, 314),
	('QYOFKD67M46O619X', 1, 78, 316),
	('RPYWFQ78R57M454M', 1, 32, 148),
	('RPYWFQ78R57M454M', 1, 92, 356),
	('RQIEKN53P28L104F', 1, 25, 95),
	('SUWKGL75C43X557G', 1, 45, 285),
	('SZTRCY98J54I287S', 2, 42, 245),
	('TIQYOM49D23J164Q', 1, 57, 82),
	('TNDBMY03G41G911D', 1, 6, 300),
	('TVADLY02V46A711M', 3, 98, 323),
	('TYVSZO24Z61A406E', 2, 45, 12),
	('UAJHGE95C70J432H', 1, 17, 103),
	('UJTOCR76H81S160S', 1, 9, 182),
	('UJTOCR76H81S160S', 2, 73, 32),
	('UJTOCR76H81S160S', 2, 98, 143),
	('USMPTR19N92Q443S', 1, 73, 269),
	('VCMNOY15J91W546T', 1, 32, 50),
	('VCMNOY15J91W546T', 2, 28, 255),
	('VUGYHT17E97X370K', 1, 40, 246),
	('VUGYHT17E97X370K', 1, 78, 397),
	('WFRBMO64J00T602P', 1, 33, 89),
	('WGYNCK65W29E742V', 1, 5, 132),
	('WMEPSF32N04Y001I', 1, 65, 109),
	('WMEPSF32N04Y001I', 1, 73, 229),
	('XILADC61X36M430P', 3, 28, 295),
	('XLSOIZ80T94C609C', 2, 9, 190),
	('XMOSRQ07C92E931O', 1, 26, 63),
	('XMOSRQ07C92E931O', 1, 79, 263),
	('XMZWID05F95C731S', 1, 37, 81),
	('XMZWID05F95C731S', 1, 44, 157),
	('XYBJLN62N21X682T', 2, 88, 347),
	('YRWNCB73I96G468M', 1, 6, 109),
	('YVUQIG95X28I478V', 2, 40, 211),
	('YWHFEQ10X22R265R', 3, 4, 27),
	('ZJPRNW27Q98E957V', 1, 93, 166),
	('ZJPRNW27Q98E957V', 2, 73, 216),
	('ZWRTNC56U87C479G', 1, 15, 349);

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
