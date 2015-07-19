omnisharp-demo
==============
![omnisharp-emacs screenshot](https://raw.githubusercontent.com/nosami/nosami.github.io/master/emacs-demo.png)
Ready made emacs configuration for [omnisharp-emacs](https://github.com/OmniSharp/omnisharp-emacs)
with a bunch of plugins ready installed and keybindings designed to be familiar to VS/Resharper users.

Don't use this if you already have an emacs installation that you want to keep!!

This is meant for people who are new to emacs and want to get running quickly.

To install ```git clone https://github.com/nosami/omnisharp-demo.git ~/.emacs.d```

For OSX, use http://emacsformacosx.com/ or ```brew install emacs -cocoa --with-gnutls```

For OSX you may need to remove an old version of emacs from /usr/bin as well (or change paths)

```
$ sudo rm /usr/bin/emacs
$ sudo rm -rf /usr/share/emacs
```
or create an alias
```alias emacs="/usr/local/Cellar/emacs/24.3/Emacs.app/Contents/MacOS/Emacs -nw"```

For Windows, use http://emacsbinw64.sourceforge.net/

To run k commands from emacs on OSX, you'll need to start it from the shell to
ensure that your PATH is set correctly within emacs after ```kvm use .....```

You might want to use an alias such as

```alias e='/Applications/Emacs.app/Contents/MacOS/Emacs'``` in your ~/.bashrc or ~/.zshrc file.

| Feature                                | Keybinding               | Notes                                                     |
|----------------------------------------|--------------------------|-----------------------------------------------------------|
| Intellisense                           | None                     | Automatic                                                 |
| Goto Definition                        | Cmd-D, F12               | Might want to disable OSX F12 key                         |
| Find Usages                            | Cmd-U or Shift-F12       |                                                           |
| Find Implementations                   | Cmd-I                    |                                                           |
| Rename                                 | F2 or Ctrl-R,R           |                                                           |
| Run test                               | Ctrl-R-T                 | Currently, only k test supported.                         |
| Run all tests                          | Ctrl-R-A                 | Start emacs from the shell                                |
| Run last tests                         | Ctrl-R-L                 | to get the PATH set up correctly                          |
| Find file in project                   | Ctrl-, or Ctrl-P         |                                                           |
| Format Document                        | Ctrl-K,D                 |                                                           |
| Comment block or line                  | Ctrl-K,C                 |                                                           |
| Go to line number                      | Ctrl-G                   |                                                           |
| Duplicate line or region               | Ctrl-D                   |                                                           |
| Open current file in Directory Listing | Ctrl-Alt-L               |                                                           |
| Toggle directory view                  | F7                       |                                                           |
| Full screen mode                       | Alt-Shift-Enter or Cmd-F |                                                           |
| Jump to word                           | Cmd-J                    | Then first character of the word                          |
| Incremental search                     | Ctrl-I, F3 to repeat     | Or Ctrl-S, and press again to repeat                      |
| Switch to previous buffer              | Ctrl-Tab                 |                                                           |
| Expand selection                       | Ctrl-Alt-Left            |                                                           |
| Contract selection                     | Ctrl-Alt-Right           |                                                           |
| Find in files (incrementally!)         | Ctrl-Shift-F             | Requires ag https://github.com/ggreer/the_silver_searcher |
| Navigate split windows                 | Alt- ← ↑ ↓ →             |                                                           |
| Navigate up to previous definition     | Cmd-Shift-up             |                                                           |
| Navigate down to next definition       | Cmd-Shift-down           |                                                           |
| Save file                              | Cmd-S                    |                                                           |
| Quit                                   | Cmd-Q                    |                                                           |

Snippets
--------
Type abbreviation followed by tab key to complete. Press tab again to
move between snippet placeholders.

| Abbreviation | Expands to                                    |
|--------------|-----------------------------------------------|
| class        | Class with name from file                     |
| ctor         | Constructor with name generated from filename |
| cw           | Console.WriteLine                             |
| else         | else                                          |
| elif         | else if { .. Condition .. }                   |
| for          | for                                           |
| foreach      | foreach                                       |
| if           | If                                            |
| namespace    | Namespace from folder name                    |
| private      | private method                                |
| prop         | Public property                               |
| public       | public method                                 |
| tcf          | Try Catch Finally                             |
| test         | NUnit test method                             |
| tf           | NUnit test fixture                            |
| while        | while                                         |

