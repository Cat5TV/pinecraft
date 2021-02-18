<?php
  /*
    Pinecraft Settings Interface (PSI)
    By Robbie Ferguson
  */
  require_once('functions.php');

  if (!auth()) {
    header('location:login.php');
    exit();
  }

  $config = loadConfig();

  // Load Game Server Version
  if (file_exists($config->instdir . 'version_history.json')) {
    $tmp = json_decode(file_get_contents($config->instdir . 'version_history.json'));
    $config->mcver = $tmp->currentVersion;
  }

  // Load server.properties
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

  // Load user info
  if (!isset($config->server->users)) $config->server->users = new stdClass();
  if (!isset($config->server->users->ban)) $config->server->users->ban = new stdClass();
  // Players on server
  if (file_exists($config->instdir . 'usercache.json')) {
    $config->server->users->players = json_decode(file_get_contents($config->instdir . 'usercache.json'));
  }
  // Ops (admin) players
  if (file_exists($config->instdir . 'ops.json')) {
    $config->server->users->ops = json_decode(file_get_contents($config->instdir . 'ops.json'));
  }
  // Banned players
  if (file_exists($config->instdir . 'banned-players.json')) {
    $config->server->users->ban->player = json_decode(file_get_contents($config->instdir . 'banned-players.json'));
  }
  // Banned IP addresses
  if (file_exists($config->instdir . 'banned-ips.json')) {
    $config->server->users->ban->ip = json_decode(file_get_contents($config->instdir . 'banned-ips.json'));
  }

  // Store everything in the main config file
  file_put_contents($config->cfgfile,json_encode($config));

?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Pinecraft</title>
  <meta name="author" content="Robbie Ferguson">

  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link href="https://fonts.googleapis.com/css2?family=Open+Sans&display=swap" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BmbxuPwQa2lc/FVzBcNJ7UAyJxM6wuqIj61tLrc4wSX0szH/Ev+nYRRuWlolflfl" crossorigin="anonymous">
  <link href="style.css" rel="stylesheet">
  <meta name="theme-color" content="#7952b3">
</head>
<body class="bg-light">

