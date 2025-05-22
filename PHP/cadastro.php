<?php

class Cliente {
    private $conex;
    private $tabela = 'clientes';

    public function __construct($bd) {
        $this->conex = $bd;
    }

    public function cadastrar($dados) {
        $sql = "INSERT INTO " . $this->tabela . " (nome, cpf, email, telefone, endereco, estado_civil) 
                VALUES (:nome, :cpf, :email, :telefone, :endereco, :estado_civil)";
        
        $stmt = $this->conex->prepare($sql);
        $stmt->bindParam(':nome', $dados['nome']);
        $stmt->bindParam(':cpf', $dados['cpf']);
        $stmt->bindParam(':email', $dados['email']);
        $stmt->bindParam(':telefone', $dados['telefone']);
        $stmt->bindParam(':endereco', $dados['endereco']);
        $stmt->bindParam(':estado_civil', $dados['estado_civil']);

        return $stmt->execute();
    }
}

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
    $cliente = new Cliente($conex);

    $dados = [
        'nome' => $_POST['nome'] ?? '',
        'cpf' => $_POST['cpf'] ?? '',
        'email' => $_POST['email'] ?? '',
        'telefone' => $_POST['telefone'] ?? '',
        'endereco' => $_POST['endereco'] ?? '',
        'estado_civil' => $_POST['estado_civil'] ?? ''
    ];

    if ($cliente->cadastrar($dados)) {
        // Redireciona após cadastro bem-sucedido
        header('Location: \PI-Grupo-04\Site\cliente.html');
        exit;
    } else {
        echo 'Erro ao cadastrar cliente.';
    }
}
?>