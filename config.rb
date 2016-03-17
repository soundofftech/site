set :site_url, 'http://soundofftech.org/'
set :site_title, 'Sound Off'
set :photos_path, 'photos'

set :partials_dir, 'partials'

activate :directory_indexes

# Per-page layout changes:
#
# With no layout
page '/*.xml',  layout: false
page '/*.json', layout: false
page '/*.txt',  layout: false

# Disable directory_index for 404 page
page '/error.html', directory_index: false

# CAMPAIGNS
campaign_templates = Dir['source/campaigns/*.markdown']

campaign_templates.map! do |tpl_name|
  tpl_name = File.basename(tpl_name).gsub(/.markdown$/, '')
end

###
# Helpers and extensions
###

Time.zone = 'Pacific Time (US & Canada)'

###
# Blog settings
###

activate :blog do |blog|
  blog.permalink = 'blog/{year}/{month}/{title}.html'
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

activate :s3_sync do |s3_sync|
  s3_sync.bucket                     = 'www.soundofftech.org' # The name of the S3 bucket you are targeting. This is globally unique.
  s3_sync.region                     = 'us-east-1'     # The AWS region for your bucket.
  s3_sync.delete                     = true # We delete stray files by default.
  s3_sync.after_build                = false # We do not chain after the build step by default.
  s3_sync.prefer_gzip                = true
  s3_sync.path_style                 = true
  s3_sync.reduced_redundancy_storage = false
  s3_sync.acl                        = 'public-read'
  s3_sync.encryption                 = false
  s3_sync.prefix                     = ''
  s3_sync.version_bucket             = false
  s3_sync.index_document             = 'index.html'
  s3_sync.error_document             = 'error.html'
end