// assets/js/config.js
// Dual-mode run configuration: GitHub Pages demo mode vs local XAMPP MySQL mode.

const IS_PAGES = location.hostname.endsWith('github.io');
export const DEMO_MODE = IS_PAGES;                     // Pages: read data/demo-data.json
export const API_BASE  = IS_PAGES ? null : './api';    // Local: real PHP + MySQL
