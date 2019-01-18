#include "gtest/gtest.h"

#include <printer_lib/printer.h>

#include <sstream>

namespace {

TEST(HelloTest, print_hello_get_hello) {
    std::stringstream ss;
    Printer printer(ss);
    printer.print("hello");

    EXPECT_STREQ("hello\n", ss.str().c_str());
}

} // namespace