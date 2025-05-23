window.addEventListener('message', function(event) {
    const data = event.data;
    if (data.action === 'show') {
        const ui = document.getElementById('progress-ui');
        const fill = document.getElementById('progress-fill');
        ui.style.display = 'block';
        fill.style.transitionDuration = `${data.duration}ms`;
        fill.style.width = '100%';
    } else if (data.action === 'hide') {
        const ui = document.getElementById('progress-ui');
        const fill = document.getElementById('progress-fill');
        ui.style.display = 'none';
        fill.style.width = '0%';
        fetch(`https://${GetParentResourceName()}/close`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({})
        });
    }
});