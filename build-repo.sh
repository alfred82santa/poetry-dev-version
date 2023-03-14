export SHORT_PACKAGE_NAME=poetry-dev-version
# Shot name of package (no discovery prefix). Example: daiscovery-foobar => foobar
export FULL_PACKAGE_NAME=poetry-dev-version
# Full name of package.
export REPO_NAME=poetry-dev-version
# Repository name without owner (no Telefonica/). Example: Telefonica/discovery-foobar => discovery-foobar
export PACKAGE_DIR=src/poetry_dev_version


export REPO_NAME=poetry-dev-version
export REPO_ID="$(gh api graphql -f query='{repository(owner:"alfred82santa",name:"'$REPO_NAME'"){id}}' -q .data.repository.id)"
gh repo edit Telefonica/$REPO_NAME --default-branch=develop --delete-branch-on-merge=true --enable-rebase-merge=true --enable-auto-merge=true --add-topic poetry,poetry-plugin
gh api graphql -f query='
     mutation($repositoryId:ID!,$branch:String!) {
       createBranchProtectionRule(input: {
         repositoryId: $repositoryId
         pattern: $branch
         requiresApprovingReviews: true
         requiresConversationResolution: true
         requiresStatusChecks: true
         requiresStrictStatusChecks: true
         allowsForcePushes: false
         requiredStatusCheckContexts: ["Success Pull Request"]
       }) { clientMutationId }
     }' -f repositoryId="$REPO_ID" -f branch="develop"
gh api graphql -f query='
     mutation($repositoryId:ID!,$branch:String!) {
       createBranchProtectionRule(input: {
         repositoryId: $repositoryId
         pattern: $branch
         requiresApprovingReviews: true
         requiresConversationResolution: true
         requiresStatusChecks: true
         requiresStrictStatusChecks: true
         dismissesStaleReviews: true
         allowsForcePushes: false
         requiredStatusCheckContexts: ["Success Pull Request"]
       }) { clientMutationId }
     }' -f repositoryId="$REPO_ID" -f branch="[main,master]*"