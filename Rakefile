begin
  require 'rake/gempackagetask'
rescue LoadError
end
require 'rake/clean'
require 'rbconfig'
include Config

PKG_NAME = 'permutation'
PKG_VERSION = File.read('VERSION').chomp
PKG_FILES = FileList['**/*'].exclude(/^(doc|CVS|pkg|coverage)/)
CLEAN.include 'coverage', 'doc'

desc "Testing library"
task :test  do
  ruby %{-Ilib test/test.rb}
end

desc "Testing library (with coverage)"
task :coverage  do
  sh %{rcov -Ilib test/test.rb}
end

desc "Installing library"
task :install  do
  ruby 'install.rb'
end

desc "Creating documentation"
task :doc do
  ruby 'make_doc.rb'
end

if defined? Gem
  spec_src = <<GEM
# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = '#{PKG_NAME}'
  s.version = '#{PKG_VERSION}'
  s.summary = 'Permutation library in pure Ruby'
  s.description = "Library to perform different operations with permutations of sequences (strings, arrays, etc.)"

  s.files = #{PKG_FILES.to_a.sort.inspect}

  s.require_path = 'lib'

  s.has_rdoc = true
  s.rdoc_options << '--title' <<  'Permutation' << '--line-numbers'
  s.extra_rdoc_files = Dir['lib/**/*.rb']
  s.test_files << 'test/test.rb'

  s.author = "Florian Frank"
  s.email = "flori@ping.de"
  s.homepage = "http://#{PKG_NAME}.rubyforge.org"
  s.rubyforge_project = "#{PKG_NAME}"
end
GEM

  desc 'Create a gemspec file'
  task :gemspec do
    File.open("#{PKG_NAME}.gemspec", 'w') do |f|
      f.puts spec_src
    end
  end

  spec = eval(spec_src)
  Rake::GemPackageTask.new(spec) do |pkg|
    pkg.need_tar = true
    pkg.package_files += PKG_FILES
  end
end

desc m = "Writing version information for #{PKG_VERSION}"
task :version do
  puts m
  File.open(File.join('lib', PKG_NAME, 'version.rb'), 'w') do |v|
    v.puts <<EOT
class Permutation
  # Permutation version
  VERSION         = '#{PKG_VERSION}'
  VERSION_ARRAY   = VERSION.split(/\\./).map { |x| x.to_i } # :nodoc:
  VERSION_MAJOR   = VERSION_ARRAY[0] # :nodoc:
  VERSION_MINOR   = VERSION_ARRAY[1] # :nodoc:
  VERSION_BUILD   = VERSION_ARRAY[2] # :nodoc:
end
EOT
  end
end

task :default => [ :version, :gemspec, :test ]

task :release => [ :clean, :version, :gemspec, :package ]
