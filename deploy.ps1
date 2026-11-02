[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  テニプリ部 GitHub 自動アップロード (ワンクリック更新)" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

# 1. Git リモートURLの確認
$remoteUrl = git remote get-url origin 2>$null
if (-not $remoteUrl) {
    Write-Host "--------------------------------------------------------" -ForegroundColor Yellow
    Write-Host "【初回セットアップ】GitHubのリポジトリURLが未登録です。" -ForegroundColor Yellow
    Write-Host "--------------------------------------------------------" -ForegroundColor Yellow
    Write-Host "例: https://github.com/kaki-palette/tenipuri-news.git" -ForegroundColor Gray
    Write-Host ""
    $inputUrl = Read-Host "GitHubのリポジトリURLを貼り付けてEnterを押してください"
    if ([string]::IsNullOrWhiteSpace($inputUrl)) {
        Write-Host "URLが入力されませんでした。処理を中断します。" -ForegroundColor Red
        exit 1
    }
    git remote add origin $inputUrl.Trim()
    Write-Host "リモートURLを登録しました: $inputUrl" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host "接続先: $remoteUrl" -ForegroundColor Gray
    Write-Host ""
}

# 2. 変更ファイルの検出とステージング
Write-Host "[1/3] 更新ファイルをステージング中..." -ForegroundColor Cyan
git add -A

# 3. コミット作成
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$commitMsg = "Update: $timestamp テニプリ最新ニュース＆カレンダー更新"
Write-Host "[2/3] コミット作成中: $commitMsg" -ForegroundColor Cyan
git commit -m $commitMsg 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "（コミット対象の新しい変更はありませんでした）" -ForegroundColor Gray
}

# 4. GitHubへプッシュ
Write-Host "[3/3] GitHubへアップロード (Push) 中..." -ForegroundColor Cyan
git branch -M main
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Green
    Write-Host "  【成功】GitHubへのアップロードが正常に完了しました！" -ForegroundColor Green
    Write-Host "========================================================" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "========================================================" -ForegroundColor Yellow
    Write-Host "  【確認】プッシュ時に認証が必要です。" -ForegroundColor Yellow
    Write-Host "  ブラウザでのGitHubサインイン画面やトークン入力画面が" -ForegroundColor Yellow
    Write-Host "  表示された場合は、画面の指示に従ってログインしてください。" -ForegroundColor Yellow
    Write-Host "========================================================" -ForegroundColor Yellow
}

Write-Host ""