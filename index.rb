# frozen_string_literal: true

require 'yaml'
require 'date'

# Description/Explanation of Car class
class Car
  attr_accessor :cars, :make, :model, :year_from, :year_to, :price_from, :price_to, :date_or_price_sort,
                :asc_desc_sort, :result_selection

  def initialize(cars)
    @cars = cars
    @make = make
    @model = model
    @year_from = year_from
    @year_to = year_to
    @price_from = price_from
    @price_to = price_to
    @date_or_price_sort = date_or_price_sort
    @asc_desc_sort = asc_desc_sort
    @result_selection = @cars
    @app_errors = []
  end

  def sanitize_text(text)
    return if text.empty?

    text.downcase.capitalize
  end

  def get_by_make(make_to_find)
    return if make_to_find.length.zero?

    res = @result_selection.filter { |obj| obj['make'] == sanitize_text(make_to_find) }
    @result_selection = res.empty? ? @app_errors.push("Can't find by make: #{make_to_find}") : res
  end

  def get_by_model(model_to_find)
    return if model_to_find.length.zero?

    res = @result_selection.filter { |obj| obj['model'] == sanitize_text(model_to_find) }
    @result_selection = res.empty? ? @app_errors.push("Can't find by model: #{model_to_find}") : res
  end

  def get_by_year_from(year_to_find)
    return if year_to_find.length.zero?

    res = @result_selection.filter { |obj| obj['year'] >= sanitize_text(year_to_find).to_i }
    @result_selection = res.empty? ? @app_errors.push("Can't find by year: #{year_to_find}") : res
  end

  def get_by_year_to(year_to)
    return if year_to.length.zero?

    res = @result_selection.filter { |obj| obj['year'] <= sanitize_text(year_to).to_i }
    @result_selection = res.empty? ? @app_errors.push("Can't find by year: #{year_to}") : res
  end

  def get_by_price_from(price)
    return if price.length.zero?

    res = @result_selection.filter { |obj| obj['price'] >= sanitize_text(price).to_i }
    @result_selection = res.empty? ? @app_errors.push("Can't find by price_from: #{price}") : res
  end

  def get_by_price_to(price)
    return if price.length.zero?

    res = @result_selection.filter { |obj| obj['price'] <= sanitize_text(price).to_i }
    @result_selection = res.empty? ? @app_errors.push("Can't find by price_to: #{price}") : res
  end

  def sort_by_criterias(direction, option = 'desc')
    if 'price' == option
      @result_selection = @result_selection.sort { |one, two| one[option] <=> two[option] }
    elsif 'date_added' == option
      @result_selection = @result_selection.sort { |one, two| one[option] <=> two[option] }
    end
    @result_selection = direction == 'asc' ? @result_selection : @result_selection.reverse
  end

  def init
    puts 'Please select search rules'

    puts 'Please choose make:'
    @make = gets.chomp

    puts 'Please choose model:'
    @model = gets.chomp

    puts 'Please choose year_from:'
    @year_from = gets.chomp

    puts 'Please choose year_to:'
    @year_to = gets.chomp

    puts 'Please choose price_from:'
    @price_from = gets.chomp

    puts 'Please choose price_to:'
    @price_to = gets.chomp

    puts 'Please choose sort option (date_added|price):'
    @date_or_price_sort = gets.chomp

    puts 'Please choose sort direction(desc|asc):'
    @asc_desc_sort = gets.chomp

    fetch_data
  end

  def fetch_data
    unless @make && @model && @year_from && @year_to && @price_from && price_to && @asc_desc_sort && @date_or_price_sort
      return
    end

    get_by_make(@make)
    get_by_model(@model)
    get_by_year_from(@year_from)
    get_by_year_to(@year_to)
    get_by_price_from(@price_from)
    get_by_price_to(@price_to)
    sort_by_criterias(@asc_desc_sort, @date_or_price_sort)
    display_result
  end

  def display_result
    if !@app_errors.empty?
      puts 'Errors', @app_errors
    else
      puts '=================================='
      puts 'Display results', @result_selection
    end
  end
end

cars = YAML.load_file('./db/cars.yaml')

Car.new(cars).init
