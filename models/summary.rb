require_relative '../config/application'

class Summary
  def initialize document, comp_ratio, threshold = 4
    @document = document
    @comp_ratio = comp_ratio
    @threshold = threshold
    @decay_rate = 1
    @fractal_dimension = 1
  end

  def get_document_summary
    @nodes = Parser.parse @document
    set_all_rbss
    print_all_rbss
    set_fractal_values
    print_all_fractal_values
  end

  private

  def set_all_rbss
    @nodes.each do |node|
      if node.depth < 6
        node.rbss = Algorithm.range_block_sentence_score node, @nodes
      end
    end
  end

  def print_all_rbss
    @nodes.each do |node|
      puts "Node depth: #{node.depth}, Node RBSS: #{node.rbss}"
    end
  end

  def print_all_fractal_values
    @nodes.each do |node|
      puts "Node depth: #{node.depth}, Node FV: #{node.fv}"
    end
  end

  def set_fractal_values
    @nodes.each do |node|
      if node.depth == 1
        node.fv = 1
      elsif ( node.rbss > 0 ) && ( node.depth < 5 )
        node.fv = node.parent.fv * @decay_rate * ( node.rbss / sum_children_rbss(node) )
      end
    end
  end

  def sum_children_rbss node
    sum_rbss = 0
    node.children.each { |child| sum_rbss += child.rbss }
    sum_rbss
  end
end
