import 'dart:html' as html;
import 'dart:convert';
import 'dart:math';
import 'models/post.dart';
import 'models/country.dart';
import 'services/api_service.dart';
import 'services/storage_service.dart';

void main() {
  runApp();
}

void runApp() {
  final app = FlutterApp();
  app.render();
}

class FlutterApp {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  List<Post> _posts = [];
  List<Country> _countries = [];
  final Random _random = Random();
  
  void render() {
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    await _loadSamplePosts();
    await _loadStoredPosts();
    await _loadCountries();
    _renderUI();
  }
  
  Future<void> _loadSamplePosts() async {
    // Solo generar posts de ejemplo si no hay posts guardados
    final existingPosts = await _storageService.getStoredPosts();
    if (existingPosts.isEmpty) {
      final samplePosts = _generateRandomPosts(4);
      _posts.addAll(samplePosts);
      await _storageService.savePosts(samplePosts);
    } else {
      // Cargar posts existentes
      _posts.addAll(existingPosts);
    }
  }
  
  Future<void> _loadStoredPosts() async {
    try {
      final apiPosts = await _apiService.getPosts();
      _posts.addAll(apiPosts);
    } catch (e) {
      print('Error cargando posts de la API: $e');
    }
    
    final storedPosts = await _storageService.getStoredPosts();
    for (final post in storedPosts) {
      if (!_posts.any((p) => p.id == post.id)) {
        _posts.add(post);
      }
    }
  }
  
  Future<void> _loadCountries() async {
    try {
      _countries = await _apiService.getCountries();
    } catch (e) {
      print('Error cargando países: $e');
    }
  }
  
  void _renderUI() {
    final body = html.document.body!;
    body.children.clear();
    
    // Header
    final header = html.DivElement();
    header.className = 'header';
    header.setInnerHtml('''
      <h1>🏥 Taller Flutter - Caso de Estudio</h1>
      <div class="nav">
        <button id="posts-tab" class="nav-btn active">📝 Posts</button>
        <button id="countries-tab" class="nav-btn">🌍 Países</button>
        <button id="create-tab" class="nav-btn">✏️ Crear Post</button>
      </div>
    ''', treeSanitizer: html.NodeTreeSanitizer.trusted);
    body.children.add(header);
    
    // Container principal
    final container = html.DivElement();
    container.id = 'main-container';
    body.children.add(container);
    
    // CSS
    _addStyles();
    
    // Event listeners
    _setupEventListeners();
    
    // Mostrar posts por defecto
    _showPostsSection();
  }
  
  void _addStyles() {
    final style = html.StyleElement();
    style.text = '''
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }
      
      body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        color: #333;
      }
      
      .header {
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(10px);
        padding: 20px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        margin-bottom: 20px;
      }
      
      .header h1 {
        text-align: center;
        color: #4a5568;
        margin-bottom: 20px;
        font-size: 2em;
      }
      
      .nav {
        display: flex;
        justify-content: center;
        gap: 10px;
      }
      
      .nav-btn {
        padding: 12px 24px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: bold;
        transition: all 0.3s ease;
        background: #e2e8f0;
        color: #4a5568;
      }
      
      .nav-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      }
      
      .nav-btn.active {
        background: #667eea;
        color: white;
      }
      
      #main-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
      }
      
      .post-card, .country-card {
        background: white;
        border-radius: 12px;
        padding: 20px;
        margin: 15px 0;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s ease;
      }
      
      .post-card:hover, .country-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
      }
      
      .post-title, .country-title {
        color: #2d3748;
        margin-bottom: 10px;
        font-size: 1.3em;
      }
      
      .post-body, .country-info {
        color: #4a5568;
        line-height: 1.6;
      }
      
      .form-container {
        background: white;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        margin: 20px 0;
      }
      
      .form-group {
        margin-bottom: 20px;
      }
      
      .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
        color: #2d3748;
      }
      
      .form-group input, .form-group textarea {
        width: 100%;
        padding: 12px;
        border: 2px solid #e2e8f0;
        border-radius: 8px;
        font-size: 16px;
        transition: border-color 0.3s ease;
      }
      
      .form-group input:focus, .form-group textarea:focus {
        outline: none;
        border-color: #667eea;
      }
      
      .btn-primary {
        background: #667eea;
        color: white;
        padding: 12px 30px;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 16px;
        font-weight: bold;
        transition: all 0.3s ease;
      }
      
      .btn-primary:hover {
        background: #5a67d8;
        transform: translateY(-2px);
      }
      
      .loading {
        text-align: center;
        padding: 20px;
        font-size: 18px;
        color: #4a5568;
      }
      
      .error {
        background: #fed7d7;
        border: 1px solid #feb2b2;
        color: #c53030;
        padding: 12px;
        border-radius: 8px;
        margin: 10px 0;
      }
      
      .success {
        background: #c6f6d5;
        border: 1px solid #9ae6b4;
        color: #2f855a;
        padding: 12px;
        border-radius: 8px;
        margin: 10px 0;
      }
    ''';
    html.document.head!.children.add(style);
  }
  
