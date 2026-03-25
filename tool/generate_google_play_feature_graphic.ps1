Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$outputPath = Join-Path $root "store\assets\google-play\feature-graphic\feature-graphic.png"
$iconPath = Join-Path $root "android\app\src\main\res\mipmap-xxxhdpi\ic_launcher.png"
$mainMenuPath = Join-Path $root "store\assets\source-captures\main-menu.png"
$generatorPath = Join-Path $root "store\assets\source-captures\generator.png"
$analyzerPath = Join-Path $root "store\assets\source-captures\analyzer.png"

foreach ($path in @($iconPath, $mainMenuPath, $generatorPath, $analyzerPath)) {
    if (-not (Test-Path $path)) {
        throw "Required asset missing: $path"
    }
}

function New-RoundedRectPath {
    param(
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height,
        [float]$Radius
    )

    $diameter = $Radius * 2
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($X, $Y, $diameter, $diameter, 180, 90)
    $path.AddArc($X + $Width - $diameter, $Y, $diameter, $diameter, 270, 90)
    $path.AddArc($X + $Width - $diameter, $Y + $Height - $diameter, $diameter, $diameter, 0, 90)
    $path.AddArc($X, $Y + $Height - $diameter, $diameter, $diameter, 90, 90)
    $path.CloseFigure()
    return $path
}

function DrawRoundedRect {
    param(
        [System.Drawing.Graphics]$Graphics,
        [System.Drawing.Brush]$Brush,
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height,
        [float]$Radius
    )

    $path = New-RoundedRectPath -X $X -Y $Y -Width $Width -Height $Height -Radius $Radius
    try {
        $Graphics.FillPath($Brush, $path)
    } finally {
        $path.Dispose()
    }
}

function DrawScreenshotCard {
    param(
        [System.Drawing.Graphics]$Graphics,
        [string]$ImagePath,
        [float]$X,
        [float]$Y,
        [float]$Width,
        [float]$Height
    )

    $shadowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(70, 5, 10, 18))
    $frameBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(230, 248, 250, 252))
    $strokePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(40, 12, 24, 35), 2)
    $image = [System.Drawing.Image]::FromFile($ImagePath)

    try {
        DrawRoundedRect -Graphics $Graphics -Brush $shadowBrush -X ($X + 8) -Y ($Y + 12) -Width $Width -Height $Height -Radius 28
        DrawRoundedRect -Graphics $Graphics -Brush $frameBrush -X $X -Y $Y -Width $Width -Height $Height -Radius 28

        $clipPath = New-RoundedRectPath -X $X -Y $Y -Width $Width -Height $Height -Radius 28
        $previousClip = $Graphics.Clip
        try {
            $Graphics.SetClip($clipPath)
            $Graphics.DrawImage($image, [System.Drawing.RectangleF]::new($X, $Y, $Width, $Height))
        } finally {
            $Graphics.Clip = $previousClip
            $clipPath.Dispose()
        }

        $outlinePath = New-RoundedRectPath -X $X -Y $Y -Width $Width -Height $Height -Radius 28
        try {
            $Graphics.DrawPath($strokePen, $outlinePath)
        } finally {
            $outlinePath.Dispose()
        }
    } finally {
        $image.Dispose()
        $shadowBrush.Dispose()
        $frameBrush.Dispose()
        $strokePen.Dispose()
    }
}

$width = 1024
$height = 500
$bitmap = New-Object System.Drawing.Bitmap $width, $height
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)

