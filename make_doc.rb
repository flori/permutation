#!/usr/bin/env ruby

$outdir = 'doc/'
puts "Creating documentation in '#$outdir'."
system "rdoc -d -m doc-main.txt -o #$outdir #{(%w[doc-main.txt] + Dir['lib/**/*.rb']) * ' '}"
