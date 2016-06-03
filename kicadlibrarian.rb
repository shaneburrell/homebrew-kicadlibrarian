# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Kicadlibrarian < Formula
  homepage "http://www.compuphase.com/electronics/kicadlibranrian_en.htm"
  head "https://github.com/shaneburrell/kicadlibr-osx.git"

  depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "curl"
  depends_on "libharu"

  resource "wx31patch" do
    url "https://gist.githubusercontent.com/metacollin/710d4cb34a549532cbd33c5ab668eecc/raw/e8ca8cb496d778cb356c83b659dc5736e302b964/wx31.patch"
    sha256 "bbe4a15ebbb4b5b58d3a01ae36902672fe6fe579302b2635e6cb395116f65e3b"
  end

  resource "wxk" do
    url "https://github.com/wxWidgets/wxWidgets/releases/download/v3.1.0/wxWidgets-3.1.0.tar.bz2"
    sha256 "e082460fb6bf14b7dd6e8ac142598d1d3d0b08a7b5ba402fdbf8711da7e66da8"
  end


  def install
    resource("wxk").stage do
      Pathname.pwd.install resource "wx31patch"
      safe_system "/usr/bin/patch", "-g", "0", "-f", "-d", Pathname.pwd, "-p1", "-i", "wx31.patch"

      mkdir "wx-build" do
        args = %W[
          --prefix=#{buildpath}/wxk
          --with-opengl
          --enable-aui
          --enable-utf8
          --enable-html
          --enable-stl
          --with-libjpeg=builtin
          --with-libpng=builtin
          --with-regex=builtin
          --with-libtiff=builtin
          --with-zlib=builtin
          --with-expat=builtin
          --without-liblzma
          --with-macosx-version-min=#{MacOS.version}
          --enable-universal_binary=i386,x86_64
          CC=#{ENV.cc}
          CXX=#{ENV.cxx}
        ]

        system "../configure", *args
        system "make", "-j8"
        system "make", "install"
      end
    end

    args = %W[
            -DCMAKE_C_COMPILER=/usr/bin/clang
            -DCMAKE_CXX_COMPILER=/usr/bin/clang++
            -DCMAKE_INSTALL_PREFIX=#{prefix}
            -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
            -DwxWidgets_CONFIG_EXECUTABLE=#{buildpath}/wxk/bin/wx-config
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
