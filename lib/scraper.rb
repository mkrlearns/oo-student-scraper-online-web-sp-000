require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = []

    doc.css('.student-card').each do |student|
      name = student.css('.student-name').text
      location = student.css('.student-location').text
      profile_url = student.css('a').attribute('href').value
      student_info = { name: name, location: location, profile_url: profile_url }
      students << student_info
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student = {}

    social_icon_container = doc.css(".social-icon-container a").collect { |a| a.attribute("href").value }

    social_icon_container.each do |link|
      if link.include?("twitter") student[:twitter] = link
      elsif link.include?("linkedin") student[:linkedin] = link
      elsif link.include?("github") student[:github] = link
      else student[:blog] = link
      end
    end

    student[:bio] = doc.css('.description-holder p').text
    student[:profile_quote] = doc.css('.profile-quote').text
    student
  end

end

