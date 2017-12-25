<?php

namespace Core;

class Router {
  private $routes = [
    'GET' => [],
    'POST' => []
  ];

  /**
   * Loads the routes configuration from a file
   *
   * @param string $file Path of the routes file
   * @return void
   */
  public static function load(string $file) {
    $routes = require $file;
    $router = new self($routes);

    return $router;
  }

  public function __construct(array $routes) {
    $this->parseRoutes($routes);
  }

  public function define(array $routes) {
    $this->parseRoutes($routes);
  }

  /**
   * Adds a route for a GET request
   *
   * @param string $uri
   * @param string $controller
   * @return void
   */
  public function get(string $uri, string $controller) {
    $this->routes['GET'][$uri] = $controller;
  }

  /**
   * Adds a route for a POST request
   *
   * @param string $uri
   * @param string $controller
   * @return void
   */
  public function post(string $uri, string $controller) {
    $this->routes['POST'][$uri] = $controller;
  }

  /**
   * Handles a request to a route
   *
   * @param string $uri
   * @param string $method
   * @return void
   */
  public function direct(string $uri, string $method) {
    $route = [];

    if (array_key_exists($method, $this->routes) && array_key_exists($uri, $this->routes[$method])) {
      $route = \explode('@', $this->routes[$method][$uri]);
    } else {
      $route = \explode('@', $this->routes['GET']['404']);
    }
    
    $controller = $route[0];
    $action = $route[1];

    return $this->callAction($controller, $action);
  }

  /**
   * Calls the appropriate method of route Controller as specified in the 
   * configuration
   *
   * @param string $controller
   * @param string $action
   * @return void
   */
  private function callAction(string $controller, string $action) {
    require_once "app/controllers/{$controller}.php";

    $name = "App\\Controllers\\{$controller}";
    $instance = new $name;

    if (!\method_exists($instance, $action)) {
      throw new Exception("{$action} does not exist on controller {$controller}");
    }

    return $instance->$action();
  }

  private function parseRoutes(array $routes) {
    if (\array_key_exists('GET', $routes)) {
      foreach ($routes['GET'] as $uri => $controller) {
        $this->get($uri, $controller);
      }
    }

    if (\array_key_exists('POST', $routes)) {
      foreach ($routes['POST'] as $uri => $controller) {
        $this->post($uri, $controller);
      }
    }
  }
}
