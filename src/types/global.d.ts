export {};

declare global {
  interface Window {
    ABASE?: {
      moneyMaskInit?: () => void;
    };
  }
}