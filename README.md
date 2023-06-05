[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://stand-with-ukraine.pp.ua)

[![License GPL 3](https://img.shields.io/badge/license-GPL_3-green.svg)](http://www.gnu.org/copyleft/gpl.html)
[![MELPA](http://melpa.org/packages/ctrlxo-badge.svg)](http://melpa.org/#/ctrlxo)

# emacs-ctrlxo

Switch to the most recently used window.

## Usage

Use the `ctrlxo` function to start switching between windows on visible frames in the recent usage ordering.

`ctrlxo` also activates transient keymap:
- <kbd>o</kbd> to switch to the next window
- <kbd>O</kbd> to switch to the previous window
- <kbd>C-g</kbd> to cancel switching and select window that was active on `ctrlxo` invocation

Use the `ctrlxo-currrent-frame` function to start switching between windows on the current frame.

### Use <kbd>C-TAB</kbd> and <kbd>C-x o</kbd> to switch windows

Following example configuration will allow to switch between windows on all visible frames with <kbd>C-TAB</kbd> and between windows on the current frame with <kbd>C-x o</kbd>:

```elisp
(require 'ctrlxo)

(global-set-key (kbd "C-<tab>") #'ctrlxo)
(global-set-key (kbd "C-x o") #'ctrlxo-current-frame)

(define-key ctrlxo-map (kbd "<tab>") #'ctrlxo-forward)
(define-key ctrlxo-map (kbd "<S-tab>") #'ctrlxo-backward)
```

Now use <kbd>C-TAB</kbd> or <kbd>C-x o</kbd> to start switching, <kbd>TAB</kbd> or <kbd>o</kbd> to select next window and <kbd>S-TAB</kbd> or <kbd>O</kbd> to select previous window.

## Installation

`ctrlxo` is available on [MELPA](https://melpa.org/#/ctrlxo).

Alternatively, you can download `ctrlxo.el` and run:

<kbd>M-x</kbd> `package-install-file` <kbd>RET</kbd> `<path-to-ctrlxo-el>` <kbd>RET</kbd>
