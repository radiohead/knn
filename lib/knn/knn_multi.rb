require 'knn/knn'

module KNN
  class KNNMulti < KNN
    private

    def euclidean_distance(left = [], right = [])
      sum = 0
      left.each_with_index do |left_v, idx|
        next if unknown_index.include?(idx)
        sum += (left_v - right[idx])**2
      end

      Math.sqrt(sum)
    end
  end
end
