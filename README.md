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

Maybe give it a try as `other-window` replacement:

```elisp
(global-set-key (kbd "C-x o") #'ctrlxo)
```

## Installation

`ctrlxo` is available on [MELPA](https://melpa.org/#/ctrlxo).

Alternatively, you can download `ctrlxo.el` and run:

<kbd>M-x</kbd> `package-install-file` <kbd>RET</kbd> `<path-to-ctrlxo-el>` <kbd>RET</kbd>
