!#/bin/bash
echo ""
echo "==================="
echo "Testing environment"
echo "==================="
echo ""
echo "PATH=$PATH"
echo env
cd ./.test/hello-world
echo ""
echo "================================="
echo "Testing hello-world (debug build)"
echo "================================="
echo ""
cargo run
echo ""
echo "==================================="
echo "Testing hello-world (release build)"
echo "==================================="
cargo run --release
echo ""
cd ../../
echo ""
echo "========================================================================="
echo "Very basic env test complete - successfully compiled and ran hello-world."
echo "========================================================================="
echo ""