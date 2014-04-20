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
    gen_summary find_contributing_nodes
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

  def find_contributing_nodes
    important_nodes = []

    @nodes.each do |node|
      if (node.parent != nil)
        if node.parent.quota > @threshold && node.quota < threshold
          important_nodes << node
        end
      end
    end

    important_nodes
  end

  def gen_summary important_nodes
    summary = []
    important_nodes.each { |node| summary << return_top_sentences(node).first(quota)}
    summary
  end

  def return_top_sentences node
    #get all sentences from node
    #calculate FSS for each sentence
    #store these values in a has like: { content: sentence_content, fss: fss}
    #sort sentences into an array with highest fss first

    sentences = []
    
  end
end
