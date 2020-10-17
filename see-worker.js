const window = this;
importScripts('/fengari-web.js');

var shims = "package.loaded.ffi = {typeof=function() end} os = {getenv=function() end} io = {open=function() end} bit = {band = function(a,b) return a & b end, rshift=function(a,b) return a >> b end} unpack = table.unpack";

window.done(window.fengari.load(shims + ' dofile("antifennel.lua")')());
