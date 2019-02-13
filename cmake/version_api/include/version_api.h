#ifndef VERSION_API_H_
#define VERSION_API_H_

namespace version {

/** CMake Project Version Info
 * \desc 
 *      Provides an API for version information about the CMake project.
 *      Information is populated at configuration time 
 *      and is available at compile time.
 */
struct project{

    /// Project Name
    /// \desc As recorded in PROJECT_NAME
    static const char *   name();

    /// Project Version
    /// \desc As recorded in PROJECT_VERSION
    static const char *   semver();

    /// Project Data
    struct data_t{

        /// The name of the project
        /// \desc As recorded in PROJECT_NAME
        const char *    name;

        /// Project major version
        /// \desc As recorded in PROJECT_VERSION_MAJOR
        const unsigned  major;

        /// Project minor version
        /// \desc As recorded in PROJECT_VERSION_MINOR
        const unsigned  minor;

        /// Project patch version
        /// \desc As recorded in PROJECT_VERSION_PATCH
        const unsigned  patch;
    };

    /// Project Data
    static data_t data();
};

/** Git Repo Version Info
 * \desc 
 *      Provides an API for version information about the project source repo.
 *      Information is populated at configuration time 
 *      and  is available at compile time.
 */
struct git{

    /// Git description
    /// \desc As provided by `git describe`
    static const char *   desc();

    /// Git remote url
    /// \desc As provided by `git remote get-url $(git remote)`
    static const char *   url();

    /// Git source branch
    /// \desc As provided by `git rev-parse --abbrev-ref HEAD`
    static const char *   branch();
    /// Git commit hash
    /// \desc As provided by `git rev-parse HEAD`
    static const char *   hash();

    /// Git working state
    /// \desc As provided by `git diff --quiet`
    static const bool     dirty();

    /// Git version data
    struct data_t{

        /// Git remote url
        /// \desc As provided by `git remote get-url $(git remote)`
        const char *    url;

        /// Git source branch
        /// \desc As provided by `git rev-parse --abbrev-ref HEAD`
        const char *    branch;

        /// Git commit hash
        /// \desc As provided by `git rev-parse HEAD`
        const char *    hash;
        
        /// Git working state
        /// \desc As provided by `git diff --quiet`
        const bool      dirty;
    };

    /// Git version data
    static data_t data();
};

} // namespace version


#endif // VERSION_API_H_