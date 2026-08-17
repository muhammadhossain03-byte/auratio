// assets/js/api.js
// API client with transparent dual-mode fallback (local PHP/MySQL or demo-data.json on GitHub Pages)

import { DEMO_MODE, API_BASE } from './config.js';

let demoDataCache = null;

async function loadDemoData() {
  if (!demoDataCache) {
    const res = await fetch('./data/demo-data.json');
    if (!res.ok) throw new Error('Failed to load demo data.');
    demoDataCache = await res.json();
  }
  return demoDataCache;
}

export async function api(endpoint, opts = {}) {
  if (DEMO_MODE) {
    const method = opts.method || 'GET';
    if (method !== 'GET') {
      throw new Error('Write operations (create, update, delete) are disabled in GitHub Pages demo mode. Please run locally with XAMPP for live MySQL operations.');
    }
    const data = await loadDemoData();
    
    // Parse endpoint and query string
    const [path, queryString] = endpoint.split('?');
    const params = new URLSearchParams(queryString || '');

    if (path === 'lookups.php') {
      return data.lookups;
    }
    if (path === 'users.php') {
      const id = params.get('id');
      if (id) {
        const u = data.users.find(x => x.user_id == id);
        if (!u) throw new Error('Record not found.');
        return u;
      }
      return data.users;
    }
    if (path === 'curricula.php') {
      const id = params.get('id');
      if (id) {
        const c = data.curricula.find(x => x.curriculum_id == id);
        if (!c) throw new Error('Record not found.');
        return c;
      }
      return data.curricula;
    }
    if (path === 'submissions.php') {
      const id = params.get('id');
      if (id) {
        const s = data.submissions.find(x => x.submission_id == id);
        if (!s) throw new Error('Record not found.');
        return s;
      }
      return data.submissions;
    }
    if (path === 'evaluations.php') {
      return data.evaluations;
    }
    if (path === 'events.php') {
      const resource = params.get('resource');
      if (resource === 'registrations') {
        const eventId = params.get('event_id');
        return data.registrations[eventId] || [];
      }
      const id = params.get('id');
      if (id) {
        const ev = data.events.find(x => x.event_id == id);
        if (!ev) throw new Error('Record not found.');
        return ev;
      }
      return data.events;
    }
    throw new Error(`Unknown endpoint: ${endpoint}`);
  }

  // Local mode: real PHP + MySQL
  const url = `${API_BASE}/${endpoint}`;
  const res = await fetch(url, { headers: { 'Content-Type': 'application/json' }, ...opts });
  const json = await res.json();
  if (!json.ok) throw new Error(json.error?.message || 'Unknown error');
  return json.data;
}

export async function apiGet(ep) { return api(ep); }
export async function apiPost(ep, data) { return api(ep, { method: 'POST', body: JSON.stringify(data) }); }
export async function apiPut(ep, data) { return api(ep, { method: 'PUT', body: JSON.stringify(data) }); }
export async function apiDel(ep) { return api(ep, { method: 'DELETE' }); }
