// an example to create a new mapping `ctrl-y`
// mapkey('<Ctrl-y>', 'Show me the money', function() {
//     Front.showPopup('a well-known phrase uttered by characters in the 1996 film Jerry Maguire (Escape to close).');
// });
mapkey('<Space>', 'Choose a tab with omnibar', function() {
  Front.openOmnibar({type: "Tabs"});
});
// // an example to replace `u` with `?`, click `Default mappings` to see how `u` works.
// map('?', 'u');

// // an example to remove mapkey `Ctrl-i`
// unmap('<Ctrl-i>');

// click `Save` button to make above settings to take effect.
// set theme
settings.theme = `
.sk_theme {
    background: #fff;
    color: #00f;
}
.sk_theme tbody {
    color: #000;
}
.sk_theme input {
    color: #317ef3;
}
.sk_theme .url {
    color: #38f;
}
.sk_theme .annotation {
    color: #38f;
}

.sk_theme .focused {
    background: #00f;
}`;

settings.focusFirstCandidate = true;
