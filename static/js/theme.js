/**
 * Theme Management System - Light Mode Only
 * Handles light theme application and UI updates
 */

// Prevent redeclaration if already loaded
if (typeof window.ThemeManager === 'undefined') {

class ThemeManager {
  constructor() {
    this.theme = 'light';
    this.callbacks = [];
    this.init();
  }

  init() {
    // Apply light theme on load
    this.applyTheme('light');
  }



  applyTheme() {
    const root = document.documentElement;
    
    // Remove any existing theme classes
    root.classList.remove('light', 'dark');
    
    // Add light theme class
    root.classList.add('light');
    
    // Set data attribute for CSS selectors
    root.setAttribute('data-theme', 'light');
    
    // Update meta theme-color for mobile browsers
    const metaThemeColor = document.querySelector('meta[name="theme-color"]');
    if (metaThemeColor) {
      metaThemeColor.setAttribute('content', '#ffffff');
    }
    
    // Trigger callbacks
    this.callbacks.forEach(callback => callback('light'));
  }

  getTheme() {
    return 'light';
  }

  isLight() {
    return true;
  }

  isDark() {
    return false;
  }

  onThemeChange(callback) {
    this.callbacks.push(callback);
  }
}

/**
 * Menu Items Management System
 * Handles menu item hover effects and animations
 */
class MenuManager {
  constructor() {
    this.init();
  }

  init() {
    // Initialize menu items with hover effects
    this.initializeMenuItems();
    
    console.log('Menu manager initialized successfully');
  }

  initializeMenuItems() {
    const sidebar = document.querySelector('[data-sidebar]');
    if (!sidebar) return;

    const menuItems = sidebar.querySelectorAll('[data-menu-item]');
    
    menuItems.forEach((item, index) => {
      // Add stagger animation delay
      item.style.animationDelay = `${index * 0.1}s`;

      // Add hover effects
      item.addEventListener('mouseenter', (e) => {
        this.addHoverEffect(e.currentTarget);
      });

      item.addEventListener('mouseleave', (e) => {
        this.removeHoverEffect(e.currentTarget);
      });

      // Add click ripple effect
      item.addEventListener('click', (e) => {
        this.addRippleEffect(e);
      });
    });
  }

  addHoverEffect(item) {
    item.classList.add('hover-active');
    
    // Add glow effect
    const glowElement = item.querySelector('[data-menu-glow]');
    if (glowElement) {
      glowElement.style.opacity = '1';
      glowElement.style.transform = 'scale(2)';
    }
  }

  removeHoverEffect(item) {
    item.classList.remove('hover-active');
    
    // Remove glow effect
    const glowElement = item.querySelector('[data-menu-glow]');
    if (glowElement) {
      glowElement.style.opacity = '0';
      glowElement.style.transform = 'scale(0.8)';
    }
  }

  addRippleEffect(event) {
    const item = event.currentTarget;
    const rect = item.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    const x = event.clientX - rect.left - size / 2;
    const y = event.clientY - rect.top - size / 2;

    const ripple = document.createElement('div');
    ripple.className = 'ripple-effect';
    ripple.style.cssText = `
      position: absolute;
      width: ${size}px;
      height: ${size}px;
      left: ${x}px;
      top: ${y}px;
      background: rgba(255, 255, 255, 0.3);
      border-radius: 50%;
      transform: scale(0);
      animation: ripple 0.6s ease-out;
      pointer-events: none;
      z-index: 10;
    `;

    // Add ripple keyframes if not exists
    if (!document.querySelector('#ripple-styles')) {
      const style = document.createElement('style');
      style.id = 'ripple-styles';
      style.textContent = `
        @keyframes ripple {
          to {
            transform: scale(2);
            opacity: 0;
          }
        }
      `;
      document.head.appendChild(style);
    }

    item.style.position = 'relative';
    item.appendChild(ripple);

    setTimeout(() => {
      ripple.remove();
    }, 600);
  }
}

// Initialize managers when DOM is ready
let themeManager, menuManager;

function initializeThemeSystem() {
  // Prevent double initialization
  if (window.themeManager || window.menuManager) {
    console.log('Theme system already initialized');
    return;
  }
  
  try {
    themeManager = new ThemeManager();
    menuManager = new MenuManager();
    
    // Make managers globally available
    window.themeManager = themeManager;
    window.menuManager = menuManager;
    
    console.log('Theme system initialized successfully');
  } catch (error) {
    console.error('Error initializing theme system:', error);
  }
}

// Initialize on DOM ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initializeThemeSystem);
} else {
  initializeThemeSystem();
}

// Export for module usage
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { ThemeManager, MenuManager };
}

} // End of redeclaration protection