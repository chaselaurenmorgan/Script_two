#require 'selenium-webdriver'
#require 'gmail'

 # @urls = "test_url"
 # @urls << test_url.to_s.chomp

#puts "#{test_url}"
#driver = Selenium::WebDriver.for :chrome
#driver.navigate.to "https://www.webpagetest.org/"
#driver.find_element(:id, "url").send_keys("#{@urlsl}")
#driver.find_element(:class, "start_test").click


#wait = Selenium::WebDriver::Wait.new(:timeout => 60)
#wait.until { driver.find_element(:id => "LoadTime") }

#  driver.find_element(:id, 'LoadTime').text
#  driver.find_element(:id, 'TTFB').text

#  puts driver.find_element(:id, "LoadTime").text
#  puts driver.find_element(:id, 'TTFB').text

#  load_time = driver.find_element(:id, "LoadTime").text
#  time_to_first_byte = driver.find_element(:id, "TTFB").text
#  x += 1

#end

#  gmail = Gmail.connect('username', 'password')
#  email = gmail.compose do
#    to "@gmail.com"
#    subject "First Testing Script"
#    body "Values are #{time_to_first_byte}(TTFB) and #{load_time}(LoadTime)
#    from the #{@urls}"
#end
#email.deliver!
#sleep 5
