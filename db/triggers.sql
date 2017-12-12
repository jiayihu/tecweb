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
