<?php

class Usuario {
    private $conex;
    private $tabela = 'usuarios';

    public function __construct($bd) {
        $this->conex = $bd;
    }

    public function autenticar($email, $senha) {
        $sql = "SELECT * FROM " . $this->tabela . " WHERE email = :email LIMIT 1";
        $stmt = $this->conex->prepare($sql);
        $stmt->bindParam(':email', $email);
        $stmt->execute();

        if ($stmt->rowCount() === 1) {
            $usuario = $stmt->fetch(PDO::FETCH_ASSOC);
            if (password_verify($senha, $usuario['senha_hash'])) {
                return $usuario;  // Retorna dados do usuário
            }
        }
        return false;
    }
}

session_start();

$host = 'localhost';
$db = 'advocaciadb';
$user = 'root';
$pass = '';

try {
    $conn = new PDO("mysql:host=$host;dbname=$bd", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Erro de conexão: " . $e->getMessage());
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['username'] ?? '';
    $senha = $_POST['password'] ?? '';

    $usuarioObj = new Usuario($conex);
    $usuario = $usuarioObj->autenticar($email, $senha);

    if ($usuario) {
        $_SESSION['usuario_id'] = $usuario['id'];
        $_SESSION['usuario_nome'] = $usuario['nome'];
        $_SESSION['usuario_tipo'] = $usuario['tipo'];

        header('Location: /PI-GRUPO-04/Site/cliente.html');
        exit;
    } else {
        echo 'Email ou senha incorretos.';
    }
}
?>