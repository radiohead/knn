require 'knn/validations/base'
require 'descriptive_statistics'

module Validations
  class LeaveOneOut < Base
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
