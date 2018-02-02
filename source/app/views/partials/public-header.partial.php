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
<body>
  <header id="top" class="navbar-container"> <!-- Per il back to top -->
    <div class="navbar container clearfix">
      <div class="navbar-left left">
        <a class="home-link" href="/" title="Go back to home">
          <img class="logo-img" src="public/images/logo.png" alt="Logo Studio Sherlock & Watson" />
        </a>
      </div>
      <ul class="list navbar-right right">
        <li class="list-item">
          <a class="navbar-link <?= $routeName === 'servizi' ? 'active' : '' ?>" href="servizi">Servizi</a>
        </li>
        <li class="list-item">
          <a class="navbar-link <?= $routeName === 'casi' ? 'active' : '' ?>" href="casi">Casi di Studio</a>
        </li>
        <li class="list-item">
          <a class="navbar-link <?= $routeName === 'contatti' ? 'active' : '' ?>" href="contatti">Contatti</a>
        </li>
        <li class="list-item">
          <a class="navbar-link <?= $routeName === 'login' ? 'active' : '' ?>" href="login">Login</a>
        </li>
      </ul>
    </div>
  </header>
