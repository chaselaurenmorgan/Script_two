require 'selenium-webdriver'
require 'gmail'

@urls = []
@email_body = " "

inFile = File.open("urls.txt")


while line = inFile.gets
  @urls << line.to_s.chomp
end


for test_urls in @urls
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

 @email_body +=@email_body


end
puts @email_body


  @gmail = Gmail.connect('username', 'password')
  email = @gmail.compose do
    puts @email_body
    to 'username@yahoo.com'
    subject 'Second Script'
    body "Here is your data #{@email_body}"

  end
  email.deliver!

driver.quit












