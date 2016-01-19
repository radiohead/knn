module Regressions
  class Average
    attr_reader :vectors, :target_index

    def initialize(vectors_with_distance = [], target_index)
      @vectors = vectors_with_distance
      @target_index = target_index
    end

    def fit
      vectors.reduce(0){ |acc, vector| acc + vector.last[target_index] } / vectors.size
    end
  end
end
