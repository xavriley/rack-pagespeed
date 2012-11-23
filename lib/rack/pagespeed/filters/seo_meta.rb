require 'summarize'

class Rack::PageSpeed::Filters::SeoMeta < Rack::PageSpeed::Filter
  name      'seo_meta'
  requires_store
  priority 2
  
  def execute! document
    @options[:title] ||= "%{h1}"
    @options[:meta_desc] ||= "%{body}"
    @options[:meta_keywords] ||= "%{body}"

    title_format = (@options[:meta_title] || "%{h1}")

    title_format.gsub!(/%{([^\}]+)}/) do 
      "#{document.css($1).first.try(:'text')}"
    end

    if 
      doc_title = document.css('title').first 
    else 
      doc_title = Nokogiri::XML::Element.new('title', document)
      document.at('head').children.first.before doc_title
    end
    doc_title.content = title_format

    description_selector = @options[:meta_desc]
    body_text = description_selector.gsub!(/%{([^\}]+)}/) do 
      "#{document.css($1).first.try(:'inner_text')}".gsub(/\s+/, ' ')
    end

    new_meta_desc_text = body_text.summarize(:ratio => 10)
    if 
      meta_desc = document.css("meta[name='description']").first
    else
      meta_desc = Nokogiri::XML::Element.new('meta', document)
      meta_desc['name'] = "description"
      document.at('head').children.first.after meta_desc
    end
    meta_desc['content'] = new_meta_desc_text

    keyword_selector = @options[:meta_keywords]
    new_meta_keywords_text = keyword_selector.gsub!(/%{([^\}]+)}/) { 
      "#{document.css($1).first.try(:'inner_text')}".gsub(/\s+/, ' ')
    }.summarize(:topics => true)

    if 
      meta_keywords = document.css("meta[name='keywords']").first
    else
      meta_keywords = Nokogiri::XML::Element.new('meta', document)
      meta_keywords['name'] = "keywords"
      document.at('head').children[1].after meta_keywords
    end
    meta_keywords['content'] = new_meta_keywords_text.last.to_s

  end

end


