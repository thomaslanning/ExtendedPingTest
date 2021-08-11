function Test-Ping {
    param (
        $server,
        $seconds
    )

    $time = Get-Date

    $ping = [System.Collections.ArrayList]@()

    $jitterArray = [System.Collections.ArrayList]@()

    $errors = 0

    while ((NEW-TIMESPAN –Start $time –End (Get-Date)).seconds -lt $seconds) {
        try {
            $ping += (Test-Connection -ComputerName $server -count 1 -ErrorAction Stop).ResponseTime
        }
        catch {
            $errors += 1
        }
    }

    For ($i = 1; $i -le $ping.count; $i++) {
        $jitter = $ping[$i] - $ping[$i - 1]
        $jitterArray += [System.Math]::Abs($jitter)
    }

    $stats = $ping | Measure-Object -Average -Maximum -Minimum

    $jitterStats = $jitterArray | Measure-Object -Average

    $results = [ordered]@{}

    $results["Count"] = $ping.count + $errors
    $results["Packet Loss"] = (1 - ($ping.count / ($ping.count + $errors))) * 100
    $results["Ping Average"] = $stats.Average
    $results["Ping Min"] = $stats.Minimum
    $results["Ping Max"] = $stats.Maximum
    $results["Ping Jitter"] = $jitterStats.Average

    return $results
}
