#include "gtest/gtest.h"

#include <printer_lib/printer.h>

#include <sstream>

#ifndef APPEND_ENDLINE
#define APPEND_ENDLINE 1
#endif

#if APPEND_ENDLINE
#define NL_STR "\n"
#else
#define NL_STR ""
#endif

namespace {



TEST(HelloTest, print_hello_get_hello) {
    std::stringstream ss;
    Printer printer(ss);
    printer.print("hello");

    const char expected[] = "hello" NL_STR;

    EXPECT_STREQ(expected, ss.str().c_str());
}

TEST(HelloTest, version_check) {

    EXPECT_STREQ("1.0.0", version::semver());
}

} // namespace