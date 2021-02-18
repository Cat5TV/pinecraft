<?php
  /*
    Pinecraft Settings Interface (PSI)
    By Robbie Ferguson
  */
  require_once('functions.php');
  session_destroy();
  session_start();
  $config = loadConfig();
  if (isset($_POST['password'])) {
    $password = password_hash($_POST['password'], PASSWORD_DEFAULT);
    if (isset($_POST['password1'])) {
      if (password_verify($_POST['password'], $_POST['password1'])) {
        // Password is good. Store it, and login.
        $config->adminpass = $password;
        file_put_contents($config->cfgfile,json_encode($config));
        $_SESSION['auth'] = 1;
      }
    } else {
      if (password_verify($_POST['password'], $config->adminpass)) {
        $_SESSION['auth'] = 1;
      }
    }
  }
  if (auth()) {
    header('location:/');
    exit();
  }

?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Pinecraft</title>
  <meta name="author" content="Robbie Ferguson">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-BmbxuPwQa2lc/FVzBcNJ7UAyJxM6wuqIj61tLrc4wSX0szH/Ev+nYRRuWlolflfl" crossorigin="anonymous">
  <link href="style.css" rel="stylesheet">
  <meta name="theme-color" content="#7952b3">
</head>
<body class="bg-light">

<div class="container">

  <main>
    <?php if (!isset($config->adminpass)) { ?>
    <div class="py-5 text-center">
      <img class="d-block mx-auto mb-4" src="logo.webp" alt="" height="57" />
      <h2>Pinecraft Settings Interface</h2>
    <?php if (!isset($password)) { ?>
      <p>This is your first time logging in. Please set a password.</p>
    <?php } elseif (!isset($_POST['password1']))  { ?>
      <p>Please confirm the password by entering it one more time.</p>
    <?php } else { ?>
      <p>The passwords did not match. Please try again.</p>
    <?php } ?>
    </div>

    <div class="row g-5">
      <div class="col-md-4 offset-md-4">
        <form method="post" class="card p-2">
          <div class="input-group">
            <input type="password" name="password" class="form-control" placeholder="Password">
            <?php if (isset($password)) echo '<input type="hidden" name="password1" value="' . $password . '">'; ?>
            <button type="submit" class="btn btn-secondary">Submit</button>
          </div>
        </form>
      </div>
    </div>

    <?php } else { ?>

    <div class="py-5 text-center">
      <img class="d-block mx-auto mb-4" src="logo.webp" alt="" height="57" />
      <h2>Pinecraft Settings Interface</h2>
      <p>Please login.</p>
    </div>

    <div class="row g-5">
      <div class="col-md-4 offset-md-4">
        <form method="post" class="card p-2">
          <div class="input-group">
            <input type="password" name="password" class="form-control" placeholder="Password">
            <button type="submit" class="btn btn-secondary">Login</button>
          </div>
        </form>
      </div>
    </div>

    <?php } ?>

  </main>

</div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta2/dist/js/bootstrap.bundle.min.js" integrity="sha384-b5kHyXgcpbZJO/tY9Ul7kGkf1S0CWuKcCD38l8YkeH8z8QjE0GmW1gYU5S9FOnJ0" crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js" integrity="sha512-bLT0Qm9VnAYZDflyKcBaQ2gg0hSYNQrJ8RilYldYQ1FxQYoCLtUjuuRuZo+fjqhx/qtq/1itJ0C2ejDxltZVFg==" crossorigin="anonymous"></script>
</body>
</html>
