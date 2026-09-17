/* ═══════════════════════════════════════════════════════════════════════════
   🐺 LXR-SPAWN — NUI logic (vanilla)
   Receives { action: 'open', options, isNew, locale, server } / { action: 'close' }
   Posts { preview: { id } } on hover / selection and { choose: { id } } on confirm.
   © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
   ═══════════════════════════════════════════════════════════════════════════ */
(() => {
    'use strict';

    const resource = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'lxr-spawn';
    const $ = (id) => document.getElementById(id);
    let locale = {};
    let options = [];
    let selected = null;

    const postNUI = (event, payload) =>
        fetch(`https://${resource}/${event}`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(payload || {}),
        }).then((r) => r.json()).catch(() => ({}));

    const t = (key, fallback) => (locale[key] !== undefined ? locale[key] : (fallback !== undefined ? fallback : key));

    function render() {
        const list = $('options');
        list.innerHTML = '';
        options.forEach((opt) => {
            const li = document.createElement('li');
            const btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'lxr-card' + (selected === opt.id ? ' lxr-card--active' : '');
            const name = document.createElement('span');
            name.className = 'lxr-card__name';
            name.textContent = opt.label;
            const kind = document.createElement('span');
            kind.className = 'lxr-card__kind';
            kind.textContent = opt.kind === 'last' ? '↩' : opt.kind === 'random' ? '?' : '';
            btn.append(name, kind);
            btn.addEventListener('click', () => {
                selected = opt.id;
                $('btn-spawn').disabled = false;
                render();
                if (opt.coords) postNUI('preview', { id: opt.id });
            });
            btn.addEventListener('mouseenter', () => { if (opt.coords) postNUI('preview', { id: opt.id }); });
            li.appendChild(btn);
            list.appendChild(li);
        });
    }

    $('btn-spawn').addEventListener('click', () => {
        if (!selected) return;
        $('btn-spawn').disabled = true;
        postNUI('choose', { id: selected });
    });

    document.addEventListener('keyup', (e) => {
        if (e.key === 'Enter' && selected) $('btn-spawn').click();
    });

    window.addEventListener('message', (event) => {
        const data = event.data || {};
        if (data.action === 'open') {
            locale = data.locale || {};
            options = Array.isArray(data.options) ? data.options : [];
            selected = options[0] ? options[0].id : null;
            $('t-title').textContent = t('ui.title', 'Where do you ride from?');
            $('t-subtitle').textContent = data.isNew ? t('ui.new_character', '') : t('ui.subtitle', '');
            $('btn-spawn').textContent = t('ui.spawn', 'Ride out');
            $('btn-spawn').disabled = !selected;
            if (data.server) {
                $('server-name').textContent = data.server.name || 'LXRCore';
                $('server-tagline').textContent = data.server.tagline || '';
            }
            render();
            $('app').classList.remove('hidden');
        } else if (data.action === 'close') {
            $('app').classList.add('hidden');
        }
    });
})();
