# Converte uma foto de cardapio (inclusive CMYK/pesada) para JPG leve em RGB, 2400 px de largura.
# Uso (PowerShell, dentro da pasta cardapio):
#   .\converter-cardapio.ps1 -Entrada "C:\caminho\novo-menu-frente.jpg" -Saida "cardapio-frente-web.jpg"
# Depois suba o arquivo de saida no GitHub (fotos-tower) com ESSE MESMO NOME para substituir o antigo.
param(
  [Parameter(Mandatory = $true)][string]$Entrada,
  [Parameter(Mandatory = $true)][string]$Saida,
  [int]$Largura = 2400,
  [int]$Qualidade = 85
)
Add-Type -AssemblyName System.Drawing
$enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
$ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$Qualidade)
$src = [System.Drawing.Image]::FromFile($Entrada)
$h = [int]($src.Height * $Largura / $src.Width)
$bmp = New-Object System.Drawing.Bitmap($Largura, $h, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = 'HighQualityBicubic'
$g.DrawImage($src, 0, 0, $Largura, $h)
$g.Dispose(); $src.Dispose()
$bmp.Save($Saida, $enc, $ep)
$bmp.Dispose()
Get-Item $Saida | Select-Object Name, @{n = 'MB'; e = { [math]::Round($_.Length / 1MB, 2) } }
