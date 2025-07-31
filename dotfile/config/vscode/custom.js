/*
Hide context menu items in vscode.
`Reload Custom CSS and JS` to apply changes.

Tricks:
  Help > Toggle Developer Tools, run `setTimeout(() => { debugger }, 3000)`
  in Console, open the context menu within 3 seconds, wait for the debugger
  to pause, then inspect items in Elements.
*/
/*
Hide context menu items in vscode.
`Reload Custom CSS and JS` to apply changes.

Tricks:
  Help > Toggle Developer Tools, run `setTimeout(() => { debugger }, 3000)`
  in Console, open the context menu within 3 seconds, wait for the debugger
  to pause, then inspect items in Elements.
*/

(() => {
	console.log("Hello from custom_context_menu.js~");

	const selectors = [
		'"_":has( + "Command Palette...")',
		'"_":has( + "Share")', // separator before "Share"
		'"Change All Occurrences"', // exact match
		'"Command Palette..."',
		'^"Find All"',
		'"Format',
		'"Layout Controls"',
		'^"Peek"',
		'"Share" + "_"', // separator after "Share"
		'^"Share"',
		'^"Show"',
		'^"Go to"', // start with "Go to"
	];

	const css_selectors = selectors
		.join(",\n")
		.replaceAll(/([*^|])?"(.+?)"/g, '[aria-label\x241="\x242"]');
	console.log(css_selectors);

	function wait_for(root) {
		const selector = ".monaco-menu-container > .monaco-scrollable-element";
		new MutationObserver((mutations) => {
			for (let mutation of mutations) {
				for (let node of mutation.addedNodes) {
					if (node.matches?.(selector)) {
						// console.log(">>", node);
						modify(node);
					}
				}
			}
		}).observe(root, { subtree: true, childList: true });
	}

	// context menu in editor
	Element.prototype._attachShadow = Element.prototype.attachShadow;
	Element.prototype.attachShadow = function () {
		const shadow = this._attachShadow({ mode: "open" });
		wait_for(shadow);
		return shadow;
	};
	// context menu in other places
	wait_for(document);

	// get mouse position
	let mouse_y = 0;
	document.addEventListener("mouseup", (e) => {
		// bug: not working in titlebar
		if (e.button === 2) {
			mouse_y = e.clientY;
			// console.log("mouse_y", mouse_y);
		}
	});

	function modify(container) {
		if (container.matches(".titlebar-container *")) {
			// console.log("skip titlebar");
			return;
		}
		for (let item of container.querySelectorAll(".action-item")) {
			const label = item.querySelector(".action-label");
			const aria_label = label?.getAttribute("aria-label") || "_";
			item.setAttribute("aria-label", aria_label);
		}

		const menu = container.parentNode;
		const style = document.createElement("style");
		menu.appendChild(style);
		style.innerText = `
    :host > .monaco-menu-container, :not(.menubar-menu-button) > .monaco-menu-container {
      ${css_selectors},
      .visible.scrollbar.vertical, .shadow {
        display: none !important;
      }
    }
    `.replaceAll(/\s+/g, " ");

		// fix context menu position
		if (menu.matches(".monaco-submenu")) {
			return;
		}
		let menu_top = Number.parseInt(menu.style.top);
		const menu_height = menu.clientHeight;
		// console.log("menu_top", menu_top, "menu_height", menu_height);
		const titlebar_height = 40;
		const window_height = window.innerHeight;
		if (menu_top < titlebar_height && menu_height < 90) {
			mouse_y = menu_top;
		} else {
			if (mouse_y < window_height / 2) {
				menu_top = mouse_y;
				if (menu_top + menu_height > window_height) {
					menu_top = window_height - menu_height;
				}
			} else {
				menu_top = mouse_y - menu_height;
				if (menu_top < titlebar_height) {
					menu_top = titlebar_height;
				}
			}
			menu.style.top = menu_top + "px";
		}
	}
})();
