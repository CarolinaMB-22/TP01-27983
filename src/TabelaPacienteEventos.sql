CREATE TABLE paciente_eventos (
  id_paciente NVARCHAR(50),
  nome_hash NVARCHAR(64),
  nif_hash NVARCHAR(64),
  telefone NVARCHAR(20),
  email_hash NVARCHAR(64),
  data_consulta DATE,
  especialidade NVARCHAR(100),
  tipo_exame NVARCHAR(100),
  resultado NVARCHAR(50),
  data_exame DATE
);
