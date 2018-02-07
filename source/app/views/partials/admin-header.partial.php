<!DOCTYPE html>
<html lang="it">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <link rel="icon" href="<?= ROOT ?>/favicon.ico?v=3" type="image/x-icon">
  <title>Studio Sherlock & Watson</title>

  <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
  <link href="<?= ROOT ?>/public/css/external/normalize.css" rel="stylesheet">
  <link href="<?= ROOT ?>/public/css/common.css" rel="stylesheet">
  <link href="<?= ROOT ?>/public/css/<?= $routeName ?>.css" rel="stylesheet">
</head>

<body class="page-<?= $routeName ?>">
  <a class="screen-reader" href="#content">Salta la navigazione</a>
  <header id="top" class="navbar-container"> <!-- Per il back to top -->
    <div class="navbar container clearfix">
      <div class="navbar-left left">
        <a href="<?= ROOT ?>/dashboard" title="Ritorna alla dashboard">
          <img lang="en" class="logo-img" src="<?= ROOT ?>/public/images/logo.png" alt="Logo Studio Sherlock & Watson, rimanda alla dashboard" />
        </a>
      </div>
      <ul class="list navbar-right right">
        <?php if ($role !== 'inspector'): ?>
        <li class="list-item dropdown">
          <span tabindex="0" class="dropdown-toggle">Dashboard</span>
          <ul class="submenu screen-reader">
            <?php if ($role === 'admin'): ?>
            <?php endif; ?>
            <li class="list-item">
              <a href="<?= ROOT ?>/aggiungi-criminale">Aggiungi criminale</a>
            </li>
            <li class="list-item">
              <a href="<?= ROOT ?>/aggiungi-cliente">Aggiungi cliente</a>
            </li>
          </ul>
        </li>
        <?php endif; ?>
        <li class="list-item">
          <a class="navbar-link <?= $routeName === 'ricerca' ? 'active' : '' ?>" href="<?= ROOT ?>/ricerca">Ricerca</a>
        </li>
        <?php if ($role === 'admin'): ?>
        <li class="list-item">
          <a class="navbar-link <?= $routeName === 'utenti' ? 'active' : '' ?>" href="<?= ROOT ?>/utenti">Utenti</a>
        </li>
        <?php endif; ?>
        <li class="list-item dropdown dropdown-right">
          <span tabindex="0" class="dropdown-toggle"><?= $username ?></span>
          <ul class="submenu screen-reader">
            <li class="list-item">
              <a href="<?= ROOT ?>/impostazioni">Impostazioni</a>
            </li>
            <li class="list-item">
              <a href="<?= ROOT ?>/logout">Esci</a>
            </li>
          </ul>
        </li>
      </ul>
    </div>
  </header>
