require 'knn/regressions'
require 'knn/classifications'
require 'descriptive_statistics'

module Validations
  class LeaveOneOut
    attr_reader :data, :target_index, :number_of_neighbors, :regression_class, :classification_class

    def initialize(data, target_index, number_of_neighbors, regression_class = Regressions::Average, classification_class = Classifications::Simple)
      @data = data
      @target_index = target_index
      @number_of_neighbors = number_of_neighbors
      @regression_class = regression_class
      @classification_class = classification_class
    end

    def regression
      lookup do |nearest|
        regression_class.new(nearest, target_index).fit
      end
    end

    def classification
      lookup do |nearest|
        classification_class.new(nearest, target_index).fit
      end
    end

  private
    def lookup
      errors = data.map do |row|
        nearest = KNN.new(data - [row], target_index).find_nearest(row, number_of_neighbors)
        predicted = yield(nearest)

        (row.at(target_index) - predicted).abs
      end

      [number_of_neighbors, errors.mean, errors.variance]
    end
  end
end