class Recipe
    attr_accessor :name, :date_posted, :url, :ingredients, :instructions, :nutrition_facts, :notes, :summary, :prep_time, :cooking_time


    @@all = []

    def self.all
        @@all.dup.freeze
    end

    def self.delete_recipe(recipe)
        @@all = @@all.select {|r| r != recipe}
    end

    def initialize(*args)
        puts args
    end

    # def initialize(name, date_posted, url, ingredients, instructions, nutrition_facts=nil, notes=nil, summary=nil, prep_time=nil, cooking_time=nil)
    #     @name = name
    #     @date_posted = date_posted
    #     @url = url
    #     @ingredients = ingredients
    #     @instructions = instructions
    #     @nutrition_facts = nutrition_facts
    #     @notes = notes
    #     @summary = summary
    #     @prep_time = prep_time
    #     @cooking_time = cooking_time

    #     @@all << self
    # end

    def is_recipe?
        !(@name.nil? || @ingredients.nil? || @instruction.nil?)
    end

end