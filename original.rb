require 'selenium-webdriver'
require 'gmail'


@urls = []
File.each("urls.txt").with_index do |line, line_num|

  @urls = line.to_s.chomp
  @line_num = line_num.to_i
  begin @urls
   puts "#{@line_num}: #{@urls}"

end

driver = Selenium::WebDriver.for :chrome
@email_body = " "



driver.navigate.to "https://www.webpagetest.org/"
driver.find_element(:id, "url").send_keys("#{@urls}")
driver.find_element(:class, "start_test").click


wait = Selenium::WebDriver::Wait.new(:timeout => 80)
wait.until { driver.find_element(:id => "LoadTime") }
wait.until { driver.find_element(:id => "TTFB") }

  driver.find_element(:id, 'LoadTime').text
  driver.find_element(:id, 'TTFB').text

  puts driver.find_element(:id, "LoadTime").text
  puts driver.find_element(:id, 'TTFB').text

  @load_time = driver.find_element(:id, "LoadTime").text
  @time_to_first_byte = driver.find_element(:id, "TTFB").text

@email_body = "Values are #{@time_to_first_byte}(TTFB) and #{@load_time}(LoadTime)
from the #{@urls}"

puts @email_body += 1.to_s

driver.quit
end

@email_body = "Values are #{@time_to_first_byte}(TTFB) and #{@load_time}(LoadTime)
from the #{@urls}"

@gmail = Gmail.connect('username', 'password')
  email = @gmail.compose do
    to 'username@yahoo.com'
  @line_num = 1
    if @line_num == 1
     subject 'Second Ruby Script!'
      body "Here is your data:" +@email_body
      puts ' email has been sent'
    else
      break
      end
  end
  email.deliver!


sleep 50
