<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title><?php echo $title; ?></title>
</head>
<body>
  <?php if(isset($username)) { ?>
  <p>Hello <?php echo $username; ?>, <a
  href="/index.php/authentication/signout"> Sign out </a></p>
  <?php } ?>
  <br>
  <br>
