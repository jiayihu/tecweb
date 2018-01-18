<?php

return [
  'GET' => [
    '' => 'PagesController@home',
    'servizi' => 'PagesController@services',
    'casi' => 'PagesController@cases',
    'contatti' => 'PagesController@contacts',
    'login' => 'PagesController@login',
    'logout' => 'PagesController@logout',

    'dashboard' => 'PagesController@dashboard',
    'aggiungi-caso' => 'PagesController@addCase',
    'ricerca' => 'PagesController@search',
    'caso' => 'PagesController@case',
    'utenti' => 'PagesController@users',
    'impostazioni' => 'PagesController@impostazioni',
    'aggiungi-criminale' => 'PagesController@addCriminale',

    '404' => 'PagesController@notFound'
  ],
  'POST' => [
    'login' => 'PagesController@loginPOST',
    'api/authenticate' => 'AuthController@authenticateAPI',

    'ricerca' => 'PagesController@searchPOST',

    'aggiungi-utente' => 'PagesController@addUserPOST',
    'api/utenti/add' => 'UsersController@addUserAPI',

    'modifica-utente' => 'PagesController@editUserPOST',
    'elimina-utente' => 'PagesController@deleteUserPOST',

    'modifica-password' => 'PagesController@editUserPasswordPOST',

    'aggiunta-criminale' => 'PagesController@aggiungiCriminale'
  ]
];
