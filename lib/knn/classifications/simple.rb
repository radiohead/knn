module Classifications
  class Simple
    attr_reader :vectors, :target_index

    def initialize(vectors_with_distance, target_index)
      @vectors = vectors_with_distance
      @target_index = target_index
    end

    def fit
      classes = vectors.reduce({}) do |acc, vector|
        vector_class = vector.last[target_index]
        acc.merge(vector_class => acc.fetch(vector_class, 0) + 1)
      end

      classes.max_by { |_, count| count }.first
    end
  end
end
