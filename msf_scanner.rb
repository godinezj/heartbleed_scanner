#!/usr/bin/ruby
msfbase = '../../tools/msf/metasploit-framework'
$:.unshift(File.expand_path("#{msfbase}/lib"))
$:.unshift(File.expand_path("#{msfbase}/trunk/lib"))

require 'fastlib'
require 'msfenv'

$:.unshift(ENV['MSF_LOCAL_LIB']) if ENV['MSF_LOCAL_LIB']

require 'rex'
require 'msf/ui'
require 'msf/base'
# NOTE: comments below starting with ## are from msfcli, just using them
# to map what is being done here to msfcli

## Initialize the simplified framework instance
class MsfScanner
  def initialize
    $framework = Msf::Simple::Framework.create
    
    ## Determine what type of module it is 
    scanner = $framework.auxiliary.create("scanner/http/ssl/openssl_heartbleed")
    scanner.init_ui(Rex::Ui::Text::Input::Stdio.new, Rex::Ui::Text::Output::Stdio.new)
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
  def scan(host)
    puts "Scanning "+host
    args=["RHOSTS=#{host}", "RPORT=443", "SSL=true"]
    args.each {|arg|
          k,v = arg.split("=", 2)
          @con.run_single("set #{k} #{v}")
    }
    @con.run_single("run")
  end
end

if __FILE__ == $0
  scanner = MsfScanner.new()
  scanner.scan('127.0.0.1')
end

