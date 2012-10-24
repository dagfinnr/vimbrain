task :default => [:install]

files = [
"lib/vimbrain/cursor.rb",
"lib/vimbrain/cursor_position.rb",
"lib/vimbrain/event.rb",
"lib/vimbrain/singleton.rb",
"lib/vimbrain/testrunner.rb",
"lib/vimbrain/vim.rb",
"lib/vimbrain/window.rb",
"lib/vimbrain/vim/command.rb",
"lib/vimbrain/vim/user_dialog.rb",
]

desc "Install"
task :install do
    vimfiles = ENV['VIMFILES'] if ENV['VIMFILES']
    vimfiles ||= File.expand_path("~/vimfiles") if RUBY_PLATFORM =~ /(win|w)32$/
    vimfiles ||= File.expand_path("~/.vim")

    plugin_dir = File.join(vimfiles, 'plugin')
    FileUtils.cp('vimbrain.vim', plugin_dir)

    puts "Installing vimbrain"
    files.each do |file|
        target_file = File.join(vimfiles, 'vimbrain', file)
        FileUtils.mkdir_p(File.dirname(target_file))
        FileUtils.cp(file, target_file)
        puts " Copied #{file} to #{target_file}"
    end
end

