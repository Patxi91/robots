module Robots
  class CLI
    def initialize(options)
      @options = options
      @board = Board.example
      @random = Random.new
    end

    def run(io = $stdout)
      robot = Robot.new(:silver, board.random_cell(random))
      if options.all
        run_all(robot, io)
      elsif options.chain
        run_chained(robot, io)
      else
        solve(robot, options.goal, io)
      end
    end

    private

    def run_all(robot, io)
      board.targets.shuffle(random: random).each do |goal|
        solve(robot, goal, io)
      end
    end

    def run_chained(robot, io)
      board.targets.shuffle.inject(robot) do |state, target|
        outcome = solve(state, target, io)
        outcome.final_state
      end
    end

    def solve(robot, goal, io)
      solver = Solvers::RecursiveDfs.new(robot, goal)

      io.puts "#{robot}"
      io.puts "Attempting to solve for #{goal}"

      solver.outcome.tap { |outcome| outcome.write(io) }
    end

    def solver
      @solver ||= Solvers::RecursiveDfs.new(robot, goal)
    end

    def robot_for_goal(goal)
      color = (goal.color == :any) ? :silver : goal.color
      Robot.new(color, board.cell(6, 14))
    end

    attr_reader :options, :board, :random
  end
end
