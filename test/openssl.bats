#!/usr/bin/env bats

@test "It should install an OpenSSL version protected from CVE-2014-0160" {
  # For details on CVE-2014-0160, see http://heartbleed.com/
  run dpkg -s openssl
  echo $output
  [[ "$output" =~ "1.0.1f-1ubuntu2.4" ]]
}

@test "It should install a libssl version protected from CVE-2014-0160" {
  run dpkg -s libssl1.0.0
  [[ "$output" =~ "1.0.1f-1ubuntu2.4" ]]
}
