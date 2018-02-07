<?php require 'partials/public-header.partial.php' ?>

<div id="content" class="intro">
  <div class="container v-centered-wrapper">
    <div class="v-centered">
      <h1 lang="en" class="intro-name">Studio Sherlock & Watson</h1>
      <p>
        <a class="btn btn-outline" href="contatti">Entra in contatto</a>
      </p>
      <p>Sei un ispettore? <a href="login">Accedi</a> all'area amministrativa.</p>
    </div>
  </div>
</div>

<main class="container">
  <div class="history">
    <p>Nato nel 1887 a Padova, da oltre un secolo si occupa di risolvere i più controversi ed enigmatici casi di criminalità offrendo consulenza a privati, aziende e alla polizia.</p>
  </div>

  <section class="service clearfix">
    <div class="service-content col half">
      <h2>Investigazioni private</h2>
      <p>Le indagini private svolte con la massima professionalità e riservatezza, sono un necessario strumento nei casi in cui si necessiti verificare la fedeltà del proprio compagno o coniuge per la tutela dei figli minori. Le indagini private sono fruibili a fronte di un diritto giuridicamente rilevante. In questo ambito rientra anche il controllo su figli minori compagnie sospette e qualsiasi accertamento di infedeltà.</p>
      <p><a href="servizi#private" class="btn btn-outline">Apri servizio</a></p>
    </div>
    <div class="service-photo col half">
      <img src="<?= ROOT ?>/public/images/home/private.jpg" alt="Investigazioni private">
    </div>
  </section>

  <section class="service clearfix">
    <div class="service-photo col half">
      <img src="<?= ROOT ?>/public/images/home/agency.jpg" alt="Investigazioni aziendali">
    </div>
    <div class="service-content col half">
      <h2>Investigazioni aziendali</h2>
      <p>Effettuiamo indagini aziendali di qualsiasi tipo, per verificare l’infedeltà dei soci o dei dipendenti, l’assenteismo, per tutelare il marchio o il brevetto, Antisabotaggio, Controspionaggio industriale, concorrenza sleale, violazione patto di non concorrenza furti e ammanchi, antifrode assicurativa.</p>
      <p><a href="servizi#aziendali" class="btn btn-outline">Apri servizio</a></p>
    </div>
  </section>

  <section class="service clearfix">
    <div class="service-content col half">
      <h2>Investigazioni difensive</h2>
      <p>La nostra agenzia investigativa è specializzata in investigazioni a supporto degli studi legali sia nell’ambito civile sia nella difesa penale. Le indagini investigative rappresentano uno strumento rapido ed efficace che si rivela di fondamentale importanza qualora ci sia la necessità di raccogliere informazioni o elementi di prova da far valere nel processo civile o penale.</p>
      <p><a href="servizi#difensive" class="btn btn-outline">Apri servizio</a></p>
    </div>
    <div class="service-photo col half">
      <img src="<?= ROOT ?>/public/images/home/legal.jpg" alt="Investigazioni difensive">
    </div>
  </section>

  <section class="service clearfix">
    <div class="service-photo col half">
      <img src="<?= ROOT ?>/public/images/home/special.jpg" alt="Investigazioni cyber-security">
    </div>
    <div class="service-content col half">
      <h2>Investigazioni <span lang="en">cyber-security</span></h2>
      <p>La nostra divisione informatica, attraverso dotazioni software all’avanguardia è in grado di offrirvi servizi di analisi forense sui dispositivi ormai di uso quotidiano come PC, tablet, e smartphone.</p>
      <p><a href="servizi#cyber" class="btn btn-outline">Apri servizio</a></p>
    </div>
  </section>

  <section class="method clearfix">
    <h2 class="method-title">Il nostro metodo investigativo</h2>
    <div class="method-content"> 
      <h3 class="method-content-title">#1 Analisi del caso</h3>
      <div class="method-content-image">
          <img src="<?= ROOT ?>/public/images/home/microscopio.png" alt="Icon analisi dettagliata come un microscopio">
      </div>
      <p class="method-content-text">Nella fase iniziale il cliente trasferirà tutte le informazioni in suo possesso, in maniera tale da permettere ai nostri esperti di valutare la situazione e predisporre l'attività investigativa più idonea al raggiungimento del risultato.</p>
    </div>
    <div class="method-content"> 
        <h3 class="method-content-title">#2 Attività investigativa</h3>
        <div class="method-content-image">
            <img src="<?= ROOT ?>/public/images/home/lente.png" alt="Icona investigazione con lente">
        </div>
        <p class="method-content-text">Mediante l'applicazione di metodologie di comprovata efficacia, operiamo sul campo tramite strumenti tecnologici e informatici, per raccogliere informazioni e prove certe, ottenute legalmente.</p>
      </div>
      <div class="method-content"> 
          <h3 class="method-content-title">#3 Report finale</h3>
          <div class="method-content-image">
              <img src="<?= ROOT ?>/public/images/home/note.png" alt="Icona report">
          </div>
          <p class="method-content-text">Al termine dell'attività investigativa, l'investigatore incaricato del caso, redigerà un documento estremamente dettagliato di tutte le situazioni osservate e gli elementi di prova raccolti, consegnando al cliente tutto quanto il materiale.</p>
        </div>
  </section>
</main>

<?php require 'partials/public-footer.partial.php' ?>
