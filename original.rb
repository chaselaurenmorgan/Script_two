require 'selenium-webdriver'
require 'open-uri'
require 'gmail'
require 'crack'
require 'yaml'


un_pw = YAML.load_file("un_pw.yaml")
username =  un_pw["username"]
password =  un_pw["password"]




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
 xml_result = result_url.gsub!("/result/","/xmlResult/")
 puts  xml_result

 #sending request
 xml = open(xml_result).read


#parse the response with crack 

@document_loadtime = Crack::XML.parse(xml)['response']['data']['average']['firstView']['loadTime']
@document_ttfb = Crack::XML.parse(xml)['response']['data']['average']['firstView']['TTFB']

#output the load time and the TTFB 
puts @document_loadtime
puts @document_ttfb



email_body = email_body + "\n" + "Values are #{@document_ttfb}(TTFB) and #{@document_loadtime}(LoadTime)
from #{test_urls}"


end
puts email_body




  @gmail = Gmail.connect("#{username}", "#{password}")
  email = @gmail.compose do
    to 'joshuakempcoaching@gmail.com'
    subject 'API Script'
    body "Here is your data: " + email_body



  end
  email.deliver!
sleep 45

driver.quit
