class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :books, :through => :taggings

  def self.tags_with_counts
    Tagging.joins(:tag).group(:tag).count
  end
  def to_param
    return name
  end
end
