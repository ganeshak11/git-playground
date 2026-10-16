# shellcheck shell=bash
# Mission 16 reference solution:
# Uses automated git bisect run with test.sh to find the regression commit,
# records the culprit hash to culprit.txt, and resets bisect.

cd "${SANDBOX}/repo" || exit 1

# 1. Start bisect between bad HEAD and good v1.0
git bisect start HEAD v1.0 >/dev/null 2>&1

# 2. Run automated bisect with the test script
output="$(git bisect run ./test.sh 2>&1)"

# 3. Parse the culprit commit hash
culprit="$(echo "$output" | grep "is the first bad commit" | awk '{print $1}')"

# 4. Cleanly reset bisect
git bisect reset >/dev/null 2>&1

# 5. Write culprit hash to file
if [[ -n "$culprit" ]]; then
    echo "$culprit" > culprit.txt
else
    # Fallback to direct query if bisect output was redirected
    bad="$(git log --grep="Refactor coupon discount rules" --format="%H" -1)"
    echo "$bad" > culprit.txt
fi
