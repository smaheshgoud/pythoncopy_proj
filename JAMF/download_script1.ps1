#########sh
ACCESS_TOKEN="YOUR_ACCESS_TOKEN"
JAMF_URL="https://your-jamf-pro-instance"
POLICIES_ENDPOINT="$JAMF_URL/JSSResource/policies"

curl -X GET \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  $POLICIES_ENDPOINT
####################sh

ACCESS_TOKEN="YOUR_ACCESS_TOKEN"
JAMF_URL="https://your-jamf-pro-instance"
PACKAGES_ENDPOINT="$JAMF_URL/JSSResource/packages"

curl -X GET \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  $PACKAGES_ENDPOINT
###################ps1
$ACCESS_TOKEN = "YOUR_ACCESS_TOKEN"
$JAMF_URL = "https://your-jamf-pro-instance"

# List Policies
$POLICIES_ENDPOINT = "$JAMF_URL/JSSResource/policies"
$headers = @{
    Authorization = "Bearer $ACCESS_TOKEN"
}
$responsePolicies = Invoke-RestMethod -Uri $POLICIES_ENDPOINT -Headers $headers -Method Get

# List Packages
$PACKAGES_ENDPOINT = "$JAMF_URL/JSSResource/packages"
$responsePackages = Invoke-RestMethod -Uri $PACKAGES_ENDPOINT -Headers $headers -Method Get

# Output responses
Write-Host "Policies:"
Write-Output $responsePolicies

Write-Host "Packages:"
Write-Output $responsePackages
