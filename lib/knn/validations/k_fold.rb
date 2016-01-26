require 'byebug'

require 'knn/validations/base'
require 'descriptive_statistics'

module Validations
  class KFold < Base
    attr_reader :folds

    def initialize(data, target_index, number_of_neighbors, folds = 2)
      super(data, target_index, number_of_neighbors)
      @folds = folds
    end

    private

    def lookup
      fold_size = data.size / folds
      ranges = (0..folds).map { |i| (i * fold_size)..((i + 1) * fold_size - 1) }

      errors = ranges.map do |range|
        slice = data[range]
        training_data = data - slice

        predicted = slice.map do |row|
          nearest = KNN.new(training_data, target_index).find_nearest(row, number_of_neighbors)
          yield(nearest)
        end

        evaluate_prediction(predicted, slice)
      end

      evaluate_errors(errors)
    end

    def evaluate_prediction(predicted, actual)
      errors = []

      predicted.each_with_index do |i, row|
        predicted_value = row.at(target_index)
        actual_value = actual.at(i).at(target_index)

        errors << (predicted_value - actual_value).abs
      end

      errors
    end

    def evaluate_errors(errors)
      [errors.mean, errors.variance]
    end
  end
end
