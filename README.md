# Progetto tecweb

![](design/logo.png)

## Linee Guida CSS

- Cercare di riutilizzare il più possibile classi CSS in `common.css`
- Cercare di scrivere CSS riutilizzabile, ad esempio spostando componenti come `dropdown` in `common.css`
- Evitare valori "magici" come 3,4 o 17 px per posizionare gli elementi.
- Evitare `position: absolute` se possibile

## Linee Guida PhP

- Il codice sorgente è fortemente basato su quanto appreso nella serie di tutorial [The PHP Practitioner](https://laracasts.com/series/php-for-beginners)
- La suddivisione del codice sorgente è la seguente:
  - In `app/routes.php` vi è la configurazione dei controllers associati alle rotte delle pagine
    1. Ad ogni rotta corrisponde un controller ed un metodo di tale controller
    2. Tale metodo può direttamente ritornare la pagina HTML richiesta oppure fare richieste dati al database ed elaborarli
    3. In `app/models` vi sono le classi che rappresentano il model dell'applicazione
    4. In `app/views` vi sono i templates delle pagine
  - In `public` ci sono i file statici come CSS ed immagini. Non c'è HTML perché è in `app/views` in PhP
  - In `core` ci sono le classi e funzioni generiche riusabili per ogni progetto usate dalle classi in `app`
- I form del sito fanno richiesta al server a due possibili endpoints per form:
  1. Endpoint solo API: PhP ritorna il risultato in JSON che viene usato da Javascript
  2. Endpoint con HTML: PhP gestisce la richiesta (internamente tramite punto 1) e restituisce una nuova pagina HTML per gli utenti senza Javascript
- Il codice è documentato secondo lo standard [PhPDoc](http://manual.phpdoc.org/HTMLframesConverter/default/)
