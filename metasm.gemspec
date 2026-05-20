lib = File.expand_path('lib', File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metasm/version'

Gem::Specification.new do |s|
  s.name          = 'metasm'
  s.version       = Metasm::VERSION
  s.summary       =
    "Metasm is a cross-architecture assembler, disassembler, linker, and debugger."
  s.description   = ""
  s.authors       = ["Yoann Guillot"]
  s.email         = ['john at ofjj.net']
  s.files         = `git ls-files -z`.split("\x0")
  s.test_files    = s.files.grep(%r{^tests/})
  s.require_paths = ["."]
  s.homepage      = 'http://metasm.cr0.org'
  s.license       = 'LGPL-2.1'

  s.add_development_dependency "rake"
  s.add_development_dependency "test-unit"
end