try {
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    $backgroundRect = [System.Drawing.Rectangle]::new(0, 0, $width, $height)
    $backgroundBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $backgroundRect,
        [System.Drawing.Color]::FromArgb(255, 15, 28, 44),
        [System.Drawing.Color]::FromArgb(255, 36, 89, 96),
        20
    )
    try {
        $graphics.FillRectangle($backgroundBrush, $backgroundRect)
    } finally {
        $backgroundBrush.Dispose()
    }

    $accentBrushA = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(40, 255, 255, 255))
    $accentBrushB = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(50, 255, 209, 102))
    try {
        $graphics.FillEllipse($accentBrushA, -120, -80, 340, 340)
        $graphics.FillEllipse($accentBrushB, 720, 260, 260, 260)
    } finally {
        $accentBrushA.Dispose()
        $accentBrushB.Dispose()
    }

    $panelBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(52, 255, 255, 255))
    try {
        DrawRoundedRect -Graphics $graphics -Brush $panelBrush -X 44 -Y 48 -Width 432 -Height 404 -Radius 34
    } finally {
        $panelBrush.Dispose()
    }

    $iconBackdropBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(235, 245, 250, 253))
    try {
        DrawRoundedRect -Graphics $graphics -Brush $iconBackdropBrush -X 76 -Y 84 -Width 96 -Height 96 -Radius 24
    } finally {
        $iconBackdropBrush.Dispose()
    }

    $icon = [System.Drawing.Image]::FromFile($iconPath)
    try {
        $graphics.DrawImage($icon, [System.Drawing.RectangleF]::new(92, 100, 64, 64))
    } finally {
        $icon.Dispose()
    }

    $titleFont = New-Object System.Drawing.Font("Segoe UI", 32, [System.Drawing.FontStyle]::Bold)
    $bodyFont = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Regular)
    $chipFont = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
    $titleBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 245, 249, 252))
    $bodyBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(230, 226, 236, 241))
    $chipTextBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 15, 28, 44))
    $chipBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(240, 255, 209, 102))
    $chipBrushAlt = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(235, 186, 235, 222))
    try {
        $graphics.DrawString("Chordest", $titleFont, $titleBrush, 196, 92)
        $graphics.DrawString(
            "Practice chords, harmony, and improvisation with\nsmart progression tools and a built-in analyzer.",
            $bodyFont,
            $bodyBrush,
            [System.Drawing.RectangleF]::new(80, 208, 350, 78)
        )

        DrawRoundedRect -Graphics $graphics -Brush $chipBrush -X 80 -Y 314 -Width 126 -Height 36 -Radius 16
        DrawRoundedRect -Graphics $graphics -Brush $chipBrushAlt -X 216 -Y 314 -Width 126 -Height 36 -Radius 16
        DrawRoundedRect -Graphics $graphics -Brush $chipBrush -X 352 -Y 314 -Width 96 -Height 36 -Radius 16
        $graphics.DrawString("Smart Generator", $chipFont, $chipTextBrush, 95, 324)
        $graphics.DrawString("Chord Analyzer", $chipFont, $chipTextBrush, 232, 324)
        $graphics.DrawString("5 locales", $chipFont, $chipTextBrush, 371, 324)

        $graphics.DrawString(
            "Local-first practice flow with piano sample playback,\nsettings persistence, and guided harmony study.",
            $bodyFont,
            $bodyBrush,
            [System.Drawing.RectangleF]::new(80, 374, 360, 54)
        )
    } finally {
        $titleFont.Dispose()
        $bodyFont.Dispose()
        $chipFont.Dispose()
        $titleBrush.Dispose()
        $bodyBrush.Dispose()
        $chipTextBrush.Dispose()
        $chipBrush.Dispose()
        $chipBrushAlt.Dispose()
    }

    DrawScreenshotCard -Graphics $graphics -ImagePath $mainMenuPath -X 542 -Y 56 -Width 156 -Height 338
    DrawScreenshotCard -Graphics $graphics -ImagePath $generatorPath -X 700 -Y 84 -Width 156 -Height 338
    DrawScreenshotCard -Graphics $graphics -ImagePath $analyzerPath -X 858 -Y 112 -Width 156 -Height 338

    [System.IO.Directory]::CreateDirectory((Split-Path -Parent $outputPath)) | Out-Null
    $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "Generated $outputPath"
} finally {
    $graphics.Dispose()
    $bitmap.Dispose()
}
