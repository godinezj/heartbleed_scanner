#!/usr/bin/ruby
msfbase = '../metasploit-framework'
$:.unshift(File.expand_path("#{msfbase}/lib"))
$:.unshift(File.expand_path("#{msfbase}/trunk/lib"))

require 'rubygems'
require 'fastlib'
require 'msfenv'

$:.unshift(ENV['MSF_LOCAL_LIB']) if ENV['MSF_LOCAL_LIB']

require 'rex'
require 'msf/ui'
require 'msf/base'
require './stdio'

## Initialize the simplified framework instance
# NOTE: comments below starting with ## are from msfcli, just using them
# to map what is being done here to msfcli
class MsfScanner
  def initialize
    @framework = Msf::Simple::Framework.create()
    $stdout.puts "[*] Initializing modules..."
    
    ## Determine what type of module it is 
    scanner = @framework.auxiliary.create("scanner/ssl/openssl_heartbleed")
    #scanner.init_ui(Rex::Ui::Text::Input::Stdio.new, Rex::Ui::Text::Output::Stdio.new)
    scanner.init_ui(Rex::Ui::Text::Input::Stdio.new, Stdio.new)
    $stdout.puts("\n" + Msf::Serializer::ReadableText.dump_auxiliary_actions(scanner, "\t"))
      
    @con = Msf::Ui::Console::Driver.new(
      Msf::Ui::Console::Driver::DefaultPrompt,
      Msf::Ui::Console::Driver::DefaultPromptChar,
        {
        'Framework' => $framework
        }
    )
    @con.run_single("use auxiliary/#{scanner.refname}")
  end
  def scan(hosts)
    rhosts = hosts.join(' ')
    puts "Scanning: "+rhosts
    args=["RHOSTS=#{rhosts}", "RPORT=443", "THREADS=10"]
    args.each {|arg|
          k,v = arg.split("=", 2)
          @con.run_single("set #{k} #{v}")
    }
    @con.run_single("run")
  end
end

if __FILE__ == $0
  scanner = MsfScanner.new()
  ARGV.each { |file_name|
    file = File.open(file_name, 'r')
    scanner.scan(file.readlines)
    file.close
  }
end

