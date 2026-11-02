# テニプリ部 GitHub 自動アップロード スクリプト
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "  テニプリ部 GitHub 自動アップロード (ワンクリック更新)" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

# 1. リモートURLの確認
$remoteUrl = git remote get-url origin 2>$null
if (-not $remoteUrl) {
    Write-Host "[案内] 初回セットアップ: GitHubのリポジトリURLが未登録です。" -ForegroundColor Yellow
    Write-Host "例: https://github.com/kaki-palette/tenipuri-news.git" -ForegroundColor Gray
    $inputUrl = Read-Host "GitHubのリポジトリURLを入力してください"
    if ([string]::IsNullOrWhiteSpace($inputUrl)) {
        Write-Host "[エラー] URLが未入力のため終了します。" -ForegroundColor Red
        exit 1
    }
    git remote add origin $inputUrl.Trim()
    Write-Host "[完了] リモートURLを登録しました: $inputUrl" -ForegroundColor Green
    Write-Host ""
}

# 2. ステージング
Write-Host "[1/3] 更新ファイルをステージング中..." -ForegroundColor Cyan
git add -A

# 3. コミット
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$commitMsg = "Update: $timestamp テニプリ最新ニュース＆カレンダー更新"
Write-Host "[2/3] コミット作成中: $commitMsg" -ForegroundColor Cyan
git commit -m $commitMsg

# 4. プッシュ
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
    Write-Host "  【確認】プッシュ時に認証等の確認が必要です。" -ForegroundColor Yellow
    Write-Host "========================================================" -ForegroundColor Yellow
}
