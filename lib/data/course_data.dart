import '../models/course.dart';
import '../models/learning_module.dart';
import '../models/question.dart';

class CourseData {
  static List<Course> getInitialCourses() {
    return [
      _buildFlutterCourse(),
      _buildPythonCourse(),
      _buildWebDevCourse(),
      _buildCybersecurityCourse(),
    ];
  }

  // ==========================================
  // COURSE 1: FLUTTER FUNDAMENTALS
  // ==========================================
  static Course _buildFlutterCourse() {
    return Course(
      id: 'course_flutter',
      title: 'Flutter Fundamentals',
      shortDescription: 'Build beautiful native cross-platform mobile apps using Flutter and Dart.',
      fullDescription:
          'Master modern mobile application development with Google’s Flutter framework. Learn Dart language syntax, sound null safety, foundational layout widgets, state management using setState, navigation patterns, and deployment best practices for Android and iOS.',
      category: 'Mobile Development',
      difficulty: 'Beginner',
      duration: '45 min',
      iconName: 'flutter',
      skillsLearned: [
        'Flutter Architecture & Engine',
        'Dart Null Safety & Syntax',
        'Stateless & Stateful Widgets',
        'Responsive Layouts (Row, Column, GridView)',
        'State Management & Lifecycle',
        'On-device Quiz Engine & UI Building',
      ],
      modules: [
        // MODULE 1
        LearningModule(
          id: 'flt_mod_1',
          orderIndex: 1,
          title: 'Introduction to Flutter & Architecture',
          estimatedMinutes: '8 min',
          summary:
              'Understand what Flutter is, its rendering engine, reactive UI model, and cross-platform compilation pipeline.',
          sections: [
            const ModuleSection(
              title: 'What is Flutter?',
              body:
                  'Flutter is Google’s open-source UI software development kit (SDK) used to build natively compiled applications for mobile, web, and desktop from a single codebase. Unlike frameworks that rely on web views or bridge layers (such as React Native’s traditional architecture), Flutter draws its own pixels directly onto a canvas using high-performance rendering engines like Impeller and Skia.',
              bulletPoints: [
                'Single codebase targets Android, iOS, Web, macOS, Linux, and Windows.',
                'Sub-second Hot Reload enables rapid UI experimentation without losing app state.',
                'Direct-to-native rendering provides smooth 60 FPS and 120 FPS performance.',
              ],
              tip: 'Hot Reload updates code changes into the running Dart Virtual Machine; Hot Restart completely resets application state.',
            ),
            const ModuleSection(
              title: 'Flutter Architectural Layers',
              body:
                  'Flutter is structured in three primary layers: the Framework (written in Dart), the Engine (written in C++), and the Platform Embedder. The Framework provides high-level widgets, Material and Cupertino design libraries, animation controllers, and gesture recognizers. The Engine handles low-level graphics rendering, text layout with HarfBuzz, file and network I/O, and the Dart runtime.',
              codeSnippet: '// Core Flutter Entry Point\nvoid main() {\n  runApp(const MyApp());\n}',
              bulletPoints: [
                'Dart Framework: Widgets, Rendering, Animation, Painting.',
                'C++ Engine: Impeller/Skia, Dart VM, Text layout, Platform channels.',
                'Embedder: Native host wrapper for iOS (Objective-C/Swift) and Android (Java/Kotlin).',
              ],
            ),
          ],
          keyTakeaway:
              'Flutter controls every pixel on screen by rendering directly through its C++ engine, bypassing native OEM UI bridges for consistent, blazing-fast performance across platforms.',
        ),

        // MODULE 2
        LearningModule(
          id: 'flt_mod_2',
          orderIndex: 2,
          title: 'Dart Language & Sound Null Safety',
          estimatedMinutes: '10 min',
          summary:
              'Learn essential Dart fundamentals, object orientation, collections, and modern Sound Null Safety.',
          sections: [
            const ModuleSection(
              title: 'Variables, Types & Immutability',
              body:
                  'Dart is an object-oriented, strongly typed language. Variables can be explicitly typed or inferred using var. Understanding the distinction between final and const is critical for performant Flutter widgets: "final" variables are single-assignment variables initialized at runtime, while "const" variables are immutable compile-time constants.',
              codeSnippet: '// Compile-time vs Runtime Immutability\nconst double passScore = 60.0; // Known at compile time\nfinal DateTime now = DateTime.now(); // Evaluated at runtime',
              bulletPoints: [
                'var: Type inferred by compiler at first assignment.',
                'final: Immutable variable whose value is determined at runtime.',
                'const: Immutable value known entirely at compile time.',
              ],
            ),
            const ModuleSection(
              title: 'Sound Null Safety in Dart',
              body:
                  'Dart features Sound Null Safety, meaning variables cannot contain null unless explicitly marked as nullable using the question mark (?) syntax. The Dart compiler guarantees that non-nullable types will never result in a null pointer exception at runtime, eliminating the dreaded NullPointerException.',
              codeSnippet: 'String nonNullable = "SkillUp"; // Cannot be null\nString? optionalHint; // Can be null or String\n\n// Safe access & null-coalescing\nint length = optionalHint?.length ?? 0;',
              bulletPoints: [
                '? declares a nullable type (e.g. String?).',
                '!. asserts that a nullable value is definitely non-null.',
                '?? provides a fallback value if the left expression evaluates to null.',
              ],
              tip: 'Avoid overusing the bang operator (!); always prefer safe navigation (?.) or null-coalescing (??).',
            ),
          ],
          keyTakeaway:
              'Sound Null Safety turns runtime null-dereference crashes into compile-time errors, making your Flutter application robust, predictable, and memory-safe.',
        ),

        // MODULE 3
        LearningModule(
          id: 'flt_mod_3',
          orderIndex: 3,
          title: 'Widgets, Layouts & Material Design 3',
          estimatedMinutes: '10 min',
          summary:
              'Discover how Flutter uses a tree of widgets to construct responsive user interfaces using Material 3 guidelines.',
          sections: [
            const ModuleSection(
              title: 'The "Everything is a Widget" Philosophy',
              body:
                  'In Flutter, virtually every UI element is a widget—from structural elements (Scaffold, AppBar) and layout wrappers (Padding, Center, Align) to visual primitives (Text, Icon, Image). Widgets are immutable configuration descriptions of how a part of the interface should look.',
              bulletPoints: [
                'StatelessWidget: Immutable configuration with no internal state changes (e.g., icons, badges).',
                'StatefulWidget: Retains mutable state across frames through an associated State object.',
                'Widget Tree: Hierarchy describing UI nodes; Flutter reconciles this against the Element and RenderObject trees.',
              ],
            ),
            const ModuleSection(
              title: 'Structural & Scrollable Layout Widgets',
              body:
                  'Layouts are built by combining single-child widgets (Container, SizedBox, Padding) with multi-child widgets (Column, Row, Stack, Wrap). When displaying dynamic, scrollable lists, ListView and GridView utilize lazy-loading builder constructors to instantiate only the items currently visible in the viewport.',
              codeSnippet: '// Efficient scrollable grid\nGridView.builder(\n  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(\n    crossAxisCount: 2,\n    childAspectRatio: 0.85,\n  ),\n  itemCount: courses.length,\n  itemBuilder: (context, index) => CourseCard(course: courses[index]),\n);',
              bulletPoints: [
                'Scaffold: Provides basic visual Material layout structure (appBar, body, floatingActionButton, bottomNavigationBar).',
                'Column & Row: Position children vertically and horizontally along main and cross axes.',
                'Stack: Layers widgets on top of each other using Positioned children.',
              ],
              tip: 'Wrap scrollable content in SafeArea to prevent overlap with camera notches and home indicator bars.',
            ),
          ],
          keyTakeaway:
              'Flutter decomposes complex screens into composable widgets. Using ListView.builder and GridView optimizes memory by recycling off-screen items.',
        ),

        // MODULE 4
        LearningModule(
          id: 'flt_mod_4',
          orderIndex: 4,
          title: 'State Management & Navigation Flow',
          estimatedMinutes: '9 min',
          summary:
              'Understand reactive UI updates with setState, StatefulWidget lifecycle, and declarative navigation patterns.',
          sections: [
            const ModuleSection(
              title: 'StatefulWidget Lifecycle & setState()',
              body:
                  'State is any data that changes over time and affects how the screen renders. Calling setState() notifies the framework that the internal state has changed, scheduling a call to the build() method so the UI reflects the newest values.',
              codeSnippet: 'void selectAnswer(int optionIndex) {\n  setState(() {\n    selectedOptionIndex = optionIndex;\n  });\n}',
              bulletPoints: [
                'initState(): Called exactly once when the State object is inserted into the tree.',
                'build(): Called repeatedly whenever state changes via setState() or inherited dependencies update.',
                'dispose(): Clean up controllers, listeners, or timers when the widget is permanently removed.',
              ],
            ),
            const ModuleSection(
              title: 'Routing & Screen Navigation',
              body:
                  'Navigation in Flutter pushes and pops Route objects on a stack managed by the Navigator widget. You can navigate imperatively using MaterialPageRoute or define named routes for structured applications.',
              codeSnippet: '// Imperative push with data transfer\nNavigator.push(\n  context,\n  MaterialPageRoute(\n    builder: (context) => CourseDetailScreen(course: selectedCourse),\n  ),\n);',
              bulletPoints: [
                'Navigator.push(): Places a new screen on top of the navigation stack.',
                'Navigator.pop(): Removes the active screen from the stack, optionally returning a result.',
                'Navigator.pushReplacement(): Replaces the current route (e.g. going from Welcome to Home).',
              ],
            ),
          ],
          keyTakeaway:
              'setState() triggers a targeted re-render of the widget subtree, while Navigator manages route stacks for seamless screen transitions.',
        ),

        // MODULE 5
        LearningModule(
          id: 'flt_mod_5',
          orderIndex: 5,
          title: 'Building, Testing & Deploying Flutter Apps',
          estimatedMinutes: '8 min',
          summary:
              'Explore Flutter project structure, pubspec.yaml dependency management, unit testing, and production builds.',
          sections: [
            const ModuleSection(
              title: 'Project Structure & pubspec.yaml',
              body:
                  'The pubspec.yaml file is the project manifest in Flutter. It specifies third-party dependencies from pub.dev, custom assets (images, fonts, JSON files), and platform configuration metadata. The lib/ directory houses all Dart code, starting at main.dart.',
              codeSnippet: 'dependencies:\n  flutter:\n    sdk: flutter\n  shared_preferences: ^2.2.0\n  google_fonts: ^6.0.0',
              bulletPoints: [
                'lib/: Contains all application Dart source code.',
                'test/: Contains unit, widget, and integration test scripts.',
                'android/ and ios/: Native platform container projects that host the Flutter engine.',
              ],
            ),
            const ModuleSection(
              title: 'Testing & Academic Verification',
              body:
                  'Flutter supports three test tiers: Unit Tests (verifying pure Dart logic, algorithms, and models), Widget Tests (verifying UI rendering and tap interactions in a headless environment), and Integration Tests (running end-to-end flows on emulators or real devices).',
              bulletPoints: [
                'testWidgets(): Mocks widget tree and advances virtual clock via tester.pump().',
                'On-device verification: All scoring algorithms must execute deterministically without network calls.',
                'Clean release build: Proves absence of render overflows or memory leaks.',
              ],
              tip: 'Always test on various device dimensions to verify layout responsiveness and prevent yellow-and-black stripe render overflows.',
            ),
          ],
          keyTakeaway:
              'Flutter’s modular architecture and comprehensive testing ecosystem allow developers to test business logic and UI independently before creating release binaries.',
        ),
      ],

      // QUESTION BANK (18 QUESTIONS)
      questionBank: [
        // Module 1 Questions
        const Question(
          id: 'flt_q01',
          moduleId: 'flt_mod_1',
          questionText: 'What is the primary rendering engine used by Flutter to draw pixels onto the screen canvas?',
          options: ['WebKit', 'Gecko', 'Impeller / Skia', 'V8 Engine'],
          correctOptionIndex: 2,
          hint: 'Flutter bypasses native OEM UI widgets and paints its own canvas.',
          explanation: 'Flutter utilizes Impeller (and Skia) to paint pixels directly to the canvas without web bridges.',
        ),
        const Question(
          id: 'flt_q02',
          moduleId: 'flt_mod_1',
          questionText: 'Which Flutter feature enables sub-second code updates into a running app without losing its state?',
          options: ['Hot Restart', 'Hot Reload', 'Cold Boot', 'Just-In-Time Recompile'],
          correctOptionIndex: 1,
          hint: 'It injects updated source code into the running Dart VM.',
          explanation: 'Hot Reload injects code changes directly into the running Dart Virtual Machine while preserving state.',
        ),
        const Question(
          id: 'flt_q03',
          moduleId: 'flt_mod_1',
          questionText: 'Which layer of Flutter architecture is written in C++ and handles graphics and text layout?',
          options: ['Framework Layer', 'Engine Layer', 'Embedder Layer', 'Material Library'],
          correctOptionIndex: 1,
          hint: null, // Null safety test
          explanation: 'The Engine layer is implemented in C++ and manages rendering, Dart VM runtime, and text layout.',
        ),
        const Question(
          id: 'flt_q04',
          moduleId: 'flt_mod_1',
          questionText: 'What is the main function call in main.dart that binds the widget tree to the Flutter engine?',
          options: ['startFlutter()', 'launchApp()', 'runApp()', 'initContext()'],
          correctOptionIndex: 2,
          hint: 'It takes a root Widget as its parameter.',
          explanation: null, // Null safety test
        ),

        // Module 2 Questions
        const Question(
          id: 'flt_q05',
          moduleId: 'flt_mod_2',
          questionText: 'What is the key difference between "final" and "const" variables in Dart?',
          options: [
            '"final" can be reassigned, while "const" cannot.',
            '"const" is a compile-time constant, whereas "final" is initialized at runtime.',
            '"final" only works with integers, while "const" works with strings.',
            'There is no technical difference in Dart.'
          ],
          correctOptionIndex: 1,
          hint: 'One is known before the code executes; the other can be computed when running.',
          explanation: '"const" values are immutable and known at compile time, whereas "final" variables can be computed at runtime once.',
        ),
        const Question(
          id: 'flt_q06',
          moduleId: 'flt_mod_2',
          questionText: 'In Dart Sound Null Safety, what symbol is used to declare that a variable can hold a null value?',
          options: ['!', '?', '#', '&'],
          correctOptionIndex: 1,
          hint: 'Placed directly after the type declaration (e.g. String?).',
          explanation: 'The question mark (?) denotes that a variable type is nullable in Dart.',
        ),
        const Question(
          id: 'flt_q07',
          moduleId: 'flt_mod_2',
          questionText: 'What does the null-coalescing operator (??) do in Dart?',
          options: [
            'Throws an exception if null is encountered.',
            'Provides a default fallback value if the left expression evaluates to null.',
            'Forces a variable to become non-nullable.',
            'Compares two strings for case-insensitive equality.'
          ],
          correctOptionIndex: 1,
          hint: 'Used as: value ?? defaultValue',
          explanation: 'The ?? operator evaluates the left-hand operand; if it is null, it evaluates and returns the right-hand operand.',
        ),
        const Question(
          id: 'flt_q08',
          moduleId: 'flt_mod_2',
          questionText: 'Which operator is used to cast or assert that a nullable expression is definitely not null?',
          options: ['?', '!', '??', '~'],
          correctOptionIndex: 1,
          hint: null,
          explanation: 'The bang (!) operator asserts that a nullable variable is non-null at runtime.',
        ),

        // Module 3 Questions
        const Question(
          id: 'flt_q09',
          moduleId: 'flt_mod_3',
          questionText: 'Which Flutter widget provides the default visual structure and layout for Material Design screens?',
          options: ['Container', 'Scaffold', 'Center', 'MaterialApp'],
          correctOptionIndex: 1,
          hint: 'It includes slots for appBar, body, and floatingActionButton.',
          explanation: 'Scaffold implements the basic Material Design visual layout structure.',
        ),
        const Question(
          id: 'flt_q10',
          moduleId: 'flt_mod_3',
          questionText: 'Why should you prefer ListView.builder() over ListView() for long or dynamic collections?',
          options: [
            'ListView.builder renders all items into memory upfront.',
            'ListView.builder creates items on-demand only as they scroll into view.',
            'ListView.builder supports animations while ListView does not.',
            'ListView.builder does not require an item count.'
          ],
          correctOptionIndex: 1,
          hint: 'Think about memory consumption and recycling viewport items.',
          explanation: 'ListView.builder utilizes lazy instantiation, constructing widgets only when visible in the viewport.',
        ),
        const Question(
          id: 'flt_q11',
          moduleId: 'flt_mod_3',
          questionText: 'Which widget allows you to stack multiple visual elements directly on top of each other?',
          options: ['Column', 'Row', 'Stack', 'Wrap'],
          correctOptionIndex: 2,
          hint: 'Commonly used with Positioned widgets to place overlays.',
          explanation: 'Stack places its children on top of each other relative to the edges of its box.',
        ),
        const Question(
          id: 'flt_q12',
          moduleId: 'flt_mod_3',
          questionText: 'Which widget prevents UI elements from overlapping system status bars, notches, and navigation gestures?',
          options: ['Padding', 'SafeArea', 'SizedBox', 'Expanded'],
          correctOptionIndex: 1,
          hint: null,
          explanation: 'SafeArea insets its child by sufficient padding to avoid intrusions by the operating system.',
        ),

        // Module 4 Questions
        const Question(
          id: 'flt_q13',
          moduleId: 'flt_mod_4',
          questionText: 'What method must be called inside a StatefulWidget to notify Flutter that internal state has changed?',
          options: ['update()', 'notify()', 'setState()', 'refresh()'],
          correctOptionIndex: 2,
          hint: 'It marks the widget as dirty and schedules a rebuild.',
          explanation: 'Calling setState() schedules a call to build() for this State object with updated values.',
        ),
        const Question(
          id: 'flt_q14',
          moduleId: 'flt_mod_4',
          questionText: 'Which lifecycle method of a State object is invoked exactly once when the widget enters the tree?',
          options: ['initState()', 'build()', 'dispose()', 'didUpdateWidget()'],
          correctOptionIndex: 0,
          hint: 'Used for one-time initialization of controllers and subscriptions.',
          explanation: 'initState() is called once when the State object is first inserted into the widget tree.',
        ),
        const Question(
          id: 'flt_q15',
          moduleId: 'flt_mod_4',
          questionText: 'Which Navigator method removes the topmost screen and returns to the previous route on the stack?',
          options: ['Navigator.push()', 'Navigator.pop()', 'Navigator.remove()', 'Navigator.back()'],
          correctOptionIndex: 1,
          hint: 'Pops the current Route off the navigation stack.',
          explanation: 'Navigator.pop(context) pops the top-most route off the stack, revealing the previous screen.',
        ),

        // Module 5 Questions
        const Question(
          id: 'flt_q16',
          moduleId: 'flt_mod_5',
          questionText: 'In which file are Flutter external packages, asset declarations, and font dependencies specified?',
          options: ['main.dart', 'pubspec.yaml', 'build.gradle', 'manifest.json'],
          correctOptionIndex: 1,
          hint: 'The standard package configuration file for Dart and Flutter.',
          explanation: 'pubspec.yaml defines metadata, external package dependencies, assets, and fonts.',
        ),
        const Question(
          id: 'flt_q17',
          moduleId: 'flt_mod_5',
          questionText: 'What type of Flutter test executes in a headless Dart environment to verify widget UI and interactions?',
          options: ['Unit Test', 'Widget Test', 'Integration Test', 'Manual Test'],
          correctOptionIndex: 1,
          hint: 'Uses testWidgets() and tester.pump().',
          explanation: 'Widget tests verify widget look and user interaction behaviors without needing a physical mobile device.',
        ),
        const Question(
          id: 'flt_q18',
          moduleId: 'flt_mod_5',
          questionText: 'What is the default passing percentage threshold required by SkillUp to earn a verified certificate?',
          options: ['50%', '60%', '75%', '80%'],
          correctOptionIndex: 1,
          hint: 'Exactly 6 out of 10 questions correct.',
          explanation: 'SkillUp defines a constant passing standard of 60.0% (at least 6 correct answers out of 10).',
        ),
      ],
    );
  }

