/**
 * ABASE Form Validation - Validações em tempo real e melhorias de UX
 *
 * Funcionalidades:
 * - Validação de PIX por tipo
 * - Feedback visual para campos obrigatórios
 * - Tooltips informativos
 * - Indicadores de progresso
 */

(function() {
    'use strict';

    /**
     * Validadores específicos por tipo de chave PIX
     */
    const pixValidators = {
        CPF: function(value) {
            const cleaned = value.replace(/\D/g, '');
            return cleaned.length === 11 && /^\d{11}$/.test(cleaned);
        },

        CNPJ: function(value) {
            const cleaned = value.replace(/\D/g, '');
            return cleaned.length === 14 && /^\d{14}$/.test(cleaned);
        },

        EMAIL: function(value) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(value);
        },

        TELEFONE: function(value) {
            const cleaned = value.replace(/\D/g, '');
            return cleaned.length >= 10 && cleaned.length <= 11 && /^\d+$/.test(cleaned);
        },

        ALEATORIA: function(value) {
            // UUID padrão do PIX ou chave aleatória
            return value.length >= 32 && /^[a-f0-9-]+$/i.test(value);
        }
    };

    /**
     * Placeholders específicos por tipo de PIX
     */
    const pixPlaceholders = {
        CPF: "000.000.000-00",
        CNPJ: "00.000.000/0000-00",
        EMAIL: "usuario@email.com",
        TELEFONE: "(11) 99999-9999",
        ALEATORIA: "chave-uuid-aleatoria"
    };

    /**
     * Dicas específicas por tipo de PIX
     */
    const pixHints = {
        CPF: "Digite o CPF do associado (mesmo usado na identificação)",
        CNPJ: "Digite o CNPJ da empresa/organização",
        EMAIL: "Digite o e-mail cadastrado como chave PIX",
        TELEFONE: "Digite o telefone com DDD cadastrado como chave PIX",
        ALEATORIA: "Digite a chave aleatória gerada pelo banco"
    };

    /**
     * Mostra feedback de validação
     */
    function showFieldFeedback(field, type, message) {
        const container = field.parentElement;
        let feedback = container.querySelector('.field-feedback');

        // Remove feedback anterior
        if (feedback) {
            feedback.remove();
        }

        // Adiciona novo feedback se necessário
        if (message) {
            feedback = document.createElement('div');
            feedback.className = `field-feedback text-xs mt-1 ${
                type === 'success' ? 'text-green-600' :
                type === 'error' ? 'text-red-600' : 'text-gray-500'
            }`;
            feedback.textContent = message;
            container.appendChild(feedback);

            // Atualiza visual do campo
            field.classList.remove('border-gray-200', 'border-green-500', 'border-red-500');
            if (type === 'success') {
                field.classList.add('border-green-500');
            } else if (type === 'error') {
                field.classList.add('border-red-500');
            } else {
                field.classList.add('border-gray-200');
            }
        }
    }

    /**
     * Valida chave PIX baseada no tipo selecionado
     */
    function validatePixKey() {
        const tipoField = document.querySelector('[name="tipo_chave_pix"]');
        const chaveField = document.querySelector('[name="chave_pix"]');

        if (!tipoField || !chaveField) return;

        const tipo = tipoField.value;
        const chave = chaveField.value;

        // Atualiza placeholder e hint
        if (tipo && pixPlaceholders[tipo]) {
            chaveField.placeholder = pixPlaceholders[tipo];

            // Atualiza hint
            const hintElement = chaveField.parentElement.querySelector('p');
            if (hintElement) {
                hintElement.innerHTML = `💡 ${pixHints[tipo]}`;
            }
        }

        // Valida se ambos os campos estão preenchidos
        if (!tipo || !chave) {
            showFieldFeedback(chaveField, 'info', '');
            return;
        }

        // Aplica validação específica
        const validator = pixValidators[tipo];
        if (validator) {
            const isValid = validator(chave);

            if (isValid) {
                showFieldFeedback(chaveField, 'success', '✓ Chave PIX válida');
            } else {
                showFieldFeedback(chaveField, 'error', `Formato inválido para ${tipo}`);
            }
        }
    }

    /**
     * Adiciona indicadores visuais para campos obrigatórios
     */
    function highlightRequiredFields() {
        const requiredFields = document.querySelectorAll('[required]');

        requiredFields.forEach(field => {
            const label = document.querySelector(`label[for="${field.id}"]`);
            if (label && !label.classList.contains('required-field')) {
                label.classList.add('required-field');
            }
        });
    }

    /**
     * Adiciona tooltip para explicar formato esperado
     */
    function addTooltips() {
        const fieldsWithTooltips = [
            {
                selector: '[name="matricula_servidor"]',
                text: 'Digite apenas números da matrícula funcional'
            },
            {
                selector: '[name="valor_bruto_total"]',
                text: 'Valor total bruto conforme contra-cheque'
            },
            {
                selector: '[name="valor_liquido"]',
                text: 'Valor líquido descontando impostos e contribuições'
            }
        ];

        fieldsWithTooltips.forEach(item => {
            const field = document.querySelector(item.selector);
            if (field) {
                field.setAttribute('title', item.text);
                field.style.cursor = 'help';
            }
        });
    }

    /**
     * Verifica se deve mostrar barra de progresso
     */
    function shouldShowProgressBar() {
        // Verifica se é a página de cadastro de associado
        const isNewCadastroPage = window.location.pathname.includes('/cadastros/novo/');
        const isEditCadastroPage = window.location.pathname.includes('/cadastros/') && window.location.search.includes('edit=');
        const hasFormWithManyFields = document.querySelectorAll('input, select, textarea').length > 15;

        return (isNewCadastroPage || isEditCadastroPage) && hasFormWithManyFields;
    }

    /**
     * Calcula e exibe progresso do preenchimento com barra flutuante
     */
    function updateFormProgress() {
        if (!shouldShowProgressBar()) {
            return;
        }

        // Contar todos os campos (não só obrigatórios)
        const allFields = document.querySelectorAll('input:not([type="hidden"]), select, textarea');
        const filledFields = Array.from(allFields).filter(field => {
            if (field.type === 'checkbox' || field.type === 'radio') {
                return field.checked;
            }
            return field.value.trim() !== '';
        });

        const progress = Math.round((filledFields.length / allFields.length) * 100);

        let progressBar = document.querySelector('.form-progress');
        if (!progressBar) {
            // Cria barra de progresso flutuante
            progressBar = document.createElement('div');
            progressBar.className = 'form-progress fixed top-0 left-0 right-0 z-50 bg-white shadow-md border-b transition-all duration-300';
            progressBar.style.transform = 'translateY(-100%)';
            progressBar.innerHTML = `
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-3">
                    <div class="flex items-center justify-between mb-2">
                        <div class="flex items-center space-x-3">
                            <svg class="w-5 h-5 text-red-600" fill="currentColor" viewBox="0 0 20 20">
                                <path fill-rule="evenodd" d="M3 4a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm0 4a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm0 4a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z"/>
                            </svg>
                            <span class="text-sm font-medium text-gray-900">Progresso do Formulário</span>
                        </div>
                        <span class="text-sm font-semibold text-red-600"><span class="progress-percent">${progress}</span>%</span>
                    </div>
                    <div class="w-full bg-gray-200 rounded-full h-2.5">
                        <div class="progress-bar bg-gradient-to-r from-red-500 to-red-600 h-2.5 rounded-full transition-all duration-500" style="width: ${progress}%"></div>
                    </div>
                    <div class="text-xs text-gray-600 mt-2 flex justify-between">
                        <span><span class="filled-count">${filledFields.length}</span> de ${allFields.length} campos preenchidos</span>
                        <span class="progress-message">${progress === 100 ? '✓ Formulário completo!' : `${allFields.length - filledFields.length} campos restantes`}</span>
                    </div>
                </div>
            `;

            document.body.appendChild(progressBar);

            // Controla visibilidade durante scroll
            let scrollTimeout;
            window.addEventListener('scroll', function() {
                clearTimeout(scrollTimeout);

                if (window.scrollY > 100) {
                    progressBar.style.transform = 'translateY(0)';
                } else {
                    progressBar.style.transform = 'translateY(-100%)';
                }

                // Auto-hide após 3 segundos sem scroll
                scrollTimeout = setTimeout(() => {
                    if (window.scrollY > 100 && progress < 100) {
                        progressBar.style.transform = 'translateY(-100%)';
                    }
                }, 3000);
            });
        } else {
            // Atualiza barra existente
            progressBar.querySelector('.progress-percent').textContent = progress;
            progressBar.querySelector('.progress-bar').style.width = `${progress}%`;
            progressBar.querySelector('.filled-count').textContent = filledFields.length;

            const progressMessage = progressBar.querySelector('.progress-message');
            if (progressMessage) {
                progressMessage.textContent = progress === 100 ? '✓ Formulário completo!' : `${allFields.length - filledFields.length} campos restantes`;
                progressMessage.className = progress === 100 ? 'text-green-600 font-medium' : 'text-gray-600';
            }
        }
    }

    /**
     * Inicializa validações
     */
    function initializeValidation() {
        // Validação PIX
        const tipoPixField = document.querySelector('[name="tipo_chave_pix"]');
        const chavePixField = document.querySelector('[name="chave_pix"]');

        if (tipoPixField) {
            tipoPixField.addEventListener('change', validatePixKey);
        }

        if (chavePixField) {
            chavePixField.addEventListener('input', validatePixKey);
            chavePixField.addEventListener('blur', validatePixKey);
        }

        // Campos obrigatórios
        highlightRequiredFields();

        // Tooltips
        addTooltips();

        // Progresso inicial
        updateFormProgress();

        // Atualiza progresso quando campos mudam
        const allFields = document.querySelectorAll('input, select, textarea');
        allFields.forEach(field => {
            field.addEventListener('input', updateFormProgress);
            field.addEventListener('change', updateFormProgress);
        });

        // Validação inicial PIX
        validatePixKey();
    }

    // API pública
    window.ABASE = window.ABASE || {};
    window.ABASE.FormValidation = {
        initialize: initializeValidation,
        validatePix: validatePixKey,
        updateProgress: updateFormProgress
    };

    // Auto-inicialização
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeValidation);
    } else {
        initializeValidation();
    }

    // Para sistemas dinâmicos
    document.addEventListener('htmx:afterSwap', initializeValidation);

})();