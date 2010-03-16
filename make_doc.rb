#!/usr/bin/env ruby

$outdir = 'doc/'
puts "Creating documentation in '#$outdir'."
system "rdoc -d -m README -t 'Permutation library for Ruby' -o #$outdir #{(%w[README] + Dir['lib/**/*.rb']) * ' '}"
