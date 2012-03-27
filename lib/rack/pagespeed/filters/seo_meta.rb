class Rack::PageSpeed::Filters::SeoMeta < Rack::PageSpeed::Filter
  requires_store
  name    'seo_meta'
  priority 2
  
  def execute! document
    nodes = document.css('h1')
    doc_title = document.css('title')
    return false unless nodes.count > 0
    doc_title.text = nodes.map{|h1| h1.text() }.join(' ')
  end
end
