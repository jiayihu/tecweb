<!DOCTYPE html>
<html lang="it">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <link rel="icon" href="favicon.ico?v=3" type="image/x-icon">
  <title>Studio Sherlock & Watson</title>

  <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
  <link href="public/css/external/normalize.css" rel="stylesheet">
  <link href="public/css/common.css" rel="stylesheet">
  <link href="public/css/<?= $routeName ?>.css" rel="stylesheet">
</head>

<body class="page-<?= $routeName ?>">
  <header id="top" class="navbar-container"> <!-- Per il back to top -->
    <div class="navbar container clearfix">
      <div class="navbar-left left">
        <a href="/dashboard" title="Go back to dashboard">
          <img class="logo-img" src="public/images/logo.png" alt="Logo Studio Sherlock & Watson" />
        </a>
      </div>
      <ul class="list navbar-right right">
        <?php if ($role !== 'inspector'): ?>
        <li class="list-item dropdown">
          <span class="dropdown-toggle">Dashboard</span>
          <ul class="submenu">
            <?php if ($role === 'admin'): ?>
            <li class="list-item">
              <a href="">Gestisci tag</a>
            </li>
            <?php endif; ?>
            <li class="list-item">
              <a href="aggiungi-criminale">Aggiungi criminale</a>
            </li>
            <li class="list-item">
              <a href="aggiungi-cliente">Aggiungi cliente</a>
            </li>
          </ul>
        </li>
        <?php endif; ?>
        <li class="list-item">
          <a class="navbar-link <?= $routeName === 'ricerca' ? 'active' : '' ?>" href="ricerca">Ricerca</a>
        </li>
        <?php if ($role === 'admin'): ?>
        <li class="list-item">
          <a class="navbar-link <?= $routeName === 'utenti' ? 'active' : '' ?>" href="utenti">Utenti</a>
        </li>
        <?php endif; ?>
        <li class="list-item dropdown dropdown-right">
          <span class="dropdown-toggle"><?= $username ?></span>
          <ul class="submenu">
            <li class="list-item">
              <a href="impostazioni">Impostazioni</a>
            </li>
            <li class="list-item">
              <a href="/logout">Logout</a>
            </li>
          </ul>
        </li>
      </ul>
    </div>
  </header>
