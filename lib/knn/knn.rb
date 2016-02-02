module KNN
  class KNN
    attr_reader :data, :unknown_index, :distance

    def initialize(data, unknown_index, distance = :euclidean)
      fail 'Only euclidean distance is currently implemented!' if distance != :euclidean

      @data = data
      @distance = distance
      @unknown_index = unknown_index
    end

    def find_nearest(pivot, neighbors_count)
      data_with_distances = data.map do |data_point|
        [euclidean_distance(data_point, pivot), data_point]
      end

      data_with_distances.sort! do |left, right|
        left.first <=> right.first
      end

      data_with_distances[0...neighbors_count]
    end

    private

    def euclidean_distance(left = [], right = [])
      sum = 0
      left.each_with_index do |left_v, idx|
        next if idx == unknown_index
        sum += (left_v - right[idx])**2
      end

      Math.sqrt(sum)
    end
  end
end
