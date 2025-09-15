/**
 * Máscara BRL "blur-only":
 * - Enquanto digita: NÃO reformatamos (não mexe no cursor, nem "anda casas").
 * - Ao focar: tira símbolo e separadores para edição fácil.
 * - Ao sair do campo (blur): formata "R$ X.XXX,YY".
 * - No submit: envia "1234.56" para o backend (string).
 */
type MoneyInput = HTMLInputElement & { dataset: DOMStringMap };

const BRL = new Intl.NumberFormat("pt-BR", {
  style: "currency",
  currency: "BRL",
  maximumFractionDigits: 2,
});

/** Converte string livre ("2.345,6" | "2345.6" | "R$ 2.345,60") => número JS */
function parseLoose(s: string): number {
  if (!s) return 0;
  let t = s.replace(/\s|R\$/g, "");
  // remove separador de milhar (.)
  t = t.replace(/\.(?=\d{3}(?:\D|$))/g, "");
  // vírgula decimal -> ponto
  t = t.replace(/,/, ".");
  const n = Number(t);
  return Number.isFinite(n) ? n : 0;
}

/** Formata número JS => "R$ X.XXX,YY" */
function toBRL(n: number): string {
  return BRL.format(Number.isFinite(n) ? n : 0);
}

/** Pega "raw" do dataset ou converte o que está no input */
function getRaw(el: MoneyInput): number {
  if (el.dataset.raw) {
    const n = Number(el.dataset.raw);
    if (Number.isFinite(n)) return n;
  }
  return parseLoose(el.value);
}

/** Exibe para edição (sem R$ e sem separadores de milhar, com vírgula se houver decimais) */
function showEditable(el: MoneyInput): void {
  const n = getRaw(el);
  // Mostra com ponto como decimal (mais estável para edição) ou inteiro puro
  el.value = Number.isInteger(n) ? String(n) : String(n).replace(".", ",");
}

/** Exibe formatado BRL e armazena raw no dataset */
function showFormatted(el: MoneyInput): void {
  const n = parseLoose(el.value);
  el.dataset.raw = String(n.toFixed(2));   // usado no submit
  el.value = toBRL(n);
}

/** No submit: substitui pelo raw "1234.56" para o backend */
function unmaskForSubmit(el: MoneyInput): void {
  const n = getRaw(el);
  el.value = n.toFixed(2);
}

/** Inicializa campos marcados com data-money="brl" */
function bindMoneyInputs(): void {
  const sel = 'input[data-money="brl"]';
  document.querySelectorAll<HTMLInputElement>(sel).forEach((el) => {
    const node = el as MoneyInput;
    if (node.dataset.brlBound === "1") return;
    node.dataset.brlBound = "1";
    node.setAttribute("inputmode", "decimal");

    // Estado inicial: se vier preenchido do server, formata bonito
    if (node.value && /\d/.test(node.value)) showFormatted(node);

    node.addEventListener("focus", () => showEditable(node));
    node.addEventListener("blur", () => showFormatted(node));
  });

  // Unmask de todos os formularios antes de enviar
  document.querySelectorAll("form").forEach((form) => {
    if ((form as any)._brlHooked) return;
    (form as any)._brlHooked = true;

    form.addEventListener(
      "submit",
      () => {
        form
          .querySelectorAll<HTMLInputElement>('input[data-money="brl"]')
          .forEach((el) => unmaskForSubmit(el as MoneyInput));
      },
      { capture: true }
    );
  });

  // Formatar textos estáticos: <span data-brl-text>5000.00</span>
  document.querySelectorAll<HTMLElement>("[data-brl-text]").forEach((node) => {
    const n = parseLoose(node.textContent || "");
    node.textContent = toBRL(n);
  });
}

document.addEventListener("DOMContentLoaded", bindMoneyInputs);
// Re-inicializador para páginas dinâmicas (HTMX/Turbo)
(window as any).ABASE = (window as any).ABASE || {};
(window as any).ABASE.moneyMaskInit = bindMoneyInputs;