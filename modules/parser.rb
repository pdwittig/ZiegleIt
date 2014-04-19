require_relative '../config/application.rb'

# Module takes a file input and by calling Module.parse with a file
# input, the module creates node objects based on the content of the
# file
module Parser
  def self.parse file
    @file = file
    create_reader
    read_nodes
    reduce_paragraphs_into_sentences
    # print_wait
    # p @nodes.length
    # count_each
    @nodes
  end

  def self.count_each
    puts "h1: #{@nodes.select { |node| node.depth == 1 }.length}"
    puts "h2: #{@nodes.select { |node| node.depth == 2 }.length}"
    puts "h3: #{@nodes.select { |node| node.depth == 3 }.length}"
    puts "h4: #{@nodes.select { |node| node.depth == 4 }.length}"
    puts "p: #{@nodes.select { |node| node.depth == 5 }.length}"
  end

  private

  def self.create_reader
    @reader = Nokogiri::XML::Reader(File.open(@file))
  end

  def self.read_nodes
    @nodes = []
    @reader.each do |node|

      if (node.inner_xml != '') && (node.inner_xml != 'Contents')
        break if  node.inner_xml.match(/(See also<\/span>)/) &&
        node.name == 'h2'

        create_node create_args node
      end
    end
  end

  def self.create_node args
    if args && args[:depth] > 0
      new_node = TreeNode.new(args)
      @nodes.reverse.each do |node|
        node << new_node if new_node.parent.nil? && node.depth < new_node.depth
      end

      @nodes << new_node
    end
  end

  def self.create_args node
    case
    when node.name =~ /(h).{1}/
      { depth: node.name.delete('h').to_i,
        content: "#{node.inner_xml.match(/[ \w]+(?=<\/span>)/)}" }
    when node.name == 'p'
        { depth: 5,
          content: (Nokogiri::XML.fragment(node.inner_xml).content) }
    end
  end

  def self.print_wait
    @nodes.each do |node|
      p node
      puts "\n"
    end
  end

  def self.break_into_sentences node
    sentence_regex = /((?<=[a-z0-9)][.?!])|(?<=[a-z0-9][.?!]"))\s+(?="?[A-Z])/
    node.content.split(sentence_regex).reject { |sentence| sentence == "" }
  end

  def self.reduce_paragraphs_into_sentences
    @nodes.find_all { |node| node.depth == 5 }.each do |node|
      create_and_add_sentence_nodes break_into_sentences(node), node
    end
  end

  def self.create_and_add_sentence_nodes sentences, node
    sentences.map! { |sentence| TreeNode.new({content: sentence, depth: 6})}
    sentences.each { |sentence| @nodes << sentence }
    sentences.each { |sentence| node << sentence }
  end
end
