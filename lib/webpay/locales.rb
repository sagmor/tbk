if defined? I18n
  I18n.load_path += Dir[File.expand_path("../locales/*.yml", __FILE__)]
end
