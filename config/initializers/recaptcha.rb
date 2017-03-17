Recaptcha.configure do |config|
  config.site_key  = ENV['RECAPTCHA_SITE_KEY']
  config.secret_key = ENV['RECAPTCHA_SECRET_KEY']
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end
#Recaptcha.configure do |config|
  #config.site_key = '6LeeVxkUAAAAAH_8cbwy9-IY-_BNsAvOCIrnQuyk'
  #config.secret_key = '6LeeVxkUAAAAAPFtJVg_RtwogcVzJJ2Ld6HRvAPu'
#end
