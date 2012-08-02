class Rack::PageSpeed::Filters::SeoMeta < Rack::PageSpeed::Filter
  requires_store
  priority 2
  
  def execute! document
    nodes = document.css('h1')
    doc_title = document.css('title').first
    return false unless nodes.count > 0
    new_title = doc_title.clone
    new_title.content = nodes.map{|h1| h1.text() }.join(' ')
    doc_title.before new_title
    doc_title.remove
  end
end


