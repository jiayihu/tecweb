<?php require 'partials/public-header.partial.php' ?>

<div id="content" class="intro">
  <div class="container v-centered-wrapper">
    <div class="v-centered">
      <h1 class="intro-name">
        <a href="#formcontatti" class="underl">Contattaci</a>
      </h1>
    </div>
  </div>
</div>

<main class="container">
  <section class="service clearfix">
    <div class="service-content col half">
      <div class="contacts">
        <div class="contact">
          <h2>INDIRIZZO</h2>
          <p>Via Trieste, 63<br/>35121 Padova (IT)</p>
          <a class="uppercase" href="https://goo.gl/maps/LPorPN1PNZG2">Google maps</a>
        </div>
        <div class="contact">
        <h2>TELEFONO</h2>
        <p>+39 049 827 5111</p>
      </div>
      
      
      </div>
      <div class="directions">
      <h2>COME RAGGIUNGERCI</h2>
      <h3>AUTO</h3>
      <ol class="direction">
        <li>All'uscita Padova Est dell'autostrada A4 seguire le indicazioni per Padova Centro ed immettersi in via S. Marco</li>
        <li>Alla rotonda, prendere la 3a uscita</li>
        <li>Continuare su via S. Marco e alla rotonda prendere la 2a uscita in via Venezia</li>
        <li>Proseguire dritto su via Venezia e alla rotonda prendere la 2a uscita in via N. Tommaseo</li>
        <li>Proseguire dritto e alla rotonda prendere la 3a uscita su via E. Berlinguer</li>
        <li>Proseguire dritto e alla rotonda prendere la 3a uscita su via E. degli Scrovegni</li>
        <li>Al primo incrocio, svoltare a sinistra</li>
        <li>L'ufficio è situato sulla sinistra</li>
      </ol>
      <h3>MEZZI PUBBLICI</h3>
      <ol class="direction">
        <li>Dalla stazione di Padova, prendere uno tra gli autobus urbani numero 5, 7, 10, 12 e 18</li>
        <li>Scendere alla seconda fermata</li>
        <li>Prendere la prima laterale sulla destra, via U. Bassi</li>
        <li>L'ufficio è a 200m sulla destra</li>
      <ol>
      </div>
    </div>
    <div class="service-photo col half img">
      <img src="<?= ROOT ?>/public/images/contatti/office.jpg" alt="Il nostro ufficio">
    </div>
  </section>

  <section class="service clearfix">
    <div class="service-photo col half img">
      <img src="<?= ROOT ?>/public/images/contatti/envelop.jpg" alt="Lettera">
    </div>
    <div class="service-content col half">
      <h2>Contattaci</h2>
      <form id="formcontatti" action="<?= ROOT ?>/" method="post">
        <div class="contactbox">
          <div class="contactbox-field">
            <label for="name" class="screen-reader">nome e cognome</label>
            <input id="name" class="input" type="text" name="nome" placeholder="Nome e cognome" required>
            <span class="underline"></span>
          </div>
          <div class="contactbox-field">
            <label for="phone" class="screen-reader">telefono</label>
            <input id="phone" class="input" type="text" name="telefono" placeholder="Telefono" required>
            <span class="underline"></span>
          </div>
          <div class="contactbox-field">
            <label for="email" class="screen-reader" lang="en">email</label>
            <input id="email" class="input" type="email" name="email" required placeholder="Email">
            <span class="underline"></span>
          </div>
          <div class="contactbox-message">
            <label for="message" class="screen-reader">messaggio</label>
            <textarea id="message" rows="3" cols="30" placeholder="Messaggio" required name="message"></textarea>
          </div>
        </div>
      </form>
      <input type="submit" class="btn btn-outline" value="Invia">
      </div>
  </section>
</main>

<?php require 'partials/public-footer.partial.php' ?>
