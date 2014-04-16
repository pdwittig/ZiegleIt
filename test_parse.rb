require 'nokogiri'
# require_relative './models/treenode'
require_relative './modules/parser'

include Parser

test_doc1 = 'test_files/wiki_computer_science.html'
test_doc2 = 'test_files/wiki_physics.html'
test_doc3 = 'test_files/wiki_arc_pair_grammar.html'

Parser.parse test_doc1