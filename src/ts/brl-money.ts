/**
 * Máscara BRL robusta em TypeScript (sem libs).
 * - Input: digitação livre → exibe "R$ 5.000,00"
 * - Submit: converte para "1234.56" (string) para o backend
 * - Exibição: elementos com [data-brl-text] são formatados em "R$ X.XXX,YY"
 */

type MoneyInput = HTMLInputElement & { dataset: DOMStringMap };

const BRL = new Intl.NumberFormat("pt-BR", { style: "currency", currency: "BRL", maximumFractionDigits: 2 });

/** Mantém apenas dígitos (para trabalhar em centavos) */
function onlyDigits(s: string): string {
  return s.replace(/\D+/g, "");
}

/** Converte centavos (string de dígitos) em string número com ponto decimal e 2 casas (ex.: "1234.56") */
function centsToNumberString(cents: string): string {
  const n = cents.length ? Number.parseInt(cents, 10) : 0;
  return (n / 100).toFixed(2);
}

/** Formata "1234.56" como "R$ 1.234,56" */
function formatBRL(numberString: string): string {
  const n = Number(numberString || "0");
  return BRL.format(Number.isFinite(n) ? n : 0);
}

/** Aplica a máscara em um input */
function maskInput(el: MoneyInput): void {
  const cents = onlyDigits(el.value);
  const numStr = centsToNumberString(cents);
  el.value = formatBRL(numStr);
  // guarda o valor "desmascarado" como referência (opcional)
  el.dataset.brlRaw = numStr; // "1234.56"
}

/** Ao digitar ou sair do campo */
function onInput(e: Event): void {
  const el = e.target as MoneyInput;
  maskInput(el);
}

/** Converte o valor do input para "1234.56" antes do submit */
function unmaskInput(el: MoneyInput): void {
  const cents = onlyDigits(el.value);
  el.value = centsToNumberString(cents);
}

/** Seletores dos campos de dinheiro */
const SELECTOR = [
  'input[data-brl="money"]',   // recomendação: use este atributo
  // fallback por nome (opcional; deixe se não puder marcar todos os inputs):
  'input[name*="valor"]',
  'input[name*="mensal"]',
  'input[name*="salario"]',
  'input[name*="parcela"]',
  'input[name*="desconto"]',
  'input[name*="doacao"]',
].join(",");

/** Atacha listeners aos inputs */
function attachToInputs(): void {
  document.querySelectorAll<HTMLInputElement>(SELECTOR).forEach((el) => {
    const node = el as MoneyInput;
    if (node.dataset.brlBound === "1") return;
    node.dataset.brlBound = "1";
    node.setAttribute("inputmode", "decimal");
    node.addEventListener("input", onInput);
    node.addEventListener("blur", onInput);

    // Se já vier valor do servidor (ex.: edição), aplique a máscara:
    if (node.value && /\d/.test(node.value)) maskInput(node);
  });
}

/** No submit, desmascarar todos os inputs alvo */
function hookForms(): void {
  document.querySelectorAll<HTMLFormElement>("form").forEach((form) => {
    if ((form as any)._brlHooked) return;
    (form as any)._brlHooked = true;

    form.addEventListener("submit", () => {
      form.querySelectorAll<HTMLInputElement>(SELECTOR).forEach((el) => unmaskInput(el as MoneyInput));
    }, { capture: true });
  });
}

/** Formatar spans/tds estáticos: <span data-brl-text>5000.00</span> → "R$ 5.000,00" */
function formatStaticTexts(): void {
  document.querySelectorAll<HTMLElement>("[data-brl-text]").forEach((node) => {
    const raw = (node.textContent || "")
      .replace(/[^\d.,-]/g, "")
      .replace(/\./g, "")
      .replace(",", ".");
    const n = Number(raw);
    if (!Number.isNaN(n)) node.textContent = BRL.format(n);
  });
}

/** Inicialização */
function init(): void {
  attachToInputs();
  hookForms();
  formatStaticTexts();
}

document.addEventListener("DOMContentLoaded", init);

// Exponha para re-inicialização em páginas com troca dinâmica:
window.ABASE = window.ABASE ?? {};
window.ABASE.moneyMaskInit = init;