3rd party libraries used in XIFF
================================

as3crypto
---------
https://github.com/timkurvers/as3-crypto
which is a fork of
http://code.google.com/p/as3crypto
with additional patches and fixes.

Current included SWC version updated 2011-10-02.

as3zlib
-------
http://code.google.com/p/as3zlib/

Build 2012-07-14, with patch from issue #1 applied
http://code.google.com/p/as3zlib/issues/detail?id=1.

and the following two classes excluded:
    ZInputStream
    ZOutputStream.

The swc was build with the following command:
C:\flex_sdk_4.6.0.23201B\bin\compc.exe -include-sources as3zlib\src -optimize -output as3zlib\as3zlib.swc

as explained in the related XIFF issue for adding XEP-0138 - Stream Compression support
http://issues.igniterealtime.org/browse/XIFF-53

flexunit
--------
http://www.flexunit.org/

Latest update on 2012-07-23, from http://flexunit.digitalprimates.net:8080/job/FlexUnit4-Flex4.1/9/

