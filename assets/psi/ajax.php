<?php
  if (!isset($_POST['query'])) {
    die('Not intended to be called directly.');
  }

  require_once('functions.php');
  $config = loadConfig();

  switch ($_POST['query']) {
    case 'running':
      if (running()) {
        $response = '<div class="text-success"><h6 class="my-0">Online</h6><small>Server is responding.</small></div><span class="badge">✔️</span>';
      } else {
        $response = '<div class="text-danger"><h6 class="my-0">Offline</h6><small>Server is not responding.</small></div><span class="badge">❌</span>';
      }
      break;
    case 'load':
      $load = sys_getloadavg();
      $response = '<div> <h6 class="my-0">Server Load</h6><div class="row"><div class="col-10 text-start fw-bold"><small>1 Minute Average:</small></div><div class="col-2 text-end"><small>' . $load[0] . '</small></div></div><div class="row"><div class="col-10 text-start fw-bold"><small>5 Minute Average:</small></div><div class="col-2 text-end"><small>' . $load[1] . '</small></div></div><div class="row"><div class="col-10 text-start fw-bold"><small>15 Minute Average:</small></div><div class="col-2 text-end"><small>' . $load[2] . '</small></div></div> </div>';
      break;
    case 'size':
      $io = popen ( '/usr/bin/du -sk ' . preg_quote(escapeshellarg($config->instdir),' '), 'r' );
      $size = fgets ( $io, 4096);
      $size = substr ( $size, 0, strpos ( $size, "\t" ) );
      pclose ( $io );
      $response = '<div><h6 class="my-0">Game Disk Usage</h6><small>' . $config->instdir . '</small></div><span class="text-muted">' . formatBytes($size) . '️</span>';
      break;
    case 'df':
      $df = disk_free_space($config->instdir);
      $response = '<div><h6 class="my-0">Game Disk Free</h6><small>' . $config->instdir . '</small></div><span class="text-muted">' . formatBytes($df) . '️</span>';
      break;
    case 'uptime':
      $str   = @file_get_contents('/proc/uptime');
      $num   = floatval($str);
      $secs  = fmod($num, 60); $num = intdiv($num, 60);
      $mins  = $num % 60;      $num = intdiv($num, 60);
      $hours = $num % 24;      $num = intdiv($num, 24);
      $days  = $num;
      $uptime = '';
      if ($days > 0) $uptime .= floor($days) . 'd ';
      if ($hours > 0) $uptime .= floor($hours) . 'h ';
      if ($mins > 0) $uptime .= floor($mins) . 'm ';
      if ($secs > 0) $uptime .= floor($secs) . 's ';
      $response = '<div><h6 class="my-0">Server Uptime</h6></div><span class="text-muted">' . $uptime . '️</span>';
      break;
  }

  echo $response;
