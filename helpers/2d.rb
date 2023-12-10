# frozen_string_literal: true

require "matrix"

DIRECTIONS_2D = ([-1, 0, 1].repeated_permutation(2).to_a - [[0, 0]]).map { Vector.elements _1 }

ROTATE_RIGHT = Matrix[[0, -1], [1, 0]]
ROTATE_LEFT = Matrix[[0, 1], [-1, 0]]
FLIP = Matrix[[-1, 0], [0, -1]]
