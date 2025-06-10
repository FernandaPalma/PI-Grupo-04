<?php
declare(strict_types=1);

require_once 'C:\xampp\htdocs\PI-Grupo-04\PHP\classes\Cliente.php';

session_start();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $clienteObj = new Cliente();

    // Sanitização e Validação Básica
    $dados = [
        'nome' => trim($_POST['nome'] ?? ''),
        'cpf' => trim($_POST['cpf'] ?? ''),
        'email' => trim($_POST['email'] ?? ''),
        'telefone' => trim($_POST['telefone'] ?? ''),
        'endereco' => trim($_POST['endereco'] ?? ''),
        'estado_civil' => trim($_POST['estado_civil'] ?? '')
    ];

    foreach ($dados as $key => $value) {
        if (empty($value)) {
            echo "O campo $key é obrigatório.";
            exit;
        }
    }

    $cadastro = new Cliente();

    if ($cadastro->cadastrar($dados)) {
        header('Location: /PI-Grupo-04/Site/cliente.html');
        exit;
    } else {
        echo 'Erro ao realizar o agendamento.';
    }
}
?>
