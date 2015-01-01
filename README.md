omnisharp-demo
==============
![omnisharp-emacs screenshot](https://raw.githubusercontent.com/nosami/nosami.github.io/master/emacs-demo.png)
Ready made emacs configuration for [omnisharp-emacs](https://github.com/OmniSharp/omnisharp-emacs)
with a bunch of plugins ready installed and keybindings designed to be familiar to VS/Resharper users.

Don't use this if you already have an emacs installation that you want to keep!!

This is meant for people who are new to emacs and want to get running quickly.

To install ```git clone https://github.com/nosami/omnisharp-demo.git ~/.emacs.d```

For OSX, use http://emacsformacosx.com/ or ```sudo brew install emacs --HEAD --use-git-head --cocoa --with-gnutls```

For Windows, use http://emacsbinw64.sourceforge.net/

To run k commands from emacs on OSX, you'll need to start it from the shell to
ensure that your PATH is set correctly within emacs after ```kvm use .....```

You might want to use an alias such as

```alias e='/Applications/Emacs.app/Contents/MacOS/Emacs'``` in your ~/.bashrc or ~/.zshrc file.

| Keybinding         | Notes                             | Feature                                |
|--------------------+-----------------------------------+----------------------------------------|
| None               | Automatic                         | Intellisense                           |
| Cmd-D, F12         | Might want to disable OSX F12 key | Goto Definition                        |
| Cmd-U or Shift-F12 |                                   | Find Usages                            |
| F2 or Ctrl-R,R     |                                   | Rename                                 |
| Ctrl-R-T           | Currently, only k test supported. | Run test                               |
| Ctrl-R-A           | Start emacs from the shell        | Run all tests                          |
| Ctrl-R-L           | to get the PATH set up correctly  | Run last tests                         |
| Ctrl-, or Ctrl-P   |                                   | Find file in project                   |
| Ctrl-K,D           |                                   | Format Document                        |
| Ctrl-K,C           |                                   | Comment block or line                  |
| Ctrl-G             |                                   | Go to line number                      |
| Ctrl-Alt-L         |                                   | Open current file in Directory Listing |
| F7                 |                                   | Toggle directory view                  |
| Cmd-F              |                                   | Full screen mode                       |
| Cmd-J              | Then first character of the word  | Jump to word                           |
| Ctrl-S             | Press again to repeat             | Incremental search                     |
| Alt- ←↑↓→          |                                   | Navigate split windows                 |
| Cmd-S              |                                   | Save file                              |
| Cmd-Q              |                                   | Quit                                   |

Snippets
--------
Type abbreviation followed by tab key to complete. Press tab again to
move between snippet placeholders.

| Abbreviation | Expands to                                    |
|--------------+-----------------------------------------------|
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

