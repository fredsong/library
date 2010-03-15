class GeneralController < ApplicationController
  def index
    @tag_counts = Tag.tags_with_counts
  end
end
