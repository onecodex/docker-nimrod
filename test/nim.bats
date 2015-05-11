#!/usr/bin/env bats

@test "Test for Nim v0.11.2" {
    N=$(nim --version)
    [[ $N == *Version\ 0.11.2* ]]
}

@test "Test for Nimble (ex-Babel)" {
    NIMBLE=$(nimble --version)
    [[ $NIMBLE == *v0.6.0* ]]
}
