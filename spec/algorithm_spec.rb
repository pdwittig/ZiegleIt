require 'rspec'
require_relative '../config/application'

describe Algorithm, "arc: run calculations" do

  puts "Checking algorithm functionality and accuracy..."

  before(:all) do
    test_doc = 'spec/wiki_arc_pair_grammar.html'
    @nodes = Parser.parse test_doc
  end

  it "should calculate accurate RBSS values" do
    Algorithm.range_block_sentence_score(@nodes[1], @nodes).round(2).should eq(150.75)
  end
end

