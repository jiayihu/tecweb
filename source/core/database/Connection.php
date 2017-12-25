<?php 

namespace Core\Database;

class Connection {
  /**
   * Returns the PDO instance to make better and safer database requests 
   *
   * @param array $config Environment configuration with private credentials
   * @return void
   */
  public static function make(array $config) {
    try {
      return new \PDO(
        "mysql:host={$config['hostdb']};dbname={$config['name']}",
        $config['username'],
        $config['password'],
        $config['options']
      );
    } catch (\PDOException $e) {
      die('Could not connect' . $e->getMessage());
    }
  }
}
