/**
 * ABASE ViaCEP Integration - Busca inteligente de CEP com edição permitida
 *
 * Funcionalidades:
 * - Busca automática ao digitar CEP completo
 * - Preenchimento inteligente dos campos de endereço
 * - Permite edição após preenchimento
 * - Feedback visual durante busca
 * - Tratamento de erros
 */

(function() {
    'use strict';

    let debounceTimer = null;

    /**
     * Normaliza CEP removendo caracteres não numéricos
     */
    function normalizeCep(cep) {
        return cep.replace(/\D/g, '');
    }

    /**
     * Valida se CEP tem formato correto
     */
    function isValidCep(cep) {
        const normalized = normalizeCep(cep);
        return normalized.length === 8 && /^\d{8}$/.test(normalized);
    }

    /**
     * Aplica máscara visual ao CEP
     */
    function maskCep(cep) {
        const normalized = normalizeCep(cep);
        if (normalized.length > 5) {
            return normalized.replace(/(\d{5})(\d)/, '$1-$2');
        }
        return normalized;
    }

    /**
     * Exibe estado de loading no campo CEP
     */
    function showCepLoading(cepField, loading = true) {
        const container = cepField.parentElement;
        let loadingElement = container.querySelector('.cep-loading');

        if (loading) {
            if (!loadingElement) {
                loadingElement = document.createElement('div');
                loadingElement.className = 'cep-loading absolute right-3 top-1/2 transform -translate-y-1/2';
                loadingElement.innerHTML = `
                    <div class="animate-spin rounded-full h-4 w-4 border-2 border-blue-500 border-t-transparent"></div>
                `;
                container.style.position = 'relative';
                container.appendChild(loadingElement);
            }
            cepField.style.paddingRight = '2.5rem';
        } else {
            if (loadingElement) {
                loadingElement.remove();
                cepField.style.paddingRight = '';
            }
        }
    }

    /**
     * Exibe feedback de resultado da busca
     */
    function showCepFeedback(cepField, type, message) {
        const container = cepField.parentElement;
        let feedbackElement = container.querySelector('.cep-feedback');

        // Remove feedback anterior
        if (feedbackElement) {
            feedbackElement.remove();
        }

        // Cria novo feedback se necessário
        if (message) {
            feedbackElement = document.createElement('div');
            feedbackElement.className = `cep-feedback text-xs mt-1 ${
                type === 'success' ? 'text-green-600' :
                type === 'error' ? 'text-red-600' : 'text-gray-500'
            }`;
            feedbackElement.textContent = message;
            container.appendChild(feedbackElement);

            // Remove automaticamente após 3 segundos para sucessos
            if (type === 'success') {
                setTimeout(() => {
                    if (feedbackElement && feedbackElement.parentElement) {
                        feedbackElement.remove();
                    }
                }, 3000);
            }
        }
    }

    /**
     * Busca dados do CEP na API ViaCEP
     */
    async function fetchCepData(cep) {
        const normalized = normalizeCep(cep);

        try {
            const response = await fetch(`https://viacep.com.br/ws/${normalized}/json/`);
            const data = await response.json();

            if (data.erro) {
                throw new Error('CEP não encontrado');
            }

            return {
                success: true,
                data: {
                    endereco: data.logradouro || '',
                    bairro: data.bairro || '',
                    cidade: data.localidade || '',
                    uf: data.uf || ''
                }
            };
        } catch (error) {
            return {
                success: false,
                error: error.message || 'Erro ao buscar CEP'
            };
        }
    }

    /**
     * Preenche campos de endereço
     */
    function fillAddressFields(data) {
        const fields = {
            endereco: document.querySelector('[name="endereco"]'),
            bairro: document.querySelector('[name="bairro"]'),
            cidade: document.querySelector('[name="cidade"]'),
            uf: document.querySelector('[name="uf"]')
        };

        Object.keys(fields).forEach(key => {
            const field = fields[key];
            if (field && data[key]) {
                // Só preenche se o campo estiver vazio
                if (!field.value.trim()) {
                    field.value = data[key];

                    // Adiciona efeito visual
                    field.style.backgroundColor = '#f0f9ff';
                    setTimeout(() => {
                        field.style.backgroundColor = '';
                    }, 1000);
                } else {
                    // Campo já tem valor - não sobrescreve
                    console.log(`Campo ${key} já preenchido, mantendo valor atual`);
                }
            }
        });
    }

    /**
     * Manipula busca de CEP
     */
    async function handleCepSearch(cepField) {
        const cep = cepField.value;

        if (!isValidCep(cep)) {
            showCepFeedback(cepField, 'info', '');
            return;
        }

        showCepLoading(cepField, true);
        showCepFeedback(cepField, 'info', 'Buscando CEP...');

        const result = await fetchCepData(cep);

        showCepLoading(cepField, false);

        if (result.success) {
            fillAddressFields(result.data);
            showCepFeedback(cepField, 'success', 'CEP encontrado! Campos preenchidos automaticamente.');
        } else {
            showCepFeedback(cepField, 'error', result.error + '. Preencha manualmente.');
        }
    }

    /**
     * Inicializa integração ViaCEP
     */
    function initializeViaCep() {
        const cepField = document.querySelector('[name="cep"]');

        if (!cepField) return;

        // Aplica máscara durante digitação
        cepField.addEventListener('input', function(e) {
            this.value = maskCep(this.value);
        });

        // Busca CEP com debounce
        cepField.addEventListener('input', function(e) {
            clearTimeout(debounceTimer);

            debounceTimer = setTimeout(() => {
                handleCepSearch(this);
            }, 500); // Aguarda 500ms após parar de digitar
        });

        // Busca também no blur (quando sai do campo)
        cepField.addEventListener('blur', function(e) {
            clearTimeout(debounceTimer);

            if (isValidCep(this.value)) {
                handleCepSearch(this);
            }
        });

        // Limpa feedback ao focar novamente
        cepField.addEventListener('focus', function(e) {
            const feedback = this.parentElement.querySelector('.cep-feedback');
            if (feedback && feedback.classList.contains('text-green-600')) {
                feedback.remove();
            }
        });
    }

    // API pública
    window.ABASE = window.ABASE || {};
    window.ABASE.ViaCep = {
        initialize: initializeViaCep,
        search: handleCepSearch,
        mask: maskCep,
        validate: isValidCep
    };

    // Auto-inicialização
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeViaCep);
    } else {
        initializeViaCep();
    }

    // Para compatibilidade com sistemas dinâmicos (HTMX, etc)
    document.addEventListener('htmx:afterSwap', initializeViaCep);

})();