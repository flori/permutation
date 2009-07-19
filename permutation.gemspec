# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'permutation'
  s.version = '0.1.7'
  s.summary = 'Permutation library in pure Ruby'
  s.description = "Library to perform different operations with permutations of sequences (strings, arrays, etc.)"

  s.files = ["CHANGES", "COPYING", "README", "Rakefile", "VERSION", "examples", "examples/tsp.rb", "install.rb", "lib", "lib/permutation", "lib/permutation.rb", "lib/permutation/version.rb", "make_doc.rb", "permutation.gemspec", "test", "test/test.rb"]

  s.require_path = 'lib'

  s.has_rdoc = true
  s.rdoc_options << '--title' <<  'Permutation' << '--line-numbers'
  s.extra_rdoc_files = Dir['lib/**/*.rb']
  s.test_files << 'test/test.rb'

  s.author = "Florian Frank"
  s.email = "flori@ping.de"
  s.homepage = "http://permutation.rubyforge.org"
  s.rubyforge_project = "permutation"
end
