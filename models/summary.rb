require_relative '../config/application'

class Summary
  def initialize document, comp_ratio, threshold = 4
    @document = document
    @comp_ratio = comp_ratio
    @threshold = threshold
    @decay_rate = 1
    @fractal_dimension = 1
    @important_nodes = []
  end

  def get_document_summary
    @nodes = Parser.parse @document
    @quota = (@nodes.count { |node| node.leaf? } * @comp_ratio).to_i
    set_and_print_rbss_fv_quota
    find_contributing_nodes
    gen_summary
    print_all_nodes
    print_summary
  end

  private

  def print_summary
    puts @summary.join(" ")
  end

  def set_and_print_rbss_fv_quota
    set_all_rbss
    # print_all_rbss
    set_fractal_values
    # print_all_fractal_values
    set_quota_values
    # print_all_quota_values
    print_sum_fv
    print_sum_quota
  end

  def print_all_nodes
    @nodes.each { |node| puts node }
  end

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
      elsif (node.rbss > 0) && (node.depth < 6)
        node.fv = node.parent.fv * @decay_rate * (node.rbss / sum_sibling_rbss(node))
      end
    end
  end

  def sum_sibling_rbss node, sum_rbss = 0
    @nodes.each { |sibling| sum_rbss += sibling.rbss if sibling.depth == node.depth }
    sum_rbss
  end

  def set_quota_values
    @nodes.each { |node| node.quota = (@quota * node.fv).round if node.fv != 0 }
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

  def find_contributing_nodes(node = @nodes.first)
    if node.quota < @threshold
      @important_nodes << node
    elsif node.children.select { |child| child.quota > 0 }.length > 0
      @important_nodes << node      
    else
      node.children.each { |child| find_contributing_nodes(child) }
    end
  end

  def gen_summary
    @summary = []
    @important_nodes.each { |node| @summary += return_top_sentences(node).first(node.quota) }
    @summary.reject!(&:empty?)
    p "Sentences in @summary: #{@summary.length}"
  end

  def return_top_sentences node
    all_sentence_nodes = Algorithm.range_block_sentences node
    all_sentence_nodes.map! do |sentence|
      { content: sentence.content, fss: Algorithm.fractal_sentence_score(sentence) }
    end
    all_sentence_nodes.sort_by! { |sentence| sentence[:fss] }
    all_sentence_nodes.map { |sentence| sentence[:content] }
  end
end
