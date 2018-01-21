require 'selenium-webdriver'
require 'open-uri'
require 'gmail'
require 'crack'
require 'yaml'


un_pw = YAML.load_file("un_pw.yaml")
username =  un_pw["username"]
password =  un_pw["password"]

#puts "This is the username: " + username



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




#grab url 
result_url =  driver.current_url
#puts 'this is url ' + result_url 


#change the url use .gsub
 result_url.gsub!("/result/","/xmlResult/")
 puts result_url
 
 #sending request
 xml = URI.parse(result_url)
 xml = open(result_url).read


#reading server response 
xml.read

#parse the response with crack 

document = Crack::XML.parse(xml)['response']['statusCode']


puts  document


#xml_url = "https://www.webpagetest.org/xmlResult/180120_RC_42bb8809db7b1d43dfa17e83eb752e7a/"
#sending request
#xml = URI.parse(xml_url)
#xml = open(xml_url).read

#reading server response 
#xml.read 



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
