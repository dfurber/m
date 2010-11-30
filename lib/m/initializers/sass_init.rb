Sass::Plugin.options[:template_location] = { 'app/stylesheets' => 'public/stylesheets' }

if Rails.env == 'development'
  Sass::Plugin.options[:debug_info] = true
elsif Rails.env == 'production'
  Sass::Plugin.options[:style] = :compressed
  Sass::Plugin.options[:no_cache] = true
end