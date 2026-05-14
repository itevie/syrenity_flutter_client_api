enum LexicalTokenType {
  bold,
  italic,
  boldItalic,
  underscore,
  code,
  openAngle,
  closeAngle,
  at,
  hashtag,
  file, // f:
  server, // s:
  strikeThrough, // ~~
  link,
  text,
}

class LexicalToken {
  final LexicalTokenType type;
  final String value;

  const LexicalToken(this.type, this.value);

  @override
  String toString() => "LexicalToken($type, '$value')";
}

List<LexicalToken> lex(String contents) {
  final tokens = <LexicalToken>[];
  final buffer = StringBuffer();

  int i = 0;

  void flushText() {
    if (buffer.isNotEmpty) {
      tokens.add(LexicalToken(LexicalTokenType.text, buffer.toString()));

      buffer.clear();
    }
  }

  while (i < contents.length) {
    // try reading until whitespace
    int end = i;

    while (end < contents.length && !RegExp(r'\s').hasMatch(contents[end])) {
      end++;
    }

    final word = contents.substring(i, end);

    if (isLink(word)) {
      flushText();

      tokens.add(LexicalToken(LexicalTokenType.link, word));

      i = end;
      continue;
    }

    // multi-char tokens
    if (contents.startsWith("***", i)) {
      flushText();
      tokens.add(LexicalToken(LexicalTokenType.boldItalic, "***"));
      i += 3;
      continue;
    }

    if (contents.startsWith("**", i)) {
      flushText();
      tokens.add(LexicalToken(LexicalTokenType.bold, "**"));
      i += 2;
      continue;
    }

    if (contents.startsWith("~~", i)) {
      flushText();
      tokens.add(LexicalToken(LexicalTokenType.strikeThrough, "~~"));
      i += 2;
      continue;
    }

    switch (contents[i]) {
      case "*":
        flushText();
        tokens.add(LexicalToken(LexicalTokenType.italic, "*"));
        i++;
        continue;

      case "_":
        flushText();
        tokens.add(LexicalToken(LexicalTokenType.underscore, "_"));
        i++;
        continue;

      case "`":
        flushText();
        tokens.add(LexicalToken(LexicalTokenType.code, "`"));
        i++;
        continue;
    }

    buffer.write(contents[i]);
    i++;
  }

  flushText();

  return tokens;
}

bool isLink(String value) {
  final uri = Uri.tryParse(value);

  if (uri == null) return false;

  // has protocol/scheme
  if (uri.hasScheme) return true;

  // bare domains like google.com
  if (uri.host.isNotEmpty) return true;

  return false;
}