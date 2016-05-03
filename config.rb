set :site_url, 'http://soundofftech.org/'
set :site_title, 'Sound Off'
set :photos_path, 'photos'
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'
set :partials_dir, 'partials'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, footnotes: true, no_intra_emphasis: true

set :date_format, '%e %B %Y'

# Per-page layout changes:
#
# With no layout
page '/*.xml',  layout: false
page '/*.json', layout: false
page '/*.txt',  layout: false

# Disable directory_index for 404 page
page '/error.html', directory_index: false

Time.zone = 'Pacific Time (US & Canada)'

### Campaigns
# CAMPAIGNS
campaign_templates = Dir['source/campaign/*.markdown']

campaign_templates.map! do |tpl_name|
  tpl_name = File.basename(tpl_name).gsub(/.markdown$/, '')
  proxy "/campaign/#{tpl_name}/index.html", "/campaign/#{tpl_name}.html", :ignore => true, :layout => "campaign"
end

###
# Blog settings
###

activate :blog do |blog|
  blog.permalink = 'blog/{year}/{month}/{title}'
  blog.sources = 'blog/{year}-{month}-{day}-{title}'
  
  blog.layout = "article"
  blog.default_extension = ".markdown"

  # Enable pagination
  # blog.paginate = true
  # blog.per_page = 10
  # blog.page_link = "page/{num}"
end

# Reload the browser automatically whenever files change
# activate :livereload

activate :s3_sync do |s3_sync|
  s3_sync.bucket = 'soundofftech-org' # The name of the S3 bucket you are targeting. This is globally unique.
  s3_sync.region = 'us-west-2'     # The AWS region for your bucket.
  s3_sync.prefer_gzip = true
  # s3_sync.delete = false # We delete stray files by default.
  # s3_sync.after_build = false # We do not chain after the build step by default.
  # s3_sync.prefer_gzip = true
  # s3_sync.path_style = true
  # s3_sync.reduced_redundancy_storage = false
  # s3_sync.acl = 'public-read'
  # s3_sync.encryption = false
  # s3_sync.prefix = ''
  # s3_sync.version_bucket = false
  # s3_sync.index_document = 'index.html'
  # s3_sync.error_document = '404.html'
end

activate :cdn do |cdn|
  cloud_front_config = YAML.load_file(".s3_sync")
  
  cdn.cloudfront = {
      access_key_id: cloud_front_config["aws_access_key_id"],
      secret_access_key: cloud_front_config["aws_secret_access_key"],
      distribution_id: 'EBY7O415ZV0PJ'
    }
end

caching_policy 'text/html', max_age: (60*60*2), must_revalidate: true
caching_policy 'image/png', max_age: (60*60*24*365), public: true
caching_policy 'image/jpeg', max_age: (60*60*24*365), public: true
caching_policy 'image/gif', max_age: (60*60*24*365), public: true
caching_policy 'text/css', max_age: (60*60*24*365), public: true
caching_policy 'application/javascript', max_age: (60*60*24*365), public: true

after_s3_sync do |files_by_status|
  cdn_invalidate(files_by_status[:updated])
end

configure :development do
  # Reload the browser automatically whenever files change
  # activate :livereload
end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  activate :minify_css
  activate :minify_html
  activate :gzip
  
  # Minify JavaScript on build
  activate :minify_javascript
  activate :asset_hash
end

activate :directory_indexes

