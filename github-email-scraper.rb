# awesome code forthcoming
require 'rubygems'
require 'watir-webdriver'

b = Watir::Browser.new :firefox
page = 1
url = "https://github.com/search?q=location%3ABuffalo%2CNY+location%3ASyracuse%2CNY+location%3ARochester%2CNY+location%3AAlbany%2CNY+location%3ABinghamton%2CNY+location%3AIthaca%2CNY&type=Users&s=followers&p=#{page}"
b.goto url
count_text = b.div(class: 'sort-bar').h3.text
count = count_text.scan(/\d/).join.to_i

num_pages = (count / 10.0).ceil

emails = []

1.upto(num_pages).each do |page|
	b.driver.manage.timeouts.implicit_wait = 10
	url = "https://github.com/search?q=location%3ABuffalo%2CNY+location%3ASyracuse%2CNY+location%3ARochester%2CNY+location%3AAlbany%2CNY+location%3ABinghamton%2CNY+location%3AIthaca%2CNY&type=Users&s=followers&p=#{page}"
	b.goto url
	links = b.links class: 'email'
	links.each do |l|
		emails << l.text
	end
	puts emails.count	
end

puts emails.count

