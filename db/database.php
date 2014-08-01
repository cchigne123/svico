<?php

require_once '../conf/local.php';
//require_once '../conf/remoto.php';


class ConexionBD
{

    private $host = DB_HOST;
    private $user = DB_USER;
    private $passw = DB_PASSW;
    private $dbname = DB_NAME;
    private $conn;
    private $options;
    private $error;

    private $stmt;

    function __construct()
    {

        $dsn = 'mysql:host=' . $this->host . ';dbname=' . $this->dbname;

        $this->options = array(
            PDO::ATTR_PERSISTENT => true,
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
        );

        try {
            $this->conn = new PDO($dsn, $this->user, $this->passw, $this->options);
        } catch (Exception $e) {
            $this->error = $e->getMessage();
        }

    }

    function query($query)
    {
        $this->stmt = $this->conn->prepare($query);
    }

    function bind($param, $value, $type = null)
    {
        if (is_null($type)) {
            switch (true) {
                case is_int($value):
                    $type = PDO::PARAM_INT;
                    break;
                case is_bool($value):
                    $type = PDO::PARAM_BOOL;
                    break;
                case is_null($value):
                    $type = PDO::PARAM_NULL;
                    break;
                default:
                    $type = PDO::PARAM_STR;
            }
        }
        $this->stmt->bindParam($param, $value, $type);
    }

    function execute()
    {
        return $this->stmt->execute();
    }

    function resultSet()
    {
        $this->execute();
        return $this->stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    function lastInsertId()
    {
        return $this->conn->lastInsertId();
    }

} 