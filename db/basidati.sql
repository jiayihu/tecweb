/**
  * L'ordine è importante a causa delle chiavi esterne. Non si può droppare una
  * tabella se prima non si droppano quelle relazionate come FOREIGN KEY
 */
DROP TABLE IF EXISTS amministratore_aziendale, cittadino, collaborazione, etichettamento, fattura, ispettore, lavoro, prova, risoluzione, scena_investigazione, tag, telefono;
DROP TABLE IF EXISTS collaboratore, criminale, investigatore, investigazione;
DROP TABLE IF EXISTS caso, cliente, luogo, tariffa;

CREATE TABLE tariffa (
  tipologia_caso VARCHAR(50) PRIMARY KEY,
  prezzo FLOAT(12,2) NOT NULL
);

CREATE TABLE tag (
  slug VARCHAR(50) PRIMARY KEY,
  nome VARCHAR(50) NOT NULL UNIQUE,
  descrizione VARCHAR(100)
);

CREATE TABLE luogo (
  citta VARCHAR(100),
  indirizzo VARCHAR(100),
  PRIMARY KEY (citta, indirizzo)
);

CREATE TABLE cliente (
  codice_fiscale VARCHAR(16) PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  cognome VARCHAR(100) NOT NULL,
  citta_fatturazione VARCHAR(100) NOT NULL,
  indirizzo_fatturazione VARCHAR(100) NOT NULL,
  FOREIGN KEY (citta_fatturazione, indirizzo_fatturazione) REFERENCES luogo(citta, indirizzo) ON DELETE NO ACTION ON UPDATE CASCADE
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
  FOREIGN KEY (citta, indirizzo) REFERENCES luogo(citta, indirizzo) ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (investigazione, caso) REFERENCES investigazione(numero, caso) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE etichettamento (
  caso INTEGER(10),
  tag VARCHAR(50),
  PRIMARY KEY (caso, tag),
  FOREIGN KEY (caso) REFERENCES caso(codice) ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (tag) REFERENCES tag(slug) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE fattura (
  numero INTEGER(10) auto_increment,
  data_fattura DATE NOT NULL,
  descrizione VARCHAR(500) NOT NULL,
  importo FLOAT(12,2) NOT NULL,
  cliente VARCHAR(16) NOT NULL,
  investigazione TINYINT NOT NULL,
  caso INTEGER(10) NOT NULL,
  PRIMARY KEY (numero, data_fattura),
  FOREIGN KEY (cliente) REFERENCES cliente(codice_fiscale) ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (investigazione, caso) REFERENCES investigazione(numero, caso) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE telefono (
  numero VARCHAR(25) PRIMARY KEY,
  cliente VARCHAR(16) NOT NULL,
  FOREIGN KEY (cliente) REFERENCES cliente(codice_fiscale) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE criminale (
  codice_fiscale VARCHAR(16) PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  cognome VARCHAR(100) NOT NULL,
  descrizione TEXT NOT NULL
);

CREATE TABLE investigatore (
  codice_fiscale VARCHAR(16) PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  cognome VARCHAR(100) NOT NULL,
  servizio_militare BOOLEAN DEFAULT 0
);

CREATE TABLE collaboratore (
  codice_fiscale VARCHAR(16) PRIMARY KEY,
  nome VARCHAR(16) NOT NULL,
  cognome VARCHAR(16) NOT NULL,
  lavoro VARCHAR(100) NOT NULL
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

CREATE TABLE collaborazione (
  collaboratore VARCHAR(16),
  investigazione TINYINT,
  caso INTEGER(10),
  PRIMARY KEY (collaboratore, investigazione, caso),
  FOREIGN KEY (collaboratore) REFERENCES collaboratore(codice_fiscale) ON DELETE NO ACTION ON UPDATE CASCADE,
  FOREIGN KEY (investigazione, caso) REFERENCES investigazione(numero, caso) ON DELETE NO ACTION ON UPDATE CASCADE
);
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
insert into luogo (citta, indirizzo) values ('Dondo', '295 Declaration Circle');
insert into luogo (citta, indirizzo) values ('Melville', '877 Londonderry Junction');
insert into luogo (citta, indirizzo) values ('Panganiban', '5 Golf Point');
insert into luogo (citta, indirizzo) values ('Kawanishi', '1 Rutledge Street');
insert into luogo (citta, indirizzo) values ('Sendafa', '55 Hudson Place');
insert into luogo (citta, indirizzo) values ('Sendafa', '20 Chive Parkway');
insert into luogo (citta, indirizzo) values ('Colombo', '451 Pepper Wood Terrace');
insert into luogo (citta, indirizzo) values ('Yizhivtsi', '9 Bluejay Alley');
insert into luogo (citta, indirizzo) values ('Catania', '442 Center Crossing');
insert into luogo (citta, indirizzo) values ('Cachí', '420 Vernon Junction');
insert into luogo (citta, indirizzo) values ('Halmstad', '5 Oneill Street');
insert into luogo (citta, indirizzo) values ('Naranjo', '8766 Brickson Park Drive');
insert into luogo (citta, indirizzo) values ('Svalyava', '5 Glacier Hill Junction');
insert into luogo (citta, indirizzo) values ('Venëv', '07 Waubesa Hill');
insert into luogo (citta, indirizzo) values ('Wawu', '57706 Ohio Park');
insert into luogo (citta, indirizzo) values ('Bielice', '44 Dexter Pass');
insert into luogo (citta, indirizzo) values ('Lafia', '1580 Goodland Point');
insert into luogo (citta, indirizzo) values ('Ganzhou', '56728 Glacier Hill Junction');
insert into luogo (citta, indirizzo) values ('Jurm', '2 Jana Street');
insert into luogo (citta, indirizzo) values ('Lagoa', '9 Welch Parkway');
insert into luogo (citta, indirizzo) values ('Novopokrovskaya', '988 Kensington Lane');
insert into luogo (citta, indirizzo) values ('Charleston', '7 Bartelt Way');
insert into luogo (citta, indirizzo) values ('Retiro', '917 Dexter Terrace');
insert into luogo (citta, indirizzo) values ('Mersa Matruh', '6 Saint Paul Terrace');
insert into luogo (citta, indirizzo) values ('Osa', '9242 Sutherland Alley');
insert into luogo (citta, indirizzo) values ('Castleblayney', '74 Lake View Terrace');
insert into luogo (citta, indirizzo) values ('Comal', '0 Arapahoe Street');
insert into luogo (citta, indirizzo) values ('Fatualam', '67 Magdeline Drive');
insert into luogo (citta, indirizzo) values ('Juan de Acosta', '87538 Tennessee Park');
insert into luogo (citta, indirizzo) values ('Ughelli', '79 Shelley Parkway');
insert into luogo (citta, indirizzo) values ('Липково', '1 Pankratz Way');
insert into luogo (citta, indirizzo) values ('Shangxian', '207 Stuart Street');
insert into luogo (citta, indirizzo) values ('Balrothery', '13 Vahlen Parkway');
insert into luogo (citta, indirizzo) values ('Nine', '136 Vera Way');
insert into luogo (citta, indirizzo) values ('Jincheng', '1674 Katie Pass');
insert into luogo (citta, indirizzo) values ('Poroçan', '5 Farragut Circle');
insert into luogo (citta, indirizzo) values ('Zhouzai', '751 Sugar Court');
insert into luogo (citta, indirizzo) values ('Pavlohrad', '42 Continental Center');
insert into luogo (citta, indirizzo) values ('Anyang', '38 Sutteridge Place');
insert into luogo (citta, indirizzo) values ('Boden', '2455 Lakeland Park');
insert into luogo (citta, indirizzo) values ('Gif-sur-Yvette', '59861 Union Trail');
insert into luogo (citta, indirizzo) values ('Lidköping', '0 Chinook Circle');
insert into luogo (citta, indirizzo) values ('Ziębice', '08931 Reinke Way');
insert into luogo (citta, indirizzo) values ('Dutsin Ma', '3663 Dexter Place');
insert into luogo (citta, indirizzo) values ('Jiangpu', '66 International Place');
insert into luogo (citta, indirizzo) values ('Thị Trấn Trùng Khánh', '533 Raven Park');
insert into luogo (citta, indirizzo) values ('Sarongan', '235 Dunning Parkway');
insert into luogo (citta, indirizzo) values ('Lunik', '72883 Southridge Pass');
insert into luogo (citta, indirizzo) values ('Huanfeng', '25 Golf View Place');
insert into luogo (citta, indirizzo) values ('Tongliao', '31 Saint Paul Court');
insert into luogo (citta, indirizzo) values ('Dupnitsa', '7471 Barby Street');
insert into luogo (citta, indirizzo) values ('Jarigue', '77964 Morningstar Plaza');
insert into luogo (citta, indirizzo) values ('Khudoyelanskoye', '80 Waywood Terrace');
insert into luogo (citta, indirizzo) values ('São Luís de Montes Belos', '1 Aberg Street');
insert into luogo (citta, indirizzo) values ('‘Abasān al Kabīrah', '018 Mccormick Crossing');
insert into luogo (citta, indirizzo) values ('Marsaxlokk', '319 Elka Terrace');
insert into luogo (citta, indirizzo) values ('Águas de Lindóia', '758 Roth Junction');
insert into luogo (citta, indirizzo) values ('Volokolamsk', '3 Westerfield Terrace');
insert into luogo (citta, indirizzo) values ('Zhoupu', '0502 Ilene Road');
insert into luogo (citta, indirizzo) values ('Catania', '5099 Ridgeview Hill');
insert into luogo (citta, indirizzo) values ('Pop Shahri', '2 Toban Park');
insert into luogo (citta, indirizzo) values ('Yangkang', '01 Forest Dale Junction');
insert into luogo (citta, indirizzo) values ('Sísion', '0005 Northridge Drive');
insert into luogo (citta, indirizzo) values ('Oke Mesi', '56 Amoth Parkway');
insert into luogo (citta, indirizzo) values ('Limeil-Brévannes', '14885 Sycamore Road');
insert into luogo (citta, indirizzo) values ('Sanlanbahai', '500 Hazelcrest Hill');
insert into luogo (citta, indirizzo) values ('San Juan', '992 Paget Circle');
insert into luogo (citta, indirizzo) values ('Sangiang', '6654 Jay Plaza');
insert into luogo (citta, indirizzo) values ('Liushikou', '15436 Spenser Center');
insert into luogo (citta, indirizzo) values ('Fray Luis A. Beltrán', '2 Eliot Park');
insert into luogo (citta, indirizzo) values ('Kota Kinabalu', '915 Sunbrook Crossing');
insert into luogo (citta, indirizzo) values ('Frederiksberg', '6 David Alley');
insert into luogo (citta, indirizzo) values ('Xieshui', '4 Spohn Lane');
insert into luogo (citta, indirizzo) values ('Argostólion', '91 Loomis Center');
insert into luogo (citta, indirizzo) values ('Mercaderes', '175 Dwight Park');
insert into luogo (citta, indirizzo) values ('Gyeongsan-si', '4 Anzinger Trail');
insert into luogo (citta, indirizzo) values ('Encantado', '2 Maple Wood Drive');
insert into luogo (citta, indirizzo) values ('Qixingtai', '583 Express Circle');
insert into luogo (citta, indirizzo) values ('Portmore', '87 Novick Street');
insert into luogo (citta, indirizzo) values ('Asen', '46574 Warner Lane');
insert into luogo (citta, indirizzo) values ('Lushan', '40444 7th Plaza');
insert into luogo (citta, indirizzo) values ('Synevyr', '91910 Birchwood Court');
insert into luogo (citta, indirizzo) values ('Krasnokamsk', '6 Elgar Park');
insert into luogo (citta, indirizzo) values ('Banjarjo', '432 Prairieview Place');
insert into luogo (citta, indirizzo) values ('Jiale', '4597 Eliot Crossing');
insert into luogo (citta, indirizzo) values ('Głogówek', '4450 Bluejay Point');
insert into luogo (citta, indirizzo) values ('Kissónerga', '64 Bellgrove Lane');
insert into luogo (citta, indirizzo) values ('Rasi Salai', '81 Shelley Drive');
insert into luogo (citta, indirizzo) values ('Montaigu', '90 Continental Pass');
insert into luogo (citta, indirizzo) values ('Barbosa', '2 Mcbride Junction');
insert into luogo (citta, indirizzo) values ('Conchal', '1 Del Mar Plaza');
insert into luogo (citta, indirizzo) values ('‘Amrān', '94 Fairview Terrace');
insert into luogo (citta, indirizzo) values ('Klimontów', '72673 Hauk Center');
insert into luogo (citta, indirizzo) values ('Wadung', '770 Golf View Crossing');
insert into luogo (citta, indirizzo) values ('Timbaúba', '362 Muir Plaza');
insert into luogo (citta, indirizzo) values ('Paris 13', '6414 Redwing Drive');
insert into luogo (citta, indirizzo) values ('Casal da Anja', '9035 Myrtle Park');
insert into luogo (citta, indirizzo) values ('Sobue', '53758 Westend Drive');
insert into luogo (citta, indirizzo) values ('Montpellier', '395 Miller Crossing');
insert into luogo (citta, indirizzo) values ('Wolfsberg', '992 Northview Crossing');
insert into luogo (citta, indirizzo) values ('Ardabīl', '749 Dwight Plaza');
insert into luogo (citta, indirizzo) values ('Kotlas', '63379 Main Center');
insert into luogo (citta, indirizzo) values ('Weston', '11039 Burning Wood Avenue');
insert into luogo (citta, indirizzo) values ('Palamadu', '628 Forest Dale Place');
insert into luogo (citta, indirizzo) values ('Kisangani', '36 Farwell Place');
insert into luogo (citta, indirizzo) values ('Cilegi', '6917 Continental Circle');
insert into luogo (citta, indirizzo) values ('Tartagal', '14 Ronald Regan Crossing');
insert into luogo (citta, indirizzo) values ('Balakhninskiy', '6855 Thackeray Point');
insert into luogo (citta, indirizzo) values ('Limoeiro de Anadia', '5819 Forster Pass');
insert into luogo (citta, indirizzo) values ('Majin', '0718 Main Place');
insert into luogo (citta, indirizzo) values ('Mauá', '854 Hazelcrest Road');
insert into luogo (citta, indirizzo) values ('Xunhe', '9 Canary Point');
insert into luogo (citta, indirizzo) values ('Haoxue', '76762 Gerald Court');
insert into luogo (citta, indirizzo) values ('Maagnas', '42227 Tomscot Drive');
insert into luogo (citta, indirizzo) values ('Jataí', '222 Carioca Terrace');
insert into luogo (citta, indirizzo) values ('Jieduo', '21 Golf Course Avenue');
insert into luogo (citta, indirizzo) values ('Nezlobnaya', '8152 Canary Place');
insert into luogo (citta, indirizzo) values ('Madrid', '096 Melody Junction');
insert into luogo (citta, indirizzo) values ('Kuala Lumpur', '88 Springs Center');
insert into luogo (citta, indirizzo) values ('Bugis', '80 Luster Court');
insert into luogo (citta, indirizzo) values ('Dobříš', '5573 Shasta Street');
insert into luogo (citta, indirizzo) values ('Perelhal', '27 Carpenter Road');
insert into luogo (citta, indirizzo) values ('Bloemhof', '104 Graedel Way');
insert into luogo (citta, indirizzo) values ('Ḩājī Khēl', '4 Kenwood Court');
insert into luogo (citta, indirizzo) values ('Verkhnyaya Belka', '752 Vernon Plaza');
insert into luogo (citta, indirizzo) values ('Hägersten', '06323 Anthes Drive');
insert into luogo (citta, indirizzo) values ('Wujingfu', '821 Commercial Terrace');
insert into luogo (citta, indirizzo) values ('Uenohara', '24409 Barnett Hill');
insert into luogo (citta, indirizzo) values ('Grujugan', '63 Moulton Crossing');
insert into luogo (citta, indirizzo) values ('Cepões', '04 Rutledge Trail');
insert into luogo (citta, indirizzo) values ('Provins', '517 Everett Pass');
insert into luogo (citta, indirizzo) values ('Tama', '6831 Crest Line Crossing');
insert into luogo (citta, indirizzo) values ('Khrebtovaya', '04 Dixon Place');
insert into luogo (citta, indirizzo) values ('Wilkes Barre', '0 Becker Junction');
insert into luogo (citta, indirizzo) values ('Prakhon Chai', '38619 Shelley Parkway');
insert into luogo (citta, indirizzo) values ('Gaoqiao', '61412 Eagle Crest Place');
insert into luogo (citta, indirizzo) values ('Tamano', '858 Bonner Pass');
insert into luogo (citta, indirizzo) values ('Tuusniemi', '7 2nd Way');
insert into luogo (citta, indirizzo) values ('Sélestat', '5 Hollow Ridge Court');
insert into luogo (citta, indirizzo) values ('Wanfa', '933 Karstens Crossing');
insert into luogo (citta, indirizzo) values ('Ikot-Ekpene', '736 Farragut Street');
insert into luogo (citta, indirizzo) values ('Mýrina', '4 Ilene Point');
insert into luogo (citta, indirizzo) values ('Baizhang', '40467 Luster Road');
insert into luogo (citta, indirizzo) values ('São Domingos do Maranhão', '3547 Hollow Ridge Lane');
insert into luogo (citta, indirizzo) values ('Pampanito', '4488 Straubel Drive');
insert into luogo (citta, indirizzo) values ('Dakingari', '3 Corscot Road');
insert into luogo (citta, indirizzo) values ('Sancha', '850 Farwell Place');
insert into luogo (citta, indirizzo) values ('Mölndal', '30592 Bartillon Junction');
insert into luogo (citta, indirizzo) values ('Tuwa', '13633 Canary Place');
insert into luogo (citta, indirizzo) values ('Enyerhyetykaw', '399 Eastlawn Street');
insert into luogo (citta, indirizzo) values ('El Fasher', '66 Bartillon Junction');
insert into luogo (citta, indirizzo) values ('København', '791 Old Shore Place');
insert into luogo (citta, indirizzo) values ('Buray', '3 Bunker Hill Lane');
insert into luogo (citta, indirizzo) values ('Selizharovo', '168 Rutledge Terrace');
insert into luogo (citta, indirizzo) values ('Hongguang', '42855 Manufacturers Court');
insert into luogo (citta, indirizzo) values ('Two Hills', '3 Ruskin Road');
insert into luogo (citta, indirizzo) values ('Straszyn', '60 Paget Lane');
insert into luogo (citta, indirizzo) values ('Da’an', '05 Schmedeman Circle');
insert into luogo (citta, indirizzo) values ('Boston', '769 Sundown Lane');
insert into luogo (citta, indirizzo) values ('Tuscaloosa', '84 Pearson Park');
insert into luogo (citta, indirizzo) values ('Farafenni', '3 Grim Way');
insert into luogo (citta, indirizzo) values ('Linhares', '88703 Mifflin Avenue');
insert into luogo (citta, indirizzo) values ('Kumagaya', '9873 Pond Road');
insert into luogo (citta, indirizzo) values ('Astypálaia', '2309 Hooker Drive');
insert into luogo (citta, indirizzo) values ('Bobrovka', '07312 Sutherland Avenue');
insert into luogo (citta, indirizzo) values ('Krasnyy Yar', '91 Acker Place');
insert into luogo (citta, indirizzo) values ('Liliba', '20802 Dixon Court');
insert into luogo (citta, indirizzo) values ('Chaeryŏng-ŭp', '58 Gateway Avenue');
insert into luogo (citta, indirizzo) values ('Al Lagowa', '86 Veith Junction');
insert into luogo (citta, indirizzo) values ('Palecenan', '807 Anniversary Avenue');
insert into luogo (citta, indirizzo) values ('Cigemlong', '54024 Bonner Center');
insert into luogo (citta, indirizzo) values ('Dijon', '08197 Alpine Avenue');
insert into luogo (citta, indirizzo) values ('Bettendorf', '1122 Shasta Trail');
insert into luogo (citta, indirizzo) values ('Libertad', '91 Chive Point');
insert into luogo (citta, indirizzo) values ('Talun', '010 Del Sol Junction');
insert into luogo (citta, indirizzo) values ('Santulhão', '0954 East Junction');
insert into luogo (citta, indirizzo) values ('Göteborg', '5 Northridge Lane');
insert into luogo (citta, indirizzo) values ('Soweto', '64640 Prairie Rose Plaza');
insert into luogo (citta, indirizzo) values ('Dankama', '4 Londonderry Trail');
insert into luogo (citta, indirizzo) values ('Riangkroko', '0955 Farragut Place');
insert into luogo (citta, indirizzo) values ('Dallas', '80483 Hoard Hill');
insert into luogo (citta, indirizzo) values ('Zeewolde', '3176 Trailsway Way');
insert into luogo (citta, indirizzo) values ('Sanhe', '259 Corry Crossing');
insert into luogo (citta, indirizzo) values ('Gazimurskiy Zavod', '9 Corben Crossing');
insert into luogo (citta, indirizzo) values ('Gunungkendeng', '76366 Bluejay Point');
insert into luogo (citta, indirizzo) values ('Masty', '836 Farwell Circle');
insert into luogo (citta, indirizzo) values ('Tamansari', '6 Crest Line Circle');
insert into luogo (citta, indirizzo) values ('Cilangkap', '1 Mayfield Circle');
insert into luogo (citta, indirizzo) values ('San Miguel', '382 Charing Cross Trail');
insert into luogo (citta, indirizzo) values ('Galán', '17 Messerschmidt Place');
insert into luogo (citta, indirizzo) values ('Magsaysay', '2 Jenna Street');
insert into luogo (citta, indirizzo) values ('Cilangkap', '64 Longview Alley');
insert into luogo (citta, indirizzo) values ('Boleszkowice', '9853 Pond Pass');
insert into luogo (citta, indirizzo) values ('Bulianhe', '785 Northfield Parkway');
insert into luogo (citta, indirizzo) values ('Dongchengyuan', '18009 Donald Drive');
insert into luogo (citta, indirizzo) values ('Gagnoa', '70 Cordelia Hill');
insert into luogo (citta, indirizzo) values ('Kota Kinabalu', '2 Sunnyside Park');
insert into luogo (citta, indirizzo) values ('Latowicz', '32 Glacier Hill Street');
insert into luogo (citta, indirizzo) values ('Banjar Ambengan', '796 Thierer Street');
insert into luogo (citta, indirizzo) values ('Litian', '24 Merrick Street');
insert into luogo (citta, indirizzo) values ('Paris 17', '671 Ramsey Park');
insert into luogo (citta, indirizzo) values ('Muarabadak', '314 Dapin Crossing');
insert into luogo (citta, indirizzo) values ('Albi', '446 Forest Dale Parkway');
insert into luogo (citta, indirizzo) values ('Capacho Nuevo', '83458 Old Shore Crossing');
insert into luogo (citta, indirizzo) values ('Ryazan’', '0 Artisan Street');
insert into luogo (citta, indirizzo) values ('Biting', '576 Rutledge Drive');
insert into luogo (citta, indirizzo) values ('Santa Rita do Sapucaí', '79 Brown Drive');
insert into luogo (citta, indirizzo) values ('Aeka', '96 Kinsman Avenue');
insert into luogo (citta, indirizzo) values ('Capão da Canoa', '95 Bonner Way');
insert into luogo (citta, indirizzo) values ('Shangcun', '86662 Melrose Terrace');
insert into luogo (citta, indirizzo) values ('Udobnaya', '704 Jenifer Circle');
insert into luogo (citta, indirizzo) values ('Zongzhai', '258 Oakridge Park');
insert into luogo (citta, indirizzo) values ('Longcun', '27 Fuller Court');
insert into luogo (citta, indirizzo) values ('Jakubowice Murowane', '1904 Schlimgen Plaza');
insert into luogo (citta, indirizzo) values ('Gävle', '42 Melrose Terrace');
insert into luogo (citta, indirizzo) values ('Al Baqāliţah', '72 Muir Plaza');
insert into luogo (citta, indirizzo) values ('Zigong', '751 Crescent Oaks Drive');
insert into luogo (citta, indirizzo) values ('Gradec', '764 Talmadge Place');
insert into luogo (citta, indirizzo) values ('Kálymnos', '4 Gulseth Terrace');
insert into luogo (citta, indirizzo) values ('Cheongsong gun', '51643 Forest Dale Junction');
insert into luogo (citta, indirizzo) values ('Qingliu', '8 Namekagon Street');
insert into luogo (citta, indirizzo) values ('Bidikotak', '0939 Graceland Hill');
insert into luogo (citta, indirizzo) values ('Nicoya', '36 Ilene Lane');
insert into luogo (citta, indirizzo) values ('Palhoça', '2319 Dayton Terrace');
insert into luogo (citta, indirizzo) values ('Louisville', '42 Harbort Court');
insert into luogo (citta, indirizzo) values ('Xinmin', '17912 Weeping Birch Center');
insert into luogo (citta, indirizzo) values ('Bacong', '3844 Daystar Point');
insert into luogo (citta, indirizzo) values ('Koímisi', '6 Katie Court');
insert into luogo (citta, indirizzo) values ('Saint-Étienne-du-Rouvray', '07 Summer Ridge Junction');
insert into luogo (citta, indirizzo) values ('Kuzhu', '4480 Village Parkway');
insert into luogo (citta, indirizzo) values ('Llauta', '0 Dapin Trail');
insert into luogo (citta, indirizzo) values ('Gorē', '72455 Quincy Way');
insert into luogo (citta, indirizzo) values ('Taū', '9 Kingsford Parkway');
insert into luogo (citta, indirizzo) values ('Masape', '6012 Comanche Drive');
insert into luogo (citta, indirizzo) values ('Nkhotakota', '1 Anhalt Alley');
insert into luogo (citta, indirizzo) values ('Wawer', '8054 Carey Terrace');
insert into luogo (citta, indirizzo) values ('Oton', '137 Lakewood Hill');
insert into luogo (citta, indirizzo) values ('Praia das Maçãs', '5 Summer Ridge Court');
insert into luogo (citta, indirizzo) values ('Kumane', '17 Dryden Junction');
insert into luogo (citta, indirizzo) values ('Veřovice', '8435 Ronald Regan Lane');
insert into luogo (citta, indirizzo) values ('Blawi', '36365 Summit Point');
insert into luogo (citta, indirizzo) values ('Fátima', '2455 Morningstar Parkway');
insert into luogo (citta, indirizzo) values ('Jacksonville', '2 Lakewood Lane');
insert into luogo (citta, indirizzo) values ('Staropavlovskaya', '64 Barnett Hill');
insert into luogo (citta, indirizzo) values ('Oruro', '12 Gateway Place');
insert into luogo (citta, indirizzo) values ('Gaosheng', '26866 Lillian Lane');
insert into luogo (citta, indirizzo) values ('Jiyizhuang', '77060 Veith Lane');
insert into luogo (citta, indirizzo) values ('Leeuwarden', '4 Morrow Trail');
insert into luogo (citta, indirizzo) values ('Guocun', '02154 Bluestem Road');
insert into luogo (citta, indirizzo) values ('Trinity Ville', '16 Florence Circle');
insert into luogo (citta, indirizzo) values ('Beiwucha', '520 Pearson Alley');
insert into luogo (citta, indirizzo) values ('Rio Largo', '39754 Northview Way');
insert into luogo (citta, indirizzo) values ('Árgos', '790 Melody Point');
insert into luogo (citta, indirizzo) values ('Jiubao', '77929 Sutteridge Hill');
insert into luogo (citta, indirizzo) values ('Potou', '7 Florence Lane');
insert into luogo (citta, indirizzo) values ('Gävle', '5982 Anthes Pass');
insert into luogo (citta, indirizzo) values ('Pathein', '8 Thompson Circle');
insert into luogo (citta, indirizzo) values ('Denpasar', '842 Northwestern Circle');
insert into luogo (citta, indirizzo) values ('Huertas', '917 Luster Pass');
insert into luogo (citta, indirizzo) values ('Sancha', '83 Barby Street');
insert into luogo (citta, indirizzo) values ('Wiang Chiang Rung', '3 Magdeline Crossing');
insert into luogo (citta, indirizzo) values ('Asheville', '949 Elgar Court');
insert into luogo (citta, indirizzo) values ('Täby', '4 Paget Drive');
insert into luogo (citta, indirizzo) values ('Itapetininga', '7 Grasskamp Hill');
insert into luogo (citta, indirizzo) values ('Pietà', '63 Hoard Crossing');
insert into luogo (citta, indirizzo) values ('Vogar', '7305 Lillian Avenue');
insert into luogo (citta, indirizzo) values ('Tubungan', '893 Porter Road');
insert into luogo (citta, indirizzo) values ('Trzcianka', '39536 8th Road');
insert into luogo (citta, indirizzo) values ('Jiazhuang', '2 Reindahl Terrace');
insert into luogo (citta, indirizzo) values ('Ji’ergele Teguoleng', '579 Forest Run Center');
insert into luogo (citta, indirizzo) values ('Matelândia', '46 Lillian Center');
insert into luogo (citta, indirizzo) values ('Huitán', '9932 Golf Course Road');
insert into luogo (citta, indirizzo) values ('Wanurian', '9965 Lerdahl Way');
insert into luogo (citta, indirizzo) values ('Sukaraja', '9 Eastlawn Terrace');
insert into luogo (citta, indirizzo) values ('Karanganyar', '32224 Hagan Plaza');
insert into luogo (citta, indirizzo) values ('Mernek', '3 Kropf Hill');
insert into luogo (citta, indirizzo) values ('Smarhon’', '211 Barnett Center');
insert into luogo (citta, indirizzo) values ('Tapiramutá', '416 Mosinee Park');
insert into luogo (citta, indirizzo) values ('Renhe', '0 4th Alley');
insert into luogo (citta, indirizzo) values ('Wujiaying', '86218 Namekagon Pass');
insert into luogo (citta, indirizzo) values ('Bayt Sīrā', '12976 Packers Junction');
insert into luogo (citta, indirizzo) values ('Marathon', '09019 Ohio Pass');
insert into luogo (citta, indirizzo) values ('Gaïtánion', '10 Lindbergh Alley');
insert into luogo (citta, indirizzo) values ('Tiguion', '07 Dayton Center');
insert into luogo (citta, indirizzo) values ('Kota Bharu', '63 Forest Lane');
insert into luogo (citta, indirizzo) values ('Bunder', '35359 Superior Lane');
insert into luogo (citta, indirizzo) values ('Hepingyizu', '8 Delladonna Terrace');
insert into luogo (citta, indirizzo) values ('Gangkou', '7 Nevada Trail');
insert into luogo (citta, indirizzo) values ('San Eugenio', '9063 Jana Junction');
insert into luogo (citta, indirizzo) values ('Ferreira do Zêzere', '42 Holmberg Point');
insert into luogo (citta, indirizzo) values ('Weiwangzhuang', '04 Wayridge Street');
insert into luogo (citta, indirizzo) values ('Siruma', '66 Dwight Lane');
insert into luogo (citta, indirizzo) values ('Linares', '51 Kim Point');
insert into luogo (citta, indirizzo) values ('Tromsø', '5 Arizona Court');
insert into luogo (citta, indirizzo) values ('Mbumi', '447 Dwight Street');
insert into luogo (citta, indirizzo) values ('Obryte', '1512 Pleasure Pass');
insert into luogo (citta, indirizzo) values ('Badīn', '557 Merry Drive');
insert into luogo (citta, indirizzo) values ('Gävle', '1915 Stephen Hill');
insert into luogo (citta, indirizzo) values ('Tianzhou', '77979 Anzinger Road');
insert into luogo (citta, indirizzo) values ('Moba', '1 Lotheville Point');
insert into luogo (citta, indirizzo) values ('Novohrad-Volyns’kyy', '7 Golden Leaf Way');
insert into luogo (citta, indirizzo) values ('Hendaye', '17 Debs Park');
insert into luogo (citta, indirizzo) values ('Puyo', '71496 Bayside Way');
insert into luogo (citta, indirizzo) values ('Xuebu', '39750 Anthes Point');
insert into luogo (citta, indirizzo) values ('Carregado', '87 Little Fleur Street');
insert into luogo (citta, indirizzo) values ('Yaozhou', '1124 Moose Plaza');
insert into luogo (citta, indirizzo) values ('Brniště', '7302 Canary Park');
insert into luogo (citta, indirizzo) values ('Tambong', '80280 Mccormick Court');
insert into luogo (citta, indirizzo) values ('Hudson Bay', '2 Crownhardt Street');
insert into luogo (citta, indirizzo) values ('Atbasar', '3 Sullivan Center');
insert into luogo (citta, indirizzo) values ('Estefania', '15 Nevada Circle');
insert into luogo (citta, indirizzo) values ('Floresta', '11929 Milwaukee Parkway');
insert into luogo (citta, indirizzo) values ('Novoorsk', '6773 Shelley Plaza');
insert into luogo (citta, indirizzo) values ('São José de Mipibu', '9760 Forest Run Terrace');
insert into luogo (citta, indirizzo) values ('Bonanza', '6 Lillian Way');
insert into luogo (citta, indirizzo) values ('Cicurug', '990 Prairie Rose Hill');
insert into luogo (citta, indirizzo) values ('Jiaozuo', '483 Rusk Center');
insert into luogo (citta, indirizzo) values ('Entre Rios', '85050 Maple Wood Circle');
insert into luogo (citta, indirizzo) values ('Melipilla', '7 Manley Court');
insert into luogo (citta, indirizzo) values ('Riachão do Jacuípe', '79 Springview Alley');
insert into luogo (citta, indirizzo) values ('Krasnokumskoye', '02 Monument Parkway');
insert into luogo (citta, indirizzo) values ('Fiais da Beira', '691 Veith Street');
insert into luogo (citta, indirizzo) values ('Sal’sk', '4091 Merrick Alley');
insert into luogo (citta, indirizzo) values ('Shenshu', '93667 Village Lane');
insert into luogo (citta, indirizzo) values ('Kunting', '6 Schurz Pass');
insert into luogo (citta, indirizzo) values ('Khiliomódhi', '921 Debs Parkway');
insert into luogo (citta, indirizzo) values ('Lingtou', '2004 Haas Way');
insert into luogo (citta, indirizzo) values ('Amarillo', '56669 Anzinger Circle');
insert into luogo (citta, indirizzo) values ('Cañaveral', '5 Anniversary Lane');
insert into luogo (citta, indirizzo) values ('Takahata', '4290 Spohn Circle');
insert into luogo (citta, indirizzo) values ('Muara', '69725 Doe Crossing Terrace');
insert into luogo (citta, indirizzo) values ('Piggotts', '68768 Buhler Alley');
insert into luogo (citta, indirizzo) values ('Tyresö', '75414 Springview Park');
insert into luogo (citta, indirizzo) values ('Paris 01', '3 Ronald Regan Terrace');
insert into luogo (citta, indirizzo) values ('Plan de Ayala', '839 Amoth Pass');
insert into luogo (citta, indirizzo) values ('Księżpol', '90 Monument Trail');
insert into luogo (citta, indirizzo) values ('Washington', '005 Scott Center');
insert into luogo (citta, indirizzo) values ('Talitsa', '686 Meadow Ridge Park');
insert into luogo (citta, indirizzo) values ('Dabat', '3189 Rowland Street');
insert into luogo (citta, indirizzo) values ('Karanglo', '84 Main Drive');
insert into luogo (citta, indirizzo) values ('Rublëvo', '2190 Arrowood Crossing');
insert into luogo (citta, indirizzo) values ('Piribebuy', '7985 Grim Avenue');
insert into luogo (citta, indirizzo) values ('Yongchang', '67 Union Circle');
insert into luogo (citta, indirizzo) values ('Lanhe', '29 Oneill Park');
insert into luogo (citta, indirizzo) values ('Kiel', '73 Delladonna Avenue');
insert into luogo (citta, indirizzo) values ('Karuk', '098 Old Shore Park');
insert into luogo (citta, indirizzo) values ('Yur’yev-Pol’skiy', '361 Judy Pass');
insert into luogo (citta, indirizzo) values ('Yuanhou', '30 Lerdahl Point');
insert into luogo (citta, indirizzo) values ('Hongmen', '39 Walton Road');
insert into luogo (citta, indirizzo) values ('Mount Darwin', '45136 Homewood Avenue');
insert into luogo (citta, indirizzo) values ('Passo Fundo', '6092 Forster Point');
insert into luogo (citta, indirizzo) values ('Rubirizi', '8 Prairie Rose Point');
insert into luogo (citta, indirizzo) values ('Oshawa', '011 Oriole Hill');
insert into luogo (citta, indirizzo) values ('Kribi', '933 Prairieview Lane');
insert into luogo (citta, indirizzo) values ('Gusang', '03974 Kingsford Street');
insert into luogo (citta, indirizzo) values ('Ronggui', '5 Barnett Road');
insert into luogo (citta, indirizzo) values ('Ardazubre', '41750 Oneill Junction');
insert into luogo (citta, indirizzo) values ('Palpalá', '359 Buhler Street');
insert into luogo (citta, indirizzo) values ('Pingkai', '046 Derek Place');
insert into luogo (citta, indirizzo) values ('Beizhuang', '42228 Erie Pass');
insert into luogo (citta, indirizzo) values ('Liucheng', '2493 Goodland Center');
insert into luogo (citta, indirizzo) values ('Al Khafjī', '60087 Dakota Street');
insert into luogo (citta, indirizzo) values ('Pervomaysk', '93 Arizona Circle');
insert into luogo (citta, indirizzo) values ('Elbasan', '25906 Sunfield Plaza');
insert into luogo (citta, indirizzo) values ('Nanhai', '9 Northport Lane');
insert into luogo (citta, indirizzo) values ('Peoria', '10044 Scott Circle');
insert into luogo (citta, indirizzo) values ('New York City', '90 Di Loreto Parkway');
insert into luogo (citta, indirizzo) values ('Kompóti', '48 Florence Circle');
insert into luogo (citta, indirizzo) values ('Soeng Sang', '223 Dottie Trail');
insert into luogo (citta, indirizzo) values ('Älvsjö', '8 Fordem Crossing');
insert into luogo (citta, indirizzo) values ('Ōmuta', '6 Springs Point');
insert into luogo (citta, indirizzo) values ('Drenova', '78 Coleman Center');
insert into luogo (citta, indirizzo) values ('Asen', '3170 Linden Way');
insert into luogo (citta, indirizzo) values ('Lukou', '56588 Logan Drive');
insert into luogo (citta, indirizzo) values ('Una', '31362 Forster Place');
insert into luogo (citta, indirizzo) values ('Mutang', '7 Forest Dale Circle');
insert into luogo (citta, indirizzo) values ('Tuusniemi', '49968 Hermina Hill');
insert into luogo (citta, indirizzo) values ('Iset’', '857 Norway Maple Park');
insert into luogo (citta, indirizzo) values ('Satis', '2029 Mayfield Alley');
insert into luogo (citta, indirizzo) values ('Anding', '2 Dakota Point');
insert into luogo (citta, indirizzo) values ('Caluquembe', '2 Del Sol Place');
insert into luogo (citta, indirizzo) values ('Himaya', '2288 Laurel Parkway');
insert into luogo (citta, indirizzo) values ('Balingasag', '5 Buena Vista Place');
insert into luogo (citta, indirizzo) values ('Donghe', '69 Marcy Pass');
insert into luogo (citta, indirizzo) values ('Ivyanyets', '5002 Sauthoff Street');
insert into luogo (citta, indirizzo) values ('Gajiram', '79067 West Point');
insert into luogo (citta, indirizzo) values ('Hetang', '9758 Hazelcrest Place');
insert into luogo (citta, indirizzo) values ('Longcun', '609 Iowa Terrace');
insert into luogo (citta, indirizzo) values ('Menuma', '731 Westend Street');
insert into luogo (citta, indirizzo) values ('Psevdás', '391 Northfield Alley');
insert into luogo (citta, indirizzo) values ('Tvrdonice', '69943 5th Hill');
insert into luogo (citta, indirizzo) values ('Mriyunan', '08 School Trail');
insert into luogo (citta, indirizzo) values ('Kabanga', '214 Almo Avenue');
insert into luogo (citta, indirizzo) values ('Xinglongchang', '26996 Kinsman Road');
insert into luogo (citta, indirizzo) values ('Neftçala', '484 Bluestem Park');
insert into luogo (citta, indirizzo) values ('Patrocínio', '18 Fallview Hill');
insert into luogo (citta, indirizzo) values ('Pasiripis', '6333 Haas Court');
insert into luogo (citta, indirizzo) values ('Rennes', '53 Northridge Avenue');
insert into luogo (citta, indirizzo) values ('Marseille', '05137 Saint Paul Crossing');
insert into luogo (citta, indirizzo) values ('Lluidas Vale', '5 Dayton Circle');
insert into luogo (citta, indirizzo) values ('Ungsang', '9599 Roth Street');
insert into luogo (citta, indirizzo) values ('Matias Olímpio', '53226 Lindbergh Pass');
insert into luogo (citta, indirizzo) values ('Iogach', '72425 Barby Pass');
insert into luogo (citta, indirizzo) values ('Zhengdun', '60 Stang Court');
insert into luogo (citta, indirizzo) values ('Cergy-Pontoise', '9 Thierer Terrace');
insert into luogo (citta, indirizzo) values ('Sujitan', '62 Brentwood Park');
insert into luogo (citta, indirizzo) values ('Cergy-Pontoise', '8417 Johnson Way');
insert into luogo (citta, indirizzo) values ('Sukamulya', '9127 Dayton Road');
insert into luogo (citta, indirizzo) values ('Budapest', '6 Upham Point');
insert into luogo (citta, indirizzo) values ('Tempurejo', '61 Amoth Drive');
insert into luogo (citta, indirizzo) values ('Wentai', '4 Pearson Court');
insert into luogo (citta, indirizzo) values ('Karang Daye', '0 International Point');
insert into luogo (citta, indirizzo) values ('Kalanchak', '884 Bartillon Parkway');
insert into luogo (citta, indirizzo) values ('Los Lotes', '882 Spenser Center');
insert into luogo (citta, indirizzo) values ('Maoya', '7 Sugar Circle');
insert into luogo (citta, indirizzo) values ('Swedru', '5 Merchant Crossing');
insert into luogo (citta, indirizzo) values ('Yaotian', '68207 Mallory Drive');
insert into luogo (citta, indirizzo) values ('Kathmandu', '02799 Lukken Point');
insert into luogo (citta, indirizzo) values ('Potou', '248 Michigan Court');
insert into luogo (citta, indirizzo) values ('Huacapampa', '37 Butterfield Place');
insert into luogo (citta, indirizzo) values ('San Sebastian', '93 Gerald Hill');
insert into luogo (citta, indirizzo) values ('Xiyuan', '3417 Mandrake Junction');
insert into luogo (citta, indirizzo) values ('Caxias', '411 Warbler Place');
insert into luogo (citta, indirizzo) values ('Namīn', '24538 Hansons Street');
insert into luogo (citta, indirizzo) values ('Březová nad Svitavou', '9 Evergreen Road');
insert into luogo (citta, indirizzo) values ('Rudnichnyy', '35 Blue Bill Park Plaza');
insert into luogo (citta, indirizzo) values ('Moguqi', '136 Dennis Terrace');
insert into luogo (citta, indirizzo) values ('Makin Village', '7908 Beilfuss Way');
insert into luogo (citta, indirizzo) values ('Thiès Nones', '9057 Bluestem Circle');
insert into luogo (citta, indirizzo) values ('Ea T’ling', '386 Raven Point');
insert into luogo (citta, indirizzo) values ('Paranapanema', '7197 Grayhawk Center');
insert into luogo (citta, indirizzo) values ('Sarae', '9 Butternut Park');
insert into luogo (citta, indirizzo) values ('Qiaobian', '601 Clemons Way');
insert into luogo (citta, indirizzo) values ('Tungor', '787 Dixon Street');
insert into luogo (citta, indirizzo) values ('Puerto Boyacá', '13468 Continental Parkway');
insert into luogo (citta, indirizzo) values ('Tiecun', '7483 Myrtle Center');
insert into luogo (citta, indirizzo) values ('Kaeng Khoi', '7447 New Castle Point');
insert into luogo (citta, indirizzo) values ('Freiburg im Breisgau', '377 Southridge Terrace');
insert into luogo (citta, indirizzo) values ('Nikopol’', '36052 Merry Parkway');
insert into luogo (citta, indirizzo) values ('Ndélé', '1 Merry Alley');
insert into luogo (citta, indirizzo) values ('Stari Grad', '94 Nova Point');
insert into luogo (citta, indirizzo) values ('Melrose', '3 Saint Paul Alley');
insert into luogo (citta, indirizzo) values ('Paris 07', '38627 Becker Parkway');
insert into luogo (citta, indirizzo) values ('Chunghwa', '2 Glacier Hill Road');
insert into luogo (citta, indirizzo) values ('Kulia Village', '16315 Autumn Leaf Center');
insert into luogo (citta, indirizzo) values ('Lengshuitan', '1158 Tennyson Avenue');
insert into luogo (citta, indirizzo) values ('Port Moody', '1 Oriole Way');
insert into luogo (citta, indirizzo) values ('Oroqen Zizhiqi', '2691 Beilfuss Drive');
insert into luogo (citta, indirizzo) values ('Nong Hin', '3132 Fairfield Trail');
insert into luogo (citta, indirizzo) values ('Senhor do Bonfim', '3526 Ohio Place');
insert into luogo (citta, indirizzo) values ('Areeiro', '90 Larry Alley');
insert into luogo (citta, indirizzo) values ('Nakonde', '997 Morning Road');
insert into luogo (citta, indirizzo) values ('Suining', '3 Chive Hill');
insert into luogo (citta, indirizzo) values ('Ruzayevka', '8632 Jackson Drive');
insert into luogo (citta, indirizzo) values ('Kataba', '2 Butternut Lane');
insert into luogo (citta, indirizzo) values ('Changshou', '4908 Hermina Lane');
insert into luogo (citta, indirizzo) values ('Nizhnyaya Omka', '286 Village Center');
insert into luogo (citta, indirizzo) values ('Sale', '500 Ridgeway Trail');
insert into luogo (citta, indirizzo) values ('Kowary', '8 Dexter Hill');
insert into luogo (citta, indirizzo) values ('Pontal', '8 Blackbird Drive');
insert into luogo (citta, indirizzo) values ('Klimontów', '3608 Myrtle Court');
insert into luogo (citta, indirizzo) values ('Paritjunus', '57970 Parkside Plaza');
insert into luogo (citta, indirizzo) values ('Dauriya', '8 Nevada Drive');
insert into luogo (citta, indirizzo) values ('San Carlos', '96462 Dawn Point');
insert into luogo (citta, indirizzo) values ('Boulogne-sur-Mer', '2796 American Lane');
insert into luogo (citta, indirizzo) values ('Yongping', '0 Dahle Street');
insert into luogo (citta, indirizzo) values ('Cochadas', '9382 Becker Avenue');
insert into luogo (citta, indirizzo) values ('Torbeyevo', '5116 Moulton Way');
insert into luogo (citta, indirizzo) values ('Tanahedang', '26 Sutherland Drive');
insert into luogo (citta, indirizzo) values ('Pasirpengarayan', '19 Northport Court');
insert into luogo (citta, indirizzo) values ('Vikhorevka', '935 Menomonie Point');
insert into luogo (citta, indirizzo) values ('Hagondange', '5 Valley Edge Park');
insert into luogo (citta, indirizzo) values ('Kabac', '57686 Shelley Alley');
insert into luogo (citta, indirizzo) values ('Ya’ngan', '6026 Dixon Place');
insert into luogo (citta, indirizzo) values ('Cristóbal', '37660 Corscot Lane');
insert into luogo (citta, indirizzo) values ('Göteborg', '027 Hoepker Court');
insert into luogo (citta, indirizzo) values ('Silvares', '1933 Ryan Circle');
insert into luogo (citta, indirizzo) values ('Sŭedinenie', '17 Sheridan Trail');
insert into luogo (citta, indirizzo) values ('Kozhva', '659 Dexter Way');
insert into luogo (citta, indirizzo) values ('Hongshanyao', '3 Almo Plaza');
insert into luogo (citta, indirizzo) values ('Nagorsk', '38 Rusk Way');
insert into luogo (citta, indirizzo) values ('Paris La Défense', '07 Acker Court');
insert into luogo (citta, indirizzo) values ('Mongo', '50 Ramsey Junction');
insert into luogo (citta, indirizzo) values ('Rila', '0 Delaware Hill');
insert into luogo (citta, indirizzo) values ('Kishk-e Nakhūd', '0583 Westerfield Parkway');
insert into luogo (citta, indirizzo) values ('Zawiya', '40 Fallview Crossing');
insert into luogo (citta, indirizzo) values ('Hadāli', '23613 Tennessee Avenue');
insert into luogo (citta, indirizzo) values ('Nejo', '6 Hovde Lane');
insert into luogo (citta, indirizzo) values ('Bulo', '80 Carioca Court');
insert into luogo (citta, indirizzo) values ('Candon', '06726 Anzinger Hill');
insert into luogo (citta, indirizzo) values ('Sumaré', '62 Sachtjen Parkway');
insert into luogo (citta, indirizzo) values ('Ciénaga', '67 Gateway Alley');
insert into luogo (citta, indirizzo) values ('Świeradów-Zdrój', '8 Becker Junction');
insert into luogo (citta, indirizzo) values ('Sunagawa', '5 Elmside Alley');
insert into luogo (citta, indirizzo) values ('Koronadal', '444 Grayhawk Pass');
insert into luogo (citta, indirizzo) values ('Santa Teresa', '37 Schiller Place');
insert into luogo (citta, indirizzo) values ('Nantes', '861 Farragut Drive');
insert into luogo (citta, indirizzo) values ('Pashkovskiy', '611 Vermont Point');
insert into luogo (citta, indirizzo) values ('Sukasari', '42 Doe Crossing Park');
insert into luogo (citta, indirizzo) values ('Arlington', '2113 Dovetail Parkway');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('CYDTFN83D62O801H', 'Andrew', 'Marshall', 'Albi', '446 Forest Dale Parkway');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('RMSVPJ12E06P994U', 'Matthew', 'Wheeler', 'Sukaraja', '9 Eastlawn Terrace');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('KNMRLP43R96Y949J', 'Judy', 'Rose', 'Riangkroko', '0955 Farragut Place');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('AOTFCB94S88D323S', 'James', 'Watson', 'Boulogne-sur-Mer', '2796 American Lane');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('VMQEJZ38Y13H905B', 'Eric', 'Alexander', 'Wentai', '4 Pearson Court');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('TFUDBC18W30V753E', 'Elizabeth', 'Riley', 'Jacksonville', '2 Lakewood Lane');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('HQRVFL93R01P879Y', 'Deborah', 'Edwards', 'Zhengdun', '60 Stang Court');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('TIHJUC06C68R524A', 'Eric', 'Cook', 'Vogar', '7305 Lillian Avenue');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('XAQWPB74E93I993E', 'Mark', 'Garza', 'Oke Mesi', '56 Amoth Parkway');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('QNOJES83S53W988H', 'Earl', 'Mills', 'Al Lagowa', '86 Veith Junction');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('HBORAL34C91E401W', 'Theresa', 'Bailey', 'Lushan', '40444 7th Plaza');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('HLPRKC83I35V546H', 'Sara', 'Allen', 'Veřovice', '8435 Ronald Regan Lane');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('NJMEYH03M57C669D', 'Matthew', 'King', 'Balrothery', '13 Vahlen Parkway');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('HXULSE22E51S717I', 'Steven', 'Alvarez', 'Cergy-Pontoise', '9 Thierer Terrace');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('TFJLPA10Y55S860J', 'Angela', 'Reynolds', 'Madrid', '096 Melody Junction');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('YKSOUC25C67E930A', 'Harold', 'Long', 'Iset’', '857 Norway Maple Park');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('UDHIKT82U77V282R', 'Jane', 'Thompson', 'Entre Rios', '85050 Maple Wood Circle');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('UODTQV22N12S229K', 'Teresa', 'Hunter', 'Vogar', '7305 Lillian Avenue');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('HXAEBT11F92L476K', 'Willie', 'Banks', 'Kozhva', '659 Dexter Way');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('RHSCJF35F27T566D', 'Doris', 'Woods', 'Huitán', '9932 Golf Course Road');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('VTHXKA28Y42K903I', 'Steve', 'Hawkins', 'Caxias', '411 Warbler Place');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('KXFLRG41V44C012N', 'Michael', 'Webb', 'Arlington', '2113 Dovetail Parkway');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('HMXYNS02J87C389K', 'Eric', 'Gomez', 'Dondo', '295 Declaration Circle');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('ODEGLR69G25P179Z', 'Rose', 'Henderson', 'Drenova', '78 Coleman Center');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('ZWJKVL29V84W243U', 'Patricia', 'Lynch', 'Jiubao', '77929 Sutteridge Hill');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('THCIQS63Z21D234V', 'Jeffrey', 'Medina', 'Huanfeng', '25 Golf View Place');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('AMGSOU02T42U148D', 'Julia', 'Little', 'Cristóbal', '37660 Corscot Lane');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('QYIATG69M29F648O', 'Michelle', 'Payne', 'Guocun', '02154 Bluestem Road');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('EGWYML53H52V479I', 'Anna', 'Kim', 'Täby', '4 Paget Drive');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('TNOUCX84P89Z484F', 'Daniel', 'Butler', 'Puyo', '71496 Bayside Way');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('YTOJSV02M26W769S', 'Stephanie', 'Mccoy', 'Rila', '0 Delaware Hill');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('VUMTIS85O67U302B', 'Wayne', 'Cook', 'Tamansari', '6 Crest Line Circle');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('HNQSZY85V83W309H', 'Diane', 'Barnes', 'Cilangkap', '1 Mayfield Circle');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('ZUOCTK93Q57W512K', 'Amanda', 'Andrews', 'Hetang', '9758 Hazelcrest Place');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('LMAZQD65D94N338U', 'Anna', 'Austin', 'Shangxian', '207 Stuart Street');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('NKFAQS92P26L797N', 'Cheryl', 'Lee', 'Dankama', '4 Londonderry Trail');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('CGVBXZ84F14Q859X', 'Howard', 'Baker', 'Novoorsk', '6773 Shelley Plaza');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('BDLNUQ87A74N842Q', 'Betty', 'Owens', 'Senhor do Bonfim', '3526 Ohio Place');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('OPSJXQ88J70X471H', 'Jonathan', 'Ross', 'Tiecun', '7483 Myrtle Center');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('BSCAXW18H42R366I', 'Jimmy', 'Dixon', 'Sarae', '9 Butternut Park');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('SGPVYC54K37Y614E', 'Jerry', 'Bennett', 'Boston', '769 Sundown Lane');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('EMCRAJ52W88I906Y', 'Ryan', 'Moreno', 'Ziębice', '08931 Reinke Way');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('WCUSXA52S95N012G', 'Charles', 'Sanders', 'Moguqi', '136 Dennis Terrace');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('GKXSOF27U19Y632J', 'Denise', 'Peterson', 'Provins', '517 Everett Pass');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('NZURQW07V26W613Y', 'Stephanie', 'Taylor', 'Hongguang', '42855 Manufacturers Court');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('NWRYLK01G00Q732N', 'Ruby', 'Cruz', 'Capão da Canoa', '95 Bonner Way');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('KZIBJF78Z54T297D', 'Jennifer', 'Frazier', 'Gajiram', '79067 West Point');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('UFNEQV92N24W661C', 'Sharon', 'Myers', 'Dutsin Ma', '3663 Dexter Place');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('MEUGSC51Y39J574X', 'Howard', 'Myers', 'Weiwangzhuang', '04 Wayridge Street');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('SLWRXP97P00K363V', 'Bruce', 'Williamson', 'Ndélé', '1 Merry Alley');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('DIWQEL90U14W018A', 'Mark', 'Long', 'São José de Mipibu', '9760 Forest Run Terrace');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('HKYQIE50Y39F640D', 'Gary', 'Warren', 'Cilangkap', '1 Mayfield Circle');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('NPQVRH26L99O487X', 'Gerald', 'Miller', 'Palpalá', '359 Buhler Street');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('KGICND54Y87D287H', 'Jason', 'Ward', 'Dijon', '08197 Alpine Avenue');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('BOUGHZ41R27X483Z', 'Johnny', 'Bryant', 'Castleblayney', '74 Lake View Terrace');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('RBFELH44P82Q132O', 'Jeremy', 'Black', 'Areeiro', '90 Larry Alley');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('GYWIJZ29Y78P151J', 'John', 'Harrison', 'Matias Olímpio', '53226 Lindbergh Pass');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('UXCTMI91A28B223O', 'Anthony', 'Jones', 'Jiyizhuang', '77060 Veith Lane');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('QKVRSB10K24S736H', 'Sean', 'Sims', 'Sanlanbahai', '500 Hazelcrest Hill');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('PKMNSJ13A54Y926P', 'Norma', 'Morales', 'Weiwangzhuang', '04 Wayridge Street');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('GMWBVD23K54N412F', 'Annie', 'Gutierrez', 'Fátima', '2455 Morningstar Parkway');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('OKBQMX01V32Z767H', 'Donald', 'Anderson', 'Swedru', '5 Merchant Crossing');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('IRZAJM89I68C301T', 'Philip', 'Fisher', 'Aeka', '96 Kinsman Avenue');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('DMTSUP71S31A293U', 'Lillian', 'Carroll', 'Kissónerga', '64 Bellgrove Lane');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('JDFCYQ74B58S276E', 'Andrea', 'Jenkins', 'Tuwa', '13633 Canary Place');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('HNTBFL70J16W581N', 'Martin', 'Graham', 'Gaoqiao', '61412 Eagle Crest Place');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('LWGEOX97W88F725Q', 'Lillian', 'Morales', 'Wujingfu', '821 Commercial Terrace');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('WJRXVO39T77P821G', 'Shirley', 'Washington', 'Klimontów', '3608 Myrtle Court');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('LKYCTP73V98J114E', 'Donna', 'Kelley', 'Ferreira do Zêzere', '42 Holmberg Point');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('MJXUBS60T73U000G', 'Lois', 'Rice', 'Rennes', '53 Northridge Avenue');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('ISKUAE91Y92T572K', 'Marie', 'Berry', 'Wiang Chiang Rung', '3 Magdeline Crossing');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('KZFVWL47Q21T073C', 'Barbara', 'Castillo', 'Cheongsong gun', '51643 Forest Dale Junction');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('EGZTYL91X92S437X', 'Sharon', 'Weaver', 'Bielice', '44 Dexter Pass');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('TRZQDY44I41H385D', 'Emily', 'Carpenter', 'Göteborg', '027 Hoepker Court');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('WSTVXH36G23E853Z', 'Larry', 'Cooper', 'Paranapanema', '7197 Grayhawk Center');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('HNKIOQ68X17J011N', 'Bonnie', 'Clark', 'Gazimurskiy Zavod', '9 Corben Crossing');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('WUBTSM78X70C518U', 'Juan', 'Ortiz', 'Selizharovo', '168 Rutledge Terrace');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('PDMQGO08G81P115R', 'Tammy', 'Kim', 'Himaya', '2288 Laurel Parkway');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('EPRTQI78Y89U201V', 'Lillian', 'Dunn', 'Zhengdun', '60 Stang Court');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('XUYFEV81T94F087T', 'Larry', 'Jones', 'Casal da Anja', '9035 Myrtle Park');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('LKHFMC28J43D552S', 'Margaret', 'Watson', 'Caluquembe', '2 Del Sol Place');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('ZLGYAQ73C19V347E', 'George', 'Wright', 'Paris 07', '38627 Becker Parkway');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('IWOGRM32I54V417G', 'Jean', 'Larson', 'Hägersten', '06323 Anthes Drive');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('UFCLNM80G61L837A', 'Brandon', 'Morrison', 'Grujugan', '63 Moulton Crossing');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('QSUPOL93H30M238B', 'Lois', 'Alvarez', 'Dupnitsa', '7471 Barby Street');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('KAIVWL36Z49Y360J', 'Scott', 'Elliott', 'Sendafa', '55 Hudson Place');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('HIUBWC48S11W075N', 'Lois', 'Kim', 'Changshou', '4908 Hermina Lane');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('BKWTGV11X72P857I', 'Terry', 'Cruz', 'Huitán', '9932 Golf Course Road');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('UJCFRT85K88S107L', 'Karen', 'Gordon', 'Da’an', '05 Schmedeman Circle');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('GDPXQF93J29D590I', 'Irene', 'Jordan', 'Dankama', '4 Londonderry Trail');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('ZUELVH09T10O307C', 'Tina', 'Freeman', 'Marathon', '09019 Ohio Pass');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('MRWGLN45Y12N351R', 'Kathleen', 'Jenkins', 'Tamansari', '6 Crest Line Circle');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('YINTFQ59R04V058R', 'Catherine', 'Warren', 'Shangxian', '207 Stuart Street');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('QYWZSD26L71N133I', 'Antonio', 'Mcdonald', 'Göteborg', '027 Hoepker Court');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('EBZPSK96V72C394W', 'Ann', 'Jenkins', 'Lushan', '40444 7th Plaza');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('BARTCQ79P64W004H', 'Raymond', 'Cooper', 'Bielice', '44 Dexter Pass');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('PUXKTN70V66W017O', 'Elizabeth', 'Moreno', 'Bugis', '80 Luster Court');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('VRJECZ43M60R161Y', 'Ruth', 'Medina', 'Melipilla', '7 Manley Court');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('NWHYQK28Q80W469K', 'Anne', 'Hansen', 'Oshawa', '011 Oriole Hill');
insert into cliente (codice_fiscale, nome, cognome, citta_fatturazione, indirizzo_fatturazione) values ('BCOTMU96P27J118X', 'Elizabeth', 'Hanson', 'Oshawa', '011 Oriole Hill');
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
INSERT INTO `fattura` (`numero`, `data_fattura`, `descrizione`, `importo`, `cliente`, `investigazione`, `caso`)
VALUES
	(1, '1978-01-07', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 66831.67, 'EPRTQI78Y89U201V', 1, 2),
	(2, '1903-07-08', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 89354.60, 'DMTSUP71S31A293U', 1, 88),
	(3, '1994-06-16', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 58354.22, 'BCOTMU96P27J118X', 1, 78),
	(4, '1937-05-30', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 17964.78, 'AMGSOU02T42U148D', 1, 1),
	(5, '1901-12-11', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 7787.91, 'QYIATG69M29F648O', 1, 63),
	(6, '1931-02-17', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 14986.50, 'MRWGLN45Y12N351R', 1, 98),
	(7, '1919-06-28', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 25345.39, 'HXAEBT11F92L476K', 1, 4),
	(8, '2010-06-15', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 23133.29, 'LKYCTP73V98J114E', 1, 82),
	(9, '1932-11-20', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 86627.65, 'IWOGRM32I54V417G', 1, 27),
	(10, '1927-07-20', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 74032.39, 'SGPVYC54K37Y614E', 1, 35),
	(11, '1929-06-30', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 10545.45, 'VTHXKA28Y42K903I', 1, 42),
	(12, '1890-11-15', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 50085.46, 'GMWBVD23K54N412F', 1, 65),
	(13, '1892-06-03', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 42656.65, 'THCIQS63Z21D234V', 1, 9),
	(14, '1931-05-02', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 2120.93, 'OPSJXQ88J70X471H', 1, 17),
	(15, '1972-10-26', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.', 79710.55, 'CYDTFN83D62O801H', 1, 8),
	(16, '1986-03-08', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 41747.96, 'NPQVRH26L99O487X', 1, 15),
	(17, '1895-05-22', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 73712.42, 'WCUSXA52S95N012G', 1, 20),
	(18, '1929-11-16', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 32870.27, 'AMGSOU02T42U148D', 1, 38),
	(19, '1987-11-11', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 33343.25, 'QNOJES83S53W988H', 1, 12),
	(20, '1891-03-18', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 45175.34, 'GMWBVD23K54N412F', 3, 65),
	(21, '1996-09-23', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 32847.20, 'EMCRAJ52W88I906Y', 1, 57),
	(22, '2001-06-24', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 58580.89, 'KXFLRG41V44C012N', 1, 69),
	(23, '1917-10-16', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 20392.58, 'HXAEBT11F92L476K', 2, 4),
	(24, '1985-12-23', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 59613.59, 'TFUDBC18W30V753E', 1, 96),
	(25, '1960-01-23', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 66755.08, 'OPSJXQ88J70X471H', 2, 17),
	(26, '1897-12-28', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 95412.26, 'WSTVXH36G23E853Z', 1, 32),
	(27, '1988-03-01', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 3650.43, 'UJCFRT85K88S107L', 1, 91),
	(28, '1987-04-05', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 92808.06, 'CYDTFN83D62O801H', 1, 6),
	(29, '1994-09-06', 'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.', 84115.74, 'TFUDBC18W30V753E', 2, 96),
	(30, '1960-07-17', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.', 55552.31, 'OKBQMX01V32Z767H', 1, 45),
	(31, '2016-04-17', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 43527.77, 'BARTCQ79P64W004H', 1, 61),
	(32, '1967-12-25', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 31446.20, 'MRWGLN45Y12N351R', 2, 98),
	(33, '1927-11-14', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.', 12102.91, 'MRWGLN45Y12N351R', 3, 98),
	(34, '1909-09-07', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 88216.69, 'THCIQS63Z21D234V', 2, 9),
	(35, '1900-11-30', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 66726.04, 'PKMNSJ13A54Y926P', 1, 5),
	(36, '2001-06-26', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 91872.00, 'NWRYLK01G00Q732N', 1, 31),
	(37, '1936-05-12', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 12567.25, 'LKYCTP73V98J114E', 1, 92),
	(38, '1905-12-18', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 60437.56, 'HBORAL34C91E401W', 1, 81),
	(39, '1892-04-17', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', 65050.81, 'VRJECZ43M60R161Y', 1, 94),
	(40, '1928-02-23', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', 90229.35, 'MEUGSC51Y39J574X', 1, 33),
	(41, '1925-05-13', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 48688.84, 'TFUDBC18W30V753E', 1, 83),
	(42, '1920-08-02', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 81176.51, 'NKFAQS92P26L797N', 1, 79),
	(43, '1968-04-22', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 21284.76, 'IWOGRM32I54V417G', 2, 27),
	(44, '1908-04-21', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 58355.54, 'IRZAJM89I68C301T', 1, 99),
	(45, '1962-01-09', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 60722.36, 'DMTSUP71S31A293U', 2, 88),
	(46, '1954-11-23', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 74732.15, 'NZURQW07V26W613Y', 1, 50),
	(47, '1900-05-23', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 41421.24, 'QYIATG69M29F648O', 2, 63),
	(48, '1891-07-01', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 2969.05, 'HNKIOQ68X17J011N', 1, 34),
	(49, '1988-11-15', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 12997.42, 'THCIQS63Z21D234V', 1, 40),
	(50, '1973-01-01', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 27854.37, 'ISKUAE91Y92T572K', 1, 7),
	(51, '1922-02-17', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 18014.72, 'OPSJXQ88J70X471H', 3, 17),
	(52, '1971-04-17', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 56947.46, 'NWHYQK28Q80W469K', 1, 73),
	(53, '1923-04-08', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 30426.75, 'EPRTQI78Y89U201V', 2, 2),
	(54, '1895-05-07', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 58072.85, 'BSCAXW18H42R366I', 1, 28),
	(55, '1916-02-11', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 98342.79, 'WJRXVO39T77P821G', 1, 18),
	(56, '1923-10-24', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.', 72493.85, 'XUYFEV81T94F087T', 1, 25),
	(57, '1977-07-21', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 3671.59, 'NKFAQS92P26L797N', 2, 79),
	(58, '1936-10-07', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 97398.06, 'BKWTGV11X72P857I', 1, 11),
	(59, '1996-06-29', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 36650.97, 'HBORAL34C91E401W', 2, 81),
	(60, '1926-05-01', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 25591.46, 'HNTBFL70J16W581N', 1, 16),
	(61, '1964-06-22', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', 98305.02, 'OKBQMX01V32Z767H', 2, 45),
	(62, '1998-03-10', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 5121.80, 'WSTVXH36G23E853Z', 1, 21),
	(63, '2012-06-29', 'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.', 62570.01, 'UFNEQV92N24W661C', 1, 93),
	(64, '1912-03-29', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 10541.05, 'YTOJSV02M26W769S', 1, 84),
	(65, '1943-02-05', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.', 47025.54, 'QYWZSD26L71N133I', 1, 37),
	(66, '1967-02-24', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 49708.77, 'UODTQV22N12S229K', 1, 39),
	(67, '1991-08-03', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', 10046.94, 'LKYCTP73V98J114E', 2, 82),
	(68, '1896-12-14', 'In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', 42966.57, 'CYDTFN83D62O801H', 1, 62),
	(69, '1936-05-17', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.', 98373.41, 'EPRTQI78Y89U201V', 1, 24),
	(70, '2002-05-18', 'In congue. Etiam justo. Etiam pretium iaculis justo.', 56064.18, 'EPRTQI78Y89U201V', 3, 2),
	(71, '1977-10-22', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.', 29310.07, 'ISKUAE91Y92T572K', 2, 7),
	(72, '1948-05-10', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', 26105.16, 'MEUGSC51Y39J574X', 2, 33),
	(73, '1999-11-18', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 60926.00, 'VRJECZ43M60R161Y', 1, 95),
	(74, '1970-05-23', 'Fusce consequat. Nulla nisl. Nunc nisl.', 81703.87, 'JDFCYQ74B58S276E', 1, 48),
	(75, '1955-04-22', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.', 46787.99, 'IRZAJM89I68C301T', 1, 44),
	(76, '1907-04-16', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.', 33499.18, 'MRWGLN45Y12N351R', 4, 98),
	(77, '1955-01-03', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 46288.24, 'OPSJXQ88J70X471H', 4, 17),
	(78, '2015-06-22', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 28212.57, 'VTHXKA28Y42K903I', 2, 42),
	(79, '1904-01-13', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 59906.82, 'THCIQS63Z21D234V', 2, 40),
	(80, '1951-01-09', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 26339.12, 'EMCRAJ52W88I906Y', 1, 86),
	(81, '1894-07-17', 'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', 57442.67, 'JDFCYQ74B58S276E', 2, 48),
	(82, '1913-12-12', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 15700.58, 'PUXKTN70V66W017O', 1, 59),
	(83, '1937-11-05', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', 70024.01, 'WJRXVO39T77P821G', 1, 74),
	(84, '1954-06-16', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 8975.16, 'TFUDBC18W30V753E', 3, 96),
	(85, '1957-05-18', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.', 40928.67, 'BSCAXW18H42R366I', 3, 28),
	(86, '1945-06-29', 'Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.', 56566.70, 'BCOTMU96P27J118X', 2, 78),
	(87, '2016-11-13', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 22226.57, 'LKYCTP73V98J114E', 3, 82),
	(88, '2001-04-03', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', 42532.00, 'UFCLNM80G61L837A', 1, 26),
	(89, '1943-10-16', 'Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', 89336.82, 'HXAEBT11F92L476K', 3, 4),
	(90, '1958-06-18', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.', 40827.09, 'BCOTMU96P27J118X', 3, 78),
	(91, '1923-02-23', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.', 54076.78, 'NWHYQK28Q80W469K', 2, 73),
	(92, '1994-05-10', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 53770.85, 'BSCAXW18H42R366I', 2, 28),
	(93, '1915-06-30', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', 70669.85, 'KXFLRG41V44C012N', 2, 69),
	(94, '1922-05-23', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 79487.85, 'LKYCTP73V98J114E', 2, 92),
	(95, '1922-03-13', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', 92823.24, 'GYWIJZ29Y78P151J', 1, 13),
	(96, '1929-01-11', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.', 52419.51, 'TRZQDY44I41H385D', 1, 87),
	(97, '1992-11-27', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 44463.49, 'GMWBVD23K54N412F', 2, 65),
	(98, '1922-09-25', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 51586.03, 'NKFAQS92P26L797N', 3, 79),
	(99, '1932-07-24', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.', 2904.07, 'BSCAXW18H42R366I', 4, 28),
	(100, '1940-10-19', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.', 36380.39, 'BKWTGV11X72P857I', 2, 11);
insert into telefono (numero, cliente) values ('33-(581)716-3845', 'HXAEBT11F92L476K');
insert into telefono (numero, cliente) values ('86-(851)430-8433', 'MEUGSC51Y39J574X');
insert into telefono (numero, cliente) values ('93-(182)854-4521', 'KZFVWL47Q21T073C');
insert into telefono (numero, cliente) values ('84-(409)228-9842', 'VUMTIS85O67U302B');
insert into telefono (numero, cliente) values ('86-(166)944-9655', 'IRZAJM89I68C301T');
insert into telefono (numero, cliente) values ('7-(734)911-8460', 'EBZPSK96V72C394W');
insert into telefono (numero, cliente) values ('353-(935)555-3926', 'HNTBFL70J16W581N');
insert into telefono (numero, cliente) values ('504-(461)997-6448', 'EMCRAJ52W88I906Y');
insert into telefono (numero, cliente) values ('380-(487)507-0537', 'IWOGRM32I54V417G');
insert into telefono (numero, cliente) values ('374-(966)271-7553', 'BKWTGV11X72P857I');
insert into telefono (numero, cliente) values ('84-(864)422-1055', 'GMWBVD23K54N412F');
insert into telefono (numero, cliente) values ('502-(815)560-0897', 'UFCLNM80G61L837A');
insert into telefono (numero, cliente) values ('504-(529)914-8259', 'PKMNSJ13A54Y926P');
insert into telefono (numero, cliente) values ('389-(306)657-8982', 'QYWZSD26L71N133I');
insert into telefono (numero, cliente) values ('86-(824)889-7908', 'MRWGLN45Y12N351R');
insert into telefono (numero, cliente) values ('86-(869)121-1766', 'VUMTIS85O67U302B');
insert into telefono (numero, cliente) values ('55-(398)560-2397', 'QYIATG69M29F648O');
insert into telefono (numero, cliente) values ('386-(421)492-4688', 'EGWYML53H52V479I');
insert into telefono (numero, cliente) values ('86-(197)334-8063', 'WSTVXH36G23E853Z');
insert into telefono (numero, cliente) values ('62-(666)753-2485', 'LKHFMC28J43D552S');
insert into telefono (numero, cliente) values ('595-(658)554-7333', 'UODTQV22N12S229K');
insert into telefono (numero, cliente) values ('86-(673)959-7877', 'QYIATG69M29F648O');
insert into telefono (numero, cliente) values ('63-(561)406-9913', 'KGICND54Y87D287H');
insert into telefono (numero, cliente) values ('55-(729)575-3978', 'OKBQMX01V32Z767H');
insert into telefono (numero, cliente) values ('420-(567)340-2327', 'RBFELH44P82Q132O');
insert into telefono (numero, cliente) values ('66-(642)747-6027', 'BOUGHZ41R27X483Z');
insert into telefono (numero, cliente) values ('7-(397)769-5912', 'QYIATG69M29F648O');
insert into telefono (numero, cliente) values ('86-(877)773-6855', 'DIWQEL90U14W018A');
insert into telefono (numero, cliente) values ('591-(941)723-3784', 'RHSCJF35F27T566D');
insert into telefono (numero, cliente) values ('54-(830)402-9937', 'HQRVFL93R01P879Y');
insert into telefono (numero, cliente) values ('52-(105)213-3912', 'YINTFQ59R04V058R');
insert into telefono (numero, cliente) values ('351-(234)863-9504', 'BKWTGV11X72P857I');
insert into telefono (numero, cliente) values ('86-(191)384-1883', 'TFJLPA10Y55S860J');
insert into telefono (numero, cliente) values ('62-(166)941-3615', 'HQRVFL93R01P879Y');
insert into telefono (numero, cliente) values ('371-(615)156-5686', 'QNOJES83S53W988H');
insert into telefono (numero, cliente) values ('1-(912)486-0376', 'HLPRKC83I35V546H');
insert into telefono (numero, cliente) values ('1-(630)462-5210', 'WSTVXH36G23E853Z');
insert into telefono (numero, cliente) values ('63-(420)760-5295', 'UDHIKT82U77V282R');
insert into telefono (numero, cliente) values ('60-(501)194-6778', 'ISKUAE91Y92T572K');
insert into telefono (numero, cliente) values ('86-(805)291-2713', 'PUXKTN70V66W017O');
insert into telefono (numero, cliente) values ('86-(353)927-5890', 'IWOGRM32I54V417G');
insert into telefono (numero, cliente) values ('7-(356)654-2254', 'WUBTSM78X70C518U');
insert into telefono (numero, cliente) values ('66-(349)724-2490', 'BARTCQ79P64W004H');
insert into telefono (numero, cliente) values ('86-(793)556-4626', 'UODTQV22N12S229K');
insert into telefono (numero, cliente) values ('62-(627)234-4907', 'BOUGHZ41R27X483Z');
insert into telefono (numero, cliente) values ('62-(767)216-9703', 'SGPVYC54K37Y614E');
insert into telefono (numero, cliente) values ('63-(468)755-4558', 'HBORAL34C91E401W');
insert into telefono (numero, cliente) values ('380-(475)590-3588', 'MEUGSC51Y39J574X');
insert into telefono (numero, cliente) values ('86-(651)497-8302', 'YINTFQ59R04V058R');
insert into telefono (numero, cliente) values ('63-(244)142-4413', 'OKBQMX01V32Z767H');
insert into telefono (numero, cliente) values ('86-(731)600-3234', 'TIHJUC06C68R524A');
insert into telefono (numero, cliente) values ('994-(848)731-2097', 'SLWRXP97P00K363V');
insert into telefono (numero, cliente) values ('94-(935)814-1118', 'HIUBWC48S11W075N');
insert into telefono (numero, cliente) values ('268-(727)205-8305', 'XUYFEV81T94F087T');
insert into telefono (numero, cliente) values ('7-(534)134-5882', 'CGVBXZ84F14Q859X');
insert into telefono (numero, cliente) values ('86-(819)117-9984', 'HMXYNS02J87C389K');
insert into telefono (numero, cliente) values ('57-(180)495-7829', 'GMWBVD23K54N412F');
insert into telefono (numero, cliente) values ('33-(506)998-3432', 'NZURQW07V26W613Y');
insert into telefono (numero, cliente) values ('212-(708)525-5134', 'MRWGLN45Y12N351R');
insert into telefono (numero, cliente) values ('63-(254)756-0342', 'THCIQS63Z21D234V');
insert into telefono (numero, cliente) values ('33-(132)333-2163', 'LKYCTP73V98J114E');
insert into telefono (numero, cliente) values ('63-(611)129-5598', 'GDPXQF93J29D590I');
insert into telefono (numero, cliente) values ('86-(224)745-6207', 'MRWGLN45Y12N351R');
insert into telefono (numero, cliente) values ('351-(455)942-7650', 'ODEGLR69G25P179Z');
insert into telefono (numero, cliente) values ('374-(341)109-0974', 'NJMEYH03M57C669D');
insert into telefono (numero, cliente) values ('221-(601)319-6867', 'DIWQEL90U14W018A');
insert into telefono (numero, cliente) values ('86-(704)468-4014', 'KZFVWL47Q21T073C');
insert into telefono (numero, cliente) values ('33-(562)818-8271', 'BCOTMU96P27J118X');
insert into telefono (numero, cliente) values ('55-(249)520-6880', 'NWHYQK28Q80W469K');
insert into telefono (numero, cliente) values ('1-(629)553-5979', 'EMCRAJ52W88I906Y');
insert into telefono (numero, cliente) values ('33-(642)328-9215', 'CYDTFN83D62O801H');
insert into telefono (numero, cliente) values ('86-(567)875-5894', 'UFNEQV92N24W661C');
insert into telefono (numero, cliente) values ('48-(140)282-4373', 'LMAZQD65D94N338U');
insert into telefono (numero, cliente) values ('233-(947)311-9020', 'OKBQMX01V32Z767H');
insert into telefono (numero, cliente) values ('48-(993)842-9410', 'GMWBVD23K54N412F');
insert into telefono (numero, cliente) values ('81-(188)322-5058', 'AOTFCB94S88D323S');
insert into telefono (numero, cliente) values ('55-(290)964-1823', 'HNTBFL70J16W581N');
insert into telefono (numero, cliente) values ('86-(608)212-6770', 'EBZPSK96V72C394W');
insert into telefono (numero, cliente) values ('507-(111)461-0018', 'HLPRKC83I35V546H');
insert into telefono (numero, cliente) values ('358-(326)474-7956', 'ODEGLR69G25P179Z');
insert into telefono (numero, cliente) values ('55-(390)101-5205', 'MRWGLN45Y12N351R');
insert into telefono (numero, cliente) values ('244-(562)555-1841', 'HNKIOQ68X17J011N');
insert into telefono (numero, cliente) values ('31-(492)834-7531', 'QSUPOL93H30M238B');
insert into telefono (numero, cliente) values ('33-(396)476-8767', 'WUBTSM78X70C518U');
insert into telefono (numero, cliente) values ('62-(112)458-5821', 'UJCFRT85K88S107L');
insert into telefono (numero, cliente) values ('46-(102)721-0140', 'HBORAL34C91E401W');
insert into telefono (numero, cliente) values ('33-(451)290-6677', 'VUMTIS85O67U302B');
insert into telefono (numero, cliente) values ('81-(558)917-4400', 'EGZTYL91X92S437X');
insert into telefono (numero, cliente) values ('216-(103)881-8337', 'ZWJKVL29V84W243U');
insert into telefono (numero, cliente) values ('30-(847)249-2286', 'NWRYLK01G00Q732N');
insert into telefono (numero, cliente) values ('86-(834)135-9811', 'THCIQS63Z21D234V');
insert into telefono (numero, cliente) values ('64-(363)535-6350', 'OKBQMX01V32Z767H');
insert into telefono (numero, cliente) values ('86-(208)979-4778', 'UFCLNM80G61L837A');
insert into telefono (numero, cliente) values ('63-(411)865-5789', 'CGVBXZ84F14Q859X');
insert into telefono (numero, cliente) values ('63-(506)799-7293', 'HKYQIE50Y39F640D');
insert into telefono (numero, cliente) values ('86-(974)143-5382', 'MRWGLN45Y12N351R');
insert into telefono (numero, cliente) values ('86-(764)457-7656', 'HQRVFL93R01P879Y');
insert into telefono (numero, cliente) values ('64-(388)753-9175', 'ZUELVH09T10O307C');
insert into telefono (numero, cliente) values ('92-(220)534-4727', 'OKBQMX01V32Z767H');
insert into telefono (numero, cliente) values ('52-(113)409-5369', 'GDPXQF93J29D590I');
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
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('YRWNCB73I96G468M', 'Patrick', 'Gonzalez', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('QYOFKD67M46O619X', 'Mildred', 'Arnold', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('SQDMIH91E22G439U', 'Jeremy', 'Brooks', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('EACOSZ97O58M305T', 'Edward', 'Walker', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('ZJPRNW27Q98E957V', 'Antonio', 'Palmer', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('HLAKWZ42Y64H379U', 'Ruth', 'Banks', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('ONPXJH44H09A891B', 'Diane', 'Frazier', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('IPOCLN85C04P396D', 'Gregory', 'Murray', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('QDTBJN76I47W472G', 'Patricia', 'Evans', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('TKINRX34C13C023K', 'Jose', 'Olson', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('HCISDQ80Q69W849I', 'George', 'Griffin', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('BQDMRS64X79K409E', 'Harold', 'Reed', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('JQHNFZ56A46J754B', 'Jeremy', 'Sanchez', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('CKVRDJ25B52N184K', 'Jimmy', 'Edwards', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('TIQYOM49D23J164Q', 'Samuel', 'Nelson', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('XMOSRQ07C92E931O', 'Roy', 'Reed', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('GBLUIP56O19V175G', 'Walter', 'Larson', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('JWTXGK76U04Y475N', 'Gloria', 'Crawford', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('HKVLQC80T24F840W', 'Judy', 'Castillo', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('XMZWID05F95C731S', 'Judith', 'Freeman', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('WMEPSF32N04Y001I', 'Daniel', 'Medina', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('VIGUCO81C89W582I', 'Aaron', 'Bell', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('UJTOCR76H81S160S', 'Roger', 'White', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('TDABRI67H98A258Z', 'Robin', 'Mendoza', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('FGDBYE74A79H701M', 'Mildred', 'King', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('KAUFRY16A02Q274L', 'Laura', 'Harris', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('ECGPUQ66E30M779T', 'Joseph', 'Coleman', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('HKUFYX18D60K305J', 'Gary', 'Jacobs', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('OCTWAP15D79K090B', 'Gary', 'Lawson', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('QGYXEF36T31X936W', 'Marilyn', 'Perkins', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('VCMNOY15J91W546T', 'Pamela', 'Thompson', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('DFYCOG23Q29R987Q', 'Andrew', 'Duncan', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('TVADLY02V46A711M', 'Pamela', 'Snyder', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('MQWVYH57U36S659Q', 'Ruth', 'Burton', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('ABQOLU62W54J888Q', 'Lisa', 'Lawrence', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('UJHSNR13Y48J646O', 'Ashley', 'Gomez', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('SIGALV68K67Q110P', 'Kathleen', 'Lee', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('BMNHWK80E60S609R', 'Joyce', 'Payne', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('SUWKGL75C43X557G', 'Annie', 'Schmidt', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('MKPSGU04D69P360V', 'Theresa', 'White', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('DUBWXY83X76G287K', 'Bobby', 'Marshall', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('JMEWSR33W68M299I', 'Denise', 'Cunningham', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('YVUQIG95X28I478V', 'Steve', 'Price', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('UAJHGE95C70J432H', 'Kathryn', 'Duncan', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('HWNJPY21Z60Y312F', 'Ann', 'Lynch', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('DFVMYE01O18J072D', 'Patricia', 'Marshall', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('TERCUN98Y11Z427W', 'Marilyn', 'Fields', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('EVYXQZ91F52Q044S', 'Tammy', 'Montgomery', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('BSFLKM81E90L609D', 'Sarah', 'Reynolds', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('HUTREA81W45G703Y', 'Ryan', 'Ford', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('GIWLHV47A46M406J', 'Aaron', 'Little', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('XYBJLN62N21X682T', 'Catherine', 'Bowman', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('GCHNKM89S16S988K', 'Joe', 'Foster', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('AHPKSZ91W29E376R', 'Thomas', 'Porter', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('SZTRCY98J54I287S', 'Annie', 'Collins', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('GRFKBN45G78Q351Y', 'Joshua', 'Powell', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('TYVSZO24Z61A406E', 'Emily', 'Wheeler', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('ZWRTNC56U87C479G', 'David', 'Davis', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('BWSXGU11J32N000T', 'Maria', 'Spencer', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('XLSOIZ80T94C609C', 'Jennifer', 'Cunningham', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('AMSPQJ77U39J885B', 'Billy', 'Richards', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('QOWHBM33D59B765E', 'Timothy', 'Dean', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('ADJBYW11C13D832V', 'Frances', 'Hanson', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('JXRPAD27B88G708L', 'Antonio', 'Dean', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('DCUHVM57H34R822L', 'Kathy', 'Harvey', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('BYRVOG58O03S506W', 'Ashley', 'Riley', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('GWHCIJ68W13K796S', 'Michael', 'Ford', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('HPDUAJ43W90R130T', 'Joan', 'Hunter', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('OIHXBN65C56K590B', 'Anthony', 'Holmes', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('LQVFZK78B06V398S', 'Harry', 'Cox', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('BDCJKO65M74E532G', 'Richard', 'Marshall', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('FQEMKC84K53B858W', 'Sean', 'Robertson', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('SLGVYU34K56X805Q', 'Anthony', 'Coleman', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('USMPTR19N92Q443S', 'Benjamin', 'Reyes', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('ISWDJV18E85Z555I', 'Donna', 'Willis', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('QEPJKT46K45E935D', 'Earl', 'Reynolds', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('CLHMXT95K53J510P', 'Betty', 'Grant', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('RAVTSJ50O89D003E', 'John', 'Franklin', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('YWHFEQ10X22R265R', 'Cheryl', 'Bailey', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('DFQZTJ15R99P183X', 'David', 'Medina', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('MCZLAG42R29S183A', 'Mildred', 'Richards', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('NTHABG94O30H959U', 'Carl', 'Hunter', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('RPYWFQ78R57M454M', 'Susan', 'Anderson', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('OBDMKL65E14N872H', 'Christina', 'Morgan', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('RWODUK55V77R196Z', 'Wayne', 'Alvarez', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('FZHXAO56O31U785X', 'Gerald', 'Clark', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('RPCVNF44U52E935R', 'Karen', 'Fernandez', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('VUGYHT17E97X370K', 'Stephen', 'Stephens', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('KRMXYQ75D28V206U', 'Lillian', 'Turner', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('WFRBMO64J00T602P', 'Harry', 'Roberts', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('LMJCTI36E79P399G', 'Robert', 'Gray', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('SKIMRB41I54V011R', 'Jeremy', 'Palmer', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('WGYNCK65W29E742V', 'Sandra', 'Ray', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('GETUML31V19G561F', 'Anna', 'Ruiz', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('MYXLTC36B29M000X', 'Karen', 'Burke', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('TNDBMY03G41G911D', 'Richard', 'Lawson', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('CHLXOW63N14W831B', 'Benjamin', 'Riley', true);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('XILADC61X36M430P', 'Paul', 'Adams', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('RQIEKN53P28L104F', 'Matthew', 'Clark', false);
insert into investigatore (codice_fiscale, nome, cognome, servizio_militare) values ('FBPSWQ99L35K802J', 'Elizabeth', 'Romero', true);
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('DPGKFL72K75W974O', 'Brenda', 'Edwards', 'Nuclear Power Engineer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('QPKFLM88A13F088T', 'Donald', 'Peterson', 'Web Designer IV');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('BNLRCQ70I62Q615M', 'Kathy', 'Bishop', 'Registered Nurse');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('LVAODW03J12X152Z', 'Joshua', 'Dixon', 'Nuclear Power Engineer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('NUXQIB91Q27T038R', 'John', 'Baker', 'Structural Engineer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('TSPBJF13Z15X392I', 'Shirley', 'Stevens', 'Analog Circuit Design manager');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('ADBUKG15N47L682Q', 'Joan', 'Gordon', 'Nurse');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('XQFCVL59L41H379P', 'James', 'Russell', 'Civil Engineer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('PSQBME69U96U545T', 'Richard', 'Butler', 'Geological Engineer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('SBIGXA42V79A498A', 'Norma', 'King', 'Electrical Engineer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('EZDISV69S80G973D', 'Frank', 'Elliott', 'Database Administrator IV');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('VLBUHD63S10P642W', 'Patricia', 'Chavez', 'Web Designer II');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('UIYOJW83O26M184N', 'Kimberly', 'Ryan', 'Administrative Officer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('NJBVTQ02C55L097O', 'Rachel', 'Duncan', 'VP Quality Control');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('WTCRIP81V93J190L', 'Jack', 'Reyes', 'Community Outreach Specialist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('YBAXWQ25U78V425L', 'Paul', 'Hunter', 'Programmer Analyst IV');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('WBGOMP66G83Q780K', 'Billy', 'Owens', 'Engineer II');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('YOAKLG62I28L382H', 'Jane', 'Ross', 'Human Resources Assistant I');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('VEWBIO49L15G971Y', 'Bruce', 'Mccoy', 'Human Resources Manager');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('YKBQCI15L61I352M', 'Ann', 'Williamson', 'Structural Engineer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('IULBJF28L96C105N', 'Lillian', 'Jenkins', 'Environmental Specialist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('FIQPHD02L57R061N', 'Christine', 'Ruiz', 'Technical Writer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('FDYMKG97R89K252D', 'Nicole', 'Fox', 'Clinical Specialist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('OFJACI23L06Z793X', 'Ashley', 'Hicks', 'Project Manager');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('CEDMVP24O08B348W', 'Gerald', 'Peterson', 'Senior Quality Engineer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('VAHSOI48T33M887M', 'Angela', 'Baker', 'Registered Nurse');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('JANGCQ13M23D479V', 'Lori', 'Hicks', 'Clinical Specialist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('PTHKRQ13C64E721P', 'Beverly', 'Oliver', 'Registered Nurse');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('WVLSKH31P96S847J', 'Helen', 'Adams', 'Junior Executive');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('DQMYIL67D89X065W', 'Nicholas', 'Gonzales', 'Web Designer II');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('YVTCUI82D91H917Y', 'Jane', 'Hudson', 'Recruiting Manager');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('SYLHPU55M77O788V', 'Cynthia', 'Lane', 'Design Engineer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('TMWPVN09E72J167C', 'Jeremy', 'Greene', 'Statistician IV');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('TJLRHK33C06D956V', 'Irene', 'Kennedy', 'Assistant Media Planner');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('TICNJO03V85W504D', 'Ernest', 'Ruiz', 'Registered Nurse');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('ENZYKT65N76T207D', 'Sharon', 'Ross', 'General Manager');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('GAYXBO05N79F244F', 'Walter', 'Mccoy', 'Clinical Specialist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('ZXOFNT47X97Z058K', 'Harry', 'Williams', 'Staff Accountant IV');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('KDOICB89U74J639W', 'Alice', 'Ford', 'Legal Assistant');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('PVOAXL77H31A233Z', 'Martha', 'Hawkins', 'Internal Auditor');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('PKVNDF03A93Y855Q', 'Teresa', 'Crawford', 'Senior Financial Analyst');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('VFIHSZ63A57Q157M', 'Ruby', 'Martin', 'Professor');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('GJNASE31L23U990G', 'Jessica', 'Green', 'Systems Administrator IV');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('UKMWGF09D78I774M', 'Bonnie', 'Young', 'Civil Engineer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('NEOKQR75Z08R751Y', 'Kimberly', 'Jacobs', 'Health Coach II');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('KNOXFW48Y56Y441R', 'Arthur', 'Bradley', 'Database Administrator IV');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('JRKYVB84S29G780L', 'Martha', 'Grant', 'Clinical Specialist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('DVKAQX02S89T146O', 'Stephanie', 'Crawford', 'GIS Technical Architect');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('NZWOLF20K84W546T', 'Louise', 'Riley', 'Technical Writer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('RPHINF40I51H514H', 'Brandon', 'Mcdonald', 'Account Executive');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('BWLZER77G02Y921A', 'Christopher', 'Adams', 'Professor');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('GIHXYS75L74A025D', 'Billy', 'Young', 'Compensation Analyst');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('BIQOMU54N05E763E', 'Christina', 'Ferguson', 'Chief Design Engineer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('WFNJUT64C54F097H', 'Jeremy', 'Reynolds', 'Pharmacist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('ASWGQC99R79C997H', 'Jennifer', 'Sullivan', 'Senior Cost Accountant');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('OLAXKB28P56B076W', 'Louis', 'Peters', 'Senior Financial Analyst');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('ZYMFEP79K94W681H', 'Matthew', 'Fuller', 'Software Test Engineer III');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('SPDKEL31O96Y623R', 'Raymond', 'Fowler', 'Environmental Specialist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('WNOPLR17N23T449Z', 'Jason', 'Fowler', 'Paralegal');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('WBLQFK19T52X334Z', 'Samuel', 'Wood', 'Pharmacist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('FLWNSA82C07C255A', 'George', 'Ford', 'Occupational Therapist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('KAQWVH72V81F873L', 'Marie', 'Rose', 'Administrative Officer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('DNXGOC11D23T992V', 'Eugene', 'Marshall', 'Business Systems Development Analyst');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('KZXURA05N30Z607Q', 'Theresa', 'Austin', 'Staff Accountant IV');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('OBNXHR82X76C339S', 'Bonnie', 'Harper', 'VP Sales');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('WTFSCB49R51Z246Z', 'Timothy', 'Morgan', 'Tax Accountant');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('MJHPWO47Q97Z231Q', 'Lois', 'Simmons', 'Desktop Support Technician');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('ROQUDH18V95Q501H', 'Jimmy', 'Morales', 'Technical Writer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('RAUTHG77N93V131Z', 'Robin', 'Edwards', 'Senior Cost Accountant');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('PJYGRI23L01X998X', 'Bruce', 'Wheeler', 'Senior Financial Analyst');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('FUGXDK39R35V489U', 'Jerry', 'Ramirez', 'Environmental Tech');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('GPSMWO87C57G943X', 'Walter', 'Wheeler', 'Safety Technician II');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('EUKALP28K55Y507T', 'Ann', 'Rodriguez', 'Paralegal');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('KNULFQ67L71J538V', 'Philip', 'Phillips', 'Internal Auditor');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('NHPSLW88I00I432R', 'Kenneth', 'Fowler', 'Budget/Accounting Analyst I');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('PZGIWX42Y00P959J', 'Gregory', 'Johnston', 'Speech Pathologist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('DULQXB19M73F108P', 'Jose', 'Sanchez', 'Food Chemist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('ZQXRKG62O37N638Z', 'Lois', 'Warren', 'Media Manager III');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('IGXLTF08Z10U029J', 'Martin', 'Lopez', 'Financial Analyst');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('PIKXTH35Y33F998G', 'David', 'Bishop', 'Recruiting Manager');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('BMXYST93N31W741K', 'Walter', 'Adams', 'Senior Editor');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('DBUQOH62O01D118W', 'Timothy', 'Franklin', 'Registered Nurse');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('DPEZAS55N91U541K', 'Jerry', 'Watson', 'Pharmacist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('JCFQWN61S99O473R', 'Donna', 'Dunn', 'Financial Advisor');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('PINEDS91F02T723A', 'Donna', 'Watson', 'Assistant Media Planner');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('WTFGMA59G34O533B', 'Debra', 'Weaver', 'Assistant Professor');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('QPTMUG03K62J786V', 'George', 'Rodriguez', 'Technical Writer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('IYLPWV82Q52H104E', 'Christopher', 'Reed', 'Statistician II');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('HJOXKL53U84O498M', 'Willie', 'Gonzalez', 'Graphic Designer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('JGHBUP99H12T677Y', 'Chris', 'Hill', 'Human Resources Assistant II');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('XFVJPC61O85Z259R', 'Norma', 'Jones', 'Project Manager');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('DECNQH71Z27J727E', 'Amanda', 'Hicks', 'Programmer Analyst I');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('NMGJHU42H50R490X', 'Deborah', 'Powell', 'Geologist II');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('QHFUNT42C60O412N', 'Kathleen', 'Carter', 'Environmental Specialist');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('WPRNFD01S72V523T', 'Joe', 'Johnston', 'Nurse');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('GAKPCL68Y38M872P', 'Aaron', 'Hall', 'Legal Assistant');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('FSPRWT52V95X358Q', 'Barbara', 'Lawson', 'Budget/Accounting Analyst IV');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('HWZIEM16L65C528V', 'Margaret', 'Schmidt', 'General Manager');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('RWTPKX68T90M455I', 'Carlos', 'Owens', 'Analyst Programmer');
insert into collaboratore (codice_fiscale, nome, cognome, lavoro) values ('EGBNAM91Q37Q830W', 'Janice', 'Matthews', 'Quality Engineer');
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
INSERT INTO `collaborazione` (`collaboratore`, `investigazione`, `caso`)
VALUES
	('PKVNDF03A93Y855Q', 1, 5),
	('NHPSLW88I00I432R', 1, 7),
	('QHFUNT42C60O412N', 1, 7),
	('VAHSOI48T33M887M', 1, 7),
	('PIKXTH35Y33F998G', 1, 8),
	('ZYMFEP79K94W681H', 1, 9),
	('IGXLTF08Z10U029J', 1, 11),
	('YVTCUI82D91H917Y', 1, 11),
	('GAYXBO05N79F244F', 1, 12),
	('JGHBUP99H12T677Y', 1, 12),
	('VFIHSZ63A57Q157M', 1, 12),
	('SYLHPU55M77O788V', 1, 15),
	('DULQXB19M73F108P', 1, 17),
	('JGHBUP99H12T677Y', 1, 17),
	('DPGKFL72K75W974O', 1, 18),
	('FLWNSA82C07C255A', 1, 20),
	('VEWBIO49L15G971Y', 1, 20),
	('WPRNFD01S72V523T', 1, 20),
	('DPEZAS55N91U541K', 1, 24),
	('EGBNAM91Q37Q830W', 1, 24),
	('NHPSLW88I00I432R', 1, 24),
	('SPDKEL31O96Y623R', 1, 26),
	('XFVJPC61O85Z259R', 1, 27),
	('JRKYVB84S29G780L', 1, 28),
	('WPRNFD01S72V523T', 1, 28),
	('BWLZER77G02Y921A', 1, 31),
	('KDOICB89U74J639W', 1, 32),
	('XFVJPC61O85Z259R', 1, 32),
	('FDYMKG97R89K252D', 1, 33),
	('ASWGQC99R79C997H', 1, 34),
	('FDYMKG97R89K252D', 1, 35),
	('KZXURA05N30Z607Q', 1, 35),
	('RPHINF40I51H514H', 1, 37),
	('DVKAQX02S89T146O', 1, 39),
	('RPHINF40I51H514H', 1, 39),
	('LVAODW03J12X152Z', 1, 40),
	('WTCRIP81V93J190L', 1, 40),
	('YVTCUI82D91H917Y', 1, 40),
	('DULQXB19M73F108P', 1, 42),
	('KNOXFW48Y56Y441R', 1, 42),
	('QPTMUG03K62J786V', 1, 45),
	('XFVJPC61O85Z259R', 1, 45),
	('BWLZER77G02Y921A', 1, 57),
	('KZXURA05N30Z607Q', 1, 57),
	('CEDMVP24O08B348W', 1, 62),
	('BWLZER77G02Y921A', 1, 65),
	('WTFSCB49R51Z246Z', 1, 65),
	('VLBUHD63S10P642W', 1, 69),
	('PINEDS91F02T723A', 1, 73),
	('WTFGMA59G34O533B', 1, 74),
	('SBIGXA42V79A498A', 1, 79),
	('ASWGQC99R79C997H', 1, 82),
	('DPEZAS55N91U541K', 1, 82),
	('JANGCQ13M23D479V', 1, 82),
	('HJOXKL53U84O498M', 1, 83),
	('JANGCQ13M23D479V', 1, 83),
	('TICNJO03V85W504D', 1, 83),
	('DPGKFL72K75W974O', 1, 91),
	('NJBVTQ02C55L097O', 1, 92),
	('YKBQCI15L61I352M', 1, 92),
	('QPKFLM88A13F088T', 1, 93),
	('WTFSCB49R51Z246Z', 1, 94),
	('BMXYST93N31W741K', 1, 96),
	('DQMYIL67D89X065W', 1, 99),
	('TMWPVN09E72J167C', 1, 99),
	('NUXQIB91Q27T038R', 2, 2),
	('DQMYIL67D89X065W', 2, 4),
	('BMXYST93N31W741K', 2, 11),
	('HWZIEM16L65C528V', 2, 17),
	('TSPBJF13Z15X392I', 2, 28),
	('CEDMVP24O08B348W', 2, 33),
	('GPSMWO87C57G943X', 2, 33),
	('PZGIWX42Y00P959J', 2, 33),
	('PTHKRQ13C64E721P', 2, 48),
	('UKMWGF09D78I774M', 2, 48),
	('BWLZER77G02Y921A', 2, 69),
	('JCFQWN61S99O473R', 2, 69),
	('DQMYIL67D89X065W', 2, 78),
	('KNOXFW48Y56Y441R', 2, 78),
	('XFVJPC61O85Z259R', 2, 79),
	('BMXYST93N31W741K', 2, 81),
	('FUGXDK39R35V489U', 2, 92),
	('TICNJO03V85W504D', 2, 92),
	('IULBJF28L96C105N', 2, 96),
	('BNLRCQ70I62Q615M', 3, 2),
	('NZWOLF20K84W546T', 3, 2),
	('HJOXKL53U84O498M', 3, 78),
	('DULQXB19M73F108P', 3, 79),
	('BIQOMU54N05E763E', 3, 82),
	('DPEZAS55N91U541K', 3, 82),
	('GAKPCL68Y38M872P', 3, 82),
	('JANGCQ13M23D479V', 3, 82),
	('WTFSCB49R51Z246Z', 3, 82),
	('FUGXDK39R35V489U', 3, 96),
	('EUKALP28K55Y507T', 3, 98),
	('KAQWVH72V81F873L', 4, 17),
	('NJBVTQ02C55L097O', 4, 28),
	('PINEDS91F02T723A', 4, 28),
	('TJLRHK33C06D956V', 4, 98);
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
DROP TRIGGER IF EXISTS ImportoFattura_ins;

DELIMITER //
CREATE TRIGGER ImportoFattura_ins
BEFORE INSERT ON fattura
FOR EACH ROW 
BEGIN
	DECLARE importoTotale float;
  
	SELECT 	ore_totali * tariffa.prezzo INTO importoTotale
	FROM	investigazione JOIN caso ON investigazione.caso = caso.codice
			JOIN tariffa ON caso.tipologia = tariffa.tipologia_caso
	WHERE	caso.codice = NEW.caso AND investigazione.numero = NEW.investigazione;

	IF NEW.importo <> importoTotale
	THEN SET NEW.importo = importoTotale;
	END IF;
END //
DELIMITER ;



DROP TRIGGER IF EXISTS ImportoFattura_upd;

DELIMITER //
CREATE TRIGGER ImportoFattura_upd
BEFORE UPDATE ON fattura
FOR EACH ROW 
BEGIN
	DECLARE importoTotale float;
  
	SELECT 	ore_totali * tariffa.prezzo INTO importoTotale
	FROM	investigazione JOIN caso ON investigazione.caso = caso.codice
			JOIN tariffa ON caso.tipologia = tariffa.tipologia_caso
	WHERE 	caso.codice = NEW.caso AND investigazione.numero = NEW.investigazione;

	IF NEW.importo <> importoTotale
	THEN SET NEW.importo = importoTotale;
	END IF;
END //
DELIMITER ;
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
