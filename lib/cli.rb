require_relative 'ruledmescraper.rb'


class KetoRecipesCLI
    def initialize
        puts
        puts 'Welcome to the ruled.me Keto Web Scraper!'
        puts 'This app will allow you to search ruled.me'
        puts 'for all recipes including a specified ingredient'
        puts 'and view details of said recipes, without all the'
        puts 'distracting images and additional links and info.'
        puts
        puts "You may type 'exit' 'quit' or 'q' at any time to quit."
        puts
        puts 'What ingredient would you like to search for?'
        
        input = gets.chomp.strip.downcase
        while input != 'exit' && input != 'quit' && input != 'q' do
            puts
            puts "Searching for #{input}..."
            puts 'This may take a few minutes.'

            Recipe.delete_all
            RuledMeScraper.search(input)

            puts
            puts 'Found these results:'
            recipes = Recipe.all.each_with_index {|recipe, i| puts "#{i + 1}.  #{recipe.name}"}
            
            puts
            puts 'What would you like to do?'
            puts 'I accept:'
            puts '    search again'
            puts '    detail(s) <item number>'
            puts '    exit/quit/q'

            input = gets.chomp.strip.downcase

            if input.start_with?('detail')
                recipe_detail(recipes[input.split[1].to_i - 1])
                puts
                puts 'What ingredient would you like to search for?'
                input = gets.chomp.strip.downcase
            elsif input == 'search again'
                puts
                puts 'What ingredient would you like to search for?'
                input = gets.chomp.strip.downcase
            end
        end

        quit_app
    end

    def quit_app
        puts
        puts 'Thank you for using this app!'
        puts 'Goodbye!'
        puts

        exit
    end


    def recipe_detail(recipe)
        puts
        puts "#{recipe.name}"
        puts "    #{recipe.summary}"
        puts 'Ingredients:'
        recipe.ingredients.each {|line| puts "    #{line}"}
        
        puts
        puts 'Would you like to see more details? (Y/n)'
        input = gets.chomp.strip.downcase

        if input == 'y' || input == 'yes' || input == ''
            recipe_more_detail(recipe)
        elsif input == 'exit' || input == 'quit' || input =='q'
            quit_app
        end
        return
    end

    def recipe_more_detail(recipe)
        puts
        puts "#{recipe.name}    #{recipe.date_posted}"
        puts "  #{recipe.url}"
        puts "    #{recipe.summary}"
        unless recipe.prep_time.nil?
            puts "  Prep time: #{recipe.prep_time}"
        end
        unless recipe.total_time.nil?
            puts "  Total time: #{recipe.total_time}"
        end
        # puts recipe.nutrition_facts
        puts 'Ingredients:'
        recipe.ingredients.each {|line| puts "    #{line}"}
        puts 'Instructions:'
        recipe.instructions.each {|line| puts "    #{line}"}
        puts 'Notes:'
        puts "    #{recipe.notes}"
        puts
    end

end


KetoRecipesCLI.new