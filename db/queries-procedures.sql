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
