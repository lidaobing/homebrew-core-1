class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gedit-technology.github.io"
  url "https://github.com/gedit-technology/libgedit-gtksourceview/releases/download/299.2.1/libgedit-gtksourceview-299.2.1.tar.xz"
  sha256 "f94ea579636d73b4a783b9ec43d77bc9a43d4b633b3bf9ba9d7a011cadb5cb92"
  license "LGPL-2.1-only"
  head "https://github.com/gedit-technology/libgedit-gtksourceview.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "gtk+3"
  depends_on "libxml2" # Dependent `gedit` uses Homebrew `libxml2`

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dgtk_doc=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs libgedit-gtksourceview-300").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
