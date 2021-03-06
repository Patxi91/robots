require "set"

module Robots
  module Solvers
    class TreeSolver < Solver
      def initialize(*args)
        super
        @visited = Set.new
      end

      private

      attr_reader :visited

      def solve
        initial_path = Path.initial(initial_state)
        initial_path.be_unprunable if initial_path.allowable_successors.any?(&:illegal_solution?)

        paths = make_paths(initial_path)

        until empty?(paths)
          path = next_path(paths)

          report_progress(path) if verbose?

          visit(path) || next

          successors = path.allowable_successors
          solution = successors.find(&:solved?)

          return solution.to_outcome if solution

          add_paths(paths, successors)
        end

        Outcome.no_solution(initial_state)
      end

      def make_paths(path)
        fail NotImplementedError, "Subclasses must implement this"
      end

      def next_path(paths)
        fail NotImplementedError, "Subclasses must implement this"
      end

      def add_paths(paths, successors)
        fail NotImplementedError, "Subclasses must implement this"
      end

      def empty?(paths)
        paths.empty?
      end

      def visit(path)
        equivalence_class = path.state.equivalence_class
        return false if visited.include?(equivalence_class)

        note_state_considered

        visited << equivalence_class if path.prunable?

        true
      end

      def report_progress(path)
        # Subclasses can implement this
      end
    end
  end
end
