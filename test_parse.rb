require_relative 'config/application'

test_doc1 = 'test_files/wiki_computer_science.html'
test_doc2 = 'test_files/wiki_physics.html'
test_doc3 = 'test_files/wiki_arc_pair_grammar.html'
test_doc4 = 'test_files/wiki_carnivore.html'

nodes = Parser.parse test_doc3

Parser.count_each
# p Algorithm.calculate_tfid "the", nodes[4], nodes
p Algorithm.range_block_sentence_score nodes[1], nodes