console.log('%c System Optimized by Custom Orchestrator ', 'background: #6366f1; color: #fff; padding: 4px; border-radius: 4px;');

document.addEventListener('keydown', function(e) {
    if ((e.ctrlKey || e.metaKey) && (e.key === 'c' || e.key === 'C')) {
        const selection = window.getSelection();
        if (selection && selection.toString().length > 0) {
            e.stopImmediatePropagation();
            try {
                navigator.clipboard.writeText(selection.toString());
            } catch (err) {
                document.execCommand('copy');
            }
        }
    }
}, true);

window.addEventListener('load', function() {
    const inputs = document.querySelectorAll('input, textarea');
    inputs.forEach(input => {
        input.addEventListener('focus', () => {
            input.style.borderColor = '#6366f1';
            input.style.boxShadow = '0 0 0 2px rgba(99, 102, 241, 0.2)';
        });
        input.addEventListener('blur', () => {
            input.style.borderColor = 'rgba(255, 255, 255, 0.08)';
            input.style.boxShadow = 'none';
        });
    });
});