  void _setupEventListeners() {
    html.document.getElementById('posts-tab')?.onClick.listen((_) {
      _setActiveTab('posts-tab');
      _showPostsSection();
    });
    
    html.document.getElementById('countries-tab')?.onClick.listen((_) {
      _setActiveTab('countries-tab');
      _showCountriesSection();
    });
    
    html.document.getElementById('create-tab')?.onClick.listen((_) {
      _setActiveTab('create-tab');
      _showCreatePostSection();
    });
  }
  
  void _setActiveTab(String activeTabId) {
    html.document.querySelectorAll('.nav-btn').forEach((btn) {
      btn.classes.remove('active');
    });
    html.document.getElementById(activeTabId)?.classes.add('active');
  }
  
  void _showPostsSection() {
    final container = html.document.getElementById('main-container')!;
    container.setInnerHtml('''
      <div class="section-header">
        <h2>📝 Posts Disponibles</h2>
        <p>Aquí puedes ver todos los posts creados, incluyendo posts de ejemplo con información de personas.</p>
      </div>
    ''', treeSanitizer: html.NodeTreeSanitizer.trusted);
    
    for (final post in _posts) {
      final postElement = html.DivElement();
      postElement.className = 'post-card';
      
      // Crear elementos de forma segura sin XSS
      final titleElement = html.HeadingElement.h3();
      titleElement.className = 'post-title';
      titleElement.text = post.title;
      
      final bodyElement = html.ParagraphElement();
      bodyElement.className = 'post-body';
      bodyElement.text = post.body;
      
      final infoElement = html.Element.tag('small');
      infoElement.text = 'ID: ${post.id} | Usuario: ${post.userId}';
      
      postElement.children.addAll([titleElement, bodyElement, infoElement]);
      container.children.add(postElement);
    }
  }
  
  void _showCountriesSection() {
    final container = html.document.getElementById('main-container')!;
    container.setInnerHtml('''
      <div class="section-header">
        <h2>🌍 Información de Países</h2>
        <p>Datos obtenidos de la API GraphQL de países.</p>
      </div>
    ''', treeSanitizer: html.NodeTreeSanitizer.trusted);
    
    if (_countries.isEmpty) {
      container.children.add(_createLoadingElement('Cargando países...'));
      return;
    }
    
    for (final country in _countries.take(20)) {
      final countryElement = html.DivElement();
      countryElement.className = 'country-card';
      
      // Crear elementos de forma segura sin XSS
      final titleElement = html.HeadingElement.h3();
      titleElement.className = 'country-title';
      titleElement.text = '${country.name} ${country.emoji}';
      
      final infoDiv = html.DivElement();
      infoDiv.className = 'country-info';
      
      final capitalP = html.ParagraphElement();
      final capitalStrong = html.Element.tag('strong');
      capitalStrong.text = 'Capital: ';
      capitalP.children.add(capitalStrong);
      capitalP.appendText(country.capital);
      
      final codeP = html.ParagraphElement();
      final codeStrong = html.Element.tag('strong');
      codeStrong.text = 'Código: ';
      codeP.children.add(codeStrong);
      codeP.appendText(country.code);
      
      final continentP = html.ParagraphElement();
      final continentStrong = html.Element.tag('strong');
      continentStrong.text = 'Continente: ';
      continentP.children.add(continentStrong);
      continentP.appendText(country.continent);
      
      infoDiv.children.addAll([capitalP, codeP, continentP]);
      countryElement.children.addAll([titleElement, infoDiv]);
      container.children.add(countryElement);
    }
  }
  
  void _showCreatePostSection() {
    final container = html.document.getElementById('main-container')!;
    container.setInnerHtml('''
      <div class="form-container">
        <h2>✏️ Crear Nuevo Post</h2>
        <p>Completa los campos para crear un nuevo post que se guardará localmente.</p>
        
        <form id="create-post-form">
          <div class="form-group">
            <label for="post-title">Título del Post:</label>
            <input type="text" id="post-title" name="title" required 
                   placeholder="Ej: Juan Pérez - Ingeniero de Software">
          </div>
          
          <div class="form-group">
            <label for="post-body">Contenido del Post:</label>
            <textarea id="post-body" name="body" rows="6" required 
                      placeholder="Describe la información de la persona, su profesión, experiencia, etc..."></textarea>
          </div>
          
          <button type="submit" class="btn-primary">Crear Post</button>
        </form>
        
        <div id="form-messages"></div>
      </div>
    ''', treeSanitizer: html.NodeTreeSanitizer.trusted);
    
    // Event listener para el formulario
    html.document.getElementById('create-post-form')?.onSubmit.listen((event) {
      event.preventDefault();
      _handleCreatePost();
    });
  }
  
