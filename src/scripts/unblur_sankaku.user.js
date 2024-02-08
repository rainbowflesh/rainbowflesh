// ==UserScript==
// @name         Unblur sankakucomplex
// @version      0.4
// @description  remove blur thump img when using adblock
// @namespace    http://tampermonkey.net/
// @license      MIT
// @updateURL    https://raw.githubusercontent.com/rainbowflesh/rainbowflesh/main/src/scripts/unblur_sankaku.user.js
// @downloadURL  https://raw.githubusercontent.com/rainbowflesh/rainbowflesh/main/src/scripts/unblur_sankaku.user.js
// @author       rainbowflesh
// @match        *://*.sankakucomplex.com/*
// @icon         https://sankakucomplex.com/favicon.ico
// @icon64       https://sankakucomplex.com/favicon.ico
// @grant        none
// @require https://code.jquery.com/jquery-3.6.0.min.js
// ==/UserScript==

(function() {
    'use strict';
    $('.thumb, .blacklisted').attr("style","filter: unset;-webkit-filter: unset;");
    $('.has-mail, .scad-i, .scad').attr("style","display:none;");
    $('#news-ticker, #sp1').attr("style","display:none;");
    $(document).ready(function() {
        $('.scad, .scad-i').hide();
    });
    // Block just-detect-adblock
    Object.defineProperty(window, 'detectAnyAdblocker', {
        value: function() {}
    });
})();
