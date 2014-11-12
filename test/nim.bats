#!/usr/bin/env bats

@test "Test for Nim v0.10.1" {
    N=$(nim --version)
    [[ $N == *Version\ 0.10.1* ]]
}

@test "Test for Nimble (ex-Babel)" {
    NIMBLE=$(nimble --version)
    [[ $NIMBLE == *v0.4.0* ]]
}
