#!/bin/bash

# Script to normalize all GitHub release tags to start with 'v'
# This updates both the git tag and GitHub release

set -e

echo "🏷️  Normalizing release tags to start with 'v'..."

# Get all releases that don't start with 'v'
gh release list --limit 1000 --json tagName | jq -r '.[] | select(.tagName | startswith("v") | not) | .tagName' | while read tag; do
    new_tag="v${tag}"
    
    echo "📝 Processing: $tag -> $new_tag"
    
    # Get the release data
    release_data=$(gh release view "$tag" --json body,name,isDraft,isPrerelease,targetCommitish)
    body=$(echo "$release_data" | jq -r '.body')
    name=$(echo "$release_data" | jq -r '.name')
    is_draft=$(echo "$release_data" | jq -r '.isDraft')
    is_prerelease=$(echo "$release_data" | jq -r '.isPrerelease')
    target_commit=$(echo "$release_data" | jq -r '.targetCommitish')
    
    # Create new git tag pointing to the same commit
    echo "🔖 Creating git tag: $new_tag"
    git tag "$new_tag" "$target_commit"
    git push origin "$new_tag"
    
    # Create new release with the same data
    echo "🚀 Creating new release: $new_tag"
    gh release create "$new_tag" \
        --title "$name" \
        --notes "$body" \
        $([ "$is_draft" = "true" ] && echo "--draft") \
        $([ "$is_prerelease" = "true" ] && echo "--prerelease")
    
    # Delete old release and tag
    echo "🗑️  Cleaning up old release: $tag"
    gh release delete "$tag" --yes
    git tag -d "$tag" 2>/dev/null || true
    git push origin --delete "$tag" 2>/dev/null || true
    
    echo "✅ Completed: $tag -> $new_tag"
    echo ""
done

echo "🎉 All tags normalized to start with 'v'"
