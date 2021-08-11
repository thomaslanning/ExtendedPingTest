import-module .\testnet.psm1

$testServer = "8.8.8.8"
$testSeconds = 5
Write-Host "Testing connection latency, this will take about $testSeconds seconds."
$result = Test-Ping -server $testServer  -seconds $testSeconds
Write-Host "Latency test complete. The results are below"
$result