  // ==========================================
  // COURSE 2: PYTHON PROGRAMMING
  // ==========================================
  static Course _buildPythonCourse() {
    return Course(
      id: 'course_python',
      title: 'Python Programming',
      shortDescription: 'Master fundamental Python programming, data structures, OOP, and automation.',
      fullDescription:
          'Learn the world’s most popular programming language from first principles. Understand Python syntax, lists, tuples, dictionaries, object-oriented programming with classes and inheritance, robust exception handling, and file manipulation.',
      category: 'Programming & AI',
      difficulty: 'Beginner',
      duration: '50 min',
      iconName: 'python',
      skillsLearned: [
        'Dynamic Typing & PEP 8 Standards',
        'Data Structures (Lists, Sets, Dicts)',
        'List Comprehensions & Lambdas',
        'OOP (Classes, Inheritance, Encapsulation)',
        'Exception Handling & Context Managers',
        'Modular Scripting & Automation',
      ],
      modules: [
        // MODULE 1
        LearningModule(
          id: 'pyt_mod_1',
          orderIndex: 1,
          title: 'Python Syntax & Execution Model',
          estimatedMinutes: '9 min',
          summary:
              'Understand how Python executes code, dynamic typing, indentation rules, and PEP 8 best practices.',
          sections: [
            const ModuleSection(
              title: 'Interpreted & Dynamically Typed',
              body:
                  'Python is an interpreted, high-level, dynamically typed language. Unlike compiled languages where variables are statically bound to memory types at compilation, Python variables are merely reference labels pointing to objects in memory. The Python bytecode interpreter (CPython) compiles .py files into bytecode (.pyc) before executing them on the Python Virtual Machine (PVM).',
              codeSnippet: '# Dynamic reassignment is valid in Python\nx = 42         # x refers to an int object\nx = "SkillUp"  # x now refers to a str object',
              bulletPoints: [
                'Significant whitespace: Indentation defines code blocks instead of curly braces.',
                'PEP 8: The official Python style guide recommending 4 spaces per indentation level.',
                'Garbage collection: Automatic memory management via reference counting and generational cyclic GC.',
              ],
            ),
          ],
          keyTakeaway:
              'Python emphasizes developer readability through mandatory indentation and dynamic object referencing, enabling concise and expressive code.',
        ),

        // MODULE 2
        LearningModule(
          id: 'pyt_mod_2',
          orderIndex: 2,
          title: 'Data Structures & Collections',
          estimatedMinutes: '11 min',
          summary:
              'Explore lists, tuples, dictionaries, sets, and concise list comprehensions.',
          sections: [
            const ModuleSection(
              title: 'Mutable vs Immutable Sequences',
              body:
                  'Python provides four built-in collection types. Lists are ordered and mutable. Tuples are ordered and immutable. Sets are unordered collections of unique elements. Dictionaries are key-value mappings with average O(1) hash lookup complexity.',
              codeSnippet: '# List comprehension with condition\nsquares = [x**2 for x in range(10) if x % 2 == 0]\n# Result: [0, 4, 16, 36, 64]',
              bulletPoints: [
                'List [1, 2, 3]: Mutable, indexed, preserves insertion order.',
                'Tuple (1, 2, 3): Immutable sequence, memory efficient, hashable as dict keys.',
                'Dictionary {"key": "value"}: High-performance key-value mapping.',
                'Set {1, 2, 3}: Removes duplicates and supports set operations (union, intersection).',
              ],
              tip: 'Use tuples instead of lists for fixed records to prevent accidental modification and save memory.',
            ),
          ],
          keyTakeaway:
              'Choosing the right data structure (dict for fast key lookups, set for uniqueness, list for order) is key to writing high-performance Python.',
        ),

        // MODULE 3
        LearningModule(
          id: 'pyt_mod_3',
          orderIndex: 3,
          title: 'Functions, Scopes & Lambda Expressions',
          estimatedMinutes: '10 min',
          summary:
              'Deep dive into modular programming, variable arguments (*args, **kwargs), closures, and anonymous functions.',
          sections: [
            const ModuleSection(
              title: 'Function Signatures & Variable Arguments',
              body:
                  'Functions in Python are first-class citizens: they can be passed as arguments, returned from other functions, and stored in variables. Python supports positional arguments, default values, and variable-length arguments via *args (tuple) and **kwargs (dictionary).',
              codeSnippet: 'def calculate_score(base, *bonuses, **metadata):\n    total = base + sum(bonuses)\n    student = metadata.get("student", "Anonymous")\n    return f"{student}: {total}"',
              bulletPoints: [
                'LEGB Rule: Scope resolution order (Local, Enclosing, Global, Built-in).',
                '*args: Collects arbitrary positional arguments into a tuple.',
                '**kwargs: Collects arbitrary keyword arguments into a dictionary.',
              ],
            ),
          ],
          keyTakeaway:
              'First-class functions and flexible argument unpacking enable clean modularization and functional programming idioms in Python.',
        ),

        // MODULE 4
        LearningModule(
          id: 'pyt_mod_4',
          orderIndex: 4,
          title: 'Object-Oriented Programming (OOP)',
          estimatedMinutes: '10 min',
          summary:
              'Master classes, objects, the self parameter, __init__ constructor, inheritance, and encapsulation.',
          sections: [
            const ModuleSection(
              title: 'Classes and Instantiation',
              body:
                  'OOP in Python organizes code around objects combining state (attributes) and behavior (methods). The __init__ method initializes new object instances, and the explicit "self" parameter represents the instance calling the method.',
              codeSnippet: 'class Learner:\n    def __init__(self, name: str, xp: int = 0):\n        self.name = name\n        self.xp = xp\n\n    def add_xp(self, amount: int):\n        self.xp += amount',
              bulletPoints: [
                'Encapsulation: Conventionally prefix private attributes with an underscore (_attribute).',
                'Inheritance: Subclasses inherit attributes and methods via class SubClass(ParentClass).',
                'Polymorphism: Different classes can implement methods with identical names (duck typing).',
              ],
            ),
          ],
          keyTakeaway:
              'Python OOP leverages explicit instance referencing (self) and duck typing ("if it quacks like a duck, it is a duck") for flexible architecture.',
        ),

        // MODULE 5
        LearningModule(
          id: 'pyt_mod_5',
          orderIndex: 5,
          title: 'Exception Handling & File Operations',
          estimatedMinutes: '10 min',
          summary:
              'Learn graceful error handling with try-except blocks and safe resource management with the with statement.',
          sections: [
            const ModuleSection(
              title: 'Robust Exception Handling & Context Managers',
              body:
                  'Errors in Python raise exceptions that disrupt normal program flow if unhandled. Using try-except-finally blocks prevents catastrophic crashes. The "with" statement implements the context management protocol (__enter__ and __exit__), ensuring files or network connections are automatically closed even if errors occur.',
              codeSnippet: '# Safe file reading with context manager\ntry:\n    with open("scores.txt", "r") as file:\n        data = file.read()\nexcept FileNotFoundError:\n    data = "No scores found"\nfinally:\n    print("Operation finished")',
              bulletPoints: [
                'try: Code block to monitor for exceptions.',
                'except ExceptionType: Handles specific errors.',
                'finally: Cleanup block that executes unconditionally.',
                'with: Automatically releases system resources when block exits.',
              ],
            ),
          ],
          keyTakeaway:
              'Always use context managers ("with open(...)") for file handling to avoid file lock leaks, and catch specific exceptions rather than bare "except:".',
        ),
      ],

      // QUESTION BANK (18 QUESTIONS)
      questionBank: [
        const Question(
          id: 'pyt_q01',
          moduleId: 'pyt_mod_1',
          questionText: 'How are code blocks (such as function bodies or loops) delimited in Python?',
          options: ['Curly braces { }', 'Indentation', 'Parentheses ( )', 'begin/end keywords'],
          correctOptionIndex: 1,
          hint: 'Python enforces readable formatting via whitespace.',
          explanation: 'Python uses consistent indentation (typically 4 spaces) rather than curly braces to define scope blocks.',
        ),
        const Question(
          id: 'pyt_q02',
          moduleId: 'pyt_mod_1',
          questionText: 'What is the official style guide standard for Python code called?',
          options: ['PEP 8', 'RFC 2616', 'ISO 9001', 'IEEE 754'],
          correctOptionIndex: 0,
          hint: 'Python Enhancement Proposal number 8.',
          explanation: 'PEP 8 is the official Python Enhancement Proposal specifying conventions for Python code style.',
        ),
        const Question(
          id: 'pyt_q03',
          moduleId: 'pyt_mod_1',
          questionText: 'What is the default reference implementation of the Python language written in C?',
          options: ['PyPy', 'CPython', 'Jython', 'IronPython'],
          correctOptionIndex: 1,
          hint: null,
          explanation: 'CPython is the original and standard bytecode interpreter written in C.',
        ),
        const Question(
          id: 'pyt_q04',
          moduleId: 'pyt_mod_2',
          questionText: 'Which of the following built-in collection types in Python is immutable?',
          options: ['List', 'Dictionary', 'Set', 'Tuple'],
          correctOptionIndex: 3,
          hint: 'Once defined with parentheses, its elements cannot be altered.',
          explanation: 'Tuples are immutable; their length and item assignments cannot be modified after instantiation.',
        ),
        const Question(
          id: 'pyt_q05',
          moduleId: 'pyt_mod_2',
          questionText: 'What is the average time complexity for key lookup in a Python dictionary?',
          options: ['O(1)', 'O(n)', 'O(log n)', 'O(n^2)'],
          correctOptionIndex: 0,
          hint: 'Python dictionaries are implemented internally as hash tables.',
          explanation: 'Dictionary key lookup utilizes hash table indexing, providing average O(1) constant time complexity.',
        ),
        const Question(
          id: 'pyt_q06',
          moduleId: 'pyt_mod_2',
          questionText: 'What is the output of the list comprehension: [x * 2 for x in [1, 2, 3]]?',
          options: ['[1, 2, 3]', '[2, 4, 6]', '[1, 4, 9]', '[2, 2, 2]'],
          correctOptionIndex: 1,
          hint: 'Each element in the sequence is multiplied by 2.',
          explanation: 'The expression doubles each item in [1, 2, 3], yielding [2, 4, 6].',
        ),
        const Question(
          id: 'pyt_q07',
          moduleId: 'pyt_mod_2',
          questionText: 'Which collection type automatically discards duplicate entries?',
          options: ['List', 'Set', 'Tuple', 'NamedTuple'],
          correctOptionIndex: 1,
          hint: null,
          explanation: 'Sets in Python store unordered collections of unique elements and discard duplicates.',
        ),
        const Question(
          id: 'pyt_q08',
          moduleId: 'pyt_mod_3',
          questionText: 'In a Python function definition, what does the *args parameter collect?',
          options: [
            'Keyword arguments as a dictionary',
            'Arbitrary positional arguments as a tuple',
            'Global configuration flags',
            'Exception handlers'
          ],
          correctOptionIndex: 1,
          hint: 'Single asterisk collects positional arguments.',
          explanation: '*args gathers extra positional arguments into a single tuple.',
        ),
        const Question(
          id: 'pyt_q09',
          moduleId: 'pyt_mod_3',
          questionText: 'What parameter collects arbitrary keyword arguments into a dictionary?',
          options: ['*args', '**kwargs', 'params', '__dict__'],
          correctOptionIndex: 1,
          hint: 'Double asterisk prefix.',
          explanation: '**kwargs packs named keyword arguments into a dictionary.',
        ),
        const Question(
          id: 'pyt_q10',
          moduleId: 'pyt_mod_3',
          questionText: 'What keyword is used in Python to define a small, anonymous single-line function?',
          options: ['def', 'func', 'lambda', 'inline'],
          correctOptionIndex: 2,
          hint: 'Derived from lambda calculus.',
          explanation: 'The lambda keyword defines anonymous, inline functions containing an expression.',
        ),
        const Question(
          id: 'pyt_q11',
          moduleId: 'pyt_mod_4',
          questionText: 'What special method acts as the constructor or initializer for a Python class?',
          options: ['__new__', '__init__', 'constructor()', 'create()'],
          correctOptionIndex: 1,
          hint: 'Dunder init method.',
          explanation: '__init__ is invoked automatically when a new instance of a class is constructed.',
        ),
        const Question(
          id: 'pyt_q12',
          moduleId: 'pyt_mod_4',
          questionText: 'What does the first parameter (typically named "self") in a Python class method represent?',
          options: [
            'The class definition itself',
            'The active instance of the class',
            'The parent superclass',
            'The global module context'
          ],
          correctOptionIndex: 1,
          hint: 'Refers to the specific object instance being acted upon.',
          explanation: '"self" points to the current object instance, granting access to its attributes and methods.',
        ),
        const Question(
          id: 'pyt_q13',
          moduleId: 'pyt_mod_4',
          questionText: 'How is inheritance declared when defining a subclass in Python?',
          options: [
            'class Dog extends Animal:',
            'class Dog(Animal):',
            'class Dog inherits Animal:',
            'class Dog: implements Animal'
          ],
          correctOptionIndex: 1,
          hint: 'Pass the parent class name inside parentheses.',
          explanation: 'Inheritance in Python is indicated by placing the base class in parentheses after the class name.',
        ),
        const Question(
          id: 'pyt_q14',
          moduleId: 'pyt_mod_5',
          questionText: 'Which statement in Python guarantees that cleanup code executes whether an exception was raised or not?',
          options: ['finally', 'else', 'catch', 'ensure'],
          correctOptionIndex: 0,
          hint: 'Follows the try and except clauses.',
          explanation: 'The finally clause always executes before exiting the try statement, regardless of exceptions.',
        ),
        const Question(
          id: 'pyt_q15',
          moduleId: 'pyt_mod_5',
          questionText: 'Why is the "with open(...) as file:" construct preferred when opening files in Python?',
          options: [
            'It reads files faster by bypassing the OS buffer.',
            'It automatically closes the file even if an exception occurs.',
            'It encrypts file contents automatically.',
            'It prevents file deletion by other programs.'
          ],
          correctOptionIndex: 1,
          hint: 'Implements context management (__enter__ and __exit__).',
          explanation: 'Context managers guarantee that the file descriptor is cleanly closed upon block exit.',
        ),
        const Question(
          id: 'pyt_q16',
          moduleId: 'pyt_mod_5',
          questionText: 'What built-in exception is raised when trying to access a dictionary key that does not exist?',
          options: ['IndexError', 'KeyError', 'ValueError', 'LookupNotFound'],
          correctOptionIndex: 1,
          hint: null,
          explanation: 'Attempting to index a dictionary with a non-existent key raises a KeyError.',
        ),
        const Question(
          id: 'pyt_q17',
          moduleId: 'pyt_mod_2',
          questionText: 'What will be the result of bool([]) in Python?',
          options: ['True', 'False', 'None', 'TypeError'],
          correctOptionIndex: 1,
          hint: 'Empty containers evaluate to falsy values in boolean context.',
          explanation: 'In Python, empty lists, strings, dictionaries, and sets evaluate to False in boolean evaluation.',
        ),
        const Question(
          id: 'pyt_q18',
          moduleId: 'pyt_mod_3',
          questionText: 'What is the scope resolution order known as the LEGB rule in Python?',
          options: [
            'Local, Enclosing, Global, Built-in',
            'Loop, External, Global, Binary',
            'Local, Extended, General, Base',
            'Lexical, Evaluation, Group, Branch'
          ],
          correctOptionIndex: 0,
          hint: null,
          explanation: 'LEGB stands for Local, Enclosing, Global, and Built-in scopes.',
        ),
      ],
    );
  }

