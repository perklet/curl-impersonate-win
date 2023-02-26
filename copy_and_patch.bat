xcopy .\boringssl_original\* .\boringssl\ /r /d /i /s /y /exclude:.\excludecopy.txt
xcopy .\curl_original\* .\curl\ /r /d /i /s /y /exclude:.\excludecopy.txt

set patch=c:\msys64\usr\bin\patch.exe
set sed=c:\msys64\usr\bin\sed.exe

cd %~dp0\boringssl
%patch% -p1 < %~dp0\curl-impersonate\chrome\patches\boringssl-old-ciphers.patch
%sed% -i 's/-ggdb//g' CMakeLists.txt
%sed% -i 's/-Werror//g' CMakeLists.txt

cd %~dp0\curl
%patch% -p1 < %~dp0\curl-impersonate\chrome\patches\curl-impersonate.patch
%sed% -i 's/-shared/-s -static -shared/g' lib\Makefile.m32
%sed% -i 's/-static/-s -static/g' src\Makefile.m32

%sed% -i 's/-DUSE_NGHTTP2/-DUSE_NGHTTP2 -DNGHTTP2_STATICLIB/g' lib\Makefile.m32
%sed% -i 's/-DUSE_NGHTTP2/-DUSE_NGHTTP2 -DNGHTTP2_STATICLIB/g' src\Makefile.m32

%sed% -i 's/-lidn2/-lidn2 -lunistring -liconv/g' lib\Makefile.m32
%sed% -i 's/-lidn2/-lidn2 -lunistring -liconv/g' src\Makefile.m32

pause
