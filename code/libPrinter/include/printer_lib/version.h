#ifndef VERSION_H_
#define VERSION_H_

/** CMake Project Version Info
 * \desc 
 *      Provides an API for version information about the CMake project.
 *      Information is populated at configuration time 
 *      and is available at compile time.
 */
struct project_version{
    constexpr project_version();

    /// Project Name
    /// \desc As recorded in PROJECT_NAME
    constexpr static const char *   name();

    /// Project Version
    /// \desc As recorded in PROJECT_VERSION
    constexpr static const char *   semver();

    /// Project Data
    struct version_data{

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
    constexpr static version_data data();
};

/** Git Repo Version Info
 * \desc 
 *      Provides an API for version information about the project source repo.
 *      Information is populated at configuration time 
 *      and  is available at compile time.
 */
struct git_version{
    constexpr git_version();

    /// Git description
    /// \desc As provided by `git describe`
    constexpr static const char *   desc();

    /// Git remote url
    /// \desc As provided by `git remote get-url $(git remote)`
    constexpr static const char *   url();

    /// Git source branch
    /// \desc As provided by `git rev-parse --abbrev-ref HEAD`
    constexpr static const char *   branch();

    /// Git commit hash
    /// \desc As provided by `git rev-parse HEAD`
    constexpr static const char *   hash();

    /// Git working state
    /// \desc As provided by `git diff --quiet`
    constexpr static const bool     dirty();

    /// Git version data
    struct git_data{

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
    constexpr static git_data data();

};


#endif // VERSION_H_