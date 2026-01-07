param(
  [Parameter(Mandatory=$true)] [string]$GitHubUser,
  [string]$RepoName = "personal-card"
)

Write-Host "Starting deployment for $GitHubUser/$RepoName"

# Initialize git if needed
if (-not (Test-Path .git)) {
  git init
  git branch -M main
  git add .
  git commit -m "Initial personal card" -q
}

# Prefer gh CLI if available
if (Get-Command gh -ErrorAction SilentlyContinue) {
  $auth = (gh auth status 2>&1)
  if ($auth -match "You are not logged in") {
    Write-Host "Please login to GitHub CLI (interactive): gh auth login"
    exit 1
  }

  gh repo create $RepoName --public --source . --remote origin --push --confirm

  # Enable Pages via GitHub API using gh
  $body = @{ source = @{ branch = "main"; path = "/" } } | ConvertTo-Json
  gh api -X PUT "repos/$GitHubUser/$RepoName/pages" -f body="$body"

  Write-Host "Repository created and pushed. Pages configured (may take a minute to become live)."
  Write-Host "URL: https://$GitHubUser.github.io/$RepoName/"
  exit 0
}

# Fallback: use curl with GITHUB_TOKEN environment variable
$token = $env:GITHUB_TOKEN
if (-not $token) {
  Write-Host "Neither gh CLI found nor GITHUB_TOKEN set. Install gh or set GITHUB_TOKEN and retry." -ForegroundColor Yellow
  Write-Host "gh: https://cli.github.com/"
  exit 1
}

# Create remote repo via GitHub API
$createBody = @{ name = $RepoName; private = $false } | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri "https://api.github.com/user/repos" -Headers @{ Authorization = "token $token"; "User-Agent" = "deploy-script" } -Body $createBody -ContentType "application/json"

# Add remote and push
$remoteUrl = "https://github.com/$GitHubUser/$RepoName.git"
if (-not (git remote)) { git remote add origin $remoteUrl }
git push -u origin main

# Enable Pages
$pagesBody = @{ source = @{ branch = "main"; path = "/" } } | ConvertTo-Json
Invoke-RestMethod -Method Put -Uri "https://api.github.com/repos/$GitHubUser/$RepoName/pages" -Headers @{ Authorization = "token $token"; "User-Agent" = "deploy-script" } -Body $pagesBody -ContentType "application/json"

Write-Host "Repository created and pushed. Pages configured (may take a minute to become live)."
Write-Host "URL: https://$GitHubUser.github.io/$RepoName/"