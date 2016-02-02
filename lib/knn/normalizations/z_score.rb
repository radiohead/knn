require 'descriptive_statistics'

module KNN
  module Normalizations
    class ZScore
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def normalize(indices)
        stats = indices.reduce({}) do |acc, index|
          values = data.map { |r| r.at(index) }
          stats = { mean: values.mean, std_dev: values.standard_deviation }
          acc.merge(index => stats)
        end

        data.map! do |row|
          row.each_with_index.map do |el, i|
            indices.include?(i) ? normalize_one(el, stats[i]) : el
          end
        end
      end

      private

      def normalize_one(value, stats)
        (value - stats[:mean]) / stats[:std_dev]
      end
    end
  end
end
