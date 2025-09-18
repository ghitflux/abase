/**
 * Modal de Confirmação - Sistema global de confirmação de ações
 */

let confirmationCallback = null;

/**
 * Abre o modal de confirmação
 * @param {string} title - Título do modal
 * @param {string} message - Mensagem de confirmação
 * @param {Function} callback - Função a ser executada na confirmação
 * @param {string} actionText - Texto do botão de ação (padrão: "Confirmar")
 * @param {string} iconColor - Cor do ícone (padrão: vermelho para alertas)
 */
function showConfirmationModal(title = 'Confirmar ação', message = 'Tem certeza que deseja realizar esta ação?', callback = null, actionText = 'Confirmar', iconColor = '#ef4444') {
    const modal = document.getElementById('confirmation-modal');
    const titleElement = document.getElementById('confirmation-title');
    const messageElement = document.getElementById('confirmation-message');
    const actionButton = document.getElementById('confirmation-action');
    const iconElement = document.querySelector('#confirmation-icon img');
    
    if (!modal || !titleElement || !messageElement || !actionButton) {
        console.error('Elementos do modal de confirmação não encontrados');
        return;
    }
    
    // Configurar conteúdo
    titleElement.textContent = title;
    messageElement.textContent = message;
    actionButton.textContent = actionText;
    
    // Configurar cor do ícone
    if (iconElement) {
        iconElement.style.stroke = iconColor;
    }
    
    // Armazenar callback
    confirmationCallback = callback;
    
    // Mostrar modal
    modal.classList.remove('hidden');
    
    // Focar no botão de cancelar por segurança
    const cancelButton = modal.querySelector('button[onclick="closeConfirmationModal()"]');
    if (cancelButton) {
        cancelButton.focus();
    }
}

/**
 * Fecha o modal de confirmação
 */
function closeConfirmationModal() {
    const modal = document.getElementById('confirmation-modal');
    if (modal) {
        modal.classList.add('hidden');
    }
    confirmationCallback = null;
}

/**
 * Executa a ação confirmada
 */
function confirmAction() {
    if (confirmationCallback && typeof confirmationCallback === 'function') {
        confirmationCallback();
    }
    closeConfirmationModal();
}

// Fechar modal com ESC
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeConfirmationModal();
    }
});

// Fechar modal clicando no backdrop
document.addEventListener('click', function(event) {
    const modal = document.getElementById('confirmation-modal');
    if (event.target === modal) {
        closeConfirmationModal();
    }
});

// Exportar funções para uso global
window.showConfirmationModal = showConfirmationModal;
window.closeConfirmationModal = closeConfirmationModal;
window.confirmAction = confirmAction;