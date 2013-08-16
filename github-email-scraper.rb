require 'rubygems'
require 'watir-webdriver'
require 'csv'

# Create a new instance of the browser
b = Watir::Browser.new :firefox
# Start with page one of the search results
page = 1
url = "https://github.com/search?q=location%3ABuffalo%2CNY+location%3ASyracuse%2CNY+location%3ARochester%2CNY+location%3AAlbany%2CNY+location%3ABinghamton%2CNY+location%3AIthaca%2CNY&type=Users&s=followers&p=#{page}"
# go to the search webpage
b.goto url
# Grab the count that displays the total number of results
count_text = b.div(class: 'sort-bar').h3.text
# Parse out the string so it returns an integer
count = count_text.scan(/\d/).join.to_i
# Get the number of pages (10 results per page)
num_pages = (count / 10.0).ceil
emails = []

# Iterate through each page, grabs the emails from the page and adds them to the email array
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

# Save the email addresses to a csv
def save_emails(emails)
	puts "Saving email addresses to CSV"
	
	CSV.open("emails.csv", "w") do |csv|
		csv << emails
	end
end

save_emails(emails)

# TODO: Github restricts the number of requests you can make at once. Need to put a timeout or something

puts emails.count

