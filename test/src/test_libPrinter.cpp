#include "gtest/gtest.h"

#include <printer_lib/printer.h>

#include <sstream>

namespace {

TEST(HelloTest, Negative) {
    std::stringstream ss;
    Printer printer(ss);
    printer.print("hello");

    EXPECT_STREQ("hello", ss.str().c_str());
}

} // namespace