@echo off
chcp 65001 >nul
title テニプリ部 - GitHub自動アップロードツール

echo ========================================================
echo   テニプリ部 GitHub 自動アップロード (ワンクリック更新)
echo ========================================================
echo.

cd /d "%~dp0"

:: 1. Git リモートURLの確認
git remote get-url origin >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [案内] 初回セットアップが必要です。
    echo GitHubのリポジトリURLがまだ登録されていません。
    echo.
    echo 例: https://github.com/kaki-palette/tenipuri-news.git
    set /p REPO_URL="GitHubのリポジトリURLを入力してください: "
    if "%REPO_URL%"=="" (
        echo [エラー] URLが入力されませんでした。処理を中断します。
        pause
        exit /b 1
    )
    git remote add origin %REPO_URL%
    echo [完了] リモートURLを登録しました: %REPO_URL%
    echo.
)

:: 2. 変更ファイルをすべてステージング
echo [1/3] 更新ファイルを検出中...
git add -A

:: 3. コミット実行
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do set CDATE=%%a-%%b-%%c
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set CTIME=%%a:%%b
set COMMIT_MSG=Update: %DATE% %TIME% テニプリ最新ニュース＆カレンダー更新

echo [2/3] コミット作成中 (%COMMIT_MSG%)...
git commit -m "%COMMIT_MSG%"

:: 4. GitHubへプッシュ
echo [3/3] GitHubへアップロード (プッシュ) 中...
git branch -M main
git push -u origin main

if %ERRORLEVEL% equ 0 (
    echo.
    echo ========================================================
    echo   【成功】GitHubへのアップロードが正常に完了しました！
    echo ========================================================
) else (
    echo.
    echo ========================================================
    echo   【注意】プッシュ時に確認またはエラーが発生しました。
    echo   GitHubのログイン認証やPersonal Access Token (PAT)の
    echo   入力画面が表示されている場合は認証を行ってください。
    echo ========================================================
)

echo.
pause
