set :site_url, 'http://soundofftech.org/'
set :site_title, 'Sound Off'
set :photos_path, 'photos'

set :partials_dir, 'partials'

# Per-page layout changes:
#
# With no layout
page '/*.xml',  layout: false
page '/*.json', layout: false
page '/*.txt',  layout: false

# Disable directory_index for 404 page
page '/error.html', directory_index: false

# Rename /about.html to just /about
proxy "/about", "/about.html", :ignore => true

# CAMPAIGNS
campaign_templates = Dir['source/campaigns/*.markdown']

campaign_templates.map! do |tpl_name|
  tpl_name = File.basename(tpl_name).gsub(/.markdown$/, '')
  proxy "/#{tpl_name}", "/campaigns/#{tpl_name}.html", :ignore => true, :layout => "campaign"
end

###
# Helpers and extensions
###

Time.zone = 'Pacific Time (US & Canada)'

###
# Blog settings
###

activate :blog do |blog|
  blog.permalink = 'blog/{year}/{month}/{title}'
  blog.sources = 'blog/{year}-{month}-{day}-{title}.html'
  
  blog.layout = "article"
  blog.default_extension = ".markdown"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

# caching_policy 'text/html', max_age: (60*60*2), must_revalidate: true
# caching_policy 'image/png', max_age: (60*60*24*365), public: true
# caching_policy 'image/jpeg', max_age: (60*60*24*365), public: true
# caching_policy 'image/gif', max_age: (60*60*24*365), public: true
# caching_policy 'text/css', max_age: (60*60*24*365), public: true
# caching_policy 'application/javascript', max_age: (60*60*24*365), public: true

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, footnotes: true, no_intra_emphasis: true

set :photos_path, 'photos'
set :date_format, '%e %B %Y'

# Reload the browser automatically whenever files change
# activate :livereload

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

configure :development do
  # Reload the browser automatically whenever files change
  # activate :livereload
end

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end
