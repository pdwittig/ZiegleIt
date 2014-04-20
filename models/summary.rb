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
    @quota = (@nodes.count { |node| node.leaf? } * @comp_ratio ).to_i
    set_all_rbss
    print_all_rbss
    set_fractal_values
    print_all_fractal_values
    set_quota_values
    print_all_quota_values
    print_sum_fv
    print_sum_quota
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

  def sum_children_rbss node, sum_rbss = 0
    @nodes.each { |child| sum_rbss += child.rbss if child.depth == node.depth }
    sum_rbss
  end

  def set_quota_values
    @nodes.each { |node| node.quota = ( @quota * node.fv ).round if node.fv != 0 }
  end

  def print_all_quota_values
    @nodes.each do |node|
      puts "Node depth: #{node.depth}, Node Quota: #{node.quota}"
    end
  end

  def print_sum_fv
    sum_fv = 0
    @nodes.each { |node| sum_fv += node.fv }
    puts "Sum of all FVs: #{sum_fv}"
  end

  def print_sum_quota
    sum_quota = 0
    @nodes.each { |node| sum_quota += node.quota }
    puts "Sum of all Quotas: #{sum_quota}"
  end

end
