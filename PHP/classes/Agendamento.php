<?php
declare(strict_types=1);
require_once 'C:\xampp\htdocs\PI-Grupo-04\PHP\classes\DB.php';

class Agendamento extends Database {
    private string $tabela = 'agendamentos';

    public function agendar(string $nome, string $data, string $hora, ?string $observacoes = null): bool {
        // Busca o ID do cliente pelo nome
        $sqlCliente = "SELECT id FROM clientes WHERE nome = :nome LIMIT 1";
        $stmtCliente = $this->conexao->prepare($sqlCliente);
        $stmtCliente->bindParam(':nome', $nome, PDO::PARAM_STR);
        $stmtCliente->execute();

        if ($stmtCliente->rowCount() === 0) {
            die('Cliente não encontrado.');
        }

        $cliente = $stmtCliente->fetch(PDO::FETCH_ASSOC);
        $cliente_id = $cliente['id'];

        // Concatena data e hora para o campo data_hora
        $data_hora = $data . ' ' . $hora;

        // Insere o agendamento
        $sql = "INSERT INTO {$this->tabela} (cliente_id, data_hora, descricao, status) 
                VALUES (:cliente_id, :data_hora, :descricao, :status)";
        $stmt = $this->conexao->prepare($sql);

        $status = 'Agendado';

        $stmt->bindParam(':cliente_id', $cliente_id, PDO::PARAM_INT);
        $stmt->bindParam(':data_hora', $data_hora, PDO::PARAM_STR);
        $stmt->bindParam(':descricao', $observacoes);
        $stmt->bindParam(':status', $status);

        return $stmt->execute();
    }
}
?>
