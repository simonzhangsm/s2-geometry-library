#!/bin/sh
# Continuous integration script for Travis

# Build the library and install it.
echo "## Building and installing libs2..."
rm -rf build
mkdir build
cd build 
cmake -DCMAKE_INSTALL_PREFIX=./install ../geometry
make -j3
make install

if [ "${TRAVIS_OS_NAME}" = "linux" ]; then
	sudo ldconfig -v | grep libs2
fi


# Build and run the C++ tests
echo "## Building and running the C++ tests..."
mkdir tests
cd tests
cmake ../../geometry/tests 
make -j3
./tests

exit 0

if [ "${TRAVIS_OS_NAME}" = "linux" ]; then
	# We really want to use the system version of Python.  Travis'
	# has broken distutils paths, and assumes a virtualenv.
	PATH="/usr/bin:${PATH}"
	which python2.7
	python2.7 -V
fi

# Build and install the Python bindings
echo "## Building and installing the Python bindings..."
cd ../
mkdir python
cd python
cmake ../../geometry/python
make VERBOSE=1
sudo make install
exit 0

# Run the Python tests
echo "## Running the Python tests..."
python2.7 -v -c 'import s2'
python2.7 test.py || exit 1

