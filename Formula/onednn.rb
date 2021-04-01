class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/refs/tags/v2.2.tar.gz"
  sha256 "4d655c0751ee6439584ef5e3d465953fe0c2f4ee2700bc02699bdc1d1572af0d"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "045f62a40883229b10146c715306d1412f6f0bc4828d45942dbba29f03bb3c12"
    sha256 cellar: :any, big_sur:       "8acd092ad84f8677785da0c5bb92e117b17f903a2702b66ee4572c93d5bb80a1"
    sha256 cellar: :any, catalina:      "669ffb542483c34cf208829b6fe5d8debc60d0e9def35394834676d4db42c4cd"
    sha256 cellar: :any, mojave:        "aa2922eb9ba741cde52d2b74f8787fdcec61e478b0d949cd6c8795fa3a2560e4"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "doc"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mkldnn.h>
      int main() {
        mkldnn_engine_t engine;
        mkldnn_status_t status = mkldnn_engine_create(&engine, mkldnn_cpu, 0);
        return !(status == mkldnn_success);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmkldnn", "-o", "test"
    system "./test"
  end
end
