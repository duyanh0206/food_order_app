class TextContent {
  final String title;
  final String description;

  TextContent({required this.title, required this.description});
}

List<TextContent> getContents() {
  return [
    TextContent(
      title: 'Welcome to the \n most tastiest app',
      description: 'You know, this app is edible meaning you \n can eat it',
    ),
    TextContent(
      title: 'We uses nitro on \n bicycles for delivery!',
      description:
          'For very fast delivery we use nitro on \n bicycles, kidding, but we are very fast.',
    ),
    TextContent(
      title: 'We have a lot of \n tasty food',
      description: 'We have a lot of tasty food and drinks for you to enjoy.',
    ),
  ];
}
