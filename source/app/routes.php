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
    'ricerca' => 'PagesController@search',
    'caso' => 'PagesController@case',
    'utenti' => 'PagesController@users',

    '404' => 'PagesController@notFound'
  ],
  'POST' => [
    'login' => 'PagesController@loginPOST',
    'api/authenticate' => 'AuthController@authenticateAPI',

    'ricerca' => 'PagesController@searchPOST',

    'dashboard' => 'PagesController@addCasePOST',

    'aggiungi-utente' => 'PagesController@addUserPOST',
    'api/utenti/add' => 'UsersController@addUserAPI',

    'modifica-utente' => 'PagesController@editUserPOST',
    'elimina-utente' => 'PagesController@deleteUserPOST'
  ]
];
