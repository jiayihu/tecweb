<?php

return [
  'GET' => [
    '' => 'PagesController@home',
    'servizi' => 'PagesController@servizi',
    'casi' => 'PagesController@casi',
    'contatti' => 'PagesController@contatti',
    'login' => 'PagesController@login',
    'logout' => 'PagesController@logout',

    'dashboard' => 'PagesController@dashboard',
    'aggiungi-caso' => 'PagesController@addCase',
    'ricerca' => 'PagesController@ricerca',
    'caso' => 'PagesController@caso',
    'utenti' => 'PagesController@utenti',

    '404' => 'PagesController@notFound'
  ],
  'POST' => [
    'login' => 'PagesController@loginPOST',
    'api/authenticate' => 'AuthController@authenticateAPI',

    'aggiungi-utente' => 'PagesController@addUserPOST',
    'api/utenti/add' => 'UsersController@addUserAPI',

    'modifica-utente' => 'PagesController@editUserPOST',
    'elimina-utente' => 'PagesController@deleteUserPOST'
  ]
];
