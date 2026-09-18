/* LXR-SPAWN — the spawn picker on the LXR UI Kit | © 2026 iBoss21 / LXRCore
   Receives { action: 'open', options, isNew, locale, server } / { action: 'close' }.
   Posts { preview: { id } } on hover / selection and { choose: { id } } on confirm. */
(function () {
  const $ = (id) => document.getElementById(id);
  const app = $('app');
  const RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'lxr-spawn';
  let L = {}, options = [], selected = null;
  const t = (k, fb) => (L[k] !== undefined ? L[k] : (fb !== undefined ? fb : k));
  const esc = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const post = (name, body) => fetch(`https://${RES}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' }, body: JSON.stringify(body || {}) }).then(r => r.json()).catch(() => ({}));
  const pad = (i) => String(i).padStart(2, '0');
  function applyLocale() { document.querySelectorAll('[data-l]').forEach(el => { const k = 'ui.' + el.dataset.l; if (L[k]) el.textContent = L[k]; }); }

  function select(opt) { selected = opt.id; $('btn-spawn').disabled = false; render(); if (opt.coords) post('preview', { id: opt.id }); }
  function render() {
    const host = $('options'); host.innerHTML = '';
    $('count').textContent = pad(options.length);
    options.forEach((opt, i) => {
      const row = document.createElement('button'); row.className = 'lxr-row lxr-row--compact' + (selected === opt.id ? ' is-active' : '');
      const kind = opt.kind === 'last' ? t('ui.kind_last', 'last') : opt.kind === 'random' ? t('ui.kind_random', 'random') : t('ui.kind_town', 'town');
      row.innerHTML = `<span class="lxr-row-index">${pad(i + 1)}</span><span class="lxr-row-body"><span class="lxr-row-name">${esc(opt.label)}</span></span><span class="lxr-grow"></span><span class="sp-kind">${esc(kind)}</span>`;
      row.addEventListener('click', () => select(opt));
      row.addEventListener('mouseenter', () => { if (opt.coords) post('preview', { id: opt.id }); });
      host.appendChild(row);
    });
  }
  $('btn-spawn').addEventListener('click', () => { if (!selected) return; $('btn-spawn').disabled = true; post('choose', { id: selected }); });
  document.addEventListener('keydown', (e) => {
    if (!options.length) return;
    const i = options.findIndex(o => o.id === selected);
    if (e.key === 'ArrowDown') select(options[(i + 1) % options.length]);
    else if (e.key === 'ArrowUp') select(options[(i - 1 + options.length) % options.length]);
    else if (e.key === 'Enter' && selected) $('btn-spawn').click();
  });

  function open(m) {
    L = m.locale || {};
    document.body.classList.toggle('lang-ka', m.lang === 'ka');
    options = Array.isArray(m.options) ? m.options : [];
    selected = options[0] ? options[0].id : null;
    applyLocale();
    $('t-title').textContent = t('ui.title', 'Where do you ride from?');
    $('t-subtitle').textContent = m.isNew ? t('ui.new_character', '') : t('ui.subtitle', '');
    $('btn-spawn').textContent = t('ui.spawn', 'Ride out');
    $('btn-spawn').disabled = !selected;
    $('server-name').textContent = (m.server && m.server.name) || (m.brand && m.brand.name) || 'LXRCore';
    app.classList.remove('lxr-hidden');
    render();
  }
  window.addEventListener('message', (e) => {
    const m = e.data || {};
    const th = m.theme || (m.brand && m.brand.theme) || (m.server && m.server.theme); if (th) document.documentElement.dataset.theme = th;
    if (m.action === 'open') open(m);
    else if (m.action === 'close') { app.classList.add('lxr-hidden'); options = []; }
  });
  if (window.__LXR_MOCK__) open(window.__LXR_MOCK__);
})();
