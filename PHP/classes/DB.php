<?php
declare(strict_types=1);

class Database {
    protected PDO $conexao;

    public function __construct(
        private string $host = 'localhost',
        private string $dbname = 'advocaciadb',
        private string $usuario_db = 'root',
        private string $senha_db = ''
    ) {
        $this->conectar();
    }

    private function conectar(): void {
        try {
            $this->conexao = new PDO(
                "mysql:host={$this->host};dbname={$this->dbname}",
                $this->usuario_db,
                $this->senha_db
            );
            $this->conexao->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            die("Erro de conexão: " . $e->getMessage());
        }
    }
}
