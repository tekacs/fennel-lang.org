const window = this;
importScripts('/fengari-web.js');

fetch('/see-worker.lua')
    .then(response => response.text())
    .then(sourceCode => window.fengari.load(sourceCode)());
