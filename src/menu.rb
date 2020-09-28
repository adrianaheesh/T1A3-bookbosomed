require 'thor'

class Menu < Thor 
    class_option :help, type: :string, aliases: "-h"
    
    desc "help", "displays how to use the app"
    def help
        puts "This is a help message"
    end 
end

Menu.start(ARGV)