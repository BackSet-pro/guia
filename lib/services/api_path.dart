class APIPath {
  static String _path = 'https://guia-entrenamiento.herokuapp.com/api/';

  static String source(String instruction) {
    return '$_path$instruction';
  }
}
