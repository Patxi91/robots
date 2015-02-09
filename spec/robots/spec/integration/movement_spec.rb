require "spec_helper"

module Robots
  describe "Robot movement" do
    let(:board) { Board.new }
    let(:robot) { Robot.new(start) }

    before do
      BoardMaker.new(board).populate_example
    end

    context "with no obstacles" do
      let(:start) { board.cell(5, 11) }

      it "moves up" do
        robot.move(:up)
        expect(robot.cell).to equal board.cell(board.top, start.column)
      end

      it "moves right" do
        robot.move(:right)
        expect(robot.cell).to equal board.cell(start.row, board.right)
      end
    end

    context "with center obstacle" do
      context "while moving down" do
        let(:start) { board.cell(board.top, 7) }

        it "stops at the obstacle" do
          robot.move(:down)
          expect(robot.cell).to equal board.cell(6, start.column)
        end
      end

      context "while moving left" do
        let(:start) { board.cell(8, board.right) }

        it "stops at the obstacle" do
          robot.move(:left)
          expect(robot.cell).to equal board.cell(start.row, 9)
        end
      end
    end

    context "with edge walls" do
      let(:start) { board.cell(board.top, board.right) }

      context "moving left" do
        before { robot.move(:left) }

        it "stops at the wall" do
          expect(robot.cell).to equal board.cell(start.row, 11)
        end
      end

      context "moving down" do
        before { robot.move(:down) }

        it "stops at the wall" do
          expect(robot.cell).to equal board.cell(4, start.column)
        end
      end
    end
  end
end
