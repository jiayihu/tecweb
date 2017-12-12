/*
  Funzione 1:
  Si vuole sapere il guadagno di un caso, comprese le ore di lavoro ancora non 
  fatturate, tramite il nome del caso.
*/

DROP FUNCTION IF EXISTS GuadagnoCaso;

DELIMITER //
CREATE FUNCTION GuadagnoCaso(nome_caso VARCHAR(100))
RETURNS FLOAT(12,2)

BEGIN 
DECLARE totale FLOAT(12,2);

SELECT (SUM(investigazione.ore_totali) * tariffa.prezzo) INTO totale
FROM caso, investigazione, tariffa
WHERE caso.codice = investigazione.caso AND caso.tipologia = tariffa.tipologia_caso AND caso.nome = nome_caso
GROUP BY investigazione.caso;

RETURN totale;
END //

DELIMITER ;

/*
Esempio: SELECT GuadagnoeCaso('Uno studio in rosa');
*/


/*
  Funzione 2:
  Si vuole poter eseguire una ricerca che restituisca tutti i nomi dei casi a cui
  ha lavorato solamente un investigatore, tramite il suo nome e cognome.
*/

DROP FUNCTION IF EXISTS CasiInvSolitario;

DELIMITER //
CREATE FUNCTION CasiInvSolitario(param_nome VARCHAR(100), param_cognome VARCHAR(100))
RETURNS VARCHAR(100)

BEGIN
DECLARE NomiCasi VARCHAR(100);

SELECT CONCAT(caso.nome) INTO NomiCasi
FROM investigatore, lavoro, caso
WHERE 
	investigatore.codice_fiscale = lavoro.investigatore 
	AND lavoro.caso = caso.codice
	AND investigatore.nome = param_nome AND investigatore.cognome = param_cognome
	AND lavoro.caso NOT IN (
		SELECT l.caso
		FROM investigatore AS i JOIN lavoro AS l ON i.codice_fiscale = l.investigatore
		WHERE i.codice_fiscale <> investigatore.codice_fiscale
	);

RETURN NomiCasi;
END //

DELIMITER ;

/*
Esempio: SELECT CasiInvSolitario('Timothy', 'Dean');
*/


/*
	Funzione 3: Si vuole sapere quanti casi correnti chiusi o aperti vi sono per un
	Ispettore tramite il suo codice di distretto. Nel caso non sia specificato lo 
	stato del caso, si assume che la conta valga per i casi aperti di default.
*/

DROP FUNCTION IF EXISTS CasiDistretto;

DELIMITER //

CREATE FUNCTION CasiDistretto(param_codice_distretto VARCHAR(30), param_passato BOOLEAN)
RETURNS SMALLINT

BEGIN
	DECLARE risultato SMALLINT;
	DECLARE cerca_passato BOOLEAN;
	# Se il parametro di ricerca passato non è specificato di default conta i casi aperti
	IF param_passato = '' 
		THEN SET cerca_passato = FALSE;
	ELSE SET cerca_passato = param_passato;
	END IF;
	
	SELECT count(DISTINCT caso.codice) INTO risultato
	FROM cliente, ispettore, caso
	WHERE cliente.codice_fiscale = ispettore.codice_fiscale
	AND cliente.codice_fiscale = caso.cliente
	AND ispettore.codice_distretto = param_codice_distretto
	AND passato = cerca_passato;
	
	RETURN risultato;
END //

DELIMITER ;

/*
	ESEMPIO: SELECT `CasiDistretto`(4829, FALSE);
*/
