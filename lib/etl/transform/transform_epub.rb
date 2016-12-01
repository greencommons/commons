require 'epub/parser'

class TransformEpub
  def process(input_epub)
    @input_epub = input_epub

    {
      title: title,
      content: PageContentExtractor.new(parsed_book).start,
      metadata: {
        creators: creators,
        date: date,
        publisher: publisher,
      }
    }
  end

  private

  attr_reader :input_epub

  def title
    metadata.title
  end

  def creators
    metadata.creators.first.content
  end

  def date
    metadata.date.content
  end

  def metadata
    parsed_book.metadata
  end

  def publisher
    metadata.publishers&.first&.content
  end

  def parsed_book
    EPUB::Parser.parse(input_epub)
  end
end

class PageContentExtractor
  def initialize(parsed_book)
    @book_text = ''
    @parsed_book = parsed_book
  end

  def start
    parsed_book.each_page_on_spine do |page|
      print '.'
      parsed_xml = page.content_document.read
      page_plain = ActionView::Base.full_sanitizer.sanitize(parsed_xml)
      @book_text = (@book_text || '') + page_plain
    end

    @book_text
  end

  private

  attr_reader :parsed_book
end
