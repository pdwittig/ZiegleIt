require_relative '../config/application'

module Algorithm

  # tfid = term frequency times inverse document frequency
  # tf = term frequency
  # N = number of range blocks in the document (of same depth)
  # n = number of range blocks in document where term occurs (of same depth)
  # tl = term length

  def self.range_block_sentence_score nodes
    @nodes = nodes
  end

  def self.calculate_tfid term, range_block, nodes
    @nodes = nodes
    args = get_variable_values term, range_block
    quotient = (args[:N] * args[:tl]).to_f / args[:n]
    args[:tf] * Math.log(quotient, 2)
  end

  def self.get_variable_values term, range_block
    args = {  :N => range_blocks_in_document(range_block),
              :n => range_blocks_with_term(term, range_block),
              :tl => term.length,
              :tf => term_frequency(term, range_block)}
  end

  def self.range_blocks_in_document range_block
    @nodes.count { |node| node.depth == range_block.depth }
  end

  def self.range_blocks_with_term term, range_block

    range_blocks_with_term = 0
    @nodes.each do |node|
      if term_in_range_block?(term, node) && node.depth == range_block.depth
        range_blocks_with_term += 1
      end
    end
    range_blocks_with_term
  end

  def self.term_frequency term, range_block
    all_words_in_range_block(range_block).map(&:downcase).count(term.downcase)
  end

  def self.term_in_range_block? term, range_block
    (all_words_in_range_block range_block).include?(term)
  end

  def self.all_words_in_range_block range_block
    words = []
    if range_block.depth == 6
      return range_block.content if range_block.depth == 6
    else range_block.depth != 6
      range_block.children.each { |child| words << (all_words_in_range_block child) }
    end
    return words.flatten
  end
end
