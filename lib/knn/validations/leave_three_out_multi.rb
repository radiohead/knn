require 'knn/validations/leave_one_out_multi'
require 'descriptive_statistics'

module Validations
  class LeaveThreeOutMulti < LeaveOneOutMulti
    private

    def lookup
      target_index.reduce({}) do |acc, index|
        predictions = []
        actuals = []

        data.each_slice(3) do |rows|
          rows.each do |row|
            nearest = KNN::KNNMulti.new(data - rows, target_index).find_nearest(row, number_of_neighbors)

            predictions << yield(nearest, index)
            actuals << row[index]
          end
        end

        acc.merge(index => evaluate_c_index(actuals, predictions))
      end
    end
  end
end
