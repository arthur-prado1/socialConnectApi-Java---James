$file = "api_test_results.md"
Out-File -FilePath $file -Encoding utf8 -InputObject "# Testes da API SocialConnect`n"

function Test-Endpoint {
    param (
        [string]$Method,
        [string]$Url,
        [string]$Body = $null
    )
    $output = "## $Method $Url`n"
    if ($Body) {
        $output += "**Request Payload:**`n````json`n$Body`n`````n"
    }

    try {
        $req = [System.Net.HttpWebRequest]::Create($Url)
        $req.Method = $Method
        $req.ContentType = "application/json"
        if ($Body) {
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($Body)
            $req.ContentLength = $bytes.Length
            $reqStream = $req.GetRequestStream()
            $reqStream.Write($bytes, 0, $bytes.Length)
            $reqStream.Close()
        }
        $resp = $req.GetResponse()
        $statusCode = [int]$resp.StatusCode
        $reader = New-Object System.IO.StreamReader($resp.GetResponseStream(), [System.Text.Encoding]::UTF8)
        $respBody = $reader.ReadToEnd()
        $reader.Close()
        $resp.Close()

        $output += "**Response Status:** $statusCode`n"
        if ($respBody) {
            try {
                $formatted = $respBody | ConvertFrom-Json | ConvertTo-Json -Depth 10
            } catch {
                $formatted = $respBody
            }
            $output += "**Response Payload:**`n````json`n$formatted`n`````n"
        }
    } catch [System.Net.WebException] {
        $resp = $_.Exception.Response
        if ($resp) {
            $statusCode = [int]$resp.StatusCode
            $reader = New-Object System.IO.StreamReader($resp.GetResponseStream(), [System.Text.Encoding]::UTF8)
            $errBody = $reader.ReadToEnd()
            $reader.Close()
            $resp.Close()
            $output += "**Error Status:** $statusCode`n"
            if ($errBody) {
                try {
                    $formatted = $errBody | ConvertFrom-Json | ConvertTo-Json -Depth 10
                } catch {
                    $formatted = $errBody
                }
                $output += "**Error Response Payload:**`n````json`n$formatted`n`````n"
            }
        } else {
            $output += "**Error:** $($_.Exception.Message)`n"
        }
    } catch {
        $output += "**Error:** $($_.Exception.Message)`n"
    }
    
    Add-Content -Path $file -Value $output -Encoding utf8
}

Write-Host "Aguardando API..."
while (!(Test-NetConnection localhost -Port 8080 -WarningAction SilentlyContinue).TcpTestSucceeded) {
    Start-Sleep -Seconds 2
}
Write-Host "API online, rodando testes..."

$beneficiarioBody = @{
    nome = "João da Silva"
    cpf = "123.456.789-00"
    telefone = "(11) 99999-9999"
    endereco = "Rua das Flores, 123"
    situacaoVulnerabilidade = "Desempregado"
} | ConvertTo-Json

# 1. POST Beneficiario
Test-Endpoint -Method "POST" -Url "http://localhost:8080/api/v1/beneficiarios" -Body $beneficiarioBody

# 2. GET Todos Beneficiarios
Test-Endpoint -Method "GET" -Url "http://localhost:8080/api/v1/beneficiarios"

# 3. GET Beneficiario por ID
Test-Endpoint -Method "GET" -Url "http://localhost:8080/api/v1/beneficiarios/1"

# 4. GET Doacoes (vazio, mas testa endpoint)
Test-Endpoint -Method "GET" -Url "http://localhost:8080/api/v1/doacoes?tipo=ALIMENTO&dataInicio=2026-01-01"

# 5. DELETE Beneficiario por ID
Test-Endpoint -Method "DELETE" -Url "http://localhost:8080/api/v1/beneficiarios/1"

Write-Host "Testes concluídos! Resultados salvos em $file"
