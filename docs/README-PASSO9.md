# Passo 9 — Exportação XLSX, PDFs, Notificações e Limpeza

## Entregas

### Exportações XLSX
- **Associados**: Exportação completa com filtros por status e órgão público
- **Síntese por Órgão Público**: Relatório consolidado por instituição

### PDFs (WeasyPrint)
- **Resumo Mensal**: Relatório de contribuições associativas por período
- **Síntese por Órgão Público**: Documento consolidado em formato PDF

### Sistema de Notificações
- **Notificações Internas**: Sistema robusto de notificações por usuário e papel
- **Linguagem Neutra**: Adequada para associação, sem termos de empréstimo
- **Estados Cobertos**:
  - Envio para avaliação
  - Pendências ao agente
  - Aprovado para efetivação
  - Efetivado
- **⚠️ Importante**: Sistema de notificações por e-mail foi **ocultado** conforme solicitação - apenas notificações internas estão ativas

### Limpeza Automática
- **`clean_rascunhos`**: Remove rascunhos de anexos com mais de 7 dias
- **Agendamento**: Script `.bat` para execução automática no Windows

## Rotas Implementadas

### Exportações
- `/exportar/associados.xlsx` - Exportação de cadastros de associados
- `/exportar/orgaos.xlsx` - Exportação de síntese por órgão público

### Relatórios PDF
- `/relatorios/pdf/resumo-mensal/?mes=MM&ano=AAAA` - Resumo mensal parametrizado
- `/relatorios/pdf/sintese-orgao/` - Síntese consolidada por órgão

## Ajustes de Linguagem Implementados

Para adequação à linguagem associativa:

| Termo Anterior | Termo Atual |
|---|---|
| Mensalidade | Contribuição Associativa |
| Parcela | Cota |
| Pagamento/Financeiro | Efetivação/Registro na Associação |
| Tesouraria | Secretaria |
| Mensalidades | Contribuições |

## Estrutura de Arquivos Criados

```
apps/
├── exportacao/          # App para exportações XLSX
│   ├── services.py      # Lógica de geração de planilhas
│   ├── views.py         # Views para download
│   └── urls.py          # Rotas de exportação
├── relatorios/          # App para relatórios PDF
│   ├── services.py      # Geração de PDFs com WeasyPrint
│   ├── templates/       # Templates HTML para PDF
│   └── views.py         # Views de relatórios
├── notificacoes/        # Sistema de notificações internas
│   ├── models.py        # Models de notificação
│   ├── service.py       # Lógica de envio
│   └── admin.py         # Interface administrativa
└── documentos/
    └── management/
        └── commands/
            └── clean_rascunhos.py  # Comando de limpeza

scripts/
└── clean_rascunhos.bat  # Script para agendamento Windows
```

## Dependências Instaladas

- **openpyxl**: Manipulação de planilhas Excel
- **weasyprint**: Geração de PDFs a partir de HTML/CSS

## Observações Técnicas

### PDF Local (Alternativa)
Para ambientes onde não é possível instalar WeasyPrint:
1. Acesse a versão HTML do relatório
2. Use "Imprimir → Salvar como PDF" do navegador
3. Resultado equivalente ao PDF gerado pelo sistema

### Limpeza Automática
- Comando: `python manage.py clean_rascunhos`
- Agendamento: Use o script `scripts/clean_rascunhos.bat`
- Frequência recomendada: Diária

### Sistema de Notificações
- **Apenas notificações internas** estão ativas
- Interface administrativa disponível em `/admin/notificacoes/`
- Notificações por papel (agente, avaliador, etc.)

## Comandos de Verificação

```bash
# Verificar sistema
python manage.py check

# Aplicar migrações
python manage.py migrate

# Executar limpeza manual
python manage.py clean_rascunhos

# Iniciar servidor
python manage.py runserver
```

## Status do Passo 9

✅ **Concluído** - Todas as funcionalidades implementadas e testadas

- [x] Exportações XLSX funcionais
- [x] Relatórios PDF com WeasyPrint
- [x] Sistema de notificações internas (e-mail ocultado)
- [x] Limpeza automática de rascunhos
- [x] Ajustes de linguagem associativa
- [x] Migrações aplicadas
- [x] Sistema verificado e operacional

---

**Próximos Passos**: O sistema está pronto para uso em produção com todas as melhorias do Passo 9 implementadas.