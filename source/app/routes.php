<?php

return [
  'GET' => [
    '' => 'PagesController@home',
    'servizi' => 'PagesController@servizi',
    'casi' => 'PagesController@casi',
    'contatti' => 'PagesController@contatti',
    'login' => 'PagesController@login',
    'dashboard' => 'PagesController@dashboard',
    'aggiungi-caso' => 'PagesController@addCase',
    '404' => 'PagesController@notFound'
  ]
];