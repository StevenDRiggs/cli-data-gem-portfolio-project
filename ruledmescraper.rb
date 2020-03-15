require 'pry'


require 'nokogiri'
require 'open-uri'

require_relative 'ketorecipes.rb'


class RuledMeScraper
    BASE_SITE = 'https://www.ruled.me/'

    # class methods
    def self.search(search_term, base=BASE_SITE)
        html_arr = [Nokogiri::HTML(open(base + "?s=#{search_term}"))]
        html = html_arr[0]
        page = 1
        while html.css('.pagination-next').length > 0 do
            page += 1
            html = Nokogiri::HTML(open(base + "page/#{page}/?s=#{search_term}"))
            html_arr << html
        end
        html_arr.each {|page| scrape_page(page)}
        return
    end

    def self.scrape_page(html)
        posts = html.css('.post')
        posts.each {|post| scrape_recipe(url=post.css('.entry-title-link')[0].attributes['href'].value, date_posted=post.css('.post-data ul li').first.text.strip)}
        return
    end

    def self.scrape_recipe(url, date_posted)
        content = Nokogiri::HTML(open(url)).css('#zlrecipe-innerdiv')[0]
        unless content.nil?
            name = content.css('#zlrecipe-title').text.gsub('Â', '')

            ingredients = content.css('#zlrecipe-ingredients-list').children.collect {|li| li.text.gsub('Â', '')}
            instructions = content.css('#zlrecipe-instructions-list').children.collect {|li| li.text.gsub('Â', '')}
            nutrition_facts = content.css('tbody').children.collect {|tr| tr.collect {|td| td.text.gsub('Â', '')}}
            notes = content.css('.notes').first.text.gsub('Â', '') unless content.css('.notes').first.nil?
            summary = content.css('.summary').collect {|summary_p|
                unless summary_p.nil?
                    summary_p.text.gsub('Â', '')
                end
            }.join('\n')
            prep_time = content.css('#zlrecipe-prep-time span').first.text.gsub('Â', '') unless content.css('#zlrecipe-prep-time span').nil?
            cooking_time = (content.css('#zlrecipe-total-time span').first.text.to_i - content.css('#zlrecipe-prep-time span').first.text.to_i).to_s unless content.css('#zlrecipe-total-time span').first.nil? || content.css('#zlrecipe-prep-time span').first.nil?

            unless ingredients.nil? || instructions.nil?
                recipe = Recipe.new(
                    name: name,
                    date_posted: date_posted,
                    url: url,
                    ingredients: ingredients,
                    instructions: instructions,
                    nutrition_facts: nutrition_facts,
                    notes: notes,
                    summary: summary,
                    prep_time: prep_time,
                    cooking_time: cooking_time
                )
            end
        end
        return
    end

end