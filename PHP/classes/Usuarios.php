<?php
declare(strict_types=1);

require_once __DIR__ . '/DB.php';

class Usuarios extends Database {
    private string $tabela = 'Clientes';

    public function listarUsuarios() {
        $sql = "SELECT * FROM Clientes";
        $stmt = $this->conexao->prepare($sql);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function excluirUsuario($id, $confirmar = false)
{

    $sql = "SELECT COUNT(*) as total FROM Agendamentos WHERE cliente_id = :cliente_id";
    $stmt = $this->conexao->prepare($sql);
    $stmt->bindParam(':cliente_id', $id, PDO::PARAM_INT);
    $stmt->execute();
    $resultado = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($resultado['total'] > 0 && !$confirmar) {
    echo "<form method='POST'>";
    echo "<input type='hidden' name='excluir_id' value='{$id}'>";
    echo "<input type='hidden' name='excluir_usuario' value='1'>";
    echo "<input type='hidden' name='confirmar_exclusao_total' value='1'>";
    echo "<button type='submit'>Confirmar exclusão total</button>";
    echo "</form>";
    exit;
}

    if ($resultado['total'] > 0 && $confirmar) {
        $sql = "DELETE FROM Agendamentos WHERE cliente_id = :cliente_id";
        $stmt = $this->conexao->prepare($sql);
        $stmt->bindParam(':cliente_id', $id, PDO::PARAM_INT);
        $stmt->execute();
    }

    $sql = "DELETE FROM Clientes WHERE cliente_id = :cliente_id";
    $stmt = $this->conexao->prepare($sql);
    $stmt->bindParam(':cliente_id', $id, PDO::PARAM_INT);
    $stmt->execute();
}

public function buscarId($id)
{
    $sql = "SELECT * FROM Clientes WHERE cliente_id = :cliente_id";
    $stmt = $this->conexao->prepare($sql);
    $stmt->bindParam(':cliente_id', $id, PDO::PARAM_INT);
    $stmt->execute();
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

public function alterarUsuario($id, $nome, $telefone, $cpf, $email, $endereco, $estado_civil)
{
    $sql = "UPDATE Clientes SET nome = :nome, telefone = :telefone, cpf = :cpf, email = :email, endereco = :endereco, estado_civil = :estado_civil WHERE cliente_id = :id";
    $stmt = $this->conexao->prepare($sql);
    $stmt->bindParam(':id', $id, PDO::PARAM_INT);
    $stmt->bindParam(':nome', $nome);
    $stmt->bindParam(':telefone', $telefone);
    $stmt->bindParam(':cpf', $cpf);
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':endereco', $endereco);
    $stmt->bindParam(':estado_civil', $estado_civil);
    $stmt->execute();
}



}