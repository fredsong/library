class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :books, :through => :taggings

  def tags_with_count
    Tagging.joins(:tag).group(:tag).count
  end
end
