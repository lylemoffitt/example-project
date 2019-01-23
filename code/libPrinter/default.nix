{
    stdenv, 
    fetchgitPrivate,
    cmake
}:

stdenv.mkDerivation rec {
    name = "libPrinter-${version}";
    version = "1.0.0";

    src = fetchgitPrivate {
        url = "git@github.com:lylemoffitt/example-project.git";
        rev = "9f3ec2a8299ad288f6fd5fe4ae3f426ca65066a3";
        sha256 = "1bqj12w23nn27x64ianm2flrqvkskpvgrnly7ah8gv6k8s8chh3r";
    };

    nativeBuildInputs = [ cmake ];

    meta = with stdenv.lib; {
        description = "Simple serial printing library";
        # homepage = https://android.googlesource.com/platform/external/svox;
        # platforms = platforms.linux;
        # license = licenses.asl20;
        # maintainers = with maintainers; [ abbradar ];
    };
}