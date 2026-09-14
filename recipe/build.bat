mkdir "%SRC_DIR%"\build
pushd "%SRC_DIR%"\build

cmake -G "Ninja" ^
      -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_LIBDIR=lib ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DBUILD_SHARED_LIBS=ON ^
      -DBUILD_TESTING=ON ^
      -DENABLE_NET_TESTS=OFF ^
      ..
if errorlevel 1 exit 1

ninja install
if errorlevel 1 exit 1

@rem Network tests require S3 credentials; run the upstream non-network suite.
set "PATH=%CD%;%LIBRARY_BIN%;%PATH%"
ctest --output-on-failure -C Release
if errorlevel 1 exit 1
