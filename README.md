# Projeto TP01 – Integração de Dados Clínicos (KNIME)

## Autor
**Nome:** Carolina Macedo Branco 

**Número de Aluno:** 27983

**Unidade Curricular:** Integração de Sistemas de Informação (ISI)

**Ferramenta Utilizada:** KNIME


---

## Descrição Geral

Este projeto corresponde ao **Trabalho Prático 01** da unidade curricular **Integração de Sistemas de Informação (ESI-ISI)**.  
O objetivo consiste no desenvolvimento de um processo **ETL (Extract, Transform, Load)** em **KNIME**, aplicado ao contexto da **integração de dados clínicos** provenientes de múltiplas fontes.

O processo integra, transforma e carrega dados de **marcações de consultas médicas (XML)** e **resultados laboratoriais (CSV)** para uma base de dados **Microsoft SQL Server**, assegurando a validação, anonimização e consistência dos registos.  

O trabalho inclui também:
- **Simulação de comunicação com uma API externa (HTTP POST)**;  
- **Envio automático de notificações por e-mail**;   
- **Separação de registos rejeitados e aceites**.  

---

### **Etapas Principais:**

1. **Extração:**  
   Leitura dos ficheiros de entrada localizados em `data/input/`, nomeadamente:  
   - `consultas.xml` → dados de marcações de consultas médicas.  
   - `exames.csv` → resultados laboratoriais.  
   A extração foi realizada através dos nós **XML Reader**, **XPath** e **CSV Reader**.

2. **Transformação:**  
   Tratamento e normalização dos dados, incluindo:  
   - Limpeza e normalização de colunas (uso de `String Manipulation` e `Column Expressions`).  
   - Validação de campos com **expressões regulares** (NIF, telefone, e-mail).  
   - Filtragem de registos inválidos, exportando-os para `data/output/rejeitados.csv`. 
   - Junção das tabelas de consultas e exames (`Joiner`) por `id_paciente`. 
   - Anonimização de dados sensíveis (nome, e-mail, NIF) com **hash SHA-256** através do nó `Java Snippet`.  

3. **Armazenamento:**  
   Armazenamento dos dados válidos e anonimizados na base de dados **Microsoft SQL Server** utilizando os nós:  
   - `DB Connector`  
   - `DB Table Creator`  
   - `DB Writer`  
   A tabela final (`paciente_eventos`) contém a informação consolidada para posterior análise.

4. **Notificações Automáticas:**  
   Envio de e-mails personalizados a pacientes com resultados laboratoriais disponíveis.  
   Implementado com os nós:  
   - `Row Filter` (seleção dos destinatários)  
   - `Table Row to Variable Loop Start`  
   - `Send Email` (SMTP Gmail com App Password)  
   - `Variable Loop End`  
   Os e-mails incluem o tipo de exame, resultado e data.

5. **Exportação JSON:**  
   A tabela final `paciente_eventos` é exportada em formato **JSON** para `data/output/row1.json`,  
   permitindo a partilha estruturada dos dados com sistemas externos ou simulação de integração via API.


---

## 📂 Estrutura do Projeto

tp01_27983/
│
├── README.md → Ficheiro de descrição do projeto 
│
├── doc/
| ├── Dashboard → Graficos dos dados SQL
│ └── 27964_27983_doc.pdf → Documento do relatório do trabalho 
│
├── dataint/
│ ├── consultas_exames/ → Workflow principal desenvolvido em KNIME (processo ETL completo)
│ └── email/ → Workflow responsável pelo envio automático de notificações por e-mail
│
├── data/
│ ├── input/ → Ficheiros de entrada (dados originais)
│ │ ├── consultas.xml → Dados de marcações de consultas médicas
│ │ └── exames.csv → Dados de resultados laboratoriais
│ │
│ ├── output/ → Ficheiros de saída gerados pelo processo ETL
│ │ ├── aceites/ → Registos aceites (dados validados e integrados)
│ │ ├── rejeitados/ → Registos inválidos exportados (rejeitados.csv)
│ │ ├── logs/ → Ficheiro de log de execução (etl.log)
│ │ └── row1/ → Exportação da tabela final paciente_eventos em formato JSON
│ │
│ └── tables/ → Dados auxiliares utilizados no envio de notificações
│ └── email_table.csv → Tabela com informação para envio de e-mails a pacientes
│
├── src/
│ ├── TabelaPacienteEventos.sql/ → Contém o *script* SQL para **criar a tabela `paciente_eventos`**.
| └── PacienteEventos.sql/ → Contém o *script* SQL para **consultar e obter todos os dados** da tabela `paciente_eventos`

