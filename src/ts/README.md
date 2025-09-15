# Módulo de Máscara BRL (Blur-Only)

Módulo TypeScript para formatação de valores monetários em Real Brasileiro (BRL) com abordagem "blur-only".

## Características

- **Blur-Only**: Não reformata durante a digitação, evitando problemas de cursor
- **Foco inteligente**: Remove formatação ao focar para edição fácil
- **Formatação automática**: Aplica "R$ X.XXX,YY" ao sair do campo
- **Submit transparente**: Converte automaticamente para formato backend ("1234.56")
- **Textos estáticos**: Formata elementos de exibição automaticamente

## Como Usar

### 1. Campos de Input

Adicione o atributo `data-money="brl"` aos inputs de dinheiro:

```html
<input 
  type="text" 
  name="valor" 
  data-money="brl"
  placeholder="Digite um valor"
>
```

### 2. Textos Estáticos

Para formatar valores já existentes em spans, divs, etc:

```html
<span data-brl-text>1234.56</span>
<!-- Será exibido como: R$ 1.234,56 -->
```

### 3. Formulários

O módulo automaticamente:
- Detecta todos os formulários da página
- Converte valores para formato backend antes do submit
- Não requer configuração adicional

```html
<form>
  <input name="salario" data-money="brl">
  <input name="desconto" data-money="brl">
  <button type="submit">Enviar</button>
  <!-- Valores serão enviados como "1234.56" -->
</form>
```

## Comportamento Detalhado

### Durante a Digitação
- ✅ Usuário digita livremente: "1234", "1234.5", "1234,56"
- ✅ Cursor permanece na posição correta
- ✅ Não há reformatação que interfira na experiência

### Ao Focar (Focus)
- Remove símbolos e separadores de milhar
- Mantém vírgula decimal se houver
- Exemplo: "R$ 1.234,56" → "1234,56"

### Ao Sair do Campo (Blur)
- Formata como moeda brasileira
- Exemplo: "1234.56" → "R$ 1.234,56"
- Armazena valor raw no dataset para submit

### No Submit
- Converte automaticamente para formato numérico
- Exemplo: "R$ 1.234,56" → "1234.56"
- Backend recebe string no formato correto

## Funções Principais

### `parseLoose(s: string): number`
Converte strings diversas para número JavaScript:
- "2.345,6" → 2345.6
- "2345.6" → 2345.6  
- "R$ 2.345,60" → 2345.6

### `toBRL(n: number): string`
Formata número como moeda brasileira:
- 1234.56 → "R$ 1.234,56"

### `bindMoneyInputs(): void`
Inicializa todos os campos marcados com `data-money="brl"`

## Reinicialização Dinâmica

Para páginas com conteúdo dinâmico (HTMX, Turbo, etc.):

```javascript
// Reinicializa após carregar novo conteúdo
window.ABASE.moneyMaskInit();
```

## Compilação

O módulo é escrito em TypeScript e compilado automaticamente:

```bash
npx tsc
```

Arquivo gerado: `static/build/ts/brl-money.js`

## Integração no Template

O script é automaticamente incluído no `base.html`:

```html
<script type="module" src="{% static 'build/ts/brl-money.js' %}" defer></script>
```

## Exemplo Completo

Veja o arquivo `templates/components/money_input_example.html` para exemplos práticos de uso.

## Vantagens da Abordagem Blur-Only

1. **UX Superior**: Não interfere durante a digitação
2. **Cursor Estável**: Não há saltos ou reposicionamentos
3. **Flexibilidade**: Aceita diversos formatos de entrada
4. **Performance**: Menos processamento durante a digitação
5. **Compatibilidade**: Funciona bem com frameworks SPA

## Compatibilidade

- ✅ Navegadores modernos (ES2020+)
- ✅ Mobile (inputmode="decimal")
- ✅ Frameworks SPA (HTMX, Turbo, etc.)
- ✅ Formulários dinâmicos
- ✅ TypeScript/JavaScript