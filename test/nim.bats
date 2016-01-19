#!/usr/bin/env bats

@test "Test for Nim v0.13.0" {
    N=$(nim --version 2>&1)
    [[ $N == *0.13.0* ]]
}

@test "Test for Nimble (ex-Babel)" {
    NIMBLE=$(nimble --version)
    [[ $NIMBLE == *v0.7.0* ]]
}
