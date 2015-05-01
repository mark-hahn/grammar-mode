# grammar-mode package

This is an Atom.io package to let the author of a source file add a comment to force the file to use a certain grammar (aka "mode" in EMACS). This is needed on files with no extensions or files that start with one language but then are mostly another language (like react view files).

### Usage

Add a string with this format anywhere in the file, usually in a comment. `EXTENSION` should be a typical source file extension for the type of file that uses the grammar you want your file to use.  The period at the beginning is optional and nothing is case-sensitive.

```
-*- grammar-ext: EXTENSION -*-

Examples ...
  # -*- grammar-ext: .coffee -*-
  // -*- grammar-ext: js -*-
```

### Checking manually

Normally the `grammar-ext` comment is detected and the highlighting set when the file is loaded.  If you add a comment and want to see the results immediately then you need to issue a command to check all the loaded files.  This is done with the `grammar-mode:check-all` command which is bound by default to `ctrl-shift-alt-M`. 

### License 

Grammar-mode is copyright Mark Hahn with the MIT license.
