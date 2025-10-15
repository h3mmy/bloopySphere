# Youtube archiver

Note that for cookies to work in a kubernetes secret, it has to:

1. Be in the correct netscape format
2. The spaces _must_ be tabs
3. You _must_ store it in stringData to preserve the newline characters. The base64 encode/decode will strip those
4. The column representing expiry may need to be stripped of any decimals
