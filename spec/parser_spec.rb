require 'rspec'
require_relative '../config/application'

describe Parser, "arc: parse file and create nodes" do

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

  it "should have seven sentence nodes" do
    @nodes.find_all { |node| node.depth == 6 }.length.should eq(7)
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

describe Parser, "arc: check content of nodes" do

  puts "Checking content of created nodes..."

  before(:all) do
    test_doc = 'spec/wiki_arc_pair_grammar.html'
    @nodes = Parser.parse test_doc

    @expected_leaf1 = <<-eos
    In linguistics, Arc Pair grammar is a syntactic theory developed by David E. Johnson and Paul Postal which is a formalized continuation of relational grammar developed by David M. Perlmutter and Paul M. Postal.
    eos

    @expected_leaf2 = <<-eos
    Like relational grammar, arc pair grammar is greatly concerned with grammatical relations (as opposed to the constituent structure focus of other generative theories like versions of Chomskyan transformational grammar). In contrast to the generative-enumerative (proof-theoretic) approach to syntax assumed by transformational grammar, arc pair grammar takes a model-theoretic approach. In arc pair grammar, linguistic laws and language-specific rules of grammar are formalized in the same manner, namely, as logical statements in an axiomatic theory. Further, sentences of a language, understood as structures of a certain type, are the models of the set of linguistic laws and language-specific statements, thereby reducing the notion of grammaticality to the logical notion of model-theoretic satisfaction.
    eos

    @expected_leaf3 = <<-eos
    For a brief history of early work on relational grammar and arc pair grammar, see Newmeyer, 1980. For a more detailed history of model-theoretic approaches in linguistics, see Pullum and Scholz, 2005 and Pullum, 2007.
    eos
  end

  #Check content of title node
  it "should have the correct content in the title node" do
    @nodes.find { |node| node.depth == 1 }.content.should eq("Arc pair grammar")
    # If be is used instead of eq, test fails because of === vs ==
  end

  it "should have the correct content in leaf #1" do
    @nodes.find_all { |node| node.leaf? ==true }[0].content.should eq("#{@expected_leaf1.strip}")
  end
  
  it "should have the correct content in leaf #2" do
    @nodes.find_all { |node| node.leaf? ==true }[1].content.should eq("#{@expected_leaf2.strip}")
  end

  it "should have the correct content in leaf #3" do
    @nodes.find_all { |node| node.leaf? ==true }[2].content.should eq("#{@expected_leaf3.strip}")
  end
end

##note##Create tests: check wiki article with more complex structure ##note##