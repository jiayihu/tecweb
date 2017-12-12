/*
  Query 1:
  Si vuole poter ricercare altri casi con relativa descrizione in base al tag del caso 
  irrisolto più recente, in modo da trovare informazioni che possano aiutarne la
	risoluzione.
*/

DROP VIEW IF EXISTS CasoPiuRecente;

CREATE VIEW CasoPiuRecente AS 
SELECT caso.codice
	FROM caso JOIN investigazione ON caso.codice = investigazione.caso
	WHERE investigazione.data_inizio = (
	SELECT MAX(I.data_inizio)
	FROM caso AS C JOIN investigazione AS I ON C.codice = I.caso
	WHERE C.risolto = FALSE
);

SELECT caso.codice, caso.nome, caso.descrizione, etichettamento.tag
FROM caso JOIN etichettamento ON caso.codice = etichettamento.caso
WHERE etichettamento.tag IN (
	SELECT e.tag
	FROM CasoPiuRecente JOIN etichettamento AS e ON CasoPiuRecente.codice = e.caso
)
GROUP BY caso.codice, caso.nome, caso.descrizione, etichettamento.tag;


/*
	Query 2:
	Si vuole poter ricercare tutte le investigazioni che sono state chiuse in tal
	periodo e il numero totale di ore richieste per la risoluzione di ciascuna.
*/

SELECT numero, caso, data_termine, ore_totali
FROM investigazione
WHERE (data_termine BETWEEN DATE_FORMAT(NOW() ,'%Y-%m-01') AND LAST_DAY(CURDATE()));

/*
	Query 3:
	Si vuole sapere le percentuale di casi risolti alla prima investigazione
*/

SELECT (count(*) / (SELECT count(*) FROM caso) * 100) AS percentuale
FROM (
	SELECT investigazione.caso AS caso, count(caso) AS conta
	FROM investigazione
	GROUP BY investigazione.caso
) AS NumInvPerCaso
WHERE NumInvPerCaso.conta = 1

/*
	Query 4:
	Si vuole sapere l’amministratore aziendale con maggiori casi di spionaggio
*/

DROP VIEW IF EXISTS amministratori_spionaggio;

CREATE VIEW amministratori_spionaggio AS
SELECT amministratore_aziendale.codice_fiscale, COUNT(caso.codice) AS numero_casi
FROM amministratore_aziendale JOIN caso ON amministratore_aziendale.codice_fiscale = caso.cliente
WHERE caso.tipologia = 'spionaggio'
GROUP BY amministratore_aziendale.codice_fiscale;

SELECT cliente.codice_fiscale, cliente.nome, cliente.cognome, amm.numero_casi AS casi
FROM amministratori_spionaggio AS amm JOIN cliente ON amm.codice_fiscale = cliente.codice_fiscale
WHERE amm.numero_casi = (SELECT  MAX(numero_casi) FROM amministratori_spionaggio);


/*
	Query 5:
	Si vuole sapere quali siani i primi dieci luoghi con maggiori investigazioni 
	negli ultimi 50 anni
*/

SELECT citta, indirizzo, COUNT(*) AS numero_investigazioni
FROM scena_investigazione JOIN investigazione ON (
	scena_investigazione.investigazione = investigazione.numero 
	AND scena_investigazione.caso = investigazione.caso
)
WHERE data_inizio BETWEEN date_sub(curdate(), INTERVAL 50 year) AND curdate()
GROUP BY citta, indirizzo  
ORDER BY numero_investigazioni DESC
LIMIT 10;



/** PROCEDURE */


/*
	Procedura 1: Si vuole poter segnare un caso come risolto con relativo colpevole 
	tramite codice del caso e codice fiscale.
*/
DROP PROCEDURE IF EXISTS RisolviCaso;

DELIMITER //

CREATE PROCEDURE RisolviCaso(IN param_caso INT(10), IN param_criminale VARCHAR(16))
BEGIN 
	UPDATE caso
	SET caso.risolto = TRUE, caso.passato = TRUE
	WHERE caso.codice = param_caso;
	
	INSERT INTO risoluzione(criminale, caso)
	VALUES (param_criminale, param_caso);
END //

DELIMITER ;

# Esempio: CALL RisolviCaso(4, 'ADFHZU44F80D493Y');


/*
	Procedura 2: Si vuole sapere il codice fiscale dei clienti aventi casi senza 
	alcuna investigazione, ovvero possibili obiettivi per una pulizia del database.
*/

DROP PROCEDURE IF EXISTS CasiVuoti;

DELIMITER //

CREATE PROCEDURE CasiVuoti()
BEGIN
	SELECT cliente.codice_fiscale 
	FROM caso, cliente
	WHERE caso.cliente = cliente.codice_fiscale
		AND NOT EXISTS (
			SELECT *
			FROM investigazione AS I
			WHERE I.caso = caso.codice
		);
END //
DELIMITER ;

# Esempio: CALL `CasiVuoti`();
