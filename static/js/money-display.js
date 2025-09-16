/**
 * ABASE Money Display - Formatação de valores monetários para exibição
 *
 * Funcionalidades:
 * - Formatar valores numéricos como moeda brasileira (R$)
 * - Aplicar formatação em elementos com data-brl-text
 * - Detectar valores decimais e inteiros automaticamente
 */

(function() {
    'use strict';

    /**
     * Formata um valor numérico como moeda brasileira
     * @param {number|string} value - Valor a ser formatado
     * @returns {string} Valor formatado como R$ X.XXX,XX
     */
    function formatBRL(value) {
        if (!value && value !== 0) return 'R$ 0,00';

        // Converter para número se for string
        let numValue = typeof value === 'string' ? parseFloat(value) : value;

        // Verificar se é um número válido
        if (isNaN(numValue)) return 'R$ 0,00';

        // Formatar com Intl.NumberFormat para padrão brasileiro
        return numValue.toLocaleString('pt-BR', {
            style: 'currency',
            currency: 'BRL',
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        });
    }

    /**
     * Detecta o tipo de valor e formata adequadamente
     * @param {string} rawValue - Valor bruto do elemento
     * @returns {string} Valor formatado
     */
    function detectAndFormat(rawValue) {
        if (!rawValue || rawValue.trim() === '') return 'R$ 0,00';

        // Remove espaços em branco
        let cleanValue = rawValue.trim();

        // Se já contém R$, retorna como está
        if (cleanValue.includes('R$')) {
            return cleanValue;
        }

        // Tenta converter para número
        let numValue = parseFloat(cleanValue.replace(',', '.'));

        // Se não conseguiu converter, tenta remover pontos como separadores de milhares
        if (isNaN(numValue)) {
            // Remove pontos que podem ser separadores de milhares e converte vírgulas para pontos
            cleanValue = cleanValue.replace(/\./g, '').replace(',', '.');
            numValue = parseFloat(cleanValue);
        }

        return formatBRL(numValue);
    }

    /**
     * Aplica formatação monetária em todos os elementos com data-brl-text
     */
    function applyMoneyFormatting() {
        const elements = document.querySelectorAll('[data-brl-text]');

        elements.forEach(element => {
            const rawValue = element.textContent || element.innerText;
            const formattedValue = detectAndFormat(rawValue);

            // Atualiza o conteúdo do elemento
            element.textContent = formattedValue;

            // Adiciona classe para estilização visual
            element.classList.add('money-formatted');
        });
    }

    /**
     * Aplica formatação em elementos específicos por seletor
     * @param {string} selector - Seletor CSS
     */
    function formatMoneyBySelector(selector) {
        const elements = document.querySelectorAll(selector);

        elements.forEach(element => {
            const rawValue = element.textContent || element.innerText;
            const formattedValue = detectAndFormat(rawValue);
            element.textContent = formattedValue;
            element.classList.add('money-formatted');
        });
    }

    /**
     * Observer para aplicar formatação em conteúdo dinâmico
     */
    function setupMutationObserver() {
        const observer = new MutationObserver(function(mutations) {
            let shouldReformat = false;

            mutations.forEach(function(mutation) {
                if (mutation.type === 'childList' || mutation.type === 'subtree') {
                    const addedNodes = Array.from(mutation.addedNodes);

                    // Verifica se algum nó adicionado contém elementos com data-brl-text
                    addedNodes.forEach(node => {
                        if (node.nodeType === Node.ELEMENT_NODE) {
                            if (node.querySelector && node.querySelector('[data-brl-text]')) {
                                shouldReformat = true;
                            }
                        }
                    });
                }
            });

            if (shouldReformat) {
                setTimeout(applyMoneyFormatting, 100); // Pequeno delay para garantir renderização
            }
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
    }

    /**
     * Inicializa o sistema de formatação monetária
     */
    function initializeMoneyDisplay() {
        // Aplicar formatação inicial
        applyMoneyFormatting();

        // Configurar observer para conteúdo dinâmico
        setupMutationObserver();

        // Reprocessar após eventos HTMX
        document.addEventListener('htmx:afterSwap', applyMoneyFormatting);
        document.addEventListener('htmx:afterSettle', applyMoneyFormatting);
    }

    // API pública
    window.ABASE = window.ABASE || {};
    window.ABASE.MoneyDisplay = {
        format: formatBRL,
        formatBRL: formatBRL,
        detectAndFormat: detectAndFormat,
        applyFormatting: applyMoneyFormatting,
        formatBySelector: formatMoneyBySelector,
        initialize: initializeMoneyDisplay
    };

    // Auto-inicialização
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeMoneyDisplay);
    } else {
        initializeMoneyDisplay();
    }

})();