function Test-Ping{
    param (
        $server,
        $count
    )
    $test = Test-Connection -ComputerName $server -Count $count -ErrorAction SilentlyContinue

    $jitterArray = [System.Collections.ArrayList]@()

    For ($i = 0; $i -le $test.count; $i++) {
        $jitter = $test.ResponseTime[$i] - $test.ResponseTime[$i - 1]
        $jitterArray += [System.Math]::Abs($jitter)
    }

    $stats = $test | Measure-Object ResponseTime -Average -Maximum -Minimum

    $jitterStats = $jitterArray | Measure-Object -Average

    $results = [ordered]@{}

    $results["Count"] = $test.count
    $results["Packet Loss"] = (($test.count - $count) / $count) * 100
    $results["Ping Average"] = $stats.Average
    $results["Ping Min"] = $stats.Minimum
    $results["Ping Max"] = $stats.Maximum
    $results["Ping Jitter"] = $jitterStats.Average

    return $results
    }
