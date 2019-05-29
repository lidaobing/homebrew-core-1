class LibjdcloudSigner < Formula
  desc "C++ signing library for jdcloud.com"
  homepage "https://github.com/jdcloud-api/jdcloud-sdk-cpp-signer"
  url "https://github.com/jdcloud-api/jdcloud-sdk-cpp-signer/archive/v0.2.0.tar.gz"
  sha256 "f78ac6cfc8bdf539eaca11f13966671e38749feb46abac57db36bb24a8d12e36"
  head "https://github.com/jdcloud-api/jdcloud-sdk-cpp-signer.git"

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}", "."
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <jdcloud_signer/JdcloudSigner.h>
      using namespace jdcloud_signer;
      int main() {
        Credential credential("AK", "SK");
        JdcloudSigner signer(credential, "vm", "cn-north-1");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-ljdcloud_signer"
    system "./test"
  end
end
