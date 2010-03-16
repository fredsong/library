module IsbnLookup
  # TODO: add support for ISBNDB which has better results, but no images
  require 'amazon/aws'
  require 'amazon/aws/search'
  def self.lookup isbn
    isbn.gsub!(/[-\s]/, '')
    il = Amazon::AWS::ItemLookup.new('ASIN', {'ItemId' => isbn})
    rg = Amazon::AWS::ResponseGroup.new('Medium')
    req = Amazon::AWS::Search::Request.new
    resp = req.search(il, rg)

    getattr = [:title, :author, :publisher, :edition]

    item = resp.item_lookup_response[0].items[0].item
    attr = item.item_attributes[0]

    # HACK! just grab a review as summary. TODO: something smarter.
    review = CGI.unescape_html(item.editorial_reviews[0].editorial_review[0].content[0].to_s) rescue nil

    cover_url = item.large_image[0].url.to_s rescue nil

    book = {:summary => review, :cover_url => cover_url}
    getattr.each do |a|
      book[a] = attr.send(a)[0].to_str rescue nil
    end

    return book
  end
end
