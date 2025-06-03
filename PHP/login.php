<?php
session_start();
require_once('C:\xampp\htdocs\PI-Grupo-04\PHP\classes\Usuario.php');

$usuario = $_POST['username'];
$senha = $_POST['password'];

$user = new Usuario();
$dados = $user->autenticar($usuario, $senha); // retorna array ou false

if ($dados) {
    $_SESSION['usuario'] = $dados['nome'];
    $_SESSION['usuario_id'] = $dados['id'];
    $_SESSION['tipo_usuario'] = $dados['tipo'];

    header("Location: /PI-Grupo-04/Site/cliente.html");
    exit();
} else {
    header("Location: index.html?erro=1");
    exit();
}
?>
