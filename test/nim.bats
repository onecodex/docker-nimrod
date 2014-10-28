#!/usr/bin/env bats

@test "Test for Nim v0.9.6" {
    N=$(nim --version)
    [[ $N == *Version\ 0.9.6* ]]
}

@test "Test for Babel" {
    BABEL=$(babel --version)
    [[ $BABEL == *v0.4.0* ]]
}
