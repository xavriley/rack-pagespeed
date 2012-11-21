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

    body_text = document.css('#main').inner_text.gsub(/\s+/, ' ')

    new_meta_desc_text = body_text.summarize(:ratio => 10)
    meta_desc = document.css("meta[name='description']").first
    new_meta_desc = meta_desc.clone
    new_meta_desc['content'] = new_meta_desc_text
    meta_desc.before new_meta_desc
    meta_desc.remove

    new_meta_keywords_text = body_text.summarize(:topics => true)
    meta_keywords = document.css("meta[name='keywords']").first
    meta_keywords ||= Nokogiri::XML::Element.new('meta', document)
    meta_keywords['name'] = "keywords"
    meta_keywords['content'] = new_meta_keywords_text.last.to_s

    new_meta_keywords = meta_keywords.clone
    new_meta_keywords['content'] = new_meta_keywords_text.last.to_s
    new_title.after new_meta_keywords
    meta_keywords.remove

  end

end