  // ==========================================
  // COURSE 3: WEB DEVELOPMENT BASICS
  // ==========================================
  static Course _buildWebDevCourse() {
    return Course(
      id: 'course_webdev',
      title: 'Web Development Basics',
      shortDescription: 'Master the foundational triad of the modern web: HTML5, CSS3, and modern JavaScript.',
      fullDescription:
          'Learn how the modern web works from document structure to dynamic interactivity. Understand semantic HTML5, modern CSS layouts including Flexbox and CSS Grid, JavaScript event handling, asynchronous promises, and RESTful API consumption.',
      category: 'Web Engineering',
      difficulty: 'Beginner',
      duration: '45 min',
      iconName: 'web',
      skillsLearned: [
        'Semantic HTML5 & Accessibility (a11y)',
        'CSS Box Model, Flexbox & CSS Grid',
        'Responsive Media Queries',
        'JavaScript DOM Manipulation & Event Loop',
        'Asynchronous JS (Promises & async/await)',
        'HTTP Protocol, Fetch API & JSON',
      ],
      modules: [
        // MODULE 1
        LearningModule(
          id: 'web_mod_1',
          orderIndex: 1,
          title: 'HTML5 & Semantic Web Structure',
          estimatedMinutes: '8 min',
          summary:
              'Learn document anatomy, DOM trees, semantic tags (<header>, <main>, <article>), and accessibility.',
          sections: [
            const ModuleSection(
              title: 'Document Object Model & Semantics',
              body:
                  'HTML (HyperText Markup Language) defines the structure and meaning of web content. HTML5 introduced semantic tags that describe their content to both browser engines and assistive technologies (screen readers), enhancing SEO and accessibility.',
              codeSnippet: '<!DOCTYPE html>\n<html lang="en">\n  <head><title>SkillUp</title></head>\n  <body>\n    <header><nav>Navigation</nav></header>\n    <main><article>Content</article></main>\n  </body>\n</html>',
              bulletPoints: [
                'Semantic elements: <header>, <nav>, <main>, <section>, <article>, <footer>.',
                'Accessibility (a11y): Alt attributes on images, ARIA roles, and form label associations.',
                'DOM Tree: Hierarchical node tree constructed by browser parser.',
              ],
            ),
          ],
          keyTakeaway:
              'Semantic HTML gives structural meaning to web content, improving accessibility for screen readers and search engine indexability.',
        ),

        // MODULE 2
        LearningModule(
          id: 'web_mod_2',
          orderIndex: 2,
          title: 'CSS3, Box Model & Modern Layouts',
          estimatedMinutes: '10 min',
          summary:
              'Master the CSS box model, responsive Flexbox, CSS Grid systems, and media query breakpoints.',
          sections: [
            const ModuleSection(
              title: 'The Box Model, Flexbox & Grid',
              body:
                  'Every rendered HTML element is treated as a rectangular box composed of content, padding, border, and margin. Modern CSS layout relies on Flexbox for 1-dimensional row/column alignment and CSS Grid for complex 2-dimensional layouts.',
              codeSnippet: '/* Centering with Flexbox */\n.container {\n  display: flex;\n  justify-content: center;\n  align-items: center;\n  box-sizing: border-box;\n}',
              bulletPoints: [
                'box-sizing: border-box: Includes padding and border within specified width/height.',
                'Flexbox: Ideal for linear components (navbars, card contents).',
                'CSS Grid: Two-dimensional layout system with explicit rows and columns.',
                'Media queries: @media (max-width: 768px) adapts styling for mobile viewports.',
              ],
            ),
          ],
          keyTakeaway:
              'Setting "box-sizing: border-box" and combining Flexbox with CSS Grid eliminates unpredictable layout overflow issues across devices.',
        ),

        // MODULE 3
        LearningModule(
          id: 'web_mod_3',
          orderIndex: 3,
          title: 'JavaScript Core & Event Loop',
          estimatedMinutes: '10 min',
          summary:
              'Learn variables (let/const), data types, DOM manipulation, event listeners, and the browser event loop.',
          sections: [
            const ModuleSection(
              title: 'Single-Threaded Asynchronous Execution',
              body:
                  'JavaScript runs on a single thread with an event-driven concurrency model. Long-running tasks are offloaded to web APIs, and callbacks return to the execution stack via the macro-task and micro-task queues.',
              codeSnippet: 'const btn = document.querySelector("#enroll-btn");\nbtn.addEventListener("click", (event) => {\n  console.log("Enrolled in SkillUp course!");\n});',
              bulletPoints: [
                'let and const: Block-scoped variable declarations replacing legacy var.',
                'Event Listeners: Attach callback handlers to DOM interactions (click, input, submit).',
                'Call Stack & Event Loop: Manages execution of synchronous and asynchronous code.',
              ],
            ),
          ],
          keyTakeaway:
              'The JavaScript event loop continuously coordinates the call stack with task queues to handle asynchronous tasks without freezing the UI.',
        ),

        // MODULE 4
        LearningModule(
          id: 'web_mod_4',
          orderIndex: 4,
          title: 'Asynchronous JavaScript & Promises',
          estimatedMinutes: '9 min',
          summary:
              'Master asynchronous programming with Promises, async/await syntax, and error handling.',
          sections: [
            const ModuleSection(
              title: 'Promises vs Async/Await',
              body:
                  'A Promise represents the eventual completion or failure of an asynchronous operation and its resulting value. The modern async/await syntax allows developers to write asynchronous code that reads like synchronous code.',
              codeSnippet: 'async function fetchCourses() {\n  try {\n    const response = await fetch("/api/courses");\n    const data = await response.json();\n    return data;\n  } catch (err) {\n    console.error("Fetch failed", err);\n  }\n}',
              bulletPoints: [
                'Promise states: Pending, Fulfilled, or Rejected.',
                'await pauses function execution until the promise settles.',
                'try...catch blocks handle promise rejection cleanly.',
              ],
            ),
          ],
          keyTakeaway:
              'async/await is syntactic sugar over Promises that turns nested callback pyramids into clean, sequential, and maintainable logic.',
        ),

        // MODULE 5
        LearningModule(
          id: 'web_mod_5',
          orderIndex: 5,
          title: 'HTTP, REST APIs & Client-Side Storage',
          estimatedMinutes: '8 min',
          summary:
              'Understand HTTP verbs, JSON data serialization, Fetch API, and browser storage (localStorage).',
          sections: [
            const ModuleSection(
              title: 'Client-Server Communication & Offline Storage',
              body:
                  'Web applications exchange data with servers over HTTP/HTTPS using standardized methods: GET (retrieve), POST (create), PUT/PATCH (update), and DELETE (remove). Browsers also provide client-side key-value persistence via localStorage and sessionStorage.',
              bulletPoints: [
                'JSON (JavaScript Object Notation): Universal lightweight data interchange format.',
                'Status codes: 200 OK, 201 Created, 400 Bad Request, 404 Not Found, 500 Server Error.',
                'localStorage: Synchronous key-value storage that persists across browser sessions.',
              ],
            ),
          ],
          keyTakeaway:
              'Modern web apps combine RESTful HTTP endpoints for remote data sync with client-side storage for offline persistence.',
        ),
      ],

      // QUESTION BANK (18 QUESTIONS)
      questionBank: [
        const Question(
          id: 'web_q01',
          moduleId: 'web_mod_1',
          questionText: 'Which HTML5 element represents the central, unique content of a webpage rather than repeated banners or navigation?',
          options: ['<section>', '<main>', '<article>', '<div>'],
          correctOptionIndex: 1,
          hint: 'There should be only one non-hidden instance of this element per page.',
          explanation: 'The <main> tag represents the dominant content of the <body> of a document.',
        ),
        const Question(
          id: 'web_q02',
          moduleId: 'web_mod_1',
          questionText: 'What HTML attribute provides alternative text descriptions of images for screen readers and search engines?',
          options: ['title', 'alt', 'caption', 'src-desc'],
          correctOptionIndex: 1,
          hint: 'Essential for accessibility (a11y).',
          explanation: 'The alt attribute provides alternative text when images cannot be displayed or are read by screen readers.',
        ),
        const Question(
          id: 'web_q03',
          moduleId: 'web_mod_1',
          questionText: 'What document declaration tells the browser parser to render the page in standard HTML5 mode?',
          options: ['<!DOCTYPE html>', '<html version="5">', '<meta charset="html5">', '<?xml version="1.0"?>'],
          correctOptionIndex: 0,
          hint: null,
          explanation: '<!DOCTYPE html> is the required prelude for HTML5 documents.',
        ),
        const Question(
          id: 'web_q04',
          moduleId: 'web_mod_2',
          questionText: 'Which CSS property value ensures that padding and borders are included within the element’s total width and height?',
          options: [
            'box-sizing: content-box',
            'box-sizing: border-box',
            'margin: collapse',
            'display: inline-block'
          ],
          correctOptionIndex: 1,
          hint: 'Prevents elements from unexpectedly overflowing their parent container.',
          explanation: 'box-sizing: border-box directs the browser to calculate width and height including padding and borders.',
        ),
        const Question(
          id: 'web_q05',
          moduleId: 'web_mod_2',
          questionText: 'In CSS Flexbox, which property aligns items along the cross axis (perpendicular to main axis)?',
          options: ['justify-content', 'align-items', 'flex-direction', 'flex-wrap'],
          correctOptionIndex: 1,
          hint: 'justify-content handles the main axis; this handles the perpendicular axis.',
          explanation: 'align-items controls alignment of flex items along the cross axis.',
        ),
        const Question(
          id: 'web_q06',
          moduleId: 'web_mod_2',
          questionText: 'What CSS rule is used to apply custom styles based on device characteristics like screen width?',
          options: ['@media', '@viewport', '@responsive', '@query'],
          correctOptionIndex: 0,
          hint: 'e.g. @media (min-width: 768px)',
          explanation: 'CSS Media Queries (@media) apply styles conditionally based on viewport size or device capabilities.',
        ),
        const Question(
          id: 'web_q07',
          moduleId: 'web_mod_2',
          questionText: 'Which CSS layout system is specifically built for two-dimensional grid layouts with rows and columns?',
          options: ['Flexbox', 'CSS Grid', 'Float layout', 'Table layout'],
          correctOptionIndex: 1,
          hint: null,
          explanation: 'CSS Grid provides a 2D layout framework allowing simultaneous control over both rows and columns.',
        ),
        const Question(
          id: 'web_q08',
          moduleId: 'web_mod_3',
          questionText: 'What is the main difference between "let" and "const" in modern JavaScript?',
          options: [
            '"const" is function-scoped while "let" is block-scoped.',
            '"const" prevents variable reassignment, whereas "let" allows reassignment.',
            '"let" can only store numbers; "const" stores strings.',
            'There is no difference in ES6.'
          ],
          correctOptionIndex: 1,
          hint: 'Short for constant.',
          explanation: '"const" creates a block-scoped binding that cannot be reassigned, whereas "let" permits reassignment.',
        ),
        const Question(
          id: 'web_q09',
          moduleId: 'web_mod_3',
          questionText: 'Which method attaches an interaction callback (like a click) to an HTML element in JavaScript?',
          options: ['attachEvent()', 'addEventListener()', 'bindAction()', 'registerClick()'],
          correctOptionIndex: 1,
          hint: 'Standard DOM method accepting an event type and handler function.',
          explanation: 'addEventListener() attaches an EventListener to a specific EventTarget.',
        ),
        const Question(
          id: 'web_q10',
          moduleId: 'web_mod_3',
          questionText: 'Is JavaScript single-threaded or multi-threaded in its main browser execution context?',
          options: ['Multi-threaded', 'Single-threaded with an event loop', 'Dual-core only', 'Triple-threaded'],
          correctOptionIndex: 1,
          hint: 'Runs on one main call stack coordinated by the event loop.',
          explanation: 'JavaScript operates on a single execution thread, using non-blocking I/O and an event loop for concurrency.',
        ),
        const Question(
          id: 'web_q11',
          moduleId: 'web_mod_4',
          questionText: 'What are the three possible states of a JavaScript Promise?',
          options: [
            'Init, Running, Finished',
            'Pending, Fulfilled, Rejected',
            'Started, Waiting, Stopped',
            'Open, Processing, Closed'
          ],
          correctOptionIndex: 1,
          hint: 'Starts in pending before settling into success or failure.',
          explanation: 'A Promise starts in "pending" and transitions to either "fulfilled" or "rejected".',
        ),
        const Question(
          id: 'web_q12',
          moduleId: 'web_mod_4',
          questionText: 'What keyword can only be used inside a function declared with "async" to pause execution until a Promise resolves?',
          options: ['wait', 'yield', 'await', 'pause'],
          correctOptionIndex: 2,
          hint: 'Pauses until the promise settles.',
          explanation: 'The "await" keyword can only be placed inside async functions to wait for a promise resolution.',
        ),
        const Question(
          id: 'web_q13',
          moduleId: 'web_mod_4',
          questionText: 'Which modern browser API replaced XMLHttpRequest for making network HTTP requests using promises?',
          options: ['Axios', 'Fetch API', 'AjaxNative', 'SocketClient'],
          correctOptionIndex: 1,
          hint: 'window.fetch()',
          explanation: 'The Fetch API provides a modern, Promise-based interface for fetching network resources.',
        ),
        const Question(
          id: 'web_q14',
          moduleId: 'web_mod_5',
          questionText: 'Which HTTP method is conventionally used to retrieve resources from a server without modifying data?',
          options: ['POST', 'GET', 'PUT', 'DELETE'],
          correctOptionIndex: 1,
          hint: 'Idempotent read operation.',
          explanation: 'The GET method requests a representation of the specified resource without side effects.',
        ),
        const Question(
          id: 'web_q15',
          moduleId: 'web_mod_5',
          questionText: 'Which HTTP response status code series indicates that a client request was successfully received, understood, and accepted?',
          options: ['1xx', '2xx (e.g. 200 OK)', '4xx (e.g. 404)', '5xx (e.g. 500)'],
          correctOptionIndex: 1,
          hint: '200 OK and 201 Created belong to this class.',
          explanation: 'HTTP 2xx status codes signal successful request outcomes.',
        ),
        const Question(
          id: 'web_q16',
          moduleId: 'web_mod_5',
          questionText: 'What client-side storage mechanism retains key-value data indefinitely until explicitly cleared, even when the browser is closed?',
          options: ['sessionStorage', 'localStorage', 'Cookie with Max-Age=0', 'CacheRAM'],
          correctOptionIndex: 1,
          hint: null,
          explanation: 'localStorage data persists across browser sessions and computer restarts until cleared by the user or script.',
        ),
        const Question(
          id: 'web_q17',
          moduleId: 'web_mod_5',
          questionText: 'What does JSON stand for in web engineering?',
          options: [
            'JavaScript Object Notation',
            'Java System Over Network',
            'JavaScript Online Namespace',
            'Joint Software Operation Node'
          ],
          correctOptionIndex: 0,
          hint: 'Lightweight textual data format.',
          explanation: 'JSON stands for JavaScript Object Notation.',
        ),
        const Question(
          id: 'web_q18',
          moduleId: 'web_mod_1',
          questionText: 'What is the root container node in a web browser representing the entire parsed document object model?',
          options: ['window', 'document', 'body', 'navigator'],
          correctOptionIndex: 1,
          hint: null,
          explanation: 'document serves as the entry point to the web page’s DOM tree.',
        ),
      ],
    );
  }

