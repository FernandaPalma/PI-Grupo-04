<?php
session_start();

// Dados de conexão com o banco
$host = "localhost";
$db = "advocaciadb";
$user = "root";

// Conexão com o banco
$conn = new mysqli($host, $user, $pass, $db);

// Verificar conexão
if ($conn->connect_error) {
    die("Erro de conexão: " . $conn->connect_error);
}

// Verificar se o formulário foi enviado
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST["username"];
    $senha = $_POST["password"];

    // Protege contra SQL Injection
    $stmt = $conn->prepare("SELECT id, nome, senha_hash, tipo, cliente_id FROM usuarios WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $resultado = $stmt->get_result();

    if ($resultado->num_rows === 1) {
        $usuario = $resultado->fetch_assoc();

        // Verifica a senha
        if (password_verify($senha, $usuario['senha_hash'])) {
            $_SESSION['usuario_id'] = $usuario['id'];
            $_SESSION['usuario_nome'] = $usuario['nome'];
            $_SESSION['usuario_tipo'] = $usuario['tipo'];

            // Se for cliente, armazena o id do cliente
            if ($usuario['tipo'] === 'Cliente') {
    $_SESSION['cliente_id'] = $usuario['cliente_id'];
    echo "Redirecionando para cliente.html...";  // Debug
    header("Location: cliente.html");
    exit();
}
        } else {
            echo "Senha incorreta.";
        }
    } else {
        echo "Usuário não encontrado.";
    }

    $stmt->close();
}

$conn->close();
?>
