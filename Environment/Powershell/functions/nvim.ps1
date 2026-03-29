


function nvim 
{
    $basePort   = 9999
    $portFile   = "C:\sun\ops\environment\nvim\lua\data\unity\nvim-port.txt"

    $port       = $basePort

    while ($true) {
        $tcp = New-Object System.Net.Sockets.TcpClient
        try {
            $result = $tcp.BeginConnect("127.0.0.1", $port, $null, $null)
            $success = $result.AsyncWaitHandle.WaitOne(50)  # 50ms timeout
            if ($success -and $tcp.Connected) {
                $tcp.Close()
                $port++
            } else {
                $tcp.Close()
                break
            }
        } catch {
            break
        }
    }

    if ($port -eq $basePort) {
        $port | Out-File $portFile
    }

    & "C:\Program Files\Neovim\bin\nvim.exe" --listen "127.0.0.1:$port" $args

    if ($port -eq $basePort) {
        Remove-Item $portFile -ErrorAction SilentlyContinue
    }
}

