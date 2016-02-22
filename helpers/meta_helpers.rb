require 'pathname'
require 'date'

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

    def campaign_link(article)
      campaign_page = sitemap.find_resource_by_destination_path(article.data.campaign)
      campaign_info = campaign_page.data
      return if !campaign_info
      end_date = no_time(campaign_info["end_date"])
      start_date = no_time(campaign_info["start_date"])
      now = no_time(Date.today)
      if (now <= end_date && now >= start_date)
        return link_to("Donate", campaign_info["donation_link"], :class => "donate")
      else
        return link_to(campaign_info["name"], campaign_page.url, :class => "campaign")
      end
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
