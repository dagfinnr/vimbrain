"-----------------------------------------------------
" VimBrain
"-----------------------------------------------------
"
if !has('ruby')
    finish
endif

ruby $LOAD_PATH <<  "~/.vim/vimbrain/lib/"
rubyfile ~/.vim/vimbrain/lib/vimbrain/testrunner.rb
ruby testrunner = VimBrain::TestRunner.new

if !hasmapto('<Plug>RubySuiteRun')
  map <unique> <Leader>ts <Plug>RubySuiteRun
endif

if !hasmapto('<Plug>RubyCurrentTestRun')
  map <unique> <Leader>tt <Plug>RubyCurrentTestRun
endif

if !hasmapto('<Plug>RubyLastTestRun')
  map <unique> <Leader>tl <Plug>RubyLastTestRun
endif

function s:RunSuite()
    ruby testrunner.run_suite
endfunction

function s:RunCurrentTest()
    ruby testrunner.run_current_test
endfunction

function s:RunLastTest()
    ruby testrunner.run_last_test
endfunction

noremap <unique> <script> <Plug>RubySuiteRun <SID>RunSuite
noremap <unique> <script> <Plug>RubyCurrentTestRun <SID>RunCurrentTest
noremap <unique> <script> <Plug>RubyLastTestRun <SID>RunLastTest

noremap <SID>RunSuite :call <SID>RunSuite()<CR>
noremap <SID>RunCurrentTest :call <SID>RunCurrentTest()<CR>
noremap <SID>RunLastTest :call <SID>RunLastTest()<CR>


