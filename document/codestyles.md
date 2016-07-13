# Google Java Style
[Google Java Style官网](https://google.github.io/styleguide/javaguide.html#s4.4-column-limit)


## Source file basics
1. File Name: The source file name consists of the case-sensitive name of the top-level class it contains, plus the **.java** extension.
2. File Encoding: Source files are encoded in UTF-8.
3. Whitespace characters:
    - All other whitespace characters in string and character literals are escaped;
    - Tab characters are not used for indentation.
4. Special escape sequences
For any character that has a special escape sequence (\b, \t, \n, \f, \r, \", \' and \\), that sequence is used rather than the corresponding octal or Unicode.
5. Non-ASCII characters
For the remaining non-ASCII characters, either the actual Unicode character (e.g. ∞) or the equivalent Unicode escape (e.g. \u221e) is used,
depending only on which makes the code easier to read and understand.
eg: String unitAbbrev = "μs";    Best: perfectly clear even without a comment.

## Source file structure
1. License or copyright information, if present
    If license or copyright information belongs in a file, it belongs here.
2. Package statement
    The package statement is not line-wrapped. The column limit does not apply to package statements.
3. Import statements
    - **No wildcard imports：** Wildcard imports, static or otherwise, are not used.
    - **No line-wrapping：**Import statements are not line-wrapped. The column limit does not apply to import statements.
