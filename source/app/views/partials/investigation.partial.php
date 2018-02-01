<form action="/caso" method="post">
  <div class="investigation">
    <input
      id="inv-<?= $investigation->getId(); ?>"
      class="accordion-input hide"
      type="checkbox" 
      name="investigations" 
      <?php echo $investigation->getId() === $investigationId ? 'checked' : '' ?>
    >
    <label class="accordion-label" for="inv-<?= $investigation->getId(); ?>">Investigazione <?= $investigation->getId(); ?></label>
    <?php if ($isEdit &&  $investigation->getId() === $investigationId) : ?> 
      <input type="hidden" name="invId" value="<?= $investigation->getId(); ?>">
      <input type="hidden" name="caseId" value="<?= $selectcase->getId(); ?>">
      <div class="investigation-content">
        <p class="center">
          <button class="btn btn-outline">Salva</button>
          <a class="btn btn-outline" href="/caso?id=<?= $selectcase->getId() ?>&investigazione=<?= $investigation->getId(); ?>">Annulla</a>
        </p>
        <div class="investigation-content-field">
          <span class="investigation-content-title">Svolta da: </span> 
          <select class="select" name="investigatore">
            <?php foreach($investigatori as $investigatore) : ?>
              <?php if($investigatore->codice_fiscale == $investigation->investigatore->codice_fiscale) : ?>
                <option value="<?= $investigatore->codice_fiscale; ?>" selected><?= $investigatore->codice_fiscale; ?></option>
              <?php else: ?>
                <option value="<?= $investigatore->codice_fiscale; ?>"><?= $investigatore->codice_fiscale; ?></option>
              <?php endif; ?>
            <?php endforeach; ?>
          </select>
        </div>
        <div class="investigation-content-field">
          <span class="investigation-content-title">Ore di lavoro: </span> 
          <input class="input" type="number" name="ore" value="<?= $investigation->oreTotali ?>" min="0">
        </div>
        <div class="investigation-content-field">
          <span class="investigation-content-title">Data fine: </span> 
          <?php if($investigation->dataTermine == null) : ?>
            <input type="date" name="date_to" id="input-date-to" min="<?= $investigation->dataInizio ?>">
          <?php else : ?>
            <input type="date" name="date_to" id="input-date-to" value="<?= $investigation->dataTermine ?>" required>
          <?php endif; ?>     
        </div>
        <div class="investigation-content-field">
          <span class="investigation-content-title">Luogo: </span> 
          <?php if($investigation->scena == null) : ?>
            <input class="input" type="text" name="scena_nome" value="" placeholder="nome" required>
            <input class="input" type="text" name="scena_descrizione" value="" placeholder="descrizione" required>
            <input class="input" type="text" name="scena_citta" value="" placeholder="città" required>
            <input class="input" type="text" name="scena_indirizzo" value="" placeholder="indirizzo" required>
          <?php else : ?>
            <input class="input" type="text" name="scena_nome" value="<?= $investigation->scena->nome ?>" placeholder="nome" required>
            <input class="input" type="text" name="scena_descrizione" value="<?= $investigation->scena->descrizione ?>" placeholder="descrizione" required>
            <input class="input" type="text" name="scena_citta" value="<?= $investigation->scena->citta ?>" placeholder="città" required>
            <input class="input" type="text" name="scena_indirizzo" value="<?= $investigation->scena->indirizzo ?>" placeholder="indirizzo" required>
          <?php endif; ?>
        </div>
        <div class="investigation-content-field">
          <span class="investigation-content-title">Rapporto: </span>
          <textarea name="rapporto"><?= ucfirst($investigation->rapporto) ?></textarea>
        </div>
      </div>
  
    <?php else: ?>
    <div class="investigation-content">
      <p class="actions">
        <?php if ($routeName === 'dashboard'): ?>
        <a href="/caso?id=<?= $selectcase->getId() ?>&investigazione=<?= $investigation->getId(); ?>">Mostra dettagli</a>
        <?php elseif ($role !== 'inspector'): ?>
        <a href="/caso?id=<?= $selectcase->getId() ?>&investigazione=<?= $investigation->getId(); ?>&modifica=true">Modifica</a>
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
              if($investigation->scena == null) 
                echo '-';
              else
                echo $investigation->getScene();
          ?>
      </div>
      <div class="investigation-content-field">
        <span class="investigation-content-title">Rapporto: </span>
          <?php
            if($investigation->rapporto == '') {
              echo '-';
            } else {
              echo ucfirst($investigation->rapporto);
            }
          ?>
      </div>
      <div class="investigation-content-field">
        <span class="investigation-content-title">Prove: </span>
        <?php if(count($investigation->prove) > 0) : ?>
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
</form>
