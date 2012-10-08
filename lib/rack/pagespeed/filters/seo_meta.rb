require 'summarize'

class Rack::PageSpeed::Filters::SeoMeta < Rack::PageSpeed::Filter
  name      'seo_meta'
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

    body_text = document.css('.content_main').inner_text
    new_meta_desc = body_text.summarize(:ratio => 10)
    new_meta_keywords = body_text.summarize(:topics => true)
    meta_desc = document.css("meta[name='description']")

    binding.pry
  end

end


