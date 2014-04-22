require_relative '../config/application'

# tfid = term frequency times inverse document frequency
# tf = term frequency
# N = number of range blocks in the document (of same depth)
# n = number of range blocks in document where term occurs (of same depth)
# tl = term length
# fss = fractal sentence score

module Algorithm
  def self.range_block_sentence_score range_block, nodes
    @nodes, @range_block, rbss = nodes, range_block, 0
    sentences = range_block_sentences range_block
    sentences.each { |sentence| rbss += fractal_sentence_score(sentence) }
    rbss
  end

  ##note##Combine this method with all_words method ##note##
  def self.range_block_sentences range_block
    sentences = []

    if range_block.depth == 6
      return range_block
    else
      range_block.children.each { |child| sentences << (range_block_sentences child) }
    end

    sentences.flatten
  end

  def self.fractal_sentence_score sentence
    fss = 0
    sentence.content.each { |term| fss += calculate_tfid term }
    fss
  end

  def self.calculate_tfid term
    @term = term
    args = get_variable_values
    quotient = (args[:N] * args[:tl]).to_f / args[:n]
    args[:tf] * Math.log(quotient, 2)
  end

  def self.get_variable_values
    { N: range_blocks_in_document,
      n: range_blocks_with_term,
      tl: @term.length,
      tf: term_frequency }
  end

  def self.range_blocks_in_document
    @nodes.count { |node| node.depth == @range_block.depth }
  end

  def self.range_blocks_with_term
    range_blocks_with_term = 0

    @nodes.each do |node|
      if term_in_range_block?(node) && node.depth == @range_block.depth
        range_blocks_with_term += 1
      end
    end

    range_blocks_with_term
  end

  def self.term_frequency
    all_words_in_range_block(@range_block).map(&:downcase).count(@term.downcase)
  end

  def self.term_in_range_block? range_block
    (all_words_in_range_block range_block).include?(@term)
  end

  def self.all_words_in_range_block range_block
    words = []

    if range_block.depth == 6
      return range_block.content if range_block.depth == 6
    else
      range_block.children.each { |child| words << (all_words_in_range_block child) }
    end

    words.flatten
  end
end
