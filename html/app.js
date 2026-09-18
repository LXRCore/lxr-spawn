/* LXR-SPAWN — the spawn picker on the LXR UI Kit | © 2026 iBoss21 / LXRCore
   Receives { action: 'open', options, isNew, locale, server, protection } / { action: 'close' }.
   Options carry kind (last|town|random), region, note, services[], seen { since, near, miles }.
   Posts { preview: { id } } on hover / selection and { choose: { id } } on confirm. */
(function () {
  const $ = (id) => document.getElementById(id);
  const app = $('app');
  const RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'lxr-spawn';
  let L = {}, options = [], selected = null, protection = 0;
  const t = (k, vars, fb) => { let s = L[k]; if (s === undefined) return fb !== undefined ? fb : k; if (vars) for (const v in vars) s = s.split('%{' + v + '}').join(String(vars[v])); return s; };
  const esc = (s) => String(s == null ? '' : s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  const post = (name, body) => fetch(`https://${RES}/${name}`, { method: 'POST', headers: { 'Content-Type': 'application/json; charset=UTF-8' }, body: JSON.stringify(body || {}) }).then(r => r.json()).catch(() => ({}));
  const pad = (i) => String(i).padStart(2, '0');
  function applyLocale() { document.querySelectorAll('[data-l]').forEach(el => { const k = 'ui.' + el.dataset.l; if (L[k]) el.textContent = L[k]; }); }
  const kindOf = (opt) => opt.kind === 'last' ? t('ui.kind_last', null, 'last') : opt.kind === 'random' ? t('ui.kind_random', null, 'random') : t('ui.kind_town', null, 'town');

  function ago(seen) {
    if (!seen || seen.since == null) return '';
    const s = seen.since;
    if (s < 3600) return t('ui.ago_minutes', { n: Math.max(1, Math.floor(s / 60)) });
    if (s < 86400) return t('ui.ago_hours', { n: Math.floor(s / 3600) });
    return t('ui.ago_days', { n: Math.floor(s / 86400) });
  }

  /* ── the place card ── */
  function card(opt) {
    const el = $('card');
    if (!opt) { el.classList.add('lxr-hidden'); return; }
    el.classList.remove('lxr-hidden');
    el.dataset.kind = opt.kind;
    $('c-kicker').textContent = opt.kind === 'town' ? (opt.region || kindOf(opt)) : kindOf(opt);
    $('c-name').textContent = opt.label;
    $('c-note').textContent = opt.note || '';
    const seen = $('c-seen');
    if (opt.kind === 'last' && opt.seen) {
      const bits = [];
      const when = ago(opt.seen); if (when) bits.push(when);
      if (opt.seen.near) bits.push(t('ui.near', { miles: opt.seen.miles != null ? opt.seen.miles : '?', town: opt.seen.near }));
      seen.innerHTML = '<span class="lxr-t-smoke">' + esc(t('ui.card_last')) + '</span> <span class="lxr-t-bone">' + esc(bits.join(' · ')) + '</span>';
      seen.classList.remove('lxr-hidden');
    } else seen.classList.add('lxr-hidden');
    const svc = $('c-svc'), tags = $('c-tags');
    tags.innerHTML = '';
    if (opt.services && opt.services.length) {
      opt.services.forEach(s => { const c = document.createElement('span'); c.className = 'lxr-chip is-on'; c.textContent = t('ui.svc_' + s, null, s); tags.appendChild(c); });
      svc.classList.remove('lxr-hidden');
    } else svc.classList.add('lxr-hidden');
    $('c-protect').textContent = protection > 0 ? t('ui.protection', { s: protection }) : '';
  }

  function select(opt) { selected = opt.id; $('btn-spawn').disabled = false; render(); card(opt); if (opt.coords) post('preview', { id: opt.id }); }
  function render() {
    const host = $('options'); host.innerHTML = '';
    $('count').textContent = pad(options.length);
    options.forEach((opt, i) => {
      const row = document.createElement('button'); row.className = 'lxr-row lxr-row--compact' + (selected === opt.id ? ' is-active' : '');
      const sub = opt.kind === 'town' && opt.region ? '<span class="sp-region lxr-mono">' + esc(opt.region) + '</span>' : opt.kind === 'last' && opt.seen ? '<span class="sp-region lxr-mono">' + esc(ago(opt.seen)) + '</span>' : '';
      row.innerHTML = '<span class="lxr-row-index">' + pad(i + 1) + '</span><span class="lxr-row-body"><span class="lxr-row-name">' + esc(opt.label) + '</span>' + sub + '</span><span class="lxr-grow"></span><span class="sp-kind">' + esc(kindOf(opt)) + '</span>';
      row.addEventListener('click', () => select(opt));
      row.addEventListener('mouseenter', () => { card(opt); if (opt.coords) post('preview', { id: opt.id }); });
      row.addEventListener('mouseleave', () => { const cur = options.find(o => o.id === selected); if (cur) card(cur); });
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
    protection = Number(m.protection) || 0;
    selected = options[0] ? options[0].id : null;
    applyLocale();
    $('t-title').textContent = t('ui.title', null, 'Where do you ride from?');
    $('t-subtitle').textContent = m.isNew ? t('ui.new_character', null, '') : t('ui.subtitle', null, '');
    $('btn-spawn').textContent = t('ui.spawn', null, 'Ride out');
    $('btn-spawn').disabled = !selected;
    $('server-name').textContent = (m.server && m.server.name) || (m.brand && m.brand.name) || 'LXRCore';
    app.classList.remove('lxr-hidden');
    render();
    card(options[0] || null);
  }
  window.addEventListener('message', (e) => {
    const m = e.data || {};
    const th = m.theme || (m.brand && m.brand.theme) || (m.server && m.server.theme); if (th) document.documentElement.dataset.theme = th;
    if (m.action === 'open') open(m);
    else if (m.action === 'close') { app.classList.add('lxr-hidden'); options = []; }
  });
  if (window.__LXR_MOCK__) open(window.__LXR_MOCK__);
})();
