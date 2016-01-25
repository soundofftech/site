require 'pathname'

module MetaHelpers
  def page_title
      title = site_title.dup
      if current_page.data.title
        title << " | #{current_page.data.title}"
      elsif is_blog_article?
        title << " | #{current_article.title}"
      end
      title
    end
    
    def no_time(date)
    	Date.new(date.year, date.month, date.day)
    end
    
    def campaign_info(article)
      sitemap.find_resource_by_destination_path(article.data.campaign).data
      # data.campaigns[article.data.campaign]
    end
    
    def author_info(article)
      data.authors[article.data.author]
    end
    
    def article_photos(article)
      if (article.data.photo)
        [Pathname.new('/').join(photos_path, article.data.photo)]
      elsif (article.data.photos)
        article.data.photos.map do |photo|
          Pathname.new('/').join(photos_path, photo)
        end
      else
        []
      end
    end
    
end
