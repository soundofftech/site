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
    
    def section_navigation(page)
      section = page.data["section"]
      return nil if !section

      # Find all other pages with the same path
      navigation_pages = sitemap.resources.select do |p|
        p.data["section"] == section
      end
      
      navigation_pages = navigation_pages.sort_by { |p| [(p.data["section_order"] || 0), p.data.title] }
    end
      
    def all_campaigns()
      return @all_campaigns if @all_campaigns
      @all_campaigns = sitemap.resources.select do |p|
        p.path.start_with?("campaign/")
      end
    end
    
    # Find the currently active campaign or nil if there isn't a currently active campaign
    def current_campaign()
      return @current_campaign if @current_campaign
      now = no_time(Date.today)

      all_campaigns().each do |campaign|
        campaign_info = campaign.data
        end_date = no_time(campaign_info["end_date"])
        start_date = no_time(campaign_info["start_date"])
        if (now <= end_date && now >= start_date)
          @current_campaign = campaign_info
          return @current_campaign
        end
      end
      
      return nil
    end
      
    def campaign_info(article)
      return if !article
      path = "campaign/#{article.data.campaign}"
      campaign_page = sitemap.find_resource_by_destination_path("campaign/#{article.data.campaign}")
      return if !campaign_page
      return campaign_page.data
    end

    def campaign_link(article)
      return if !article
      campaign_page = sitemap.find_resource_by_destination_path("campaign/#{article.data.campaign}")
      return if !campaign_page
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