---

### Descrição Resumida dos Diretórios

| Diretório | Descrição |
|------------|------------|
| **doc/** | Contém o relatório completo do trabalho.|
| **dataint/** | Diretório com os workflows KNIME do projeto: `consulta_exames` (processo ETL principal) e `email` (envio automático de notificações).|
| **data/input/** | Ficheiros originais de dados - consultas (XML) e exames (CSV). |
| **data/output/** | Resultados finais do processo ETL, incluindo dados aceites, rejeitados. |
| **data/output/aceites/** | Contém o ficheiro com registos válidos (`aceites.csv`). |
| **data/output/rejeitados/** | Armazena registos rejeitados durante a validação (`rejeitados.csv`). |
| **data/output/logs/** | Ficheiro `etl.log` com registo cronológico da execução do processo. |
| **data/output/row1/** | Exportação da tabela consolidada `paciente_eventos` em formato JSON (`row1.json`). |
| **data/tables/** | Dados auxiliares para envio de e-mails, incluindo `email_table.csv`. |
| **src** | Contém os scripts SQL para a criação e consulta da estrutura da base de dados, como `TabelaPacienteEventos.sql` e `PacienteEventos.sql`.

---

### 📑 Observações

- O **workflow principal** (`consulta_exames/`) realiza todas as etapas ETL: extração, transformação, validação, anonimização e armazenamento dos dados.  
- O **workflow `email/`** é responsável pelo envio automático de notificações personalizadas a pacientes com resultados disponíveis.    
- A exportação **`row1.json`** contém a tabela final `paciente_eventos`, permitindo a partilha estruturada dos dados com sistemas externos ou APIs.  
- As pastas **`aceites/`** e **`rejeitados/`** distinguem claramente os registos válidos dos inválidos.  
- A pasta **`tables/`** fornece os dados auxiliares necessários ao envio automatizado de e-mails.  

---

## Como Executar a Solução

### 1. Pré-requisitos e Ferramentas:
- Ter instalado o **KNIME**  
- Ter o SQL server instalado, e a base de dados devidamente criada e configurada 

### 2. Execução no KNIME:
1. Abrir o **KNIME**.
2. Ir a **Local Space** e abrir a pasta tp01_27983.
3. Abrir a pasta dataint que contem consultas_exames e email.
4. Verificar os caminhos relativos das entradas e saídas:
- Entrada: `data/input/`
- Saída: `data/output/`
5. Executar o workflow ao carregar no botão **Execute all**.
6. Após a execução, verificar os ficheiros gerados em `data/output/`.

### 3. Confuguração da Base de Dados:

Antes de executar, deve garantir que a base de dados e tabela de destino está criada:

1.  Navegue para a pasta `src/` dentro do repositório.
2.  Execute o código presente em **`TabelaPacienteEventos.sql`** na sua base de dados SQL.
3.  Para confirmar que a sua tabela foi armazenada corretamenta na base de dados execute o código presente em **`PacienteEventos.sql`** na sua base de dados SQL.


---
## Video
- https://qrto.org/OhMyFD

---

## 🧑‍💻 Observações Finais
- Todos os caminhos de ficheiros foram configurados de forma **relativa**, facilitando a portabilidade do projeto.   
- O ficheiro PDF na pasta `doc/` contém explicações detalhadas do processo, fluxos e prints das transformações realizadas.
- A funcionalidade de registo de logs não foi implementada nos workflows, apesar da existência da pasta `logs/`.
---

📅 **Data:** Outubro de 2025