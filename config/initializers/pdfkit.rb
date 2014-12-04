PDFKit.configure do |config|
  config.wkhtmltopdf = '/Users/adrianbrucecunanan/.rvm/gems/ruby-2.0.0-p481/bin/wkhtmltopdf'
  config.default_options = {
    :page_size => 'Letter',
    :print_media_type => true,
  }
end
