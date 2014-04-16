require 'nokogiri'
# require_relative '../models/treenode'

module Parser

  def self.parse file
    @file = file
    gen_xml
    gen_title
    gen_sections1
    gen_sections2
    gen_sections3
    puts "----------------------------------------"
    # step_through
    get_body_node
  end

  private

  def gen_xml
    @doc = Nokogiri::XML(File.open(@file))
    @reader = Nokogiri::XML::Reader(File.open(@file))
  end

  def gen_title
    puts "title"
    @doc.search('h1.firstHeading').each do |heading|
      p heading.content
    end
    puts "----------------------"
  end

  def gen_sections1
    puts "Major Section Headers"
    @doc.search('h2 > span.mw-headline').each do |section|
      p section.content
    end
    puts "----------------------"
  end

  def gen_sections2
    puts "Minor Section Headers"
    @doc.search('h3 > span.mw-headline').each do |section|
      p section.content
    end
    puts "----------------------"
  end

  def gen_sections3
    puts "Sub Section Headers"
    @doc.search('h4 > span.mw-headline').each do |section|
      p section.content
    end
    puts "----------------------"
  end

  def get_body_node
    @reader.each do |node|
      if node.name == 'h4' && node.inner_xml != ""
        # p node.methods-Object.methods
        # p node.inner_xml
        p node.depth
      end
    end
  end

  def step_through
    @reader.each do |node|
      puts node.value
      # xml.each do |attrib|
      #   p attrib.name
      # end


      # case xml
      # when search('h2 > span.mw-headline')
      #   puts "h2 span"
      # when 'h3 > span.mw-headline'
      #   puts "h3 span"
      # end
    end
  end

end

