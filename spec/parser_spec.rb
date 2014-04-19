require 'rspec'
require_relative '../config/application'

# test_doc1 = 'test_files/wiki_computer_science.html'
# test_doc2 = 'test_files/wiki_physics.html'
# test_doc3 = 'test_files/wiki_arc_pair_grammar.html'
# test_doc4 = 'test_files/wiki_carnivore.html'

# Parser.parse test_doc3

describe Parser, "parse file and create nodes" do

  puts "Checking file parser functionality and node creation..."

  before(:all) do
    test_doc = 'spec/wiki_arc_pair_grammar.html'
    @nodes = Parser.parse test_doc
  end

  ##note##Create test: load the file ##note##

  it "should create node objects" do
    @nodes.should_not be nil
  end

  #Check qty of nodes
  it "should have one title node" do
    @nodes.find_all { |node| node.depth == 1 }.length.should eq(1)
  end

  it "should have zero h2 nodes" do
    @nodes.find_all { |node| node.depth == 2 }.length.should eq(0)
  end

  it "should have zero h2 nodes" do
    @nodes.find_all { |node| node.depth == 3 }.length.should eq(0)
  end

  it "should have zero h2 nodes" do
    @nodes.find_all { |node| node.depth == 4 }.length.should eq(0)
  end

  it "should have three paragraph nodes" do
    @nodes.find_all { |node| node.depth == 5 }.length.should eq(3)
  end

  #Check nested-ness
  it "should have a title node with 3 children nodes" do
    @nodes.find { |node| node.depth == 1 }.children.length.should eq(3)
  end

  it "should have 3 leaves" do
    @nodes.find_all { |node| node.leaf? == true }.length.should eq(3)
  end

  it "all leaves should be depth 5" do
    @nodes.find_all { |node| (node.leaf? == true) && (node.depth == 5) }.length.should eq(3)
  end
end

describe Parser, "check content of nodes" do

  puts "Checking content of created nodes..."

  before(:all) do
    test_doc = 'spec/wiki_arc_pair_grammar.html'
    @nodes = Parser.parse test_doc
  end

  #Check qty of nodes
  it "should have one title node" do
    @nodes.find_all { |node| node.depth == 1 }.length.should eq(1)
  end

  it "should have zero h2 nodes" do
    @nodes.find_all { |node| node.depth == 2 }.length.should eq(0)
  end

  it "should have zero h2 nodes" do
    @nodes.find_all { |node| node.depth == 3 }.length.should eq(0)
  end

  it "should have zero h2 nodes" do
    @nodes.find_all { |node| node.depth == 4 }.length.should eq(0)
  end

  it "should have three paragraph nodes" do
    @nodes.find_all { |node| node.depth == 5 }.length.should eq(3)
  end
  
end