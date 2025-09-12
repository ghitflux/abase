# Scripts do Sistema ABASE

**Data de criação:** 12 de setembro de 2025  
**Versão:** 1.0  

## Visão Geral

Esta pasta contém scripts utilitários para manutenção e operação do sistema ABASE. Todos os scripts foram criados para facilitar tarefas administrativas e de desenvolvimento.

## Scripts Disponíveis

### 1. clean_rascunhos.bat
**Tipo:** Script em lote (Windows)  
**Função:** Limpeza de arquivos temporários e rascunhos  
**Uso:** Execute diretamente no Windows  

```batch
clean_rascunhos.bat
```

### 2. git_manager.py
**Tipo:** Script Python  
**Função:** Gerenciamento automatizado do repositório Git  
**Recursos:**
- Verificação de status do repositório
- Commit automatizado
- Push para repositório remoto
- Backup de alterações

**Uso:**
```python
python git_manager.py
```

### 3. test_runner.py
**Tipo:** Script Python  
**Função:** Execução automatizada de testes do sistema  
**Recursos:**
- Execução de testes unitários
- Geração de relatórios
- Validação de integridade do sistema

**Uso:**
```python
python test_runner.py
```

## Dependências

### Para scripts Python:
- Python 3.8+
- Django (instalado no ambiente virtual)
- Dependências do projeto (requirements.txt)

### Para scripts em lote:
- Windows OS
- Permissões de execução

## Estrutura de Arquivos

```
scripts/
├── clean_rascunhos.bat     # Limpeza de arquivos temporários
├── git_manager.py          # Gerenciamento Git
├── test_runner.py          # Execução de testes
└── README_SCRIPTS.md       # Esta documentação
```

## Boas Práticas

1. **Backup:** Sempre faça backup antes de executar scripts de limpeza
2. **Testes:** Execute em ambiente de desenvolvimento primeiro
3. **Logs:** Verifique logs de execução para identificar problemas
4. **Permissões:** Certifique-se de ter permissões adequadas

## Manutenção

- **Frequência de uso:** Conforme necessário
- **Atualizações:** Verificar compatibilidade com novas versões
- **Monitoramento:** Acompanhar logs de execução

## Contato

Para dúvidas sobre os scripts, consulte a documentação principal do projeto ou entre em contato com a equipe de desenvolvimento.

---

**Nota:** Todos os scripts foram testados no ambiente de desenvolvimento. Use com cautela em produção.