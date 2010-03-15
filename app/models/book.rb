require 'open-uri'

class Book < ActiveRecord::Base
  attr_accessor :cover_url
  has_attached_file :cover, :styles => { :small  => "150x250>" }

  has_many :taggings
  has_many :tags, :through => :taggings, :dependent => :destroy

  after_save :assign_tags  
  attr_writer :tag_names  
  def tag_names
      @tag_names || tags.map(&:name).join(' ')
  end

  def slug
    slug = title.strip

    #blow away apostrophes
    slug.gsub! /['`]/,""

    # @ --> at, and & --> and
    slug.gsub! /\s*@\s*/, " at "
    slug.gsub! /\s*&\s*/, " and "

    #replace all non alphanumeric, underscore or periods with underscore
    slug.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '_'  

    #convert double underscores to single
    slug.gsub! /_+/,"_"

    #strip off leading/trailing underscore
    slug.gsub! /\A[_\.]+|[_\.]+\z/,""

    "#{id}-#{slug}"
  end

  def to_param
    slug
  end

  def copies_remaining
    copies
  end

  private

  def upload_url
    unless cover_url.blank?
      uri = URI.parse cover_url
      file = uri.open
      #TODO this is a HACK
      instance_eval <<-EOF
      def file.original_filename
        '#{File.basename uri.path}'
      end
      EOF
      cover.assign file
    end
  end
  before_validation :upload_url

  validates_attachment_presence :cover

  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/\s+/).map do |name|
        Tag.find_or_create_by_name(name)
      end  
    end  
  end  

  validates_numericality_of :copies, :greater_than => 0, :only_integer => true
  validates_uniqueness_of :isbn
  validates_presence_of :title
  validates_presence_of :author
end
