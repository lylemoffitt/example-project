#ifndef VERSION_H_
#define VERSION_H_

namespace version{

constexpr const char * semver();
constexpr const char * hash();
constexpr const char * short_hash();
constexpr const char * git_desc();

struct version_t{
    const unsigned major;
    const unsigned minor;
    const unsigned patch;
};

constexpr version_t version();

}

#endif // VERSION_H_