class TagsController < ApplicationController
  def show
    @tag = Tag.where('name'=>params[:id]).first
    @books = @tag.books

    respond_to do |format|
      format.html
      format.xml  { render :xml => @books }
    end
  end
end
