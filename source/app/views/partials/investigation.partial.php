<div class="investigation">
  <input
    id="inv-<?php echo $index; ?>"
    class="accordion-input hide"
    type="checkbox" 
    name="investigations" 
    <?php echo $index === $investigationId ? 'checked' : '' ?>
  >
  <label class="accordion-label" for="inv-<?php echo $index; ?>">Investigazione <?php echo $investigation->getId(); ?></label>
  <?php if ($isEdit &&  $index === $investigationId) : ?>
  <div class="investigation-content">
    <p class="actions">
      <button class="btn btn-outline">Salva modifiche</button>
    </p>
    <div class="investigation-content-field">
      <span class="investigation-content-title">Svolta da: </span> <input class="input" type="text" name="investigatore" value="Sherlock Holmes">
    </div>
    <div class="investigation-content-field">
      <span class="investigation-content-title">Ore di lavoro: </span> <input class="input" type="number" name="ore" value="5">
    </div>
    <div class="investigation-content-field">
      <span class="investigation-content-title">Data inizio: </span> <input type="date" name="date-from" id="input-date-from">
    </div>
    <div class="investigation-content-field">
      <span class="investigation-content-title">Data fine: </span> <input type="date" name="date-to" id="input-date-to">
    </div>
    <div class="investigation-content-field">
      <span class="investigation-content-title">Luogo: </span> <input class="input" type="text" name="scena" value="stanza secondo piano; via blablabla n. 6, Padova (PD)">
    </div>
    <div class="investigation-content-field">
      <span class="investigation-content-title">Rapporto: </span>
      <textarea>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</textarea>
    </div>
    <div class="investigation-content-field">
      <span class="investigation-content-title">Prove: </span>
      <table>
        <thead>
          <tr>
            <th>Nome</th>
            <th class="descr">Descrizione</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <th>Calzino</th>
            <th class="descr">Piccolo, bianco, sporco di fango. Sicuramente da uomo.</th>
          </tr>
          <tr>
            <th>Valigia</th>
            <th class="descr">Piccolo trolley da bagaglio a mano color rosa.</th>
          </tr>
          <tr>
            <th>Pupazzo</th>
            <th class="descr">Strano, assomiglia ad un coniglio.</th>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
  <?php else: ?>
  <div class="investigation-content">
    <p class="actions">
      <?php if ($routeName === 'dashboard'): ?>
      <a href="/caso?id=1&investigazione=1">Mostra dettagli</a>
      <?php elseif ($role !== 'inspector'): ?>
      <a href="/caso?id=1&investigazione=1&modifica=true">Modifica</a>
      <?php endif; ?>
    </p>

    <div class="investigation-content-field">
      <span class="investigation-content-title">Svolta da: </span> 
      <?= $inv = $investigation->getInvestigatore(); ?>
    </div>
    <div class="investigation-content-field">
      <span class="investigation-content-title">Ore di lavoro: 
      </span> <?= $investigation->oreTotali ?>
    </div>
    <div class="investigation-content-field">
      <span class="investigation-content-title">Data: </span>
      <?= $investigation->dataInizio ?> -
      <?php 
        if($investigation->dataTermine == null) {
          echo "in corso";
        } else {
          echo $investigation->dataTermine;
         };      
      ?>
    </div>
    <div class="investigation-content-field">
      <span class="investigation-content-title">Luogo: </span>
         <?php 
            if($investigation->getScene() == '') 
              echo '-';
            else
              echo "$investigation->getScene()";
         ?>
    </div>
    <div class="investigation-content-field">
      <span class="investigation-content-title">Rapporto: </span>
         <?php
          if($investigation->rapporto == '') {
            echo '-';
          } else {
            echo"ucfirst($investigation->rapporto)";
          }
         ?>
    </div>
    <div class="investigation-content-field">
      <span class="investigation-content-title">Prove: </span>
      <?php if(sizeof($investigation->prove) > 0) : ?>
        <table>
          <thead>
            <tr>
              <th>Nome</th>
              <th class="descr">Descrizione</th>
            </tr>
          </thead>
          <tbody>           
            <?php foreach($investigation->prove as $prova) : ?>
              <tr>
                <th><?= ucfirst($prova->nome) ?></th>
                <th class="descr"><?= ucfirst($prova->descrizione) ?></th>
              </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      <?php else : ?>
         -
        <?php endif; ?>
    </div>
  </div>
  <?php endif; ?>
</div>
