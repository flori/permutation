#!/usr/bin/env ruby

$outdir = 'doc/'
puts "Creating documentation in '#$outdir'."
system "rdoc -d -S -m Permutation -o #$outdir #{Dir['lib/**/*.rb'] * ' '}"