<div class="container">
  <main>
    <div class="py-5 text-center">
      <img class="d-block mx-auto mb-4" src="logo.webp" alt="" height="57" />
      <h2>Pinecraft Settings Interface</h2>
    </div>

    <div class="row g-3">

      <div class="col-md-5 col-lg-4 order-md-last">

        <h4 class="d-flex justify-content-between align-items-center mb-3">
          <span class="text-muted">Server Status</span>
        </h4>

        <ul class="list-group mb-3">
          <li class="list-group-item d-flex justify-content-between bg-light" id="running"></li>
          <li class="list-group-item d-flex justify-content-between" id="load"></li>
          <li class="list-group-item d-flex justify-content-between lh-sm">
            <div>
              <h6 class="my-0">Server Type</h6>
            </div>
            <span class="text-muted"><?= $config->flavor ?></span>
          </li>
          <li class="list-group-item d-flex justify-content-between lh-sm">
            <div>
              <h6 class="my-0">Pinecraft Installer</h6>
            </div>
            <span class="text-muted"><?= $config->pcver ?></span>
          </li>
          <li class="list-group-item d-flex justify-content-between lh-sm" id="size"></li>
          <li class="list-group-item d-flex justify-content-between lh-sm" id="df"></li>
          <li class="list-group-item d-flex justify-content-between bg-light" id="uptime"></li>
        </ul>

        <div class="text-end">
          <a href="login.php" class="btn btn-secondary">Logout</a>
        </div>

      </div>

      <div class="col-md-7 col-lg-8">
        <h4 class="mb-3">Server Configuration</h4>
        <form class="needs-validation" novalidate>
          <div class="row g-3">
            <div class="col-sm-6">
              <label for="firstName" class="form-label">First name</label>
              <input type="text" class="form-control" id="firstName" placeholder="" value="" required>
              <div class="invalid-feedback">
                Valid first name is required.
              </div>
            </div>

            <div class="col-sm-6">
              <label for="lastName" class="form-label">Last name</label>
              <input type="text" class="form-control" id="lastName" placeholder="" value="" required>
              <div class="invalid-feedback">
                Valid last name is required.
              </div>
            </div>

            <div class="col-12">
              <label for="username" class="form-label">Username</label>
              <div class="input-group has-validation">
                <span class="input-group-text">@</span>
                <input type="text" class="form-control" id="username" placeholder="Username" required>
              <div class="invalid-feedback">
                  Your username is required.
                </div>
              </div>
            </div>

            <div class="col-12">
              <label for="email" class="form-label">Email <span class="text-muted">(Optional)</span></label>
              <input type="email" class="form-control" id="email" placeholder="you@example.com">
              <div class="invalid-feedback">
                Please enter a valid email address for shipping updates.
              </div>
            </div>

            <div class="col-12">
              <label for="address" class="form-label">Address</label>
              <input type="text" class="form-control" id="address" placeholder="1234 Main St" required>
              <div class="invalid-feedback">
                Please enter your shipping address.
              </div>
            </div>

            <div class="col-12">
              <label for="address2" class="form-label">Address 2 <span class="text-muted">(Optional)</span></label>
              <input type="text" class="form-control" id="address2" placeholder="Apartment or suite">
            </div>

            <div class="col-md-5">
              <label for="country" class="form-label">Country</label>
              <select class="form-select" id="country" required>
                <option value="">Choose...</option>
                <option>United States</option>
              </select>
              <div class="invalid-feedback">
                Please select a valid country.
              </div>
            </div>

            <div class="col-md-4">
              <label for="state" class="form-label">State</label>
              <select class="form-select" id="state" required>
                <option value="">Choose...</option>
                <option>California</option>
              </select>
              <div class="invalid-feedback">
                Please provide a valid state.
              </div>
            </div>

            <div class="col-md-3">
              <label for="zip" class="form-label">Zip</label>
              <input type="text" class="form-control" id="zip" placeholder="" required>
              <div class="invalid-feedback">
                Zip code required.
              </div>
            </div>
          </div>

          <hr class="my-4">

          <div class="form-check">
            <input type="checkbox" class="form-check-input" id="same-address">
            <label class="form-check-label" for="same-address">Shipping address is the same as my billing address</label>
          </div>

          <div class="form-check">
            <input type="checkbox" class="form-check-input" id="save-info">
            <label class="form-check-label" for="save-info">Save this information for next time</label>
          </div>

          <hr class="my-4">

          <h4 class="mb-3">Payment</h4>

          <div class="my-3">
            <div class="form-check">
              <input id="credit" name="paymentMethod" type="radio" class="form-check-input" checked required>
              <label class="form-check-label" for="credit">Credit card</label>
            </div>
            <div class="form-check">
              <input id="debit" name="paymentMethod" type="radio" class="form-check-input" required>
              <label class="form-check-label" for="debit">Debit card</label>
            </div>
            <div class="form-check">
              <input id="paypal" name="paymentMethod" type="radio" class="form-check-input" required>
              <label class="form-check-label" for="paypal">PayPal</label>
            </div>
          </div>

          <div class="row gy-3">
            <div class="col-md-6">
              <label for="cc-name" class="form-label">Name on card</label>
              <input type="text" class="form-control" id="cc-name" placeholder="" required>
              <small class="text-muted">Full name as displayed on card</small>
              <div class="invalid-feedback">
                Name on card is required
              </div>
            </div>

            <div class="col-md-6">
              <label for="cc-number" class="form-label">Credit card number</label>
              <input type="text" class="form-control" id="cc-number" placeholder="" required>
              <div class="invalid-feedback">
                Credit card number is required
              </div>
            </div>

            <div class="col-md-3">
              <label for="cc-expiration" class="form-label">Expiration</label>
              <input type="text" class="form-control" id="cc-expiration" placeholder="" required>
              <div class="invalid-feedback">
                Expiration date required
              </div>
            </div>

            <div class="col-md-3">
              <label for="cc-cvv" class="form-label">CVV</label>
              <input type="text" class="form-control" id="cc-cvv" placeholder="" required>
              <div class="invalid-feedback">
                Security code required
              </div>
            </div>
          </div>

          <hr class="my-4">

          <button class="w-100 btn btn-primary btn-lg" type="submit">Save Settings</button>
        </form>

        <hr class="my-4">

        <h4 class="mb-3">Danger Zone</h4>
        <form class="needs-validation" novalidate>
          <div class="row g-3">
            <div class="col-sm-6">
              <button class="w-100 btn btn-warning btn-lg" type="submit">Power Off Server</button>
            </div>
            <div class="col-sm-6">
              <button class="w-100 btn btn-secondary btn-lg" type="submit">Reboot Server</button>
            </div>
          </div>

          <hr class="my-4">

          <div class="row g-3">
            <div class="col-sm-6">
              <button class="w-100 btn btn-danger btn-lg" type="submit">Re-Generate World</button>
            </div>
          </div>
        </form>


      </div>




    </div>
  </main>

  <footer class="my-5 pt-5 text-muted text-center text-small">
    <p class="mb-1">&copy; 2017–2021 Company Name</p>
    <ul class="list-inline">
      <li class="list-inline-item"><a href="#">Privacy</a></li>
      <li class="list-inline-item"><a href="#">Terms</a></li>
      <li class="list-inline-item"><a href="#">Support</a></li>
    </ul>
  </footer>
</div>

  <p><?php print_r($config) ?></p>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js" integrity="sha512-bLT0Qm9VnAYZDflyKcBaQ2gg0hSYNQrJ8RilYldYQ1FxQYoCLtUjuuRuZo+fjqhx/qtq/1itJ0C2ejDxltZVFg==" crossorigin="anonymous"></script>
  <script src="psi.js"></script>
</body>
</html>
