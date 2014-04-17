require 'nokogiri'
# require_relative '../models/treenode'

module Parser

  def self.parse file
    @file = file
    gen_xml
    read_document
  end

  private

  def gen_xml
    # @doc = Nokogiri::XML(File.open(@file))
    @reader = Nokogiri::XML::Reader(File.open(@file))
  end

  def read_document

    @reader.each do |node|

      if (node.inner_xml != "") && (node.inner_xml != "Contents")

        case node.name
        when 'h1'
          str = "Title: #{node.inner_xml.match(/[ \w]+(?=<\/span>)/)}" + "\n"
          puts str
        when 'h2'
          break if node.inner_xml.match(/(See also<\/span>)/)
          str = " " * 5 + "Chapter: #{node.inner_xml.match(/[ \w]+(?=<\/span>)/)}" + "\n"
          puts str
        when 'h3'
          str = " " * 10 + "Section: #{node.inner_xml.match(/[ \w]+(?=<\/span>)/)}" + "\n"
          puts str
        when 'h4'
          str = " " * 15 + "Sub Section: #{node.inner_xml.match(/[ \w]+(?=<\/span>)/)}" + "\n"
          puts str
        when 'p'
          # str = " " * 20 + "Paragraph: #{node.inner_xml}" + "\n"
          str = " " * 20 + "Paragraph: lots of words here..." + "\n"
          puts str
        end

      end
    end
  end

  # def gen_title
  #   puts "title"
  #   @doc.search('h1.firstHeading').each do |heading|
  #     p heading.content
  #   end
  #   puts "----------------------"
  # end

  # def gen_sections1
  #   puts "Major Section Headers"
  #   @doc.search('h2 > span.mw-headline').each do |section|
  #     p section.content
  #   end
  #   puts "----------------------"
  # end

  # def gen_sections2
  #   puts "Minor Section Headers"
  #   @doc.search('h3 > span.mw-headline').each do |section|
  #     p section.content
  #   end
  #   puts "----------------------"
  # end

  # def gen_sections3
  #   puts "Sub Section Headers"
  #   @doc.search('h4 > span.mw-headline').each do |section|
  #     p section.content
  #   end
  #   puts "----------------------"
  # end

end

