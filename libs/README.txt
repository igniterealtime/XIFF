3rd party libraries used in XIFF
================================

as3crypto
---------
http://code.google.com/p/as3crypto

Originally added 2010-02-25, via
http://issues.igniterealtime.org/browse/XIFF-69

Then patched via
http://issues.igniterealtime.org/browse/XIFF-73

Fix for as3crypto issue 22: flex2.compiler.as3.SignatureExtension.SignatureGenerationFailed when compiling com.hurlant.crypto.symmetric.AESKey
http://code.google.com/p/as3crypto/issues/detail?id=22

Fix for as3crypto compile error: A file found in a source-path 'pkcs9unstructuredString' must have the same name as the class definition inside the file 'universalString'.

Fix for as3crypto issue 25: TLSSocket "pure virtual function call"
http://code.google.com/p/as3crypto/issues/detail?id=25


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

