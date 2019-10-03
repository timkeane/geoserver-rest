EXPORT_PATH=$1
wsName=$2
dsName=$3
sleep 5
echo
echo "Retrieving featuretypes for datastore '$dsName' ..."
mkdir -p $EXPORT_PATH/workspaces/$wsName/datastores/$dsName/featuretypes
featuretypes=`curl $GS_REST/workspaces/$wsName/datastores/$dsName/featuretypes.json | jq '.featureTypes.featureType'`
for featuretype in $(echo "${featuretypes}" | jq -r '.[] | @base64'); do
  sleep 5
  _jq() {
    echo ${featuretype} | base64 --decode | jq -r ${1}
  }
  ftName=$(_jq '.name')
  echo
  echo "Saving featuretype '$ftName' to '$EXPORT_PATH/workspaces/$wsName/datastores/$dsName/featuretypes/$ftName.json' ..."
  echo
  curl $GS_REST/workspaces/$wsName/datastores/$dsName/featuretypes/$ftName.json > $EXPORT_PATH/workspaces/$wsName/datastores/$dsName/featuretypes/$ftName.json
done
