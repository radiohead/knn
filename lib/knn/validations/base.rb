require 'knn/regressions'
require 'knn/classifications'

module Validations
  class Base
    attr_reader :data, :target_index, :number_of_neighbors

    def initialize(data, target_index, number_of_neighbors)
      @data = data
      @target_index = target_index
      @number_of_neighbors = number_of_neighbors
    end

    def regression(regression_class = Regressions::Average)
      lookup do |nearest|
        regression_class.new(nearest, target_index).fit
      end
    end

    def classification(classification_class = Classifications::Simple)
      lookup do |nearest|
        classification_class.new(nearest, target_index).fit
      end
    end

    private

    def lookup
      [].each
    end
  end
end
