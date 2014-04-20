require_relative '../config/application'

class Summary
  def initialize document
    @document = document
  end

  def get_document_summary
    @nodes = Parser.parse @document
    p Algorithm.range_block_sentence_score @nodes[1], @nodes
  end

end