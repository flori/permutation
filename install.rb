#!/usr/bin/env ruby

require 'rbconfig'
require 'fileutils'
include FileUtils::Verbose

include Config

dest = CONFIG["sitelibdir"]
install('lib/permutation.rb', dest)
sub_dir = File.join(dest, 'permutation')
mkdir_p sub_dir
install('lib/permutation/version.rb', sub_dir)
