#!/usr/bin/env bats

load support

@test 'lp: stock' {
    run_shell tests/cases/stock.sh
}

@test 'lp: stock: git' {
    run_shell tests/cases/git.sh
}

@test 'lp: stock: path shortening' {
    run_shell tests/cases/path-shorten.sh
}

@test 'lp: stock: tags' {
    run_shell tests/cases/tags.sh
}

@test 'lp: stock: time' {
    run_shell tests/cases/time.sh
}
