#!/usr/bin/env bats

@test "It should have Bats installed" {
  which bats
}

@test "Bats should be v0.3.1" {
  bats -v | grep '0\.3\.1'
}

@test "Python 2.7.X should be installed" {
	V=$(python --version 2>&1)
	[[ $V == Python\ 2.7* ]]
}

@test "Test for Nimrod v0.9.5" {
	N=$(nimrod --version)
	[[ $N == *Version\ 0.9.5* ]]
}
