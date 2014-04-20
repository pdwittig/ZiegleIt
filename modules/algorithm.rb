require_relative '../config/application'

module Algorithm

  # tfid = term frequency times inverse document frequency
  # tf = term frequency
  # N = number of range blocks in the corpus
  # n = number of range blocks in corpus where term occurs
  # tl = term length

  def self.range_block_sentence_score nodes
    @nodes = nodes
  end

  def self.calculate_tfid term, range_block, nodes
    args = get_variable_values term, range_block, nodes
    quotient = (args[:N] * args[:tl]) / args[:n]
    tfid = args[:tf] * Math.log(quotient, 2)
    return tfid
  end

  def self.get_variable_values term, range_block
    args = {  :N => range_blocks_document,
              :n => range_blocks_corpus,
              :tl => term.length,
              :tf => term_frequency(term, range_block)}
  end

  def self.range_blocks_document
    @nodes.length
  end

  def self.range_blocks_corpus term, nodes
    @nodes = nodes
    range_blocks_with_term = 0
    @nodes.each do |range_block|
      range_blocks_with_term += 1 if term_in_range_block? term, range_block
    end
    range_blocks_with_term
  end

  def self.term_frequency term, range_block
    all_words = []
    all_sentences = range_block.select { |node| node.depth == 6 }
    all_sentences.each { |sentence| all_words << sentence.content }
    all_words.flatten!.map(&:downcase).count(term.downcase)
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