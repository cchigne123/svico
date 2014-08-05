<?php
    session_start();
?>
<!DOCTYPE html>
<html>
<meta charset="utf-8"/>
<head>
    <title>.:: TAXI SVICO | Panel de Control ::.</title>
    <link rel="stylesheet" href="../vendor/bootstrap-3.2.0-dist/css/bootstrap.css"/>
    <link rel="stylesheet" href="../css/index.css"/>
    <link rel="shortcut icon" href="../img/logo.ico" />
</head>

<body>

<div class="container">
    <div class="row">
        <div class="col-sm-6 col-md-4 col-md-offset-4">
            <div class="account-wall text-center">

                <img src="../img/logo.png" width="240" height="80" class="imgLogin" />

                <form class="form-signin" autocomplete="off" action="../app/login.php" method="post">
                    <input type="text" id="usuario" name="usuario" class="form-control usuario" placeholder="Usuario"
                           required autofocus>
                    <input type="password" id="clave" name="clave" class="form-control clave" placeholder="Clave"
                           required>
                    <br>
                    <button class="btn btn-lg btn-success btn-block" type="submit">
                        Acceder
                    </button>

                    <?php if (isset($_SESSION['errors'])) { ?>
                        <div class="errors">
                            <i class="glyphicon glyphicon-remove"></i> <?php echo $_SESSION['errors']; ?>
                        </div>
                    <?php } ?>

                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>