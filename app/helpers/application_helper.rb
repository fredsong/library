module ApplicationHelper
  def tag_cloud tag_counts, minsize = 12.0, maxsize = 45.0
    counts = tag_counts.map &:second
    min_count = counts.min
    max_count = counts.max
    spread = max_count - min_count
    spread = 1 if spread.zero?

    ret = ""
    tag_counts.each do |tag, count|
      size = minsize+(count - 1)*(maxsize-minsize)/spread
      ret << link_to(tag.name, tag, :style => "font-size: #{size.to_i}px")
    end
    ret.html_safe
  end
end
