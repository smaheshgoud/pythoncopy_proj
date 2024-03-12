ACCESS_TOKEN="YOUR_ACCESS_TOKEN"
JAMF_URL="https://your-jamf-pro-instance"
POLICIES_ENDPOINT="$JAMF_URL/JSSResource/policies"

curl -X GET \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  $POLICIES_ENDPOINT
####################

ACCESS_TOKEN="YOUR_ACCESS_TOKEN"
JAMF_URL="https://your-jamf-pro-instance"
PACKAGES_ENDPOINT="$JAMF_URL/JSSResource/packages"

curl -X GET \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  $PACKAGES_ENDPOINT