  // ==========================================
  // COURSE 4: CYBERSECURITY FUNDAMENTALS
  // ==========================================
  static Course _buildCybersecurityCourse() {
    return Course(
      id: 'course_cybersecurity',
      title: 'Cybersecurity Fundamentals',
      shortDescription: 'Explore the core principles of information security, cryptography, and defense.',
      fullDescription:
          'Build a solid defense foundation in cybersecurity. Explore the CIA Triad, network defense protocols (TLS/Firewalls), cryptographic primitives (hashing vs encryption), web application vulnerabilities like OWASP Top 10, and Zero Trust security architectures.',
      category: 'Security & Systems',
      difficulty: 'Intermediate',
      duration: '50 min',
      iconName: 'security',
      skillsLearned: [
        'CIA Triad & Threat Modeling',
        'TLS/HTTPS & Network Protocols',
        'Symmetric vs Asymmetric Encryption',
        'Cryptographic Hashing & Salting',
        'OWASP Top 10 Web Vulnerabilities',
        'Zero Trust & Principle of Least Privilege',
      ],
      modules: [
        // MODULE 1
        LearningModule(
          id: 'sec_mod_1',
          orderIndex: 1,
          title: 'The CIA Triad & Core Security Concepts',
          estimatedMinutes: '9 min',
          summary:
              'Learn the foundational pillars of information security: Confidentiality, Integrity, and Availability.',
          sections: [
            const ModuleSection(
              title: 'The Pillars of Information Security',
              body:
                  'The CIA Triad is the foundational security model guiding cybersecurity policies. Confidentiality ensures sensitive data is accessible only to authorized entities. Integrity guarantees data remains accurate, complete, and uncorrupted by unauthorized modification. Availability ensures authorized users have timely, reliable access to information and computing resources.',
              bulletPoints: [
                'Confidentiality: Enforced via encryption, access controls, and multi-factor authentication (MFA).',
                'Integrity: Enforced via cryptographic hash sums, checksums, and digital signatures.',
                'Availability: Maintained through redundancy, DDoS mitigation, failover clusters, and backups.',
              ],
            ),
          ],
          keyTakeaway:
              'Every cybersecurity control directly supports at least one pillar of the CIA Triad: Confidentiality, Integrity, or Availability.',
        ),

        // MODULE 2
        LearningModule(
          id: 'sec_mod_2',
          orderIndex: 2,
          title: 'Network Defense & Secure Protocols',
          estimatedMinutes: '10 min',
          summary:
              'Understand the TCP/IP stack, Firewalls, TLS/SSL handshakes, and encrypted communications.',
          sections: [
            const ModuleSection(
              title: 'Transport Layer Security & Firewalls',
              body:
                  'Unencrypted network traffic (such as plain HTTP or Telnet) is vulnerable to eavesdropping and Man-In-The-Middle (MITM) tampering. Transport Layer Security (TLS 1.3) encrypts network communications using asymmetric public keys during the handshake to negotiate a shared symmetric session key.',
              codeSnippet: 'Client  --- ClientHello (TLS 1.3) --->  Server\nClient  <--- ServerHello + Cert + Key --- Server\nClient  <======== Encrypted Session =======> Server',
              bulletPoints: [
                'Firewalls: Inspect and filter incoming/outgoing traffic based on IP, port, and state.',
                'TLS/HTTPS: Provides encryption, authentication, and data integrity over port 443.',
                'VPNs (Virtual Private Networks): Create encrypted tunnels across untrusted public networks.',
              ],
            ),
          ],
          keyTakeaway:
              'TLS establishes an encrypted channel over untrusted networks using asymmetric key exchange to negotiate high-speed symmetric session encryption.',
        ),

        // MODULE 3
        LearningModule(
          id: 'sec_mod_3',
          orderIndex: 3,
          title: 'Cryptography: Encryption vs Hashing',
          estimatedMinutes: '11 min',
          summary:
              'Distinguish between symmetric encryption (AES), asymmetric encryption (RSA/ECC), and one-way hashing (SHA-256, bcrypt).',
          sections: [
            const ModuleSection(
              title: 'Reversible Encryption vs One-Way Hashing',
              body:
                  'A critical cybersecurity distinction: Encryption is a two-way mathematical function designed for confidential data retrieval using a key. Hashing is a one-way deterministic algorithm that maps arbitrary inputs to fixed-size digests; it is mathematically irreversible.',
              codeSnippet: '// Cryptographic Hashing with Salt\nString salt = generateRandomSalt(16);\nString hash = bcrypt(userPassword + salt);',
              bulletPoints: [
                'Symmetric Encryption (e.g. AES-256): Uses the same secret key for encryption and decryption.',
                'Asymmetric Encryption (e.g. RSA, ECC): Uses a public key to encrypt and private key to decrypt.',
                'Hashing (e.g. SHA-256, bcrypt): Irreversible one-way transform used for password storage and integrity verification.',
                'Salting: Appending unique random bytes to passwords before hashing to defeat precomputed Rainbow Table attacks.',
              ],
              tip: 'Never store plain text passwords; always hash with a slow algorithm like bcrypt, Argon2, or PBKDF2.',
            ),
          ],
          keyTakeaway:
              'Encryption is for confidential transmission (reversible with key); Hashing is for integrity and password verification (strictly irreversible).',
        ),

        // MODULE 4
        LearningModule(
          id: 'sec_mod_4',
          orderIndex: 4,
          title: 'Web Application Security & OWASP Top 10',
          estimatedMinutes: '10 min',
          summary:
              'Identify common software vulnerabilities including SQL Injection, Cross-Site Scripting (XSS), and Broken Access Control.',
          sections: [
            const ModuleSection(
              title: 'Preventing Common Exploits',
              body:
                  'The Open Web Application Security Project (OWASP) curates the Top 10 most critical security risks to web applications. SQL Injection occurs when untrusted user input is directly concatenated into database queries. XSS occurs when malicious scripts are injected into benign websites viewed by other users.',
              codeSnippet: '// Vulnerable to SQL Injection:\nString query = "SELECT * FROM users WHERE name = \'" + userInput + "\'";\n\n// Secure (Parameterized Query):\nPreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE name = ?");\nstmt.setString(1, userInput);',
              bulletPoints: [
                'SQL Injection: Defeated by parameterized queries and prepared statements.',
                'Cross-Site Scripting (XSS): Mitigated by contextual HTML output encoding and strict Content Security Policies (CSP).',
                'Broken Access Control: Enforce authorization checks on the server for every endpoint.',
              ],
            ),
          ],
          keyTakeaway:
              'Never trust user input. Use prepared statements for databases, output encoding for HTML, and server-side authorization checks on every route.',
        ),

        // MODULE 5
        LearningModule(
          id: 'sec_mod_5',
          orderIndex: 5,
          title: 'Security Operations & Zero Trust Architecture',
          estimatedMinutes: '10 min',
          summary:
              'Explore modern defense principles: Principle of Least Privilege, Multi-Factor Authentication, and Zero Trust ("Never trust, always verify").',
          sections: [
            const ModuleSection(
              title: 'Zero Trust & Identity Defense',
              body:
                  'Traditional castle-and-moat perimeter security assumes everything inside the corporate network is trustworthy. Zero Trust shifts this paradigm to "Never trust, always verify." Every user, device, and packet must be authenticated, authorized, and continuously validated before access is granted.',
              bulletPoints: [
                'Principle of Least Privilege (PoLP): Grant users and services only the bare minimum permissions needed to complete their role.',
                'Multi-Factor Authentication (MFA): Requires two or more independent factors: something you know (password), something you have (security key/authenticator app), or something you are (biometrics).',
                'Defense in Depth: Layer multiple defensive controls so failure of one layer does not compromise the entire system.',
              ],
            ),
          ],
          keyTakeaway:
              'Zero Trust rejects perimeter-based trust, requiring continuous authentication, least privilege access, and defense-in-depth across all system layers.',
        ),
      ],

      // QUESTION BANK (18 QUESTIONS)
      questionBank: [
        const Question(
          id: 'sec_q01',
          moduleId: 'sec_mod_1',
          questionText: 'What three core principles constitute the foundational CIA Triad in information security?',
          options: [
            'Confidentiality, Integrity, Availability',
            'Control, Identity, Authentication',
            'Cyber, Internet, Application',
            'Crypto, Inspection, Authorization'
          ],
          correctOptionIndex: 0,
          hint: 'The three classic pillars of information security.',
          explanation: 'The CIA Triad stands for Confidentiality, Integrity, and Availability.',
        ),
        const Question(
          id: 'sec_q02',
          moduleId: 'sec_mod_1',
          questionText: 'Which pillar of the CIA Triad is compromised when an attacker alters financial transaction records in a database?',
          options: ['Confidentiality', 'Integrity', 'Availability', 'Non-repudiation'],
          correctOptionIndex: 1,
          hint: 'Guarantees data is accurate and not modified without authorization.',
          explanation: 'Integrity ensures data is accurate, complete, and protected against unauthorized modification or deletion.',
        ),
        const Question(
          id: 'sec_q03',
          moduleId: 'sec_mod_1',
          questionText: 'What type of cyberattack overwhelms servers with bogus traffic to deny access to legitimate users?',
          options: ['Phishing', 'DDoS (Distributed Denial of Service)', 'SQL Injection', 'Keylogger'],
          correctOptionIndex: 1,
          hint: 'Directly violates the Availability pillar.',
          explanation: 'A DDoS attack floods target network services with traffic to render them unavailable.',
        ),
        const Question(
          id: 'sec_q04',
          moduleId: 'sec_mod_2',
          questionText: 'Which cryptographic protocol secures web traffic between browsers and servers over port 443 in HTTPS?',
          options: ['Telnet', 'FTP', 'TLS (Transport Layer Security)', 'SNMP'],
          correctOptionIndex: 2,
          hint: 'Successor to SSL.',
          explanation: 'TLS encrypts web communications to safeguard privacy and data integrity.',
        ),
        const Question(
          id: 'sec_q05',
          moduleId: 'sec_mod_2',
          questionText: 'What is the primary role of a network firewall?',
          options: [
            'Encrypt hard disk drives',
            'Filter and monitor incoming/outgoing network traffic according to security rules',
            'Generate SSL certificates',
            'Compile application source code'
          ],
          correctOptionIndex: 1,
          hint: 'Operates as a barrier between trusted and untrusted networks.',
          explanation: 'Firewalls inspect packets and enforce access rules based on IP addresses, ports, and state.',
        ),
        const Question(
          id: 'sec_q06',
          moduleId: 'sec_mod_2',
          questionText: 'What type of attack involves an adversary secretly intercepting and potentially altering communications between two parties?',
          options: ['Brute Force', 'Man-In-The-Middle (MITM)', 'Buffer Overflow', 'DNS Poisoning'],
          correctOptionIndex: 1,
          hint: null,
          explanation: 'In a MITM attack, the attacker relays and modifies conversations between two entities who believe they are communicating directly.',
        ),
        const Question(
          id: 'sec_q07',
          moduleId: 'sec_mod_3',
          questionText: 'What is the key technical difference between symmetric and asymmetric encryption?',
          options: [
            'Symmetric uses one shared secret key for both encryption and decryption; asymmetric uses a public/private key pair.',
            'Symmetric cannot be decrypted, while asymmetric can.',
            'Symmetric is only used for passwords; asymmetric is for videos.',
            'Asymmetric is much faster than symmetric encryption.'
          ],
          correctOptionIndex: 0,
          hint: 'One key versus two keys.',
          explanation: 'Symmetric encryption relies on a single shared key, whereas asymmetric utilizes a mathematically linked public/private key pair.',
        ),
        const Question(
          id: 'sec_q08',
          moduleId: 'sec_mod_3',
          questionText: 'Why is cryptographic hashing considered a "one-way" function?',
          options: [
            'It can only be computed on one operating system.',
            'It is computationally infeasible to reverse or invert the hash back into the original plaintext.',
            'It always produces an output larger than the input.',
            'It requires two separate passwords to compute.'
          ],
          correctOptionIndex: 1,
          hint: 'Irreversible mathematical transformation.',
          explanation: 'Hashing algorithms produce fixed-size digests from which the original input cannot be mathematically reversed.',
        ),
        const Question(
          id: 'sec_q09',
          moduleId: 'sec_mod_3',
          questionText: 'What is the purpose of adding a unique "salt" to passwords before hashing them?',
          options: [
            'To make the password shorter',
            'To defeat precomputed dictionary and Rainbow Table attacks',
            'To make hashing reversible by administrators',
            'To allow password recovery without email'
          ],
          correctOptionIndex: 1,
          hint: 'Appends random data to ensure identical passwords generate distinct hashes.',
          explanation: 'Salting introduces random data to ensure duplicate passwords produce different hashes, neutralizing rainbow tables.',
        ),
        const Question(
          id: 'sec_q10',
          moduleId: 'sec_mod_3',
          questionText: 'Which of the following is an industry-standard symmetric block cipher?',
          options: ['RSA', 'AES (Advanced Encryption Standard)', 'ECC', 'Diffie-Hellman'],
          correctOptionIndex: 1,
          hint: null,
          explanation: 'AES is the worldwide standard symmetric block cipher adopted by NIST.',
        ),
        const Question(
          id: 'sec_q11',
          moduleId: 'sec_mod_4',
          questionText: 'What is the most effective defensive measure to eliminate SQL Injection vulnerabilities in software?',
          options: [
            'Relying on client-side JavaScript regex validation',
            'Using Parameterized Queries and Prepared Statements',
            'Increasing database user permissions',
            'Storing database queries in plain text files'
          ],
          correctOptionIndex: 1,
          hint: 'Separates code instructions from user-provided data parameters.',
          explanation: 'Parameterized queries ensure the database engine treats user input strictly as data, never as executable code.',
        ),
        const Question(
          id: 'sec_q12',
          moduleId: 'sec_mod_4',
          questionText: 'What web vulnerability allows attackers to inject malicious client-side JavaScript scripts into pages viewed by others?',
          options: ['XSS (Cross-Site Scripting)', 'CSRF', 'Buffer Overflow', 'Directory Traversal'],
          correctOptionIndex: 0,
          hint: 'Executes within the victim’s browser session.',
          explanation: 'Cross-Site Scripting (XSS) occurs when an application includes untrusted data in a web page without proper validation or escaping.',
        ),
        const Question(
          id: 'sec_q13',
          moduleId: 'sec_mod_4',
          questionText: 'What organization publishes the authoritative "Top 10" list of critical web application security risks?',
          options: ['IEEE', 'OWASP', 'W3C', 'IETF'],
          correctOptionIndex: 1,
          hint: 'Open Web Application Security Project.',
          explanation: 'OWASP (Open Web Application Security Project) publishes the widely recognized OWASP Top 10 standard.',
        ),
        const Question(
          id: 'sec_q14',
          moduleId: 'sec_mod_5',
          questionText: 'What is the core security mantra of the Zero Trust architecture model?',
          options: [
            '"Trust internal corporate networks completely"',
            '"Never trust, always verify"',
            '"Only encrypt external traffic"',
            '"Disable all firewalls for speed"'
          ],
          correctOptionIndex: 1,
          hint: 'Assumes the network is always hostile.',
          explanation: 'Zero Trust operates on the principle of "Never trust, always verify" for all access requests.',
        ),
        const Question(
          id: 'sec_q15',
          moduleId: 'sec_mod_5',
          questionText: 'What security principle dictates that users and applications should be granted only the minimal permissions required to do their job?',
          options: [
            'Principle of Least Privilege (PoLP)',
            'Maximum Separation of Duty',
            'Defense by Obscurity',
            'Full Access Rule'
          ],
          correctOptionIndex: 0,
          hint: 'Limits potential damage from compromised credentials.',
          explanation: 'The Principle of Least Privilege limits access rights for users to only those needed to fulfill their duties.',
        ),
        const Question(
          id: 'sec_q16',
          moduleId: 'sec_mod_5',
          questionText: 'Which of the following represents valid Multi-Factor Authentication (MFA)?',
          options: [
            'Entering your password and then re-typing the same password',
            'Entering a password (something you know) and a time-based authenticator code (something you have)',
            'Entering two different email addresses',
            'Entering your mother’s maiden name and pet’s name'
          ],
          correctOptionIndex: 1,
          hint: 'Must involve at least two distinct factor categories (knowledge, possession, inherence).',
          explanation: 'True MFA combines two distinct categories: something you know (password) and something you have (one-time token).',
        ),
        const Question(
          id: 'sec_q17',
          moduleId: 'sec_mod_1',
          questionText: 'What is the practice of manipulating human psychology into revealing confidential information or passwords called?',
          options: ['Reverse Engineering', 'Social Engineering (e.g. Phishing)', 'Cryptanalysis', 'SQL Injection'],
          correctOptionIndex: 1,
          hint: null,
          explanation: 'Social engineering exploits human psychology rather than software bugs to gain unauthorized access.',
        ),
        const Question(
          id: 'sec_q18',
          moduleId: 'sec_mod_3',
          questionText: 'What is the standard fixed output bit length generated by the SHA-256 cryptographic hash algorithm?',
          options: ['128 bits', '256 bits (32 bytes)', '512 bits', '1024 bits'],
          correctOptionIndex: 1,
          hint: 'The number 256 is in the algorithm name.',
          explanation: 'SHA-256 produces a deterministic 256-bit (32-byte) message digest.',
        ),
      ],
    );
  }
}
