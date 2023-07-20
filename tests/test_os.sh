# Error on unset variables
set -u

if [ -n "${ZSH_VERSION-}" ]; then
  SHUNIT_PARENT="$0"
  setopt shwordsplit
fi

. ../liquidprompt --no-activate

function test_os {
    LP_ENABLE_COLOR=0 # Cannot test hash colors.
    LP_ENABLE_OS=1

    LP_ENABLE_OS_ARCH=1
    LP_ENABLE_OS_FAMILY=1
    LP_ENABLE_OS_KERNEL=1
    LP_ENABLE_OS_DISTRIB=1
    LP_ENABLE_OS_VERSION=1

    uname() { printf 'OpenBSD i386'; }
    _lp_os
    assertEquals "BSD" "$lp_os_family"
    assertEquals "OpenBSD" "$lp_os_kernel"
    assertEquals "i386" "$lp_os_arch"
    assertNull "$lp_os_distrib"
    assertNull "$lp_os_version"
    unset -f uname

    uname() { printf 'MSYS ARM'; }
    _lp_os
    assertEquals "Windows" "$lp_os_family"
    assertEquals "MSYS" "$lp_os_kernel"
    assertEquals "ARM" "$lp_os_arch"
    assertNull "$lp_os_distrib"
    assertNull "$lp_os_version"
    unset -f uname

    uname() { printf 'Linux x86_64'; }
    _lp_grep_fields() { lp_grep_fields=("ubuntu" "focal"); }
    _lp_os
    assertEquals "GNU" "$lp_os_family"
    assertEquals "Linux" "$lp_os_kernel"
    assertEquals "x86_64" "$lp_os_arch"
    assertEquals "ubuntu" "$lp_os_distrib"
    assertEquals "focal" "$lp_os_version"
    unset -f uname
    unset -f _lp_grep_fields

    uname() { printf 'OSCO 486'; }
    _lp_grep_fields() { lp_grep_fields=("urs"); }
    _lp_os
    assertNull "$lp_os_family"
    assertNull "$lp_os_kernel"
    assertEquals "486" "$lp_os_arch"
    assertNull "$lp_os_distrib"
    assertNull "$lp_os_version"
    unset -f uname
    unset -f _lp_grep_fields

    uname() { printf 'Linux x86_64'; }
    _lp_grep_fields() { lp_grep_fields=("ubuntu" "focal"); }
    LP_MARK_OS=("FreeBSD" "NOPE" "x86" "NOPE" "GNU" "G" "Linux" "L" "x86_64" "6" "ubuntu" "U" "focal" "F")

    LP_MARK_OS_SEP="+"
    LP_ENABLE_OS_ARCH=1
    LP_ENABLE_OS_FAMILY=1
    LP_ENABLE_OS_KERNEL=1
    LP_ENABLE_OS_DISTRIB=1
    LP_ENABLE_OS_VERSION=1
    _lp_os_color
    assertEquals "6+G+L+U+F" "$lp_os_color"
    unset -f uname

    uname() { printf 'Linux'; }
    LP_MARK_OS_SEP=""
    LP_ENABLE_OS_ARCH=0
    LP_ENABLE_OS_FAMILY=1
    LP_ENABLE_OS_KERNEL=1
    LP_ENABLE_OS_DISTRIB=1
    LP_ENABLE_OS_VERSION=1
    _lp_os_color
    assertEquals "GLUF" "$lp_os_color"
    unset -f uname

    unset -f _lp_grep_fields

    # ARCH
    LP_ENABLE_OS_ARCH=1
    LP_ENABLE_OS_FAMILY=0
    LP_ENABLE_OS_KERNEL=0
    LP_ENABLE_OS_DISTRIB=0
    LP_ENABLE_OS_VERSION=0
    uname() { printf 'Linux ARM'; }
    _lp_os
    assertEquals "ARM" "$lp_os_arch"
    assertNull "arch, not family" "$lp_os_family"
    assertNull "arch, not kernel" "$lp_os_kernel"
    assertNull "arch, not distrib" "$lp_os_distrib"
    assertNull "arch, not version" "$lp_os_version"
    unset -f uname

    # FAMILY
    LP_ENABLE_OS_ARCH=0
    LP_ENABLE_OS_FAMILY=1
    LP_ENABLE_OS_KERNEL=0
    LP_ENABLE_OS_DISTRIB=0
    LP_ENABLE_OS_VERSION=0
    uname() { printf 'Linux'; }
    _lp_os
    assertNull "family, not arch" "$lp_os_arch"
    assertEquals "GNU" "$lp_os_family"
    assertNull "family, not kernel" "$lp_os_kernel"
    assertNull "family, not distrib" "$lp_os_distrib"
    assertNull "family, not version" "$lp_os_version"
    unset -f uname

    # KERNEL
    LP_ENABLE_OS_ARCH=0
    LP_ENABLE_OS_FAMILY=0
    LP_ENABLE_OS_KERNEL=1
    LP_ENABLE_OS_DISTRIB=0
    LP_ENABLE_OS_VERSION=0
    uname() { printf 'Linux'; }
    _lp_os
    assertNull "kernel, not arch" "$lp_os_arch"
    assertNull "kernel, not family" "$lp_os_family"
    assertEquals "Linux" "$lp_os_kernel"
    assertNull "kernel, not distrib" "$lp_os_distrib"
    assertNull "kernel, not version" "$lp_os_version"
    unset -f uname

    # DISTRIB
    LP_ENABLE_OS_ARCH=0
    LP_ENABLE_OS_FAMILY=0
    LP_ENABLE_OS_KERNEL=0
    LP_ENABLE_OS_DISTRIB=1
    LP_ENABLE_OS_VERSION=0
    uname() { printf 'Linux'; }
    _lp_grep_fields() { lp_grep_fields=("ubuntu"); }
    _lp_os
    assertNull "distrib, not arch" "$lp_os_arch"
    assertNull "distrib, not family" "$lp_os_family"
    assertNull "distrib, not kernel" "$lp_os_kernel"
    assertEquals "ubuntu" "$lp_os_distrib"
    assertNull "distrib, not version" "$lp_os_version"
    unset -f uname
    unset -f _lp_grep_fields

    # VERSION
    LP_ENABLE_OS_ARCH=0
    LP_ENABLE_OS_FAMILY=0
    LP_ENABLE_OS_KERNEL=0
    LP_ENABLE_OS_DISTRIB=0
    LP_ENABLE_OS_VERSION=1
    uname() { printf 'Linux'; }
    _lp_grep_fields() { lp_grep_fields=("focal"); }
    _lp_os
    assertNull "version, not arch" "$lp_os_arch"
    assertNull "version, not family" "$lp_os_family"
    assertNull "version, not kernel" "$lp_os_kernel"
    assertNull "version, not distrib" "$lp_os_distrib"
    assertEquals "focal" "$lp_os_version"
    unset -f uname
    unset -f _lp_grep_fields

}

. ./shunit2
