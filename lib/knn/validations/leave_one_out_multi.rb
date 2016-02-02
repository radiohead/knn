require 'knn/validations/base'
require 'descriptive_statistics'

require 'byebug'

module Validations
  class LeaveOneOutMulti < Base
    def regression(regression_class = Regressions::Average)
      lookup do |nearest, index|
        regression_class.new(nearest, index).fit
      end
    end

    private

    def lookup
      target_index.reduce({}) do |acc, index|
        predictions = []
        actuals = []

        data.each do |row|
          nearest = KNN::KNN.new(data - [row], index).find_nearest(row, number_of_neighbors)

          predictions << yield(nearest, index)
          actuals << row[index]
        end

        acc.merge(index => evaluate_c_index(actuals, predictions))
      end
    end

    def evaluate_c_index(actuals, predictions)
      n = 0
      h_sum = 0

      actuals.each_with_index do |t, i|
        p = predictions[i]

        ((i + 1)...actuals.length).each do |j|
          nt = actuals[j]
          np = predictions[j]

          next if t == nt

          n += 1
          if (p < np && t < nt) || (p > np && t > nt)
            h_sum += 1
          elsif p == np
            h_sum += 0.5
          end
        end
      end

      h_sum / n
    end
  end
end
