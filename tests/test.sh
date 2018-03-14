#!/bin/bash
set -e
DIR=$(dirname "$0")

PYTHON="python -m coverage run -a --source $DIR/../src/"
$PYTHON $DIR/../src/dcm2hdr.py
$PYTHON $DIR/../src/dcm2hdr.py -h

#
# Test dicom files are downloaded from: http://deanvaughan.org/wordpress/2013/07/dicom-sample-images/
# The website is under Creative Commons 4.0 Attribution - Non-commercial license, so here is the credit:
# Dean Vaughan, http://deanvaughan.org/
#

# expected failed tests
$PYTHON $DIR/../src/dcm2hdr.py x && false || true
$PYTHON $DIR/../src/dcm2hdr.py x x && false || true
$PYTHON $DIR/../src/dcm2hdr.py x x x && false || true
$PYTHON $DIR/../src/dcm2hdr.py https://google.com x && false || true

wget -c -i ${DIR}/example_dicom_files.url -nv

for file in *dcm; do
  echo $file
  output=${file/dcm/png}
  echo "Convert: $output to PNG"
  $PYTHON $DIR/../src/dcm2hdr.py $file $output
  output=${file/dcm/tiff}
  echo "Convert: output to TIFF"
  $PYTHON $DIR/../src/dcm2hdr.py $file $output
  echo "$output is done."
done

$PYTHON $DIR/../src/dcm2hdr.py $file $output -R
$PYTHON $DIR/../src/dcm2hdr.py $file $output -R -m -1000 -M 2000
$PYTHON $DIR/../src/dcm2hdr.py $file $output -R -S -r 2 --offset -1000
$PYTHON $DIR/../src/dcm2hdr.py $file $output  -z 0 -s

rm -f *.png *.tiff *.dcm
echo
echo
echo "  TESTS ARE OK!  "