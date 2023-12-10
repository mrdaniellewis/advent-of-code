# frozen_string_literal: true

require "matrix"

DIRECTIONS_3D = ([-1, 0, 1].repeated_permutation(3).to_a - [[0, 0, 0]]).map { Vector.elements _1 }

ROTATE_X = Matrix[[1, 0, 0], [0, 0, -1], [0, 1, 0]]
ROTATE_Y = Matrix[[0, 0, 1], [0, 1, 0], [-1, 0, 0]]
ROTATE_Z = Matrix[[0, -1, 0], [1, 0, 0], [0, 0, 1]]

def make_rotations(initial, rotation)
  rotations = [initial]
  3.times do
    rotations << rotations.last * rotation
  end
  rotations
end

ROTATIONS_3D = [
  # rotate around x
  *make_rotations(Matrix.identity(3), ROTATE_X),
  # flip 180 and rotate around x
  *make_rotations(ROTATE_Y * ROTATE_Y, ROTATE_X),
  # rotate to z and rotate around z
  *make_rotations(ROTATE_Y, ROTATE_Z),
  # rotate to z flip and rotate around z
  *make_rotations(ROTATE_Y * ROTATE_X * ROTATE_X, ROTATE_Z),
  # rotate to y and rotate around y
  *make_rotations(ROTATE_Z, ROTATE_Y),
  # rotate to y flip and rotate around y
  *make_rotations(ROTATE_Z * ROTATE_X * ROTATE_X, ROTATE_Y)
].freeze