  html.DivElement _createLoadingElement(String message) {
    final element = html.DivElement();
    element.className = 'loading';
    element.text = message;
    return element;
  }
  
  Future<void> _handleCreatePost() async {
    final titleInput = html.document.getElementById('post-title') as html.InputElement;
    final bodyInput = html.document.getElementById('post-body') as html.TextAreaElement;
    final messagesDiv = html.document.getElementById('form-messages')!;
    
    final title = titleInput.value?.trim() ?? '';
    final body = bodyInput.value?.trim() ?? '';
    
    if (title.isEmpty || body.isEmpty) {
      _showMessage(messagesDiv, 'Por favor completa todos los campos', 'error');
      return;
    }
    
    try {
      _showMessage(messagesDiv, 'Creando post...', 'loading');
      
      final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        body: body,
        userId: 999 // Usuario local
      );
      
      // Intentar crear en la API
      try {
        await _apiService.createPost(newPost);
      } catch (e) {
        print('No se pudo crear en la API, guardando localmente: $e');
      }
      
      // Guardar localmente siempre
      _posts.insert(0, newPost);
      await _storageService.savePost(newPost);
      
      _showMessage(messagesDiv, '¡Post creado exitosamente! 🎉', 'success');
      
      // Limpiar formulario
      titleInput.value = '';
      bodyInput.value = '';
      
      // Refrescar lista de posts para mostrar el nuevo post
      Future.delayed(Duration(seconds: 2), () {
        _showPostsSection();
      });
      
    } catch (e) {
      _showMessage(messagesDiv, 'Error al crear el post: $e', 'error');
    }
  }
  
  void _showMessage(html.Element container, String message, String type) {
    container.children.clear();
    final messageElement = html.DivElement();
    messageElement.className = type;
    messageElement.text = message;
    container.children.add(messageElement);
    
    // Auto-hide success messages
    if (type == 'success') {
      Future.delayed(Duration(seconds: 3), () {
        container.children.clear();
      });
    }
  }
  
  List<Post> _generateRandomPosts(int count) {
    final nombres = ['María', 'Carlos', 'Ana', 'David', 'Sofia', 'Miguel', 'Elena', 'Jorge', 'Lucía', 'Pablo', 'Carmen', 'Diego', 'Valeria', 'Andrés', 'Isabella'];
    final apellidos = ['González', 'Rodríguez', 'Martín', 'López', 'García', 'Pérez', 'Sánchez', 'Ramírez', 'Torres', 'Flores', 'Rivera', 'Gómez', 'Díaz', 'Vargas', 'Castillo'];
    final profesiones = ['Desarrolladora Frontend', 'Ingeniero de Software', 'Diseñadora UX/UI', 'DevOps Engineer', 'Data Scientist', 'Product Manager', 'Arquitecto de Software', 'Analista de Sistemas', 'Especialista en Ciberseguridad', 'Desarrollador Backend'];
    final ciudades = ['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Bilbao', 'Málaga', 'Zaragoza', 'Murcia', 'Palma', 'Las Palmas'];
    final tecnologias = [
      ['React', 'Flutter', 'Vue.js'], 
      ['Node.js', 'Python', 'Java'], 
      ['Docker', 'Kubernetes', 'AWS'], 
      ['GraphQL', 'REST APIs', 'MongoDB'],
      ['Machine Learning', 'TensorFlow', 'Python'],
      ['Figma', 'Sketch', 'Adobe XD'],
      ['JavaScript', 'TypeScript', 'Angular']
    ];
    
    List<Post> posts = [];
    
    for (int i = 0; i < count; i++) {
      final nombre = nombres[_random.nextInt(nombres.length)];
      final apellido = apellidos[_random.nextInt(apellidos.length)];
      final profesion = profesiones[_random.nextInt(profesiones.length)];
      final ciudad = ciudades[_random.nextInt(ciudades.length)];
      final tech = tecnologias[_random.nextInt(tecnologias.length)];
      final experiencia = _random.nextInt(8) + 2; // 2-10 años
      
      final descripcionExtras = [
        'Le encanta trabajar en proyectos colaborativos y aprender nuevas tecnologías.',
        'Disfruta enseñando programación y mentorizando a desarrolladores junior.',
        'Se especializa en crear soluciones escalables y eficientes.',
        'Trabaja remotamente y colabora con equipos internacionales.',
        'Apasionado por la innovación y la mejora continua de procesos.',
        'Combina creatividad y funcionalidad en cada proyecto.',
        'Tiene experiencia liderando equipos de desarrollo multidisciplinarios.'
      ];
      
      final post = Post(
        id: 1000 + i + 1,
        title: '$nombre $apellido - $profesion',
        body: '$nombre es especialista en ${tech.join(", ")}. ${descripcionExtras[_random.nextInt(descripcionExtras.length)]} Vive en $ciudad y tiene $experiencia años de experiencia en el campo.',
        userId: 100 + i + 1
      );
      
      posts.add(post);
    }
    
    return posts;
  }
}