#!/bin/sh
# Tests for combine.sh and combine.bat. Run: bash skills/ppt-combine/test/combine-test.sh
# Each test works on a fresh copy of the fixtures, so nothing is written into the repo.

TEST_DIR=$(cd "$(dirname "$0")" && pwd)
SKILL_DIR=$(dirname "$TEST_DIR")
FIXTURES="$TEST_DIR/fixtures"
EXPECTED="$FIXTURES/expected-FULL.md"

failures=0
passes=0
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

pass() { passes=$((passes + 1)); echo "PASS: $1"; }
fail() { failures=$((failures + 1)); echo "FAIL: $1"; }

# Prints the path of a fresh copy of the fixture spec folder.
fresh_spec() {
    d="$WORK/$1"
    mkdir -p "$d"
    cp "$FIXTURES/spec/"* "$d/"
    echo "$d"
}

# Prints the path of a fresh spec folder holding one section file and no ARCHITECTURE.md.
fresh_spec_without_architecture() {
    d="$WORK/$1"
    mkdir -p "$d"
    cp "$FIXTURES/spec/01-a.md" "$d/"
    echo "$d"
}

run_sh() {
    bash "$SKILL_DIR/combine.sh" "$1"
}

# cmd may be missing from PATH in Git Bash, so fall back to COMSPEC.
CMD=$(command -v cmd || command -v cmd.exe || true)
if [ -z "$CMD" ] && [ -n "$COMSPEC" ]; then
    CMD=$(cygpath -u "$COMSPEC" 2>/dev/null || echo "$COMSPEC")
    [ -x "$CMD" ] || CMD=
fi

run_bat() {
    "$CMD" //c "$(cygpath -w "$SKILL_DIR/combine.bat")" "$(cygpath -w "$1")"
}

# --- combine.sh ---

spec=$(fresh_spec sh-order)
out=$(run_sh "$spec")
code=$?
if [ $code -eq 0 ] && cmp -s "$spec/FULL.md" "$EXPECTED"; then
    pass "combine.sh output is byte-identical to expected-FULL.md"
else
    fail "combine.sh output differs from expected-FULL.md (exit $code)"
    diff "$EXPECTED" "$spec/FULL.md"
fi
if [ "$out" = "$spec/FULL.md" ]; then
    pass "combine.sh prints the output path"
else
    fail "combine.sh printed '$out', expected '$spec/FULL.md'"
fi

out=$(run_sh "$spec")
if [ $? -eq 0 ] && cmp -s "$spec/FULL.md" "$EXPECTED"; then
    pass "combine.sh second run overwrites with unchanged output"
else
    fail "combine.sh second run changed the output"
fi

spec=$(fresh_spec sh-cwd)
out=$(cd "$spec" && bash "$SKILL_DIR/combine.sh")
if [ $? -eq 0 ] && cmp -s "$spec/FULL.md" "$EXPECTED"; then
    pass "combine.sh with no argument uses the current directory"
else
    fail "combine.sh with no argument did not write FULL.md in the current directory"
fi

spec=$(fresh_spec "sh Deck (v2)/spec")
run_sh "$spec" >/dev/null
if [ $? -eq 0 ] && cmp -s "$spec/FULL.md" "$EXPECTED"; then
    pass "combine.sh handles a folder path with a space and parentheses"
else
    fail "combine.sh failed on a folder path with a space and parentheses"
fi

empty=$(fresh_spec_without_architecture sh-missing)
err=$(run_sh "$empty" 2>&1 >/dev/null)
code=$?
if [ $code -eq 1 ] && [ "$err" = "ARCHITECTURE.md not found in $empty" ] && [ ! -e "$empty/FULL.md" ]; then
    pass "combine.sh without ARCHITECTURE.md exits 1, reports it, writes nothing"
else
    fail "combine.sh without ARCHITECTURE.md: exit $code, stderr '$err', FULL.md exists: $([ -e "$empty/FULL.md" ] && echo yes || echo no)"
fi

# --- combine.bat ---

if [ -z "$CMD" ]; then
    echo "SKIP: combine.bat tests (cmd not found)"
else
    spec=$(fresh_spec bat-order)
    out=$(run_bat "$spec")
    code=$?
    out=$(printf '%s' "$out" | tr -d '\r')
    if [ $code -eq 0 ] && tr -d '\r' < "$spec/FULL.md" | cmp -s - "$EXPECTED"; then
        pass "combine.bat output matches expected-FULL.md, ignoring CRLF"
    else
        fail "combine.bat output differs from expected-FULL.md (exit $code)"
        tr -d '\r' < "$spec/FULL.md" | diff "$EXPECTED" -
    fi
    if [ "$out" = "$(cygpath -w "$spec/FULL.md")" ]; then
        pass "combine.bat prints the output path"
    else
        fail "combine.bat printed '$out', expected '$(cygpath -w "$spec/FULL.md")'"
    fi

    run_bat "$spec" >/dev/null
    if [ $? -eq 0 ] && tr -d '\r' < "$spec/FULL.md" | cmp -s - "$EXPECTED"; then
        pass "combine.bat second run overwrites with unchanged output"
    else
        fail "combine.bat second run changed the output"
    fi

    spec=$(fresh_spec "bat Deck (v2)/spec")
    run_bat "$spec" >/dev/null
    if [ $? -eq 0 ] && [ -f "$spec/FULL.md" ] && tr -d '\r' < "$spec/FULL.md" | cmp -s - "$EXPECTED"; then
        pass "combine.bat handles a folder path with a space and parentheses"
    else
        fail "combine.bat failed on a folder path with a space and parentheses"
    fi

    empty=$(fresh_spec_without_architecture "bat Miss (x)")
    err=$(run_bat "$empty" 2>&1 >/dev/null | tr -d '\r')
    if [ "$err" = "ARCHITECTURE.md not found in $(cygpath -w "$empty")" ]; then
        pass "combine.bat reports the full folder path when it has parentheses"
    else
        fail "combine.bat printed '$err' for a missing ARCHITECTURE.md in a folder with parentheses"
    fi

    empty=$(fresh_spec_without_architecture bat-missing)
    err=$(run_bat "$empty" 2>&1 >/dev/null)
    code=$?
    err=$(printf '%s' "$err" | tr -d '\r')
    if [ "$code" -eq 1 ] && [ "$err" = "ARCHITECTURE.md not found in $(cygpath -w "$empty")" ] && [ ! -e "$empty/FULL.md" ]; then
        pass "combine.bat without ARCHITECTURE.md exits 1, reports it, writes nothing"
    else
        fail "combine.bat without ARCHITECTURE.md: exit $code, stderr '$err', FULL.md exists: $([ -e "$empty/FULL.md" ] && echo yes || echo no)"
    fi
fi

echo "$passes passed, $failures failed"
[ $failures -eq 0 ]
