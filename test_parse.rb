require_relative 'config/application'
require 'benchmark'
require 'Thwait'

test_doc1 = 'test_files/wiki_computer_science.html'
test_doc2 = 'test_files/wiki_physics.html'
test_doc3 = 'test_files/wiki_arc_pair_grammar.html'
test_doc4 = 'test_files/wiki_carnivore.html'

nodes = Parser.parse test_doc1
Parser.count_each

# ThWait.all_waits(

  # Thread.new {
    sum = Summary.new(test_doc1, 0.5 )
    bm2 = Benchmark.measure { sum.get_document_summary }
    puts "Summary benchmark 50% compression: #{bm2}"
  # },

  # Thread.new { 
    sum = Summary.new(test_doc1, 0.1 )
    bm3 = Benchmark.measure { sum.get_document_summary }
    puts "Summary benchmark 10% compression: #{bm3}"
  # },

  # Thread.new {
    sum = Summary.new(test_doc1, 0.05 )
    bm4 = Benchmark.measure { sum.get_document_summary }
    puts "Summary benchmark 5% compression: #{bm4}"
  # }

# )

puts "-" * 80
puts "Summary benchmark 50% compression: #{bm2}"
puts "Summary benchmark 50% compression: #{bm3}"
puts "Summary benchmark 50% compression: #{bm4}"