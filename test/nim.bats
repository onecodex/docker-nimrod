#!/usr/bin/env bats

@test "Test for Nim v0.16.0" {
    N=$(nim --version 2>&1)
    [[ $N == *0.16.0* ]]
}

@test "Test for Nimble (ex-Babel)" {
    NIMBLE=$(nimble --version)
    [[ $NIMBLE == *v0.8.4* ]]
}
