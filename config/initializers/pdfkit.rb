PDFKit.configure do |config|
  config.wkhtmltopdf = '/app/vendor/bundle/bin/wkhtmltopdf'
  config.default_options = {
    :page_size => 'Legal',
    :print_media_type => true
  }
end
