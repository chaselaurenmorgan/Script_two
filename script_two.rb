require 'selenium-webdriver'
require 'gmail'


@urls = []
@email_body = " "
inFile = File.open("urls.txt")
@email_data = []



while line = inFile.gets
  @urls << line.to_s.chomp
end



for test_urls in @urls     #### I tried it with an each loop and got the same results
  driver = Selenium:: WebDriver.for :chrome
  driver.navigate.to "https://www.webpagetest.org/"
  driver.find_element(:id, "url").send_keys("#{test_urls}")
  driver.find_element(:class, "start_test").click

  wait = Selenium::WebDriver::Wait.new(:timeout => 80)
  wait.until { driver.find_element(:id => "LoadTime") }


  @load_time =  driver.find_element(:id, "LoadTime").text
  @time_to_first_byte = driver.find_element(:id, "TTFB").text

  @email_body = "Values are #{@time_to_first_byte}(TTFB) and #{@load_time}(LoadTime)
  from the #{test_urls}"
  driver.quit

  @email_body +=@email_body[0]  # This seems to repeat the email body twice and add to it but I can't get to
                                #to do the same when it is out side the loop
  @email_data << @email_body



end

  puts @email_data    #Doesn't keep the string from the loop it only repeats the last values of the
                                      # url.txt file

Gmail.connect!('username', 'password')
email = gmail.compose  do
  to "chasemorgan15@yahoo.com"
  subject "Having fun in Puerto Rico #{@email_data}!"
  body "Spent the day on the road..."
end
gmail.deliver(email)
