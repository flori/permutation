#!/usr/bin/env ruby
#
# Solves the Traveling Salesmen Problem: A minimal length tour through n
# cities (and returning to the first city) is computed -- by brute
# force.

require 'permutation'

def make_matrix(n)
  dist = Array.new(n) { [] }
  for i in 0...n
    for j in 0...n
      case
      when i == j then dist[i][j] = 0
      when i < j then  dist[i][j] = 1 + rand(999)
      when i > j then  dist[i][j] = dist[j][i]
      end
    end
  end
  dist
end

def pretty_distances(dist)
  dist.map { |line| line.map { |x| "%3u" % x }.join(' ') }.join("\n")
end

def solution(p, dist)
  (0...p.size).map { |i| dist[ p[i - 1] ][ p[i] ] }.join(' + ')
end

n = ARGV.empty? ? 7 : ARGV.shift.to_i
distances = make_matrix(n)
puts "Random distance matrix", pretty_distances(distances)
optimum, minsum = nil, nil
perm = Permutation.new(distances.size - 1)
puts "Searching through #{perm.last + 1} solutions..."
projection = (1...distances.size).to_a
perm.each! do |p|
  tour = p.project(projection)
  # Little trick: We always start in city 0:
  tour.unshift(0)
  sum = 0
  0.upto(tour.size - 1) do |i|
    sum += distances[ tour[i - 1] ][ tour[i] ]
  end
  if $DEBUG
    puts "Computed tour #{tour.inspect} with sum = #{sum} = " +
      "#{solution(tour, distances)}."
  end
  if not minsum or minsum > sum
    optimum, minsum = tour, sum
  end
end
puts "Optimal tour is #{optimum.inspect} with sum = #{minsum} = " +
   "#{solution(optimum, distances)}."
