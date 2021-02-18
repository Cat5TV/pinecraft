<?php
  if (session_status() === PHP_SESSION_NONE) session_start();

  // Check if user is authorized
  function auth() {
    if ($_SESSION['auth'] == 1) {
      return true;
    } else {
      return false;
    }
  }

  // Load the master config file
  function loadConfig() {
    $cfgfile = '/etc/pinecraft/psi/psi.json';
    $config = json_decode(file_get_contents($cfgfile));
    $config->cfgfile = $cfgfile;
    return $config;
  }

  // Check if the game server is running
  function running() {
    $config = loadConfig();
    $connection = @fsockopen('localhost', $config->server->{'server-port'});
    if (is_resource($connection)) {
      fclose($connection);
      return true;
    } else {
      return false;
    }
  }

  // Convert Bytes to Other, Automatically
  // From https://stackoverflow.com/a/2510459
  function formatBytes($bytes, $precision = 2) {
    $units = array('B', 'KB', 'MB', 'GB', 'TB');
    $bytes = max($bytes, 0);
    $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
    $pow = min($pow, count($units) - 1);
    $bytes /= (1 << (10 * $pow));
    return round($bytes, $precision) . ' ' . $units[$pow];
  }

