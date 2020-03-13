require 'pry'


require 'nokogiri'
require 'open-uri'


class RuledMeScraper
    @@base_site = 'https://www.ruled.me/'

    # class methods
    def self.scrape_search(search_term, base=@@base_site)
        html_arr = [Nokogiri::HTML(open(base + "?s=#{search_term}"))]
        html = html_arr[0]
        page = 1
        while html.css('.pagination-next').length > 0 do
            page += 1
            html = Nokogiri::HTML(open(base + "page/#{page}/?s=#{search_term}"))
            html_arr << html
        end
        html_arr
    end

    def self.scrape_page(html)
        posts = html.css('.post')
        posts.collect do |post|
            {
                title: post.css('.entry-title-link').text,
                date_posted: post.css('.post-data ul li').first.text.strip,
                url: post.css('.entry-title-link')[0].attributes['href'].value
            }
        end
    end

    def self.scrape_recipe(url)
        content = Nokogiri::HTML(open(url)).css('#zlrecipe-innerdiv')[0]
        unless content.nil?
            summary = content.css('.summary').collect {|summary_p| summary_p.text}.join('\n')
            ingredients_css = content.css('#zlrecipe-ingredients-list')[0]
            recipe = {}
            label = nil
            for entry in ingredients_css.children do
                klass = entry.attributes['class'].value
                if klass.include?('ingredient-label')
                    label = entry.text.to_sym
                    recipe[label] = []
                elsif klass.include?('ingredient')
                    unless label.nil?
                        recipe[label] << entry.text.gsub('Â', '')
                    end
                end
            end
            recipe
        end
    end

    def self.is_recipe?(url)
        recipe = scrape_recipe(url)
        !recipe.nil? && recipe.length > 0
    end

end