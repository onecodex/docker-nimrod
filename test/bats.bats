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

@test "Test for Nim v0.10.0" {
	N=$(nim --version)
	[[ $N == *Version\ 0.10.0* ]]
}

@test "Test for Nimble (ex-Babel)" {
    NIMBLE=$(nimble --version)
    [[ $NIMBLE == *v0.4.0* ]]
}
