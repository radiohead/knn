require 'knn/validations/k_fold'

module Validations
  class KFoldConfusionClassification < KFold
    attr_reader :confusion_matrix

    def initialize(data, target_index, number_of_neighbors, folds = 2)
      super
      @confusion_matrix = {}
    end

    def regression(_ = nil)
      fail NotImplementedError, 'This validation strategy does not support regression!'
    end

    private

    def evaluate_prediction(predicted, actual)
      predicted.each_with_index do |predicted_value, i|
        actual_value = actual.at(i).at(target_index)

        confusion_matrix[actual_value] ||= {}
        confusion_matrix[predicted_value] ||= {}

        confusion_matrix[actual_value][:count] = confusion_matrix[actual_value].fetch(:count, 0) + 1

        if actual_value == predicted_value
          confusion_matrix[actual_value][:tp] = confusion_matrix[actual_value].fetch(:tp, 0.0) + 1.0
        else
          confusion_matrix[actual_value][:fn] = confusion_matrix[actual_value].fetch(:fn, 0.0) + 1.0
          confusion_matrix[predicted_value][:fp] = confusion_matrix[predicted_value].fetch(:fp, 0.0) + 1.0
        end
      end

      nil
    end

    def evaluate_errors(_)
      prcs = calculate_precision_and_recall.map do |_, prc|
        f = (prc[:precision] * prc[:recall]) / (prc[:precision] + prc[:recall])
        prc[:count] * 2 * (f.nan? ? 0 : f)
      end

      prcs.reduce(0) { |a, e| a + e } / data.size
    end

    def calculate_precision_and_recall
      confusion_matrix.reduce({}) do |acc, (klass, matrix)|
        tp = matrix[:tp] || 0.0
        fp = matrix[:fp] || 0.0
        fn = matrix[:fn] || 0.0

        begin
          precision = tp / (tp + fp)
        rescue ZeroDivisionError
          precision = 0.0
        end

        begin
          recall = tp / (tp + fn)
        rescue ZeroDivisionError
          recall = 0.0
        end

        precision = 0.0 if precision.nan?
        recall = 0.0 if recall.nan?

        acc.merge(klass => { precision: precision, recall: recall, count: matrix[:count] })
      end
    end
  end
end
