require 'rspec'
require_relative '../config/application'

test_doc1 = 'test_files/wiki_computer_science.html'
test_doc2 = 'test_files/wiki_physics.html'
test_doc3 = 'test_files/wiki_arc_pair_grammar.html'
test_doc4 = 'test_files/wiki_carnivore.html'

Parser.parse test_doc3