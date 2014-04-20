require 'rspec'
require_relative '../config/application'

describe Algorithm, "arc: run calculations" do

  puts "Checking algorithm functionality and accuracy..."

  before(:all) do
    test_doc = 'spec/wiki_arc_pair_grammar.html'
    @nodes = Parser.parse test_doc
    # Algorithm.instance_variable_set(:@nodes, @nodes)
  end

  ##note##Fix the two tests below, problems with @nodes ##note##

  # it "should calculate accurate TFID values" do
  #   term = "the"
  #   @range_block = @nodes[2]
  #   Algorithm.calculate_tfid(term).round(2).should eq(5)
  # end

  # it "should calculate accurate FSS values" do
  #   Algorithm.fractal_sentence_score(@nodes[4]).round(2).should eq(150.75)
  # end

  it "should calculate accurate RBSS values" do
    Algorithm.range_block_sentence_score(@nodes[1], @nodes).round(2).should eq(150.75)
  end
end

