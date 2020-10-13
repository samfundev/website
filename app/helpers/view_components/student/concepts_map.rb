module ViewComponents
  module Student
    class ConceptsMap < ViewComponent
      initialize_with :data

      def to_s
        react_component(
          "concepts-map",
          {
            graph: data
          }
        )
      end

      private
      attr_reader :data
    end
  end
end