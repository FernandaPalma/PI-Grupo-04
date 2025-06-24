<?php
declare(strict_types=1);

require_once __DIR__ . '\classes\Usuarios.php';

$usuarioObj = new Usuarios();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['excluir_usuario'])) {
    $usuarios = new Usuarios();
    $confirmar = isset($_POST['confirmar_exclusao_total']);
    $usuarios->excluirUsuario($_POST['excluir_id'], $confirmar);
    header("Location: usuario.php");
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['atualizar_usuario'])) {
    $usuarioObj->alterarUsuario(
        $_POST['cliente_id'],
        $_POST['nome'],
        $_POST['telefone'],
        $_POST['cpf'],
        $_POST['email'],
        $_POST['endereco'],
        $_POST['estado_civil']
    );
    header("Location: usuario.php");
    exit();
}

$editarUsuario = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['alterar_usuario'])) {
    $editarUsuario = $usuarioObj->buscarId($_POST['alterar_id']);
}

if ($_SERVER["REQUEST_METHOD"] == "GET") {
    $dados = [
        'cliente_id' => trim( $_GET['cliente_id'] ?? ''),
        'nome' => trim($_GET['nome'] ?? ''),
        'cpf' => trim($_GET['cpf'] ?? ''),
        'email' => trim($_GET['email'] ?? ''),
        'telefone' => trim($_GET['telefone'] ?? ''),
        'endereco' => trim($_GET['endereco'] ?? ''),
        'estado_civil' => trim($_GET['estado_civil'] ?? '')
    ];
}

$usuarios = $usuarioObj->listarUsuarios();

?>