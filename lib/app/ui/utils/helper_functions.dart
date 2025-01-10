String splitCamelCase(String input) {
  return input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match match) {
    return '${match.group(1)} ${match.group(2)}';
  });
}
