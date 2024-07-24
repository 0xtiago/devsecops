# Set variables
$DC_VERSION = "latest"
$DC_DIRECTORY = "$env:USERPROFILE\OWASP-Dependency-Check"
$DC_PROJECT = "dependency-check scan: $PWD"
$DATA_DIRECTORY = "$DC_DIRECTORY\data"
$CACHE_DIRECTORY = "$DC_DIRECTORY\data\cache"

# Create directories if they do not exist
if (-Not (Test-Path -Path $DATA_DIRECTORY)) {
    Write-Host "Initially creating persistent directory: $DATA_DIRECTORY"
    New-Item -ItemType Directory -Path $DATA_DIRECTORY
}
if (-Not (Test-Path -Path $CACHE_DIRECTORY)) {
    Write-Host "Initially creating persistent directory: $CACHE_DIRECTORY"
    New-Item -ItemType Directory -Path $CACHE_DIRECTORY
}

# Make sure we are using the latest version
docker pull owasp/dependency-check:$DC_VERSION

# Run dependency-check
docker run --rm `
    -v "${PWD}:/src" `
    -v "${DATA_DIRECTORY}:/usr/share/dependency-check/data" `
    -v "${PWD}/reports:/report" `
    owasp/dependency-check:$DC_VERSION `
    --scan /src `
    --format "ALL" `
    --project "$DC_PROJECT" `
    --out /report

# Use suppression like this: (where /src == $PWD)
# --suppression "/src/security/dependency-check-suppression.xml"
