require 'selenium-webdriver'
require 'gmail'
require 'pry'

@urls = []
@email_body = " "
@email_data = []
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
  driver.quit

  @email_body +=@email_body[0]
  @email_data.push(@email_body)

end

@email_body = @email_data.each



  @gmail = Gmail.connect('username', 'password')
  email = @gmail.compose do
    puts @email_body
    to 'chasemorgan15@yahoo.com'
    subject 'Second Script'
    body "Here is your data #{@email_body}"

  end
  email.deliver!












