
SubAtom = require 'sub-atom'

module.exports =

  activate: -> 
    @subs = new SubAtom()
    @editorsWaitingForGrammar = []
    
    @subs.add atom.workspace.observeTextEditors (editor) => 
      editor.scan /-\*-\s*gramm[ae]r-ext:\s*\.?(\S+)\s*-\*-/i, (scanRes) =>
        @editorsWaitingForGrammar.push [editor, scanRes.match[1].toLowerCase()]
        @chkAndStartTimeout()    
        scanRes.stop()
        
    @subs.add atom.grammars.onDidAddGrammar (=> @chkAndStartTimeout())
      
    @subs.add atom.commands.add 'atom-workspace', 'grammar-mode:check-all': =>
      for editor in atom.workspace.getTextEditors()
        editor.scan /-\*-\s*gramm[ae]r-ext:\s*\.?(\S+)\s*-\*-/i, (scanRes) =>
          @editorsWaitingForGrammar.push [editor, scanRes.match[1].toLowerCase()]
          scanRes.stop()
      @chkGrammars 'timedOut'

  chkAndStartTimeout: ->
      @chkGrammars()
      if @timeout then clearTimeout @timeout
      @timeout = setTimeout (=> @chkGrammars 'timedOut'), 2000  

  chkGrammars: (timedOut) ->
    if @timeout then clearTimeout @timeout
    for editorAndExt, editorIdx in @editorsWaitingForGrammar
      [editor, ext] = editorAndExt
      grammar = atom.grammars.selectGrammar 'x.' + ext
      if grammar.name isnt 'Null Grammar'
        console.log 'setting mode', path: editor.getPath(), ext: ext, grammar: grammar.name
        setTimeout (-> editor.setGrammar grammar), 50
        @editorsWaitingForGrammar.splice editorIdx, 1
      else if timedOut
          console.log 'Grammer not found for extension "' + ext + '" ' +
                      'in file ' + editor.getPath()
          @editorsWaitingForGrammar.splice editorIdx, 1
  
  deactivate: ->
    @subs.dispose()
    
# -*- mode: CoffeeScript -*-
