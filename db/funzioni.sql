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
