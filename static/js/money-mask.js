/**
 * ABASE Money Mask - Solução unificada para máscaras monetárias BRL
 * Substitui o sistema TypeScript por JavaScript puro e otimizado
 *
 * Casos de uso suportados:
 * - Entrada manual: "400" → "R$ 400,00"
 * - Entrada com decimais: "400,50" → "R$ 400,50"
 * - Copiar/colar formatado: "R$ 1.234,56" → mantém valor correto
 * - Submit para backend: converte para "400.00" (formato americano)
 */

(function() {
    'use strict';

    // Formatador brasileiro para moeda
    const brlFormatter = new Intl.NumberFormat('pt-BR', {
        style: 'currency',
        currency: 'BRL',
        maximumFractionDigits: 2
    });

    /**
     * Converte qualquer string para número JavaScript válido
     * Suporta formatos: "400", "400,50", "1.234,56", "R$ 1.234,56"
     */
    function parseMoneyValue(value) {
        if (!value || value === '') return 0;

        // Converte para string e remove espaços
        let str = String(value).trim().replace(/\s+/g, '');

        // Remove símbolo R$
        str = str.replace(/R\$/, '');

        // Se não há vírgula, trata como número inteiro ou decimal americano
        if (!str.includes(',')) {
            // Remove pontos que são separadores de milhar
            // Mantém apenas o último ponto se for decimal (max 2 casas)
            const parts = str.split('.');
            if (parts.length === 2 && parts[1].length <= 2) {
                // Formato americano: 1234.56
                str = str;
            } else {
                // Separadores de milhar: 1.234 ou 1.234.567
                str = parts.join('');
            }
        } else {
            // Formato brasileiro com vírgula
            const parts = str.split(',');
            if (parts.length === 2) {
                // Remove pontos da parte inteira (separadores de milhar)
                const integerPart = parts[0].replace(/\./g, '');
                const decimalPart = parts[1];
                str = integerPart + '.' + decimalPart;
            }
        }

        const num = parseFloat(str);
        return isNaN(num) ? 0 : num;
    }

    /**
     * Formata número para display brasileiro: R$ 1.234,56
     */
    function formatToBRL(value) {
        const num = typeof value === 'number' ? value : parseMoneyValue(value);
        return brlFormatter.format(num);
    }

    /**
     * Converte para formato de edição: número puro ou com vírgula
     */
    function formatForEditing(value) {
        const num = typeof value === 'number' ? value : parseMoneyValue(value);

        if (num === 0) return '';

        // Se é inteiro, mostra sem decimais
        if (Number.isInteger(num)) {
            return String(num);
        }

        // Se tem decimais, usa vírgula brasileira
        return num.toFixed(2).replace('.', ',');
    }

    /**
     * Converte para formato backend: 1234.56
     */
    function formatForBackend(value) {
        const num = typeof value === 'number' ? value : parseMoneyValue(value);
        return num.toFixed(2);
    }

    /**
     * Inicializa máscara em campo específico
     */
    function initializeField(input) {
        if (input.dataset.moneyInitialized) return;
        input.dataset.moneyInitialized = 'true';

        // Configura inputmode para teclado numérico no mobile
        input.setAttribute('inputmode', 'decimal');

        // Se tem valor inicial, formata
        if (input.value && /\d/.test(input.value)) {
            input.value = formatToBRL(input.value);
        }

        // Evento focus: mostra formato editável
        input.addEventListener('focus', function() {
            const value = parseMoneyValue(this.value);
            this.value = formatForEditing(value);
        });

        // Evento blur: formata para display
        input.addEventListener('blur', function() {
            const value = parseMoneyValue(this.value);
            this.value = formatToBRL(value);

            // Dispara evento personalizado para recálculos
            this.dispatchEvent(new CustomEvent('money-changed', {
                detail: { value: value, formatted: this.value }
            }));
        });
    }

    /**
     * Inicializa todas as máscaras monetárias na página
     */
    function initializeMoneyMasks() {
        const fields = document.querySelectorAll('input[data-money="brl"]');
        fields.forEach(initializeField);

        // Encontra formulários e adiciona handler de submit
        const forms = document.querySelectorAll('form');
        forms.forEach(function(form) {
            if (form.dataset.moneyFormInitialized) return;
            form.dataset.moneyFormInitialized = 'true';

            form.addEventListener('submit', function() {
                // Converte todos os campos monetários para formato backend
                const moneyFields = this.querySelectorAll('input[data-money="brl"]');
                moneyFields.forEach(function(field) {
                    const value = parseMoneyValue(field.value);
                    field.value = formatForBackend(value);
                });
            });
        });

        // Formatar textos estáticos com data-money-text
        const staticElements = document.querySelectorAll('[data-money-text]');
        staticElements.forEach(function(element) {
            if (element.dataset.moneyTextInitialized) return;
            element.dataset.moneyTextInitialized = 'true';

            const value = parseMoneyValue(element.textContent || element.dataset.moneyText);
            element.textContent = formatToBRL(value);
        });
    }

    // API pública
    window.ABASE = window.ABASE || {};
    window.ABASE.MoneyMask = {
        parse: parseMoneyValue,
        formatBRL: formatToBRL,
        formatEdit: formatForEditing,
        formatBackend: formatForBackend,
        initialize: initializeMoneyMasks,
        initField: initializeField
    };

    // Auto-inicialização
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeMoneyMasks);
    } else {
        initializeMoneyMasks();
    }

    // Para compatibilidade com sistemas dinâmicos (HTMX, etc)
    document.addEventListener('htmx:afterSwap', initializeMoneyMasks);

})();