# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Kicadlibrarian < Formula
  homepage "http://www.compuphase.com/electronics/kicadlibranrian_en.htm"
  head "https://github.com/shaneburrell/kicadlibr-osx.git"

  depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "wxkicad"
  depends_on "curl"
  depends_on "libharu"

  def install
    args = %W[
            -DCMAKE_C_COMPILER=/usr/bin/clang
            -DCMAKE_CXX_COMPILER=/usr/bin/clang++
            -DCMAKE_INSTALL_PREFIX=#{prefix}
            -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
            -DwxWidgets_CONFIG_EXECUTABLE=#{Formula["wxkicad"].bin}/wx-config
            -DCMAKE_BUILD_TYPE=Release
            -DCMAKE_CXX_FLAGS=-stdlib=libc++
            -DCMAKE_C_FLAGS=-stdlib=libc++
        ]
    Dir.chdir("src") do
      system "cmake", "./", *args
      system "make" # if this fails, try separate make/make install steps
      system "make install"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test kicadlibrarian-sources`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
__END__
