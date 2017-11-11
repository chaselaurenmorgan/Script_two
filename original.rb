require 'selenium-webdriver'
require 'gmail'
require 'yaml'


un_pw = YAML.load_file("un_pw.yaml")
username =  un_pw[:username]
password =  un_pw[:password]



@urls = []
email_body = " "

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

  email_body = email_body + "\n" + "Values are #{@time_to_first_byte}(TTFB) and #{@load_time}(LoadTime)
  from the #{test_urls}"


end
puts email_body


  @gmail = Gmail.connect("#{username}", "#{password}")
  email = @gmail.compose do
    to 'chasemorgan15@yahoo.com'
    subject 'Second Script'
    body "Here is your data: " + email_body



  end
  email.deliver!
sleep 45

driver.quit
