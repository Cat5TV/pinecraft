<?php
  /*
    Pinecraft Settings Interface (PSI)
    By Robbie Ferguson
  */
  $cfgfile = '/etc/pinecraft/psi/psi.json';
  $config = json_decode(file_get_contents($cfgfile));
  if (!isset($config->server)) {
    if (file_exists($config->instdir . 'server.properties')) {
      $server = file($config->instdir . 'server.properties');
      if (is_array($server)) {
        $config->server = new stdClass();
        foreach($server as $line) {
          // Ignore commented lines entirely
          if (substr(trim($line),0,1) != '#') {
            $tmp = explode('=',$line);
            $key = trim($tmp[0]);
            $value = trim($tmp[1]);
            $config->server->$key = $value;
          }
        }
      }
    } else {
      die('Server not initialized.');
    }
  }
  file_put_contents($cfgfile,json_encode($config));
?>
<!DOCTYPE html><html lang="en"><head><meta charset="utf-8" /><title>Pinecraft</title>
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Open+Sans&display=swap" rel="stylesheet">
<style>
body {
  background: #333;
  color: #ccc;
  font-family: 'Open Sans', sans-serif;
  font-size: 16px;
}
#topbar {
  font-weight: bold;
  font-size: 1.2em;
  color: #fff;
  padding: 4px;
}
</style>
</head>
<body>
  <div id="topbar">
    <p>Pinecraft Settings Interface</p>
  </div>
  <p>Coming soon.</p>
</body>
</html>
