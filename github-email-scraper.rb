require 'rubygems'
require 'watir-webdriver'
require 'csv'

# Create a new instance of the browser
b = Watir::Browser.new :firefox
# Start with page one of the search results
page = 1

# If no cmd line argument, use default URL
if ARGV.empty?
	url_input = "https://github.com/search?q=location%3ABuffalo%2CNY+location%3ASyracuse%2CNY+location%3ARochester%2CNY+location%3AAlbany%2CNY+location%3ABinghamton%2CNY+location%3AIthaca%2CNY&type=Users&s=followers"
# Use the first URL the user passes in
else 
	puts "Note: only accepts one argument"
	input = ARGV[0]
	# Create duplicate so as not to modify the original object 
	url_input = input.dup
end

# go to the search webpage
b.goto url_input
# Grab the count that displays the total number of results
count_text = b.div(class: 'sort-bar').h3.text
# Parse out the string so it returns an integer
count = count_text.scan(/\d/).join.to_i
# Get the number of pages (10 results per page)
num_pages = (count / 10.0).ceil
emails = []

# Save the email addresses to a csv
def save_emails(emails)
	CSV.open("emails.csv", "w") do |csv|
		csv << emails
	end
end

# Iterate through each page, grabs the emails from the page and adds them to the email array
1.upto(num_pages).each do |page|
	b.driver.manage.timeouts.implicit_wait = 10
	url = url_input << "&p=#{page}"
	puts url
	b.goto url
	links = b.links class: 'email'
	links.each do |l|
		emails << l.text
		emails.uniq
	end
	puts emails.count
	puts emails.inspect
	save_emails(emails)

	# TODO: I'm assuming there's a more elegant way to do this?
	sleep 10
end