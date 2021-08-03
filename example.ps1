import-module .\testnet.psm1

$testServer = "8.8.8.8"
$testCount = 30
Write-Host "Testing connection latency, this may take $testCount seconds or more."
$result = Test-Ping -server $testServer  -count $testCount
Write-Host "Latency test complete. The results are below"
$result