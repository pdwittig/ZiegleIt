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
    @quota = (@nodes.count { |node| node.leaf? } * @comp_ratio).to_i
    set_and_print_rbss_fv_quota
    gen_summary find_contributing_nodes
    print_all_nodes
    print_summary
  end

  private

  def print_summary
    @summary.map! { |sentence| sentence.flatten.join(" ") }
    sum = @summary.join(". ") + "."
    puts sum
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

  def find_contributing_nodes
    @important_nodes = []
    @nodes.each do |node|
      if (node.parent != nil) && (node.parent.quota > @threshold) && (node.quota < @threshold) && (node.quota > 0)
          @important_nodes << node
      elsif (node.parent != nil) && (node.quota == 0)
          @important_nodes << node.parent
      end
    end
    @important_nodes.uniq!
    # p "Number of important_nodes: #{@important_nodes.length}"
    # p "Number of important sentences: #{num_important_sentences}"
    # @important_nodes.each { |node| puts node }
    @important_nodes
  end

  # def num_important_sentences
  #   num = 0
  #   @important_nodes.each { |node| num += node.quota }
  #   num
  # end

  def gen_summary important_nodes
    @summary = []
    important_nodes.each { |node| @summary << return_top_sentences(node).first(node.quota) }
    @summary.reject(&:empty?)
    p "Sentences in @summary: #{@summary.length}"
    @summary
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
