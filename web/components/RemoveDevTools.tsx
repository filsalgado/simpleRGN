'use client';

import { useEffect } from 'react';

export function RemoveDevTools() {
  useEffect(() => {
    const removeIndicator = () => {
      const indicator = document.getElementById('devtools-indicator');
      if (indicator) {
        indicator.remove();
      }
    };

    // Remove imediatamente
    removeIndicator();

    // Observer para remover caso seja adicionado dinamicamente
    const observer = new MutationObserver(removeIndicator);
    observer.observe(document.body, { childList: true, subtree: true });

    return () => observer.disconnect();
  }, []);

  return null;
}
