omnisharp-demo
==============

Ready made emacs configuration for [omnisharp-emacs](https://github.com/OmniSharp/omnisharp-emacs)
with a bunch of plugins ready installed.

Don't use this if you already have an emacs installation that you want to keep!!

This is meant for people who are new to emacs and want to get running quickly.

To install ```git clone https://github.com/nosami/omnisharp-demo.git ~/.emacs.d```

For OSX, use http://emacsformacosx.com/ or ```sudo brew install emacs --HEAD --use-git-head --cocoa --with-gnutls```

For Windows, use http://emacsbinw64.sourceforge.net/

To run k commands from emacs on OSX, you'll need to start it from the shell to
ensure that your PATH is set correctly within emacs after ```kvm use .....```

You might want to use an alias such as

```alias e='/Applications/Emacs.app/Contents/MacOS/Emacs'``` in your ~/.bashrc or ~/.zshrc file.

| Feature                                | Keybinding         | Notes                             |
|----------------------------------------|--------------------|-----------------------------------|
| Intellisense                           | None               | Automatic                         |
| Goto Definition                        | Cmd-D, F12         |                                   |
| Find Usages                            | Cmd-U or Shift-F12 |                                   |
| Rename                                 | F2 or Ctrl-R,R     |                                   |
| Run test                               | Ctrl-R-T           | Currently, only k test supported. |
| Run all tests                          | Ctrl-R-A           | Start emacs from the shell        |
| Run last tests                         | Ctrl-R-L           | to get the PATH set up correctly  |
| Find file in project                   | Ctrl-, or Ctrl-P   |                                   |
| Format Document                        | Ctrl-K,D           |                                   |
| Comment block or line                  | Ctrl-K,C           |                                   |
| Go to line number                      | Ctrl-G             |                                   |
| Open current file in Directory Listing | Ctrl-Alt-L         |                                   |
| Full screen mode                       | Cmd-F              |                                   |
| Jump to word                           | Cmd-J              | Then first character of the word  |
